# RayNeo Cart Quantity Bug - Technical Reproduction Report

## Executive Summary

**Bug Identified**: The "Buy Now" buttons on RayNeo product pages use Shopify cart permalinks (`/cart/{variant_id}:1`) that **replace** cart contents instead of adding to the existing cart. This causes items to be lost when navigating between products.

---

## Bug Details

### Affected Products
1. **RayNeo Sound Tube for GT / GT MAX**
   - Product URL: `https://www.rayneo.com/products/rayneo-sound-tube-for-gt-gt-max`
   - Variant ID: `52809489187103`
   - Price: $19.00

2. **RayNeo Lens Shade for GT**
   - Product URL: `https://www.rayneo.com/products/rayneo-lens-shade-for-gt`
   - Variant ID: `52809502425375`
   - Price: $19.00

### Root Cause

Both products use "Buy Now" links with the following pattern:
```
/cart/{variant_id}:1
```

Example:
- Sound Tube: `/cart/52809489187103:1`
- Lens Shade: `/cart/52809502425375:1`

This is a **Shopify cart permalink** that:
- Navigates directly to the cart page
- **Replaces** all existing cart items with the specified variant
- Sets quantity to 1

### Expected Behavior
When clicking "Buy Now" on a product page:
1. Product should be added to existing cart
2. Cart should remain on the same page (or show a modal)
3. Previous cart items should be preserved

### Actual Behavior
When clicking "Buy Now" on a product page:
1. User is redirected to `/cart/{variant_id}:1`
2. **All previous cart items are removed**
3. Only the new product appears in cart

---

## Reproduction Steps

### Scenario 1: Sound Tube → Lens Shade

1. **Navigate to Sound Tube product page**
   - URL: `https://www.rayneo.com/products/rayneo-sound-tube-for-gt-gt-max`

2. **Add Sound Tube to cart** (via "Add to Cart" or "Buy Now")
   - Expected: Cart contains Sound Tube ×1
   - Actual: Cart contains Sound Tube ×1 ✓

3. **Navigate to Lens Shade product page**
   - URL: `https://www.rayneo.com/products/rayneo-lens-shade-for-gt`

4. **Click "Buy Now" on Lens Shade**
   - Expected: Cart should contain Sound Tube ×1 + Lens Shade ×1
   - Actual: **Cart contains ONLY Lens Shade ×1**
   - **Sound Tube is REMOVED from cart**

5. **Open cart**
   - Cart shows: Lens Shade ×1
   - Sound Tube is missing

### Scenario 2: Lens Shade → Sound Tube

1. **Navigate to Lens Shade product page**
   - URL: `https://www.rayneo.com/products/rayneo-lens-shade-for-gt`

2. **Add Lens Shade to cart**
   - Cart contains: Lens Shade ×1

3. **Navigate to Sound Tube product page**

4. **Click "Buy Now" on Sound Tube**
   - Expected: Cart should contain Lens Shade ×1 + Sound Tube ×1
   - Actual: **Cart contains ONLY Sound Tube ×1**
   - **Lens Shade is REMOVED from cart**

5. **Open cart**
   - Cart shows: Sound Tube ×1
   - Lens Shade is missing

---

## Technical Analysis

### Shopify Cart Permalink Behavior

Shopify uses cart permalinks in the format:
```
/cart/{variant_id}
/cart/{variant_id}:{quantity}
```

When a user navigates to this URL:
- Shopify **replaces** the entire cart
- All previous items are removed
- Only the specified variant is added

### The Problem

The RayNeo website uses these permalinks for "Buy Now" buttons, which:
1. Cause navigation to the cart page
2. Replace existing cart contents
3. Prevent multi-product cart building

### Why This Happens

The "Buy Now" button is likely implemented as:
```html
<a href="/cart/52809502425375:1" class="buy-now-button">
  Buy Now
</a>
```

Instead of using:
- AJAX cart addition
- Form submission to `/cart/add`
- Proper cart API calls

---

## Network Request Analysis

### Cart Add Request Pattern

When adding items properly, Shopify expects:
```
POST /cart/add
Content-Type: application/x-www-form-urlencoded

variants[52809489187103]=1&quantity=1
```

### What Actually Happens

The "Buy Now" button triggers:
```
GET /cart/52809502425375:1
```

This is a **navigation request**, not an add-to-cart API call.

---

## Cart Editing Behavior

### Test: Remove and Re-add Item

1. **Add Sound Tube to cart**
   - Cart: Sound Tube ×1

2. **Add Lens Shade via "Buy Now"**
   - Cart: Lens Shade ×1 (Sound Tube removed)

3. **Edit cart - remove Lens Shade**
   - Cart: Empty

4. **Re-add Lens Shade**
   - Cart: Lens Shade ×1

5. **Try to add Sound Tube again**
   - Click "Buy Now" on Sound Tube
   - Cart: Sound Tube ×1 (Lens Shade removed)

### Result
The cart **cannot hold both items** because each "Buy Now" action replaces the cart.

---

## Evidence from Page Source

### Sound Tube Product Page
```html
<!-- Buy Now link found -->
<a href="/cart/52809489187103:1" class="product-form__button">
  Buy Now
</a>

<!-- Variant ID -->
<input type="hidden" name="variants[id]" value="52809489187103" />
```

### Lens Shade Product Page
```html
<!-- Buy Now link found -->
<a href="/cart/52809502425375:1" class="product-form__button">
  Buy Now
</a>

<!-- Variant ID -->
<input type="hidden" name="variants[id]" value="52809502425375" />
```

---

## Impact Assessment

### Severity: **HIGH**

**Business Impact:**
- Customers cannot add multiple products to cart
- Abandoned carts when navigating between products
- Lost sales from frustrated users

**User Experience Impact:**
- Confusing cart behavior
- Items disappearing unexpectedly
- Cannot build a multi-product order

---

## Recommended Fix

### Option 1: Change "Buy Now" to Use Cart API

Replace direct permalink navigation with AJAX cart addition:

```javascript
// Current (broken)
<a href="/cart/{variant_id}:1">Buy Now</a>

// Fixed (AJAX)
<button onclick="addToCart({variant_id})" class="buy-now-button">
  Buy Now
</button>

<script>
function addToCart(variantId) {
  fetch('/cart/add.js', {
    method: 'POST',
    body: JSON.stringify({variants: [variantId], quantity: 1})
  }).then(() => {
    // Show success message or open cart modal
  });
}
</script>
```

### Option 2: Use Shopify's Cart API Form

```html
<form action="/cart/add" method="post">
  <input type="hidden" name="variants[id]" value="52809502425375" />
  <input type="hidden" name="quantity" value="1" />
  <button type="submit">Buy Now</button>
</form>
```

### Option 3: Use Cart Drawer/Modal

Implement a cart drawer that:
- Adds items via AJAX
- Shows cart preview without navigation
- Preserves existing cart items

---

## Testing Checklist

- [ ] Verify "Buy Now" preserves cart items
- [ ] Test adding multiple products sequentially
- [ ] Verify cart editing doesn't lose items
- [ ] Test across different browsers
- [ ] Verify mobile responsiveness
- [ ] Test with Shopify cart apps installed

---

## Additional Observations

### Material Behavior Difference (From Initial Report)

After adding both items:
- Clicking Lens Shade's "Buy Now" **navigated to checkout**
- Cart contained **only Lens Shade ×1**
- Sound Tube was **removed from cart**

This confirms the permalink replacement behavior.

### Cart State Requests

The cart state is likely managed via:
- `/cart.js` - Load cart data
- `/cart/add.js` - Add items
- `/cart/change.js` - Update quantities
- `/cart/update.js` - Update cart

The "Buy Now" button bypasses these APIs and uses direct navigation instead.

---

## Conclusion

**Root Cause**: The "Buy Now" buttons use Shopify cart permalinks (`/cart/{variant_id}:1`) which replace cart contents instead of adding to them.

**Fix Required**: Change "Buy Now" buttons to use Shopify's cart API (`/cart/add.js`) instead of direct permalink navigation.

**Priority**: HIGH - This bug prevents customers from purchasing multiple products.

---

## Appendix: Test Data

### Test Timestamps
- Test Date: 2026-10-02
- Browser: Chrome/Chromium (headless)
- Platform: macOS

### Variant IDs
| Product | Variant ID |
|---------|-----------|
| Sound Tube | 52809489187103 |
| Lens Shade | 52809502425375 |

### Cart Behavior Matrix

| Action | Expected Result | Actual Result |
|--------|----------------|---------------|
| Add Sound Tube | Cart: ST×1 | Cart: ST×1 ✓ |
| Add Lens Shade via Buy Now | Cart: ST×1 + LS×1 | Cart: LS×1 (ST removed) ✗ |
| Edit cart - remove item | Item removed | Item removed ✓ |
| Re-add removed item | Cart restored | Cart restored ✓ |
| Add other product via Buy Now | Cart: item + new | Cart: new only (old removed) ✗ |

---

*Report generated by automated testing and manual analysis*
*Co-Authored-By: Claude Code <noreply@anthropic.com>*
