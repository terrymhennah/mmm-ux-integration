# Proof of Concept — UX-Extended Marketing Mix Modelling

## Overview

This document describes the scope, technical achievements, and limitations of the proof of concept (POC) phase of the dissertation project *"Integrating User Experience Metrics into Marketing Mix Modelling: A Comparative Analysis of Bayesian Frameworks for Holistic Marketing Attribution"*.

---

## What This POC Demonstrates

### Research Gap Addressed
A review of three leading open-source Bayesian MMM frameworks — Google Meridian, Meta Robyn, and PyMC-Marketing — confirms that **none natively incorporate UX metrics as model parameters**. This POC demonstrates that UX metrics can be integrated into all three frameworks without modification to the underlying framework code, using each framework's existing support for control variables and organic covariates.

### Technical Feasibility Confirmed
The POC establishes that the following is technically achievable:

| Capability | Status | Evidence |
|---|---|---|
| UX metrics as model inputs in PyMC-Marketing | ✅ Confirmed | Notebook 01 — `control_columns` parameter |
| UX metrics as model inputs in Meridian | ✅ Confirmed | Notebook 02 — covariate analysis |
| UX metrics as organic variables in Robyn | ✅ Confirmed | Notebook 03 — `organic_vars` parameter |
| Data pipeline connecting raw data → models | ✅ Confirmed | Notebook 04 — dbt + SQLMesh |
| PostgreSQL as central data store | ✅ Confirmed | All notebooks read from `stg_mmm_weekly_data` |
| Results written back to database | ✅ Confirmed | `mmm_results_pymc`, `mmm_results_meridian` tables |

---

## Dataset

### Synthetic Data Specification
- **Weeks:** 104 (2 years: January 2022 — December 2023)
- **Media channels:** 5 (TV, Digital, Social, Search, Radio)
- **UX metrics:** 5 (NPS score, bounce rate, session duration, pages/session, conversion rate)
- **Target variable:** Weekly sales revenue (£)
- **Data source:** Synthetically generated — no real business data used

### UX Metric Mapping to Dissertation Variables
| Dataset Variable | Dissertation UX Construct | Rationale |
|---|---|---|
| `nps_score` | Net Promoter Score / CSAT | Direct satisfaction measure |
| `bounce_rate` | Page engagement quality | Negative UX signal |
| `session_duration` | Website engagement depth | Positive UX signal |
| `pages_per_session` | Content engagement | Positive UX signal |
| `conversion_rate` | UX effectiveness | Direct outcome metric |

> **Note for full dissertation:** The synthetic dataset used in this POC was generated without documented ground truth parameters. The full dissertation will use a new dataset with known true parameters to enable parameter recovery validation (target: ≤15% MAD for marketing parameters, ≤20% for UX parameters).

---

## Data Engineering Architecture

A production-grade data pipeline was implemented to demonstrate that UX-extended MMM can be operationalised at scale:

```
mmm_dissertation_data.csv
         │
         ▼
PostgreSQL: mmm_weekly_data          ← raw storage
         │
         ▼ (dbt)
PostgreSQL: stg_mmm_weekly_data      ← cleaned + validated
         │
         ▼ (dbt)
PostgreSQL: mart_mmm_channel_performance  ← channel ROAS + spend %
         │
         ▼ (SQLMesh — weekly schedule)
PostgreSQL: mmm_results_pymc         ← PyMC model outputs
PostgreSQL: mmm_results_meridian     ← Meridian model outputs
```

**Tools:** dbt-core 1.11, SQLMesh, PostgreSQL 17, DuckDB, Jupyter Lab

---

## Limitations of This POC

The following limitations are acknowledged and will be addressed in the full dissertation:

### 1. No Baseline Comparison (Media Only)
This POC implements only the **UX-enhanced configuration**. The full dissertation requires:
- Standard MMM (media spend only) for each framework
- Side-by-side comparison of model performance metrics
- Statistical test of improvement: R², MAPE, RMSE on 80/20 train/test split

### 2. No Statistical Evaluation
The dissertation evaluation criteria (from the research proposal) have not yet been tested:
- ≥5% relative improvement in R² from adding UX metrics
- UX 95% credible intervals excluding zero
- CV ≤30% across frameworks for UX effect estimates
- Parameter recovery ≤15% MAD for marketing, ≤20% for UX

### 3. Synthetic Data Without Ground Truth
The current dataset has no documented true parameter values. The full dissertation will generate a new synthetic dataset with known parameters to validate estimation accuracy.

### 4. No Quarto Dashboards
The interactive dashboards specified in the expected outcomes (executive summary, marketing analyst, technical documentation) are not yet implemented. These will be developed in Phase 2.

### 5. Meridian Full Model Fitting
The Meridian notebook demonstrates framework integration and UX analysis but does not complete full model fitting due to JAX memory requirements in the current environment. This will be resolved with dedicated compute in Phase 2.

---

## What Comes Next — Full Dissertation

### New Dataset
A new synthetic dataset will be generated with:
- Documented true parameter values for each media channel
- Documented true UX effect sizes
- Known adstock decay rates and saturation parameters
- Seasonal and trend components with known magnitudes

### Dual Configuration Implementation
Each notebook will be restructured to run both configurations sequentially:
```python
# Configuration 1: Standard MMM
mmm_standard = MMM(channel_columns=media_cols)
mmm_standard.fit(X_train_media, y_train)

# Configuration 2: Enhanced MMM
mmm_enhanced = MMM(channel_columns=media_cols, control_columns=ux_cols)
mmm_enhanced.fit(X_train_full, y_train)

# Comparison
compare_models(mmm_standard, mmm_enhanced, X_test, y_test)
```

### Cross-Framework Comparison Notebook
A new Notebook 05 will synthesise results across all three frameworks:
- R² improvement table (Standard vs Enhanced, per framework)
- UX effect size estimates with credible intervals
- CV of UX effects across frameworks
- ROAS estimates with and without UX adjustment
- Recommendations for framework selection

### Quarto Dashboards
Three interactive dashboards:
1. **Executive Dashboard** — KPIs, budget scenarios, UX ROI
2. **Marketing Analyst Dashboard** — attribution, response curves, channel comparison
3. **Technical Dashboard** — model diagnostics, convergence, parameter estimates

---

## How to Interpret the Current Notebooks

| Notebook | What It Shows | What It Does NOT Show Yet |
|---|---|---|
| 01_pymc | UX metrics integrated as Bayesian priors; posterior estimation of UX effects | Comparison against media-only baseline |
| 02_meridian | UX correlation analysis; saturation curves; framework validation | Full model fitting; statistical significance testing |
| 03_robyn | UX as organic variables in ridge regression MMM | Pareto-optimal model selection with UX vs without |
| 04_pipeline | Production data pipeline from raw data to model-ready tables | Automated model retraining |

---

## Summary

This proof of concept successfully demonstrates that:

1. **Technical integration is feasible** — UX metrics can be incorporated into all three leading Bayesian MMM frameworks using existing framework capabilities
2. **Data engineering is production-ready** — a full dbt + SQLMesh + PostgreSQL pipeline supports operationalisation
3. **The research gap is real** — none of the three frameworks provides UX integration out of the box; this research fills an identified gap in the MMM literature
4. **The dissertation is viable** — the infrastructure, tooling, and methodology are in place to conduct the full comparative study

The full dissertation will determine whether UX integration statistically improves model performance, the central research question this POC was designed to validate as technically feasible.

MSc Dissertation POC | March 2026*
---