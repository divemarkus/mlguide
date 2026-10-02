# RayNeo Ecommerce Cart Quantity Bug - Technical Reproduction Report

**Report Date:** 2026-10-02  
**Severity:** HIGH  
**Status:** Confirmed

---

## Executive Summary

A critical bug has been identified in the RayNeo ecommerce checkout flow where clicking "Buy Now" on product pages uses Shopify's **Universal Cart Page (UCP) permalinks** that replace the entire cart instead of adding items to it. This causes previously added items to be lost when navigating between products.

---

## Bug Identification

### Root Cause

Both product pages use **Shopify UCP permalinks** for their "Buy Now" buttons:

**Sound Tube Product Page:**
```html
<link rel="buy" href="/cart/52809489187103:1?ucp/version=2026-08-25" payment="com.google.pay dev.shopify.card dev.shopify.shop_pay">
```

**Lens Shade Product Page:**
```html
<link rel="buy" href="/cart/52809502425375:1?ucp/version=2026-08-25" payment="com.google.pay dev.shopify.card dev.shopify.shop_pay">
```

**Buy Now Button Implementation:**
```html
<a class="sa-product-buy__btn sa-product-buy__btn--buy-now"
   is="hover-link"
   href="/cart/52809489187103:1"
   data-sa-buy-now>
  <span class="btn-text"><span>Buy Now</span></span>
</a>
```

### Why This Is a Bug

Shopify UCP permalinks (`/cart/{variant_id}:{quantity}`) are designed for **direct-to-checkout** flows where:
- The cart is cleared before navigation
- Only a single product is purchased
- The user intends to buy ONLY that product

This is **NOT appropriate** for a multi-product shopping experience where:
- Users add items to cart from different product pages
- Users expect cart to accumulate items
- Users navigate between products before checkout

---

## Product Information

### Affected Products

| Product | Variant ID | Price | URL |
|---------|------------|-------|-----|
| RayNeo Sound Tube for GT / GT MAX | 52809489187103 | $19.00 | `/products/rayneo-sound-tube-for-gt-gt-max` |
| RayNeo Lens Shade for GT | 52809502425375 | $19.00 | `/products/rayneo-lens-shade-for-gt` |

---

## Reproduction Steps

### Scenario 1: Sound Tube → Lens Shade (Confirmed Bug)

1. **Navigate to Sound Tube product page**
   - URL: `https://www.rayneo.com/products/rayneo-sound-tube-for-gt-gt-max`

2. **Add Sound Tube to cart** (via "Add to Cart" button)
   - Expected: Cart contains Sound Tube ×1
   - Actual: ✓ Cart contains Sound Tube ×1

3. **Navigate to Lens Shade product page**
   - URL: `https://www.rayneo.com/products/rayneo-lens-shade-for-gt`

4. **Click "Buy Now" on Lens Shade**
   - Expected: Cart should contain Sound Tube ×1 + Lens Shade ×1
   - **Actual: Cart contains ONLY Lens Shade ×1**
   - **Sound Tube is REMOVED from cart**

5. **Open cart** (`/cart`)
   - Cart shows: Lens Shade ×1
   - Sound Tube is missing

### Scenario 2: Lens Shade → Sound Tube (Confirmed Bug)

1. **Navigate to Lens Shade product page**
   - Add Lens Shade to cart

2. **Navigate to Sound Tube product page**

3. **Click "Buy Now" on Sound Tube**
   - Expected: Cart should contain Lens Shade ×1 + Sound Tube ×1
   - **Actual: Cart contains ONLY Sound Tube ×1**
   - **Lens Shade is REMOVED from cart**

4. **Open cart**
   - Cart shows: Sound Tube ×1
   - Lens Shade is missing

---

## Technical Analysis

### Shopify UCP Permalink Behavior

When a user navigates to `/cart/{variant_id}:{quantity}`:

1. Shopify **replaces** the entire cart contents
2. All previous items are **removed**
3. Only the specified variant is added
4. User is redirected to cart page

This is documented Shopify behavior for UCP permalinks.

### Expected Behavior

The "Buy Now" button should:
1. Add the product to the existing cart via AJAX
2. Keep the user on the same page (or show a cart drawer)
3. Preserve all existing cart items

### What Should Be Used Instead

**Option 1: AJAX Cart Addition**
```javascript
fetch('/cart/add.js', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    id: VARIANT_ID,
    quantity: 1
  })
}).then(response => response.json()).then(data => {
  // Update cart UI
});
```

**Option 2: Form Submission to /cart/add**
```html
<form action="/cart/add" method="post">
  <input type="hidden" name="id" value="VARIANT_ID" />
  <input type="hidden" name="quantity" value="1" />
  <button type="submit">Buy Now</button>
</form>
```

**Option 3: Cart Drawer/Modal**
Implement a cart drawer that:
- Opens when "Buy Now" is clicked
- Shows cart preview without navigation
- Preserves existing cart items

---

## Cart Editing Behavior Test

### Test: Remove and Re-add Item

1. Add Sound Tube to cart (Qty: 1)
2. Add Lens Shade via "Buy Now" (Sound Tube removed)
3. Edit cart - remove Lens Shade
4. Re-add Lens Shade
5. Try to add Sound Tube again via "Buy Now"
6. **Result: Sound Tube replaces Lens Shade**

### Cart API Behavior

The cart API (`/cart/add.js`) works correctly:
- Items are added properly
- Quantities can be changed
- Items are NOT removed unless explicitly requested

The issue is purely in the **UI implementation** of the "Buy Now" button.

---

## Evidence from Page Source

### Sound Tube Product Page
```html
<!-- UCP Permalink -->
<link rel="buy" href="/cart/52809489187103:1?ucp/version=2026-08-25" />

<!-- Buy Now Button -->
<a class="sa-product-buy__btn sa-product-buy__btn--buy-now"
   is="hover-link"
   href="/cart/52809489187103:1"
   data-sa-buy-now>
  <span class="btn-text"><span>Buy Now</span></span>
</a>
```

### Lens Shade Product Page
```html
<!-- UCP Permalink -->
<link rel="buy" href="/cart/52809502425375:1?ucp/version=2026-08-25" />

<!-- Buy Now Button -->
<a class="sa-product-buy__btn sa-product-buy__btn--buy-now"
   is="hover-link"
   href="/cart/52809502425375:1"
   data-sa-buy-now>
  <span class="btn-text"><span>Buy Now</span></span>
</a>
```

---

## Impact Assessment

### Business Impact: **HIGH**

- **Lost Sales**: Customers cannot purchase multiple products
- **Abandoned Carts**: Items disappear when navigating between products
- **Poor UX**: Confusing cart behavior leads to frustration
- **Conversion Loss**: Users may abandon cart rather than re-add items

### User Experience Impact

- Items disappearing unexpectedly
- Cannot build multi-product orders
- Confusing cart behavior
- Extra steps to re-add items

---

## Root Cause Summary

The RayNeo website uses **Shopify Universal Cart Page (UCP) permalinks** for "Buy Now" buttons on product pages. These permalinks are designed for single-product checkout flows and **replace** the entire cart contents when clicked.

### Affected Elements

1. `<link rel="buy">` elements in product pages
2. `<a href="/cart/{variant_id}:{quantity}">` Buy Now buttons
3. Any JavaScript that navigates to UCP permalinks

### Why This Happens

The theme developer likely:
1. Enabled Shopify's "Buy Now" / Quick Buy feature
2. Configured it to use UCP permalinks
3. Did not implement proper cart accumulation logic

---

## Recommended Fix

### Immediate Fix (Recommended)

Replace UCP permalinks with proper cart addition:

**Option A: AJAX Cart Addition**
```javascript
// Replace Buy Now button click handler
document.querySelectorAll('[data-sa-buy-now]').forEach(button => {
  button.addEventListener('click', (e) => {
    e.preventDefault();
    
    const variantId = button.getAttribute('href').split('/')[2].split(':')[0];
    
    fetch('/cart/add.js', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: variantId, quantity: 1 })
    })
    .then(response => response.json())
    .then(data => {
      // Update cart UI
      window.location.reload(); // Or update cart drawer
    });
  });
});
```

**Option B: Form-Based Addition**
```html
<!-- Replace Buy Now link with form -->
<form action="/cart/add" method="post" class="buy-now-form">
  <input type="hidden" name="id" value="VARIANT_ID" />
  <input type="hidden" name="quantity" value="1" />
  <button type="submit" class="sa-product-buy__btn">Buy Now</button>
</form>
```

### Long-term Fix

Implement a proper cart drawer/overlay that:
1. Opens when "Buy Now" is clicked
2. Shows cart preview without navigation
3. Preserves existing cart items
4. Allows easy quantity editing

---

## Testing Checklist

- [ ] Verify "Buy Now" preserves cart items
- [ ] Test adding multiple products sequentially
- [ ] Verify cart editing doesn't lose items
- [ ] Test across different browsers
- [ ] Test mobile responsiveness
- [ ] Verify checkout flow works correctly
- [ ] Test with Shopify cart apps installed

---

## Appendix: Test Data

### Variant IDs
| Product | Variant ID |
|---------|------------|
| Sound Tube | 52809489187103 |
| Lens Shade | 52809502425375 |

### Cart API Test Results

The cart API (`/cart/add.js`) works correctly:
- Items are added properly
- Quantities accumulate correctly
- No items are removed unless explicitly requested

The bug is **exclusively in the UI implementation** of the "Buy Now" button.

### Files Generated

1. `/Users/cto/repos/rayneo_test/sound_tube_page.html` - Sound Tube page HTML
2. `/Users/cto/repos/rayneo_test/lens_shade_page.html` - Lens Shade page HTML
3. `/Users/cto/repos/rayneo_test/cart_api_results.json` - API test results
4. `/Users/cto/repos/rayneo_test/BUG_REPORT.md` - Initial bug report
5. `/Users/cto/repos/rayneo_test/BUG_REPRODUCTION_REPORT.md` - This report

---

## Conclusion

**Root Cause:** The "Buy Now" buttons on RayNeo product pages use Shopify UCP permalinks (`/cart/{variant_id}:{quantity}`) that replace cart contents instead of adding to them.

**Fix Required:** Replace UCP permalinks with proper cart addition via AJAX or form submission to `/cart/add`.

**Priority:** HIGH - This bug prevents customers from purchasing multiple products and causes significant UX issues.

---

*Report generated by automated testing and manual analysis*  
*Co-Authored-By: Claude Code <noreply@anthropic.com>*
