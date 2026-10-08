# Gmail - Smart Features

1. Executive summary
Google's current documentation confirms three independent controls. The one in your Gmail General settings governs the use of Gmail, Chat and Meet content and activity for smart features within those apps. It is not the same as the two controls governing cross-product Workspace experiences and other Google products. 

From a security-research perspective, the central question is not simply whether Gmail uses AI. It is which data uses you authorize, for which features, and whether you can stop future use of that data.

---

2. Bordered comparison table: Gmail Smart Features ON vs. OFF
This table covers the specific Gmail setting, not the two separate Workspace settings. The behavior below is based on Google's current Help documentation. 
Area	ON — enabled	OFF — disabled	Security assessment
Content and activity	Gmail, Chat and Meet may use content and activity to personalize smart features within those products.	This use for the covered smart features stops going forward.	ON authorizes additional processing for convenience.
Smart Compose	Suggested text while composing emails.	Unavailable through this setting.	Draft suggestions may require interpreting what you write and its context.
Smart Reply	Suggested replies to emails.	Unavailable through this setting in Gmail.	Less automated interpretation of message content for these suggestions.
Inbox categories	Automatic Primary, Social and Promotions categorization.	These automatic categories are unavailable.	You may need to classify messages manually.
Summary cards	Relevant travel, package-tracking and other details can be surfaced from emails.	These summary cards are unavailable.	ON allows message-derived information to be extracted and presented in a more structured form.
Personalization	Covered features adapt to your experience and activity.	Covered personalization is disabled.	OFF reduces one category of data use; it is not a universal privacy switch.
Feature improvement	Google says Workspace content and activity may be used to improve smart features when relevant settings are enabled.	Google says the content and activity will no longer be actively processed to improve the relevant features after the setting is turned off.	OFF limits future use for this stated purpose.
Previously developed learnings	Improvement learnings may be retained.	Google says previously developed learnings may persist.	OFF is not a promise to reverse or erase prior improvements.
Email delivery and storage	Normal Gmail operation.	Normal Gmail operation continues.	This switch does not disable the core mail service.
Spam and security	Gmail continues its security protections.	Gmail continues its security protections.	Do not confuse Smart Features with spam filtering or malware defense.
Other AI features	Some separately controlled features may remain available.	Some separately controlled features may remain available.	Check feature-specific controls too.
Other Google products	This Gmail-specific setting does not govern all cross-product use of Workspace data.	Other cross-product settings remain independent.	Review the other two controls separately.
Source: 
Google Gmail Help — Smart Features

---

3. What Google's wording means from a security research perspective
A. The control is consent for a defined purpose, not a complete data-processing opt-out
Google's current documentation says that when the relevant setting is ON, Workspace content and activity can be used to provide the covered smart features. It also says this data may be processed to improve those features. Turning the setting OFF stops future use for the covered purposes. 
That distinction matters:
- ON: You authorize the specified personalization experiences and the associated data use described by Google.
- OFF: You withdraw that authorization for the covered future experiences and improvement processing.
- Neither setting: Establishes that Google stops all processing necessary to run Gmail.
Google's January 2025 announcement explicitly says the newer controls provide more granular choices without changing its underlying data-handling practices. 
B. "Improving smart features" is not proof that every email trains a general-purpose AI model
Google states that Workspace content and activity may be used to improve smart features, and gives examples involving aggregated Gmail data used to develop Smart Compose and user studies used to develop Smart Reply. 
The important distinction is that this disclosure does not, by itself, establish that every email is used to train Gemini or another general-purpose foundation model.
A careful security assessment should distinguish:
1. Processing a message to deliver a feature to you.
2. Using content or activity to improve a specific feature.
3. Training or fine-tuning a general-purpose model.
4. Retaining information or learned parameters after the original data is no longer actively processed.
Google's Smart Features documentation addresses the first two and acknowledges that previously developed learnings may persist after you switch OFF. It does not provide enough detail to conclude that all model-training pathways are covered by this single control.
C. OFF is not retroactive erasure
This is one of the most important details in Google's documentation.
Google explicitly states that previously developed learnings may persist even after you turn off a setting or delete Workspace content and activity from your Google Account. It also states that the relevant content and activity will no longer be actively processed to improve those features after the setting is turned off. 
From a data-governance perspective, this means:
- Turning OFF is a control over future processing for the specified purposes.
- It is not a guarantee that prior processing is undone.
- It does not promise that all derived information, model parameters, or aggregated learnings are deleted.
- The documentation does not establish that every historical derivative contains identifiable personal information, either.
This is a meaningful limitation, but it should not be overstated as proof that identifiable emails are permanently embedded in an AI model.
D. The largest practical risks may be account compromise and third-party access
Smart Features is only one part of the Gmail threat model. Even with it OFF, your inbox remains sensitive data.
Threat	Potential impact	Relevant mitigation
Account takeover	An attacker reads messages, searches for sensitive records, or resets passwords for other accounts.	Passkeys or hardware security keys, strong recovery controls, and security alerts.
Malicious OAuth application	An authorized third-party app reads or manipulates mail within its granted permissions.	Audit  Google account connections  and revoke unnecessary access.
Malicious forwarding rule or filter	Messages are copied, hidden, archived, or deleted without your knowledge.	Audit Gmail forwarding settings and filters.
Phishing and malicious attachments	Credentials or devices may be compromised.	Use phishing-resistant authentication and maintain endpoint security.
Cross-product data exposure	Email-derived information may appear in other products when their relevant settings permit it.	Review the separate Workspace and other Google products controls.
These threats are not all caused by Smart Features. They illustrate why disabling personalization is useful for data minimization but is not a substitute for securing the account and its integrations.

---

4. The two other controls you should not overlook
Google's current documentation identifies three independent settings. 
Setting	What it controls	Privacy-focused approach
Smart features in Gmail, Chat and Meet	Smart features within those apps, including Smart Compose, Smart Reply, automatic inbox categorization and summary cards.	OFF if you do not need these conveniences.
Smart features in Google Workspace	Cross-product Workspace personalization, such as Gmail events appearing in Calendar, personalized search and supported Gemini features.	OFF if you do not want these cross-product experiences.
Smart features in other Google products	Use of Workspace data for supported experiences in products such as Maps, Wallet, Gemini and Search.	OFF if you want to minimize this cross-product use.
Google notes that other product controls can still apply, and that explicitly sharing Workspace data through screen actions can make some features available even when the cross-product setting is OFF. 

---

5. My recommendation
For a privacy-first configuration, I would turn OFF all three settings unless you have a specific need for the functionality they provide.
My reasoning is straightforward:
- Data minimization: Do not authorize optional processing when you do not use the resulting features.
- Purpose limitation: Keep email data within the products and workflows where you actually need it.
- Least privilege: Review third-party integrations independently of Google's own personalization controls.
- Clear expectations: Understand that turning OFF a setting limits specified future processing; it does not erase historical processing or stop all service-related processing.
I would not claim that Smart Features ON automatically means Google employees are reading your email, that every message trains Gemini, or that turning OFF makes Gmail private from Google. The official documentation does not support those blanket conclusions.
Sources
1. Google Workspace Blog — Updated smart feature settings give users increased choice and control
    — January 7, 2025.
2. Gmail Help — Learn about smart features and controls for Google Workspace and other Google products
    — current feature definitions, independent controls and data-use disclosures.
3. Google Blog — New settings for smart features and personalization in Gmail
    — November 16, 2020, useful historical context for Google's original explanation of these controls.

---

## Bottom line: 
If you do not need Gmail's personalized conveniences, turning Smart Features OFF is a reasonable data-minimization decision. The most important nuance is that the switch controls specific future uses of your content and activity, not every way Google processes email or every possible use of previously developed learnings.