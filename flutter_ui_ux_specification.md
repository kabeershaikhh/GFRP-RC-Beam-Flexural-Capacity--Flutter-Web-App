# GFRP-RC Web App — UI/UX & Design Specification
**Prepared for ICEC 2026 Research Presentation**  
*Companion Document to `flutter_api_integration_guide.txt`*

---

## 1. Design Philosophy & Aesthetic

* **Theme:** Professional Structural / Civil Engineering.
* **Mood:** Precise, modern, industrial, clean, and publication-ready.
* **Avoid:** Flamboyant neon colors, cluttered dashboards, overly dense walls of AI theory. Keep AI info concise—engineers care about **accuracy, code compliance, and constructability**.
* **Palette (Silver / Slate / Steel):**
  * **Background:** Light metallic silver-gray (`#F1F5F9` to `#E2E8F0`).
  * **Card Surfaces:** Crisp white (`#FFFFFF`) with subtle silver borders (`#CBD5E1`) and soft shadows.
  * **Primary Steel / Header:** Deep slate gray (`#1E293B` or `#0F172A`).
  * **Accent Blue (Buttons / Highlights):** Blueprint / Steel Blue (`#0284C7` or `#2563EB`).
  * **Status Colors:**
    * 🟢 **Safe / Preferred (Concrete Crushing):** Emerald Green (`#10B981`)
    * 🟠 **Warning / Sudden Rupture (GFRP Rupture):** Amber (`#F59E0B`)
    * 🔴 **Constructability Hazard (Spacing Fail):** Rose / Crimson (`#EF4444`)

---

## 2. Layout & Page Structure (Two-Column Desktop View)

On web browsers, use a responsive **Two-Column Split Layout** (Inputs on the left, Results on the right). On mobile or narrow windows, it gracefully stacks vertically.

```
+-----------------------------------------------------------------------------------+
|  [Logo/Icon]  GFRP-RC Beam Capacity Analyzer  |  ICEC 2026 Conference Research     |
+-----------------------------------------------------------------------------------+
|  Banner: "AI Surrogate Model (ANN R²=0.998) & ACI 440.1R-15 Code Comparison Tool"  |
+-----------------------------------------------------------------------------------+
|                                        |                                          |
|        LEFT COLUMN: INPUT CONSOLE      |      RIGHT COLUMN: ENGINEERING RESULTS   |
|                                        |                                          |
|  [Presets: Standard | Heavy | Light]  |  [HERO CARD: AI vs ACI Capacity]         |
|                                        |    • AI Predicted Mn:  939.4 kN·m        |
|  1. Section Geometry                   |    • ACI 440.1R Code:  907.1 kN·m        |
|     - Width b (mm)                     |    • Difference:       +3.6% Gain        |
|     - Total Depth h (mm)               |                                          |
|     - Clear Cover (mm)                 |  [SAFETY & BEHAVIOR CARD]                |
|                                        |    • Failure Mode: [CONCRETE CRUSHING]   |
|  2. Concrete Properties                |    • Reinforcement Ratio: ρ/ρb = 1.81    |
|     - Strength f'c (MPa)               |    • Factored Capacity (φMn): 589.6 kN·m |
|                                        |                                          |
|  3. GFRP Reinforcement                 |  [DETAILING & CONSTRUCTABILITY CARD]     |
|     - Elastic Modulus Ef (GPa)         |    • Clear Bar Spacing: 23.5 mm [FAIL ✕] |
|     - Tensile Strength ffu (MPa)       |    • Min Reinforcement: [PASS ✓]         |
|     - Bar Size (ASTM #3 to #8)         |    • Effective Depth d: 689.4 mm         |
|     - Number of Bars                   |                                          |
|                                        |                                          |
|  [ > CALCULATE CAPACITIES BUTTON ]     |                                          |
|                                        |                                          |
+-----------------------------------------------------------------------------------+
|  Footer: 16th International Civil Engineering Conference (ICEC 2026) | NED & MUET |
+-----------------------------------------------------------------------------------+
```

---

## 3. Top Banner & Header Details

### Header Title
* **Main Title:** `GFRP-RC Flexural Capacity Analyzer`
* **Conference Pill Badge:** `ICEC 2026 Conference Paper` (Silver/Blue chip)

### User Guide / Context Banner (Concise)
A slim, dismissible silver banner just below the header:
> *"Predicts nominal flexural capacity ($M_n$) of GFRP-RC rectangular beams using an Artificial Neural Network (MLP) trained on 15,000 fiber FE simulations. Directly benchmarked against ACI 440.1R-15 code equations."*

---

## 4. Left Column: Input Console

Organize into 3 visual card groups with sliders or number input boxes:

### Group A: Cross-Section Geometry
* **Beam Width $b$:** Number box + slider (`150` – `400 mm`, default: `250`)
* **Total Depth $h$:** Number box + slider (`300` – `900 mm`, default: `500`)
* **Clear Cover:** Dropdown or field (`25, 30, 35, 40, 45, 50 mm`, default: `35`)

### Group B: Concrete Material
* **$f'_c$ Compressive Strength:** Slider/box (`20` – `55 MPa`, default: `35`)

### Group C: GFRP Reinforcement
* **Bar Diameter / Size:** Dropdown of standard ASTM sizes:
  * `#3 (9.53 mm)`
  * `#4 (12.70 mm)`
  * `#5 (15.88 mm)` *(default)*
  * `#6 (19.05 mm)`
  * `#7 (22.23 mm)`
  * `#8 (25.40 mm)`
* **Number of Bars ($n$):** Step selector or slider (`2` to `8` bars, default: `4`)
* **Modulus $E_f$:** (`40` – `65 GPa`, default: `50`)
* **Tensile Strength $f_{fu}$:** (`700` – `900 MPa`, default: `800`)

### Quick-Fill Presets (Top of Input Column)
Add 3 quick-fill chips so anyone can test with 1 click:
1. `Standard Beam` (250×500 mm, 4 #5 bars)
2. `Heavy Girder` (350×750 mm, 6 #7 bars)
3. `Light Beam` (200×400 mm, 2 #3 bars)

---

## 5. Right Column: Engineering Results Dashboard

When the user clicks **"Calculate Capacities"**, display 3 structured result cards:

### Card 1: Capacity Comparison (Hero Card)
* **Large Numbers Side-by-Side:**
  * **AI Prediction ($M_{n,\text{AI}}$):** Bold, highlighted in Steel Blue (e.g., `939.4 kN·m`).
  * **ACI Code Baseline ($M_{n,\text{ACI}}$):** Clean dark gray (e.g., `907.1 kN·m`).
* **Comparison Metric Badge:**
  * Shows `+3.6% AI Recovery` (pill badge).
  * Tooltip / Subtitle: *"AI accounts for continuous concrete softening curves, recovering ~3-5% capacity lost to ACI's rectangular stress block simplification."*

### Card 2: Failure Mode & Safety Factors
* **Governing Failure Mode Badge:**
  * If **Concrete Crushing**: Green badge with text:
    `🟢 Concrete Crushing (Ductile / Preferred in GFRP Design)`
  * If **GFRP Rupture**: Amber/Orange badge with text:
    `🟠 GFRP Rupture (Brittle / Tension-Controlled Risk)`
* **Balanced Ratio ($\rho/\rho_b$):** Value display (e.g., `1.81`).
* **Factored Design Strength ($\phi M_n$):**
  * Displays: `589.6 kN·m` with note `(Applied φ = 0.65 for design drawings)`.

### Card 3: Constructability & Detailing Checks
Engineers love this card because it prevents construction mistakes:
* **Clear Bar Spacing:** Displays spacing (e.g., `23.5 mm`).
  * If `spacing_ok == true`: Green check `✓ Spacing Adequate for Aggregate`.
  * If `spacing_ok == false`: Red alert `✕ Spacing Insufficient (< 25 mm). Risk of honeycombing! Consider 2 layers or widening.`
* **Minimum Reinforcement:** `✓ Meets ACI 440.1R ρ_min criteria`.
* **Effective Depth $d$:** (e.g., `689.4 mm`).

---

## 6. Footer & Academic Citation

Place a slim, elegant footer at the bottom of the page:

* **Paper Title:** *"Machine-Learning-Assisted Flexural Capacity Prediction of GFRP-Reinforced Concrete Beams"*
* **Conference:** 16th International Civil Engineering Conference (ICEC-2026), Karachi, Pakistan.
* **Affiliations:** Department of Civil Engineering, NED University of Engineering & Technology & Mehran University (MUET).
* **Research Model Info:** `ANN Model R² = 0.9982 (Synthetic) | R² = 0.87 (12 Real Lab Beams)`

---

## 7. Responsive Behavior Rules

1. **Desktop / Laptop (> 900px wide):**
   * Left column (Inputs): 45% width.
   * Right column (Results): 55% width.
   * Both stay on screen simultaneously without page scrolling.
2. **Tablet / Mobile (< 900px wide):**
   * Inputs stack on top.
   * "Calculate" button scrolls down to the results cards.
3. **Empty State:**
   * Before the first calculation, the right pane shows a placeholder card with an outline sketch of a beam cross-section and the text: *"Enter parameters on the left and click Calculate to view AI & ACI predictions."*
