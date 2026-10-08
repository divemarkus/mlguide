# Gmail Privacy: Top 5 Settings Everyone Should Review

- Google has put upon themselve's the power to inject Agentic AI on our Gmail by default.
- Read below to understand some of these settings.

> Markus, given that you've used Gmail since its earliest days, I understand why this feels different. You signed up when Google's famous motto was "Don't be evil." Over time, Gmail has evolved from an email service into a platform connecting email, calendars, contacts, advertising, and AI-powered services.

> Your concern about the new Smart Features setting is legitimate. Gmail can process email content to provide useful features, but that is not necessarily the same as using the content for advertising or training a general-purpose AI model. These are distinct uses of data, with different controls.

> My recommendation is to approach Gmail as a privacy-conscious systems engineer would: minimize data use, disable unnecessary integrations, secure the account, and periodically review what Google retains.

## 1. Turn off Smart Features and Personalization

Where: Gmail → Settings → General → Smart features.

Gmail's smart features use email content and activity to provide conveniences such as:

- Smart Compose and Smart Reply
- Automatic inbox categories
- Package tracking and event summaries
- AI-powered summaries and related experiences, where available

Google also provides separate controls for smart features in other Google products.

My recommendation: If you want to minimize Google's use of your email for personalized features, turn off both categories:

- Smart features in Gmail, Chat and Meet
- Smart features in other Google products

The exact labels may vary depending on your account and Google's current interface.

Trade-off: You may lose automatic inbox categorization, suggested replies, and certain summaries or integrations.

Important: Disabling Smart Features does not stop Gmail from processing email for delivery, spam filtering, malware detection, and service security. It also does not necessarily disable every separately controlled AI feature.

## 2. Turn off personalized advertising

Where:&#x20;

Google My Ad Center



Turn off Personalized ads.

Google states that it does not use the content of your Gmail messages to select ads. However, Google may personalize advertising using other activity associated with your account, such as searches and activity across Google services.

My recommendation: Disable personalized advertising if you prefer less behavioral profiling.

Trade-off: You may still see advertisements, but they should be less tailored to your interests.

This is separate from Gmail's Smart Features setting. Turning off one does not automatically turn off the other.

## 3. Limit Web & App Activity and configure auto-delete

Where:&#x20;

Google Account Activity Controls



Review Web & App Activity, including any available options for saving activity from sites and apps that use Google services.

Consider:

- Turning off activity collection you don't need.
- Setting the shortest practical auto-delete period.
- Reviewing other activity controls, including YouTube History, if applicable.
- Periodically deleting existing activity you no longer want retained.

These controls govern eligible activity associated with your Google account. They are broader than Gmail and may affect personalization in Search and other Google services.

My recommendation: Disable unnecessary activity tracking and configure auto-delete rather than retaining activity indefinitely.

Trade-off: You may lose some personalized recommendations, activity history, and continuity across devices.

## 4. Audit third-party app access to Gmail

Where:&#x20;

Google Account third-party connections



Review the applications and services authorized to access your Google account.

Pay particular attention to:

- AI assistants and email summarizers.
- Productivity and calendar integrations.
- Email automation services.
- Old applications you no longer use.
- Services with permission to read, send, delete, or manage email.

OAuth permissions can give third-party applications substantial access to your mailbox, depending on the permissions granted.

My recommendation: Remove unfamiliar, obsolete, or unnecessary connections. Grant access only when a service provides a clear benefit.

Trade-off: Removing access may break legitimate integrations until you authorize them again.

This becomes particularly important when connecting Gmail to agentic AI systems. An AI agent with mailbox access can potentially expose sensitive information or take actions on your behalf if it is compromised or misconfigured.

## 5. Harden account security and recovery access

Where:&#x20;

Google Account Security Checkup



Review the following:

- Enable a passkey or two-step verification.
- Review signed-in devices and recent security activity.
- Remove unfamiliar sessions and devices.
- Verify recovery email addresses and phone numbers.
- Review app passwords and other account access methods, if used.

My recommendation: Use a passkey or hardware security key where practical, and maintain secure recovery options.

Your Gmail account may also serve as the password-reset mechanism for financial accounts, brokerage accounts, cloud services, and other important systems. Protecting it is therefore more than just protecting email.

Trade-off: Stronger authentication adds a small amount of friction but substantially improves resistance to account takeover.

## Quick checklist: Recommended privacy configuration

Use this checklist while reviewing your settings.

### Privacy review

0 of 8 complete

Disable Smart Features in Gmail, Chat and Meet

Reduces personalized email conveniences.

Disable Smart Features in other Google products

Limits cross-product use of Gmail data for smart features.

Turn off personalized ads

Google My Ad Center.

Review Web & App Activity and auto-delete

Minimize unnecessary activity retention.

Remove unnecessary third-party app access

Pay special attention to AI tools and email integrations.

Enable passkey or two-step verification

Strengthen account authentication.

Review forwarding addresses and filters

Look for unauthorized copying or redirection of messages.

Export a periodic Gmail backup

Use Google Takeout to retain a copy of your mailbox.

Copy checklistReset

## Two additional privacy measures worth considering

### Review forwarding and filters

In Gmail, open Settings → See all settings → Forwarding and POP/IMAP and review your forwarding configuration. Also inspect Filters and Blocked Addresses.

Look for unexpected forwarding addresses, filters that automatically forward messages, or rules that archive or delete security notifications. These can be indicators of unauthorized access.

### Back up your mailbox

Use&#x20;

Google Takeout

&#x20;to export your Gmail data periodically.



A backup gives you a copy of your messages and attachments if you eventually decide to migrate away from Gmail.

## What if you want stronger privacy than Gmail can provide?

The distinction is important:

| Privacy capability                                        | Gmail with Smart Features disabled | End-to-end encrypted email                                              |
| --------------------------------------------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| Provider processes email for service delivery             | Yes                                | Yes, but protected message contents can be inaccessible to the provider |
| Provider can access ordinary unencrypted message contents | Generally yes                      | Designed to prevent provider access to protected message contents       |
| Works seamlessly with ordinary Gmail recipients           | Yes                                | Depends on the service and encryption method                            |
| Smart features and integrations                           | Available subject to settings      | Depends on the provider and configuration                               |

For example,&#x20;

Proton Mail

&#x20;offers end-to-end encryption between Proton users and supports additional methods for protected messages to external recipients. Ordinary email sent to a Gmail recipient is not automatically end-to-end encrypted merely because the sender uses Proton.



Even with encrypted email, metadata, recipient information, and messages outside the protected encryption arrangement can remain exposed.

## My bottom line

I wouldn't abandon Gmail solely because Google offers AI-powered features. I would, however, treat the account as a valuable data repository and deliberately minimize what gets used for personalization.

My recommended starting point is:

1. Smart Features OFF in both categories.
2. Personalized ads OFF.
3. Activity retention minimized.
4. Third-party access audited.
5. Strong authentication enabled.

That provides a sensible privacy baseline without requiring you to stop using Gmail.

The key distinction is that privacy settings reduce particular uses of your data; they do not make Gmail a zero-processing or end-to-end encrypted email service. If your goal is to prevent the email provider itself from accessing message contents, changing Gmail settings alone is insufficient.