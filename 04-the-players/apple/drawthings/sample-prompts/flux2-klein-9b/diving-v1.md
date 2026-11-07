# Sample Prompt - Diving v1

For Flux.2 [klein] 9B, I'd use a detailed natural-language prompt emphasizing photorealism, tropical atmosphere, realistic water, and the liveaboard vessel. Aim for a high-end travel photography look rather than an illustration.

## Draw Things — Flux.2 [klein] 9B prompt

# Tropical Thailand Liveaboard — Photorealistic

```bash
A breathtaking tropical seascape in the Andaman Sea near the Similan Islands of Thailand, captured as a high-end luxury travel and diving magazine photograph.

A beautiful tropical island rises dramatically from crystal-clear turquoise water, with towering limestone cliffs, lush emerald-green jungle vegetation, palm trees, and pristine white-sand beaches. The island is surrounded by shallow turquoise reefs that gradually transition into deep sapphire-blue ocean.

In the foreground, a beautiful 25-meter traditional Thai-inspired luxury scuba diving liveaboard yacht is anchored peacefully in the sheltered bay. The vessel has an elegant white and teak wooden exterior, multiple decks, a shaded upper sun deck, realistic windows, dive platforms, scuba tanks neatly arranged on the dive deck, and a small dive tender alongside. The boat looks authentic, professionally maintained, and purpose-built for multi-day scuba diving expeditions.

The ocean is exceptionally clear, with realistic sunlight penetrating the shallow water, subtle underwater reef formations visible beneath the surface, gentle waves, and natural reflections of the boat and island.

Warm tropical morning sunlight illuminates the scene. A few soft white clouds drift across a brilliant blue sky. The atmosphere feels peaceful, remote, adventurous, and exclusive — the feeling of arriving at a spectacular dive destination on a private tropical liveaboard expedition.

Wide cinematic composition, viewed from a slightly elevated offshore perspective, with the entire dive boat clearly visible and the island forming a magnificent backdrop. Beautiful natural color grading, realistic tropical vegetation, exceptional water detail, physically accurate lighting, realistic yacht proportions, professional marine photography, ultra-detailed textures, lifelike photographic realism, premium travel editorial photography.

No artificial-looking CGI, no fantasy elements, no exaggerated colors.
```

---

## Suggested Draw Things settings

Starting points — adjust based on the Flux.2 [klein] 9B model variant and the settings exposed by your installed Draw Things version.

| Setting            | Recommendation                         |
| ------------------ | -------------------------------------- |
| Model              | Flux.2 [klein] 9B                          |
| Aspect ratio       | 16:9                                   |
| Initial resolution | 1536 × 864                             |
| Alternative        | 1280 × 720                             |
| Steps              | 8–9                                    |
| CFG                | 1.0 (Turbo starting point)             |
| Batch size         | 1                                      |
| Output             | PNG                                    |
| Upscaling          | 2× after selecting the best generation |

Hardware approach

- M4 Max: Use 1536 × 864 as your starting resolution. Try higher resolutions if memory and generation speed permit.
- M6 Mac mini, 32GB: Start at 1280 × 720 or 1536 × 864, batch size 1. Upscale afterward.
- Both machines should be suitable for this model; the 32GB unified-memory ceiling still matters when increasing resolution or running other applications.

## Optional negative prompt

If your Draw Things model configuration exposes a negative-prompt field, try:

cartoon, illustration, painting, 3D render, CGI, fantasy island, oversaturated colors, artificial turquoise water, distorted boat, malformed yacht, unrealistic boat proportions, duplicated vessels, floating objects, warped decks, malformed windows, incorrect perspective, blurry details, low resolution, excessive haze, text, watermark, logo, frame, border

My recommendation: Generate several images at 1280 × 720 or 1536 × 864, select the best composition, and upscale that result. With this particular scene, realistic boat geometry and water reflections are more important than simply pushing the resolution higher.