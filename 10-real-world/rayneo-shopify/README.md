# RayNeo Shopify eCommerce Issue

## Scenario

> Ordered this [RayNeo AR Glasses](../../07-augmented-virtual/ar-glasses/final-comparison.md) and after liking them, ordered two accessories

> I did NOT pay attention to check-out and didn't realized what happened. After several days I received two of same accessories vs one of each.

<img width="765" height="436" alt="RayNeo-Glasses" src="https://github.com/user-attachments/assets/80e05270-a6a9-41ad-b630-b83f2be89525" />

---

## Contact RayNeo Support

> Explain they have some bug as I reproduced manually on my end

> RayNeo Support response: Hello, Thank you for your contact. I attempted to add 1x Lens Shade and 1x Sound Tube to the shopping cart, but these two items were not combined into one item. If possible, could you please provide the screen recording of your purchase process so that I can confirm it? We apologize for any inconvenience caused. Looking forward to your reply. Kind regards, RayNeo Support Team

---

## My Response

- Since screen recording are terrible tedious and reserved for super users, I will help RayNeo with their Shopify issue using Agentic AI.
- Use my paid (base-sub) GPT subscription to begin...

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

- Nice, I will use Codex, as I already have it installed on my Mac

<img width="785" height="372" alt="Codex-No-Bueno" src="https://github.com/user-attachments/assets/488c4d88-d60b-4df4-9934-cdb69f194dd4" />

> I guess we ain't building anything with Codex until end of this month!

---

# Local AI (ClaudeCode) to the Rescue

- ClaudeCode - as in locally hosted on macOS and not from Anthropic datacenter.
- Launched [ClaudeCode on macOS](../../03-the-agent/claudecode/README.md)
- Pasted the same prompt from GPT to ClaudeCode.
- Make sure to let Claude use tools: Browse the web, run code, call APIs, and access external databases. 
- Claude will also need to install Selenium and other python or developer tools.

---

## ClaudeCode went into action

- [Bug Report](BUG_REPORT.md)
- [Bug Reproduction Report](BUG_REPRODUCTION_REPORT.md)
- [Test Results](TEST_RESULTS.md)
- [Final Report](FINAL_REPORT.md)
- [Summary](SUMMARY.md)
- [Visual Summary](visual-summary.html)

### ClaudeCode Report

- Download the "visual-summary.html" or see pasted image below:
 
<img width="2317" height="7075" alt="xodtRqX3Ew" src="https://github.com/user-attachments/assets/fdb58bf9-27ca-4309-bab1-6b314adc2313" />

---




