
# 🧠 1. “One-Click” Workflow (PDF → Q&A + Voice)

### 🔹 Step-by-step (set once, then it’s easy)

**1. Open LM Studio**

* Load a model (see recommendations below)

**2. Drag & drop PDF**

* Just drop the research paper into chat
  ✔️ LM Studio auto-parses it for Q&A 

**3. Turn on voice input**

* Press:

  * **Windows:** `Win + H`
  * **Mac:** `Fn` twice
* Speak your question

**4. Ask naturally**
Examples:

* “Summarize key findings”
* “What were inclusion criteria?”
* “Any limitations in methodology?”
* “Explain this for a patient”

👉 That’s it — this can become a  **daily workflow**

---

# ⚡ Optional (make it feel “one-click”)

Do this once:

### Create a preset (super important)

In LM Studio:

* Settings → Prompts → add this:

```
You are a medical research assistant.

Rules:
- Only use the uploaded document
- Be precise and evidence-based
- Summarize clearly for clinicians
- If unsure, say “not found in document”
```

✔️ Now every chat behaves correctly

---

# 🎤 Voice upgrade (still simple)

If you want better voice (optional):

* Use Whisper locally
* Or just keep using OS dictation (good enough)

---

# 🧬 2. Best Medical-Friendly Models (LM Studio)

These work **locally + are good for research/clinical reading**

---

## 🥇 Best Overall (balanced + accurate)

### 🧠 **Mistral 7B Instruct (Q4_K_M)**

![Image](https://images.openai.com/static-rsc-4/GP5imlOccWWfwgCBX5bKRPSCqA6LZLOXl1LfC8Mt2bRxpI01x5a7V3bClrSvO0qiRFwVX830aizplmjhIcMSG73Xq-z94sq1_2CZyDYckoKPqBuuOR57hxCk4E3Qj1EETK036b4UuK0KdLP6r_QR7gYzh9u0SOvooRqfCobQ8H6e12X434ZoYmi6MjyGJLT6?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/ZCjr3nBUljlJWmWKfkE3LHVK_0dF5J3AQq2Me48HUl1qj_W-cxILVlJopmTs2GxYi2IIjA-Vv7I8cvfS7MPUHEngKCQHGIb2RGRnK05KXNGNvGtGBtg8PBo0IFECEiIgaZwavqG6ZAkFWvPT4QdUuECU7q-Iuli-oLUxQvZIKi9PwxtLAz-M4b0Pq_U6wCgt?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/xRurWfUDzP8DnAqmpSseG63djYKxpMGp35wnncGHFMqnNf9qUhjUnOHH69_KL2GGyNxTg0AjOP_NpmQBZuBpK0XQyQjM-iSxlPFkBi6fyikZ0DyxDz9N3_kb0GgONsasGiotKvSxezKqxH4EBKCsCzRzpUoLGlG5sAKPbtFeJUVK2D6P2LlcEyrmaTI63mQq?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/KckC5hj1G_Yxu1n4TX3-PefPpCalcdFH9trQ0YV6UEh2qyUH6aVTPq0K3OQZF-yRGXdTkVMQGlyxesWQpLER1QMIh3Z7DX9GI-nqw-SuNjUNEmdArA9yKb1tcYOnrUsBukjR4Frt3TSMyacKmyj61kMqeBddNuGRLFUsTmZFo-c0_x9bcuBMywRZnX-eoybT?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/Q7FuHQrJJjrD-hKL7xxU7sk1fvwjsIkbU-A7gc_WHmRSs1g4rnXeXgw4rTQlxjjT09aDujZPWnnkciYrr7kN3TPrt2k1_YiJEVdRc6v5Q5ADyyfoVC2GsNXfUDdfJCY53xhtmz6xrZGIcIO4viawauo6jFE91cgrIIdHGp5WcJCVa4L22FYr-5wCqXaOq926?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/buQgY6fCoQhcokggfwBeOzDYLFItzj60-VDJTyl513fPqk2-B3OLGoc22rlkh_pyrevqAD4CDLS9DTyNsLeSPTEjesJBnqeIDUAXD1c_HOsr38FHGUe0c1R4zrN8TnwPxli1OV3P48tIZW4AZ2nZC_l3kSpWMkx7U8_CwUM0ZaroeYR_aWL0F3749nvrQqov?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/95GIP4atNwYPFMlmRjYwJjIZj_IlVsfxZL_dKhlz-fhMAFbKaCrnaQkbyaGK39SRXfIdHT-ox3KFhEnWJzBA8feXPJ7MCCIoeUimZEIOsjnfz4WY-XbnlUD8dq2sWiEFQMifbugIiSgEImt2K6ZzxkZS53VgSAFuVySN8nxCPI8_oUtWyqR3vNGXhZn16xxQ?purpose=fullsize)

**Why:**

* Very strong reasoning
* Fast on most machines
* Good with scientific text

✔️ Best default choice

---

## 🥈 Better for long PDFs (important for research)

### 🧠 **Llama 3 8B Instruct (Q4_K_M)**

![Image](https://images.openai.com/static-rsc-4/qQnf7VG2cCkyaDLJzRALTAgyiLHQr55-kOHWb7DSM2_scV7WVmAeTi7oJjC7oIaJ43avHv7gr9VS8mIg7lwei2u4rdXuJNDrXfR10mSHRntHc68tCq0-jyqqQkzoWUltZxTdZASm2B-RS4RPAsjwQ9C4TNaN5n_v9nFeNOWTxe8UP8bxnta1qApQWD-p8cMS?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/aVZuiLqVdb0brbwdzfAamaw7MP3mTRXb2gwxTU1xwgSf5X6ZJ_-p_mcRFPmnbplH7liRa84fdQ5ONNBJwn9_nhm0ffpKEYmP5_hGAT12w8pRIAIh3WjNvinZvDQNsvWu-_FVPqVSbs3N7q5qMbkkt_YEbV2yFz42fA7NA6EaLVQfaxcLVYPPkgkNCzYSUwmY?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/h3mw8ldwLQ-k_PKlDVJDmbIkYkydTegl3iaSjNJKE0x1NYzO5wc9nVDRtQu6sSA_DvzTP7lbsirwO59yway1Ty7_qV1DGQzsHhxXYOvmY9Zo0iPEVz_Sx0z1fA95RxaWaC8yEj_RIkuvreAq4CWE764MDJQ3rVlapaEfcEpag0w7JxRkkv3Y8f3TUiLr8rPC?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/3ZxaziQ1RRR3HonxnvtVRIANUbUicVGoDYW4nRiAS9dSwIybu3710en7gLdTV8gkiJPVW4VGANKuhHtdPTx6WX3fjaaxHGTIp7YIFi8TpGrIHh5H0z1TIA7HgozoqHCSfypY6NjbDoJH9O4NHDxxhrTUHVl-IEwSHGpYNts-dMGMc0M80k0zIikdnSH8qqV7?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/tXuxVx63vwd38FB_e0KQqTGTdy7QvtgU4r8DJEjbypTnYkfqFbo_blkxuK6XTrBDaUkJv-immS53j09Nn0Eh6E_5nMrt1LKkUjUXPfnJIcgX4uCQ59t47EFcB7mQz33tDjHkRfspQI_41XE_UObWw35aTaLnNeGUUOS4v3M1cJFSiX_KRKrRXnG4G5T1ggq8?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/D9YO-Y_RV-nrVJz-EBruIbTLk8edq3Bs0zl3DdQRireGC7TAAGq7HzZ5lpmiywyvF13Mfa8SLRrZIb1e-zX5a06wErsvSCCygqLI9ZZzoh18vtmAOdhB_ile79p2WQ4L8wHxR6MBJ_49GitiFrfV7BUvyB8VrwpZpyzta5wgcEm-xPjqgqXiAwdtV2ss6CZW?purpose=fullsize)

**Why:**

* Better with long context
* More consistent answers
* Handles dense papers better

✔️ Use this for heavy research PDFs

---

## 🥉 Lightweight / fast option

### 🧠 **Phi-3 Mini (3.8B)**

![Image](https://images.openai.com/static-rsc-4/vgOCArbWU9LPK7b_abrzrW8cMBECPX1r9TIEWhWSKnNAwrSR9AN09KcRbwLIo1zuL6tkl4yFtysbmMJf2Tto747X1aWweR3YtS9L9m2ljF6PMzEXhtQgaMxEydHJXgTziyoCXZPYOoU53Xw5p8F8sUwbTefPdfECNqdFoK_yM57e2l71nlVlbKHwCJe7Giz4?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/26vDI60OPxAeThNvmeGMwuItEHmoDrxOlUyOfWArzgSq0ohDo2V_qmcc91Vb5kMxQ46sA_5xQsBX__WEiAW534hQCM2-JnyhjqOMHPnntRNctt0hCJVu0TAhfrdWKk3Q0pBVk7Xx5_DiPhFbYPyVf-ZDw8nAT_fV5PDWo85CDa8fpK5PWi-nHfj7rAFHN1Yv?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/V4imQqwa3UIma15Qxr0-1SeP7BuOGriRbETtpmVlcs1J7LxAeAgjdFxsF5hriyXwymNfEiNvSGc654Csri-0A971u0QuRbaoaPPO0Z0xusxA5_NBq574N3GPAd9O82-kMNPEicyE82xAnBbxOQW5XU26n_QEaAV1NmPTswz4IWwXPfA3-xuiI89daAemFnfS?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/ZUkQoI9_R6-rAtXYlv_yQ9eNw5vbOsE65BSXzkypu7PB_xlp1ZtVJj8aB13bkeSlR947hbIBmem8er9OSByP7VK1UcB4oQMrUVSZsYW6HVzf-AWOHKCo3Bpegjza_kfMZBXc-7cOFEzRX1AKX-7OZe9ucoosu7keMmGL9OSDPHVFgYPMXpTDuwd3-_n27FsI?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/GgH4TUCGtokxQHbeOBhjIooRgpRJAyUvD8dCHBEkrleKwMy3gh6hEkVjZwmB70uQyVKBhj7dcJZzqlMPIjkXzXCb2sSifp3rY08LAFolGcLCMtvgy71F3DQzRXwbRDPrYQNjjhZR5QVad4tHtlozOVJ1gVkSSs0FoT43Jp3xdrtVIoD-Mmh7uypvId01puy7?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/dLr0_sPN4OxOFzD4d6LJR7aGfp7gkUhrmhVEPi5RxShIR9vWvdXcvBRSjNf9WPUyphyabjlhGuFFGH9-vPB4b0CaFiwr5MturqMlHzHDj3txh0hCw9ExbnTcVoJBmOCULWciQmMlBeqtCGgzLsMAf6Szm9i73ulJEHScZEzRbI8BwGAtOUfxgct4ooMWlWIr?purpose=fullsize)

**Why:**

* Runs on almost any laptop
* Fast responses
* Good for quick summaries

⚠️ Slightly less accurate for deep research

---

# 🧪 Simple Recommendation (don’t overthink)

👉 Tell them:

* Start with: **Mistral 7B**
* If PDFs are long: switch to **Llama 3 8B**
* If laptop is slow: use **Phi-3 Mini**

---

# 🔒 Why this setup is ideal (for medical work)

* No cloud → patient/privacy safe
* Works offline
* Handles PDFs directly
* Voice makes it frictionless

---

# 🧠 Real-life example

They open a paper and just say:

> “Summarize the treatment outcomes and limitations”

→ Instant structured answer

