# Gmail Privacy and Security Review: External Images and Dynamic Email

## Executive summary

For a privacy-first Gmail configuration, I recommend:

- Images: Ask before displaying external images
- Dynamic email: Disable

These controls affect two different behaviors:

- whether Gmail automatically loads externally hosted images
- whether messages may include interactive, dynamic content

Google provides protections for both features, but neither is necessary for basic email delivery. External images may be used for tracking and dynamic email adds additional active content and interaction inside messages.

---

## 1) External images: ON vs OFF

Gmail's image setting offers two main choices:

- Always display external images
- Ask before displaying external images

The second option makes image loading a deliberate action instead of the default.

| Security / privacy area | Always display external images | Ask before displaying external images |
| --- | --- | --- |
| Default behavior | External images are displayed automatically, subject to Gmail's security checks. | External images are not automatically displayed; you choose when to load them. |
| Email tracking | Remote images may be used as tracking pixels to infer that a message was opened. | Blocks automatic loading of those images until you choose to display them. |
| Sender visibility | Gmail's image proxying limits what senders can learn directly about your device and location, but they may still infer an email was opened. | Reduces automatic open-tracking signals from external images. |
| IP address exposure | Gmail says senders cannot use image loading to obtain your computer or location information. | Also benefits from Gmail's image protections; delaying image loading adds control over whether the content is requested. |
| Browser cookies | Gmail says senders cannot use image loading to set or read browser cookies. | Same protections apply. |
| Malware protection | Gmail scans images for signs of known harmful software and suspicious content. | Gmail's scanning protections still apply when images are requested. |
| Phishing and social engineering | Images can make deceptive messages appear more convincing. | Images remain hidden until requested, which gives you time to inspect the message first. |
| Convenience | Best visual compatibility with newsletters, receipts, and promotional emails. | Some emails appear incomplete until you choose to load the images. |
| Data usage | External images load automatically when permitted. | Reduces unnecessary automatic image downloads and network requests. |

Source: Google Gmail Help — Turn images on or off in Gmail

---

## 2) Dynamic email: ON vs OFF

Dynamic email allows interactive content inside Gmail instead of forcing you to open another website. Google gives examples such as responding to Google Calendar invitations, filling out questionnaires, browsing catalogs, and responding to Google Docs comments. It also depends on Gmail allowing external images.

| Security / privacy area | Enable dynamic email | Disable dynamic email |
| --- | --- | --- |
| Interactive content | Supported messages can display interactive content inside Gmail. | Dynamic content is disabled; supported messages may fall back to a static version. |
| Actions inside messages | You can perform supported tasks without leaving your inbox. | You may need to open the associated website or application. |
| Content behavior | The interactive portion can present updated content rather than only a fixed message body. | You avoid the dynamic-email rendering path; ordinary message text and static content remain available. |
| External dependencies | Dynamic messages can depend on remote content and supported interactive services. | Reduces exposure to this specific interactive-content mechanism. |
| Phishing risk | Interactive workflows can make legitimate tasks convenient, but may also make deceptive requests appear more credible. | Removes this particular in-message interaction path; links and attachments can still be malicious. |
| Attack surface | More functionality is enabled in the email-rendering experience. | Less functionality is enabled in that rendering experience. |
| Security controls | Google restricts dynamic email to supported senders and applies security controls. These safeguards reduce risk but do not establish that every message or action is trustworthy. | Dynamic-email functionality is disabled, but normal Gmail security protections remain necessary. |
| Compatibility | Useful for interactive messages and workflows. | Some interactive features will no longer work as intended. |
| Dependency on image settings | Requires Always display external images. | Can be disabled independently; dynamic email will not function when external images are set to ask before displaying. |

Source: Google Gmail Help — Complete tasks without leaving a message

### Important distinction

Dynamic email is not the same as JavaScript executing freely inside your inbox. Gmail supports a constrained interactive email format with sender eligibility and platform controls. The security concern is the additional functionality and interaction it enables, not an assumption that arbitrary website code executes in the message.

Disabling dynamic email does not neutralize malicious links, attachments, social engineering, or other email threats.

---

## 3) Combined configuration: what I recommend

The two settings interact. Google's documentation states that Ask before displaying external images also disables dynamic email.

| Images setting | Dynamic email setting | Result |
| --- | --- | --- |
| Always display external images | Enabled | Maximum convenience; automatic image display and supported interactive email. |
| Always display external images | Disabled | Images display automatically, but dynamic email is disabled. |
| Ask before displaying external images | Enabled | Dynamic email is disabled by the image setting; interactive email will not work. |
| Ask before displaying external images | Disabled | Privacy-oriented configuration: images require your approval and dynamic email is disabled. |

### Recommended settings

| Gmail setting | Recommendation | Reason |
| --- | --- | --- |
| External images | Ask before displaying | Reduces automatic remote image loading and tracking opportunities. |
| Dynamic email | Disabled | Avoids an unnecessary interactive-content feature unless you specifically need it. |

---

## 4) Security researcher assessment

### External images: tracking is the primary privacy concern

The most important risk is not necessarily malware embedded in an image; it is the remote request generated when that image loads.

A marketing email, for example, may contain a unique tracking image URL. When that image is requested, the sender or its analytics provider may infer that the message was opened. Depending on the implementation, the URL and telemetry can also help correlate activity across messages.

Gmail proxies external images and applies security checks. Google states that this prevents senders from using image loading to obtain your computer or location information directly or to set or read browser cookies. Google nevertheless acknowledges that senders may sometimes know whether an email containing an image was opened.

My assessment: Asking before displaying external images is a useful privacy control, even with Gmail's proxying. It reduces automatic tracking requests, even though it is not a guarantee of zero tracking. Other signals, such as links you click, can still disclose activity.

### Dynamic email: reduce functionality you do not need

Dynamic email is useful for interactive workflows, but it is not essential to ordinary email communication. Enabling it introduces an additional rendering and interaction path that you may have no reason to use.

Google applies restrictions to supported dynamic-email senders. Those restrictions help, but they should not be interpreted as a guarantee that every request, workflow, or linked service is safe.

My assessment: Disable dynamic email unless you have a specific workflow that benefits from it. If you later need it, you can re-enable it.

### What these settings do not protect against

Neither setting prevents:

- phishing links and credential theft
- malicious attachments
- tracking through links you click
- social engineering or fraudulent payment requests
- data exposure caused by a compromised Gmail account
- every possible form of email tracking

These settings should complement, not replace, account security, phishing-resistant authentication, and careful handling of unexpected messages.

---

## 5) How to configure Gmail

1. Open Gmail General Settings.
2. Scroll to Images.
3. Select Ask before displaying external images.
4. Scroll to Dynamic email.
5. Clear Enable dynamic email.
6. Click Save Changes.

If you use Gmail on multiple devices, verify the behavior in the clients you use. The web and mobile interfaces may expose the settings differently.

---

## References

- [Google Gmail Help — Turn images on or off](https://support.google.com/mail/answer/6592)
- [Google Gmail Help — Complete tasks without leaving a message](https://support.google.com/mail/answer/13564156)
- [Google Gmail Help — How Gmail protects your privacy and keeps you in control](https://support.google.com/mail/answer/1306727)

---

## Bottom line

For a privacy-focused Gmail configuration, I recommend: Ask before displaying external images and Dynamic email disabled. This keeps ordinary email functionality while reducing automatic remote image requests and disabling an interactive feature you may not need.