# Replication Plan: Fariss (2014) APSR

---

## Time Estimate

**Honest answer: 48 hours is tight but doable with reduced MCMC settings.**

The README warns that "MCMC simulations take several days to finish on a server" with original settings (50k burn-in + 250k draws × 2 chains). On a laptop, that is 3–5 days per model. There are two main models.

**Feasible path**: Reduce to ~5k burn-in + 25k draws. This takes ~4–8 hours per model on a modern laptop, produces noisier but directionally correct posteriors, and lets you finish everything in ~30–40 hours. You must flag the reduced settings in the write-up.

Realistic time breakdown:
- Setup + data: 1h
- Dynamic model MCMC: 6–10h
- Constant model MCMC: 6–10h
- YSTAR run: 2–3h
- Analysis + figures: 4–5h
- Complementary ML: 4–6h
- Write-up: 3–4h

**Total: ~26–39h**, leaving some buffer within 48h.

---

## Step 1 — Environment Setup (~1h)

Install system dependency JAGS first (required before rjags), then R packages.

```
brew install jags          # macOS
install.packages(c("rjags", "coda", "foreign"))
```

**Files to create:** none.

---

## Step 2 — Data Preparation (~1h)

Copy all source CSVs into `data/` so the replication code has a single clean data directory. The input files exist in `faris_files/LatentRepressionDynamicStandardDynamicX/`.

**Files to create in `data/`:**
- `CIRI_physint_data20120401.csv`
- `PTS2011.csv`
- `Hathaway2002longData.csv`
- `ITT_CY.csv`
- `Genocide_Politicide_panel2010.csv`
- `Rummel_Politicide_panel1987.csv`
- `OneSidedKilling1989_2011.csv`
- `whpsi.csv`
- `Massive_State_Repression_Panel_1988.csv`

---

## Step 3 — Dynamic Standard Model (main model) (~6–10h MCMC)

Mirror `faris_files/LatentRepressionDynamicStandardDynamicX/LatentRepressionDynamicStandardDynamicX.R` exactly, with two changes: (1) paths point to `data/` and `code/`, (2) MCMC settings reduced.

Key MCMC parameters to change for feasibility (original → reduced):
- `BURNIN`: 50,000 → 5,000
- `DRAWS`: 250,000 → 25,000
- `CHAINS`: 2 (keep)
- `THIN`: 10 (keep)

The JAGS model file `.bug` is used as-is — copy it to `code/`.

**Files to create:**
- `code/02_dynamic_model.R` — adapted R script
- `code/LatentRepressionDynamicStandardDynamicX.bug` — copied JAGS model (unchanged)
- `data/EstimateDynamicStandardDynamicX.csv` — posterior draws output
- `data/image_dynamic.Rdata` — saved workspace

---

## Step 4 — Constant Standard Model (comparison model) (~6–10h MCMC)

Mirror `faris_files/LatentRepressionConstantStandardDynamicX/LatentRepressionConstantStandardDynamicX.R` with the same path and MCMC adjustments as Step 3. This is the baseline model that assumes no change in the accountability standard.

**Files to create:**
- `code/03_constant_model.R` — adapted R script
- `code/LatentRepressionConstantStandardDynamicX.bug` — copied JAGS model (unchanged)
- `data/EstimateConstantStandardDynamicX.csv` — posterior draws output
- `data/image_constant.Rdata` — saved workspace

---

## Step 5 — YSTAR Posterior Predictives (~2–3h MCMC)

Both model `.R` scripts include a second JAGS run using the `_YSTAR.bug` model file that samples posterior predicted values (`ystar`). Run these after Steps 3 and 4 (they reuse the same initialized model object).

Reduce DRAWS to 5,000 for YSTAR runs (original: 20,000).

**Files to create:**
- `code/LatentRepressionDynamicStandardDynamicX_YSTAR.bug` — copied (unchanged)
- `code/LatentRepressionConstantStandardDynamicX_YSTAR.bug` — copied (unchanged)
- `data/EstimateDynamicStandardDynamicX_YSTAR.csv`
- `data/EstimateConstantStandardDynamicX_YSTAR.csv`

---

## Step 6 — Analysis and Figures (~4h)

Read the posterior CSV outputs from Steps 3–4. Reproduce the key results:

- **Figure 1**: Yearly mean ± 95% CI for CIRI additive index and PTS (raw data trend showing apparent stagnation)
- **Figure 3** (or equivalent): Scatterplot comparing constant vs. dynamic latent estimates by country-year
- **Figure 5** (or equivalent): Time series of dynamic latent variable (global mean ± CI), showing improvement over time
- **Table 4**: Posterior means of discrimination (β) and difficulty (α) parameters

**Files to create:**
- `code/04_analysis_figures.R`
- `data/figures/fig1_raw_trends.pdf`
- `data/figures/fig3_constant_vs_dynamic.pdf`
- `data/figures/fig5_dynamic_time_trend.pdf`

---

## Step 7 — Complementary Unsupervised Analysis (~4–6h)

Apply one additional unsupervised ML method to the same 13-indicator panel matrix assembled in Steps 3–4. Compare its structure to the IRT latent scores. Three options — **pick one**:

### Option A: Polychoric Factor Analysis (1-factor)
Use the `polychoric` + `fa` functions (psych package) on the item matrix. Extract the first factor score for each country-year and compare it to the IRT θ estimates. This is the closest methodological alternative to IRT and the most directly comparable.
> Best choice if you want a clean "IRT vs. FA" comparison.

### Option B: UMAP Dimensionality Reduction
Project the 13-item matrix into 2D using UMAP (`uwot` package). Color points by year and region to visualize whether the temporal trend Fariss finds is visible in a purely non-parametric embedding.
> Best choice if you want a visual, exploratory complement.

### Option C: Gaussian Mixture Model (GMM) Clustering
Fit a GMM (mclust package) on the 13-item matrix to find latent repression "regimes." Tabulate cluster membership by year and region. Test whether cluster assignment correlates with the IRT score.
> Best choice if you want a substantively interpretable typology.

**Files to create:**
- `code/05_complementary_ml.R`
- `data/figures/fig_complementary.pdf`

---

## File Summary

```
replication/
├── plan.md                          ← this file
├── data/
│   ├── [9 source CSVs]              ← copied from faris_files/
│   ├── EstimateDynamicStandardDynamicX.csv
│   ├── EstimateConstantStandardDynamicX.csv
│   ├── EstimateDynamicStandardDynamicX_YSTAR.csv
│   ├── EstimateConstantStandardDynamicX_YSTAR.csv
│   ├── image_dynamic.Rdata
│   ├── image_constant.Rdata
│   └── figures/
│       ├── fig1_raw_trends.pdf
│       ├── fig3_constant_vs_dynamic.pdf
│       ├── fig5_dynamic_time_trend.pdf
│       └── fig_complementary.pdf
└── code/
    ├── 02_dynamic_model.R
    ├── 03_constant_model.R
    ├── 04_analysis_figures.R
    ├── 05_complementary_ml.R
    ├── LatentRepressionDynamicStandardDynamicX.bug
    ├── LatentRepressionDynamicStandardDynamicX_YSTAR.bug
    ├── LatentRepressionConstantStandardDynamicX.bug
    └── LatentRepressionConstantStandardDynamicX_YSTAR.bug
```

---

## Key Notes

- **MCMC is the bottleneck.** Start Steps 3 and 4 as early as possible; let them run overnight.
- The `.bug` files are the JAGS model specs — copy them unchanged, only the `.R` wrappers need editing.
- `STARTYEAR <- 1949` in the R scripts determines time indexing; do not change it.
- The panel structure (unbalanced, country-year) requires the `country[]` and `year[]` index vectors built in the data prep section of the `.R` files — keep that code intact.
- Save workspace with `save.image()` frequently; if R crashes after a long MCMC run you can reload without re-running.
