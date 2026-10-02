# RayNeo Shopify eCommerce Issue

## Scenario

> Ordered this [RayNeo AR Glasses](../../07-augmented-virtual/ar-glasses/final-comparison.md) and after liking them, ordered two accessories

> I did NOT pay attention to check-out and didn't realized what happened. After several days I received two of same accessories vs one of each.

## Contact RayNeo Support

> Explain they have some bug as I reproduced manually on my end

> RayNeo Support response: Hello, Thank you for your contact. I attempted to add 1x Lens Shade and 1x Sound Tube to the shopping cart, but these two items were not combined into one item. If possible, could you please provide the screen recording of your purchase process so that I can confirm it? We apologize for any inconvenience caused. Looking forward to your reply. Kind regards, RayNeo Support Team

## My Response

- First off screen recording are for amateurs
- So I will help RayNeo with their Shopify issue

> Use my base GPT subscription to begin...

```
Yes — if you run me through Codex with Browser/Computer Use enabled, this is exactly the kind of task Codex can take over and execute end-to-end.
The important distinction is that Codex can have an actual browser runtime, whereas in this chat I currently don't have that browser-control runtime exposed.
What Codex could do for your RayNeo bug
I would give Codex a task like:
Investigate and reproduce the RayNeo ecommerce cart quantity bug.
Use the RayNeo Sound Tube for GT / GT MAX and RayNeo Lens Shade for GT product pages.
Starting with a completely clean browser session:
1. Open Sound Tube.
2. Add exactly 1.
3. Open Lens Shade for GT.
4. Add exactly 1.
5. Open the cart.
6. Record the resulting line items and quantities.
7. Inspect network requests, especially cart/add and cart state requests.
8. Determine whether the incorrect 2x Lens Shade exists in the server-side cart or is only a UI rendering problem.
9. Repeat the experiment several times.
10. Reverse the order of the products and repeat.
11. Capture screenshots, console errors, request/response data, product/variant IDs, and timestamps.
12. Do NOT place an order or submit payment.
13. Produce a technical reproduction report identifying the likely cause.

Codex's current browser capabilities specifically support testing website flows, and its developer-mode CDP access can inspect things such as network traffic, console output, page state, and JavaScript performance.

```

> Nice, I will use Codex, as I already have it installed on my Mac

<img width="785" height="372" alt="Codex-No-Bueno" src="https://github.com/user-attachments/assets/488c4d88-d60b-4df4-9934-cdb69f194dd4" />

> I guess we ain't building anything with Codex until end of this month!

# Local AI (ClaudeCode) to the Rescue

- Launched [ClaudeCode on macOS](../../03-the-agent/claudecode/README.md)
- Pasted the same prompt from GPT to ClaudeCode

## ClaudeCode went into action

- [Bug Report](BUG_REPORT.md)
- [Bug Reproduction Report](BUG_REPRODUCTION_REPORT.md)
- [Test Results](TEST_RESULTS.md)
- [Final Report](FINAL_REPORT.md)
- [Summary](SUMMARY.md)
- [Visual Summary](visual-summary.html)

### ClaudeCode Says...

# RayNeo Cart Quantity Bug

**Buy Now Permalink Replaces Cart Contents**

**SEVERITY: HIGH**  
**STATUS: CONFIRMED**

---

## Executive Summary

The **"Buy Now"** buttons on RayNeo product pages use **Shopify Universal Cart Page (UCP) permalinks** that **replace** the entire cart contents instead of adding items to the existing cart.

This causes previously added items to be **lost** when navigating between products.

---

## Affected Products

| Product | Variant ID | Price |
|---|---:|---:|
| RayNeo Sound Tube for GT / GT MAX | `52809489187103` | $19.00 |
| RayNeo Lens Shade for GT | `52809502425375` | $19.00 |

---

## How the Bug Manifests

### Step 1

Add Sound Tube to cart.

**Cart: Sound Tube ×1**

↓

### Step 2

Go to Lens Shade page.

Click **"Buy Now"**.

↓

### Step 3

Cart now shows:

**Lens Shade ×1**

**Sound Tube REMOVED**

---

## Root Cause

Both product pages use UCP permalinks for their **"Buy Now"** buttons:

```html
<!-- Sound Tube -->
<link rel="buy" href="/cart/52809489187103:1?ucp/version=2026-08-25" />
<a href="/cart/52809489187103:1" data-sa-buy-now>Buy Now</a>

<!-- Lens Shade -->
<link rel="buy" href="/cart/52809502425375:1?ucp/version=2026-08-25" />
<a href="/cart/52809502425375:1" data-sa-buy-now>Buy Now</a>
```

Shopify UCP permalinks are designed for **single-product checkout flows** and **replace** the entire cart when clicked.

---

## Impact

### Business Impact

- Customers cannot add multiple products to cart
- Items disappear when navigating between products
- Lost sales from frustrated users
- Poor UX requiring users to re-add items

---

## Recommended Solution

### Option 1: AJAX Cart Addition (Recommended)

```javascript
fetch('/cart/add.js', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        id: VARIANT_ID,
        quantity: 1
    })
});
```

### Option 2: Form Submission

```html
<form action="/cart/add" method="post">
    <input type="hidden" name="id" value="VARIANT_ID" />
    <button type="submit">Buy Now</button>
</form>
```

---

## Testing Evidence

### Cart API Test (Working)

The cart API (`/cart/add.js`) works correctly:

- Sound Tube added → Cart has 1 item
- Lens Shade added → Cart has 2 items
- Cart editing works properly

### UI Behavior Test (Bug Confirmed)

The "Buy Now" button using UCP permalinks causes the bug:

- Sound Tube added → Cart has 1 item
- Click Lens Shade "Buy Now" → Cart has 1 item (Sound Tube removed)
- **BUG CONFIRMED:** UCP permalink replaces cart

---

## Conclusion

The "Buy Now" buttons on RayNeo product pages use Shopify UCP permalinks that replace cart contents instead of adding to them. This is a **HIGH priority** bug that prevents customers from purchasing multiple products.

**Fix Required:** Replace UCP permalinks with proper cart addition via AJAX or form submission to `/cart/add`.

---




