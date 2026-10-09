
# Chrome: Disable Google's AI Search Results

Google increasingly integrates AI-generated summaries into Search. If you prefer traditional search results and want to use AI only when you choose, you can configure Chrome to use a search URL that requests Google's web results without its AI Overview.

## Configuration

1. Open Chrome and navigate to `chrome://settings/searchEngines`.
2. Under Site search, click Add.
3. Enter the following settings:

| Field                         | Value                                       |
| ----------------------------- | ------------------------------------------- |
| Search engine                 | `GoogleNoAI`                                |
| Shortcut                      | `@web`                                      |
| URL with %s in place of query | `https://www.google.com/search?q=%s&udm=14` |

4. Click Save.
5. Find `GoogleNoAI` in your search engine list, open its menu, and select Make default if you want all address-bar searches to use it.

## What does `udm=14` do?

The `udm=14` parameter requests Google's Web search results view, emphasizing traditional web links rather than Google's blended results experience.

Important: This is a workaround, not a guaranteed permanent opt-out of every AI feature. Google controls its search interface and may change how the parameter behaves. It also does not disable AI features elsewhere in Google.

Your screenshot shows `{google:baseURL}search?q=%s&udm=14`, which is a Chrome-specific template. The explicit URL above is easier to understand and use across configurations.

Security-conscious recommendation: Keep this as your default search engine if it meets your needs, and invoke AI tools separately when you deliberately want them.