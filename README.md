# MMM-UX Integration
## Integrating User Experience Metrics into Marketing Mix Modelling
### A Comparative Analysis of Bayesian Frameworks for Holistic Marketing Attribution

> **Status: Proof of Concept** — This repository demonstrates the technical feasibility of integrating UX metrics into three leading open-source Bayesian MMM frameworks. The full dissertation implementation with controlled statistical comparison is in development.

---

## Research Overview

### The Problem

Traditional Marketing Mix Modelling (MMM) frameworks focus on media channel attribution (TV, digital, social, search, radio) alongside macroeconomic indicators and seasonality. Despite substantial evidence that User Experience (UX) metrics — such as NPS score, bounce rate, session duration, and conversion rate — significantly influence digital conversion outcomes, **none of the leading open-source Bayesian MMM frameworks incorporate UX metrics as model parameters**.

This creates a critical measurement gap: marketing practitioners cannot quantify the ROI of UX improvements using the same attribution methodology applied to media spend, potentially leading to:
- Misattribution of marketing effectiveness
- Suboptimal budget allocation across media and experience investments
- Inability to compare returns on media spend vs. UX investment

### The Research Question

> *Does integrating User Experience metrics into Bayesian Marketing Mix Models improve predictive accuracy and provide more holistic marketing attribution compared to traditional media-only configurations?*

### The Approach

This research implements an **extended MMM methodology** that incorporates UX metrics alongside traditional marketing variables across three leading open-source Bayesian frameworks:

| Framework | Developer | Language | Inference Method |
|---|---|---|---|
| **PyMC-Marketing** | PyMC Labs | Python | Full Bayesian MCMC (NUTS) |
| **Meridian** | Google | Python/JAX | Bayesian (JAX-accelerated) |
| **Robyn** | Meta | R | Ridge regression + Nevergrad |

---

## Repository Structure

```
mmm-ux-integration/
├── README.md                          # This file
├── PROOF_OF_CONCEPT.md                # POC scope, findings & next steps
├── requirements.txt                   # Python dependencies
├── data/
│   ├── mmm_dissertation_data.csv      # Synthetic dataset (104 weeks)
│   └── data_generation.py             # Reproducible data generation script
├── notebooks/
│   ├── 01_pymc_marketing_mmm.ipynb    # PyMC-Marketing: UX-enhanced MMM
│   ├── 02_meridian_mmm.ipynb          # Meridian: UX-enhanced MMM
│   ├── 03_robyn_mmm.ipynb             # Robyn: UX-enhanced MMM (R kernel)
│   ├── 04_data_pipeline_duckdb_dbt.ipynb  # Data engineering pipeline
│   └── 05_cross_framework_comparison.ipynb  # Coming in full dissertation
├── outputs/
│   ├── figures/                       # Generated visualisations
│   └── results/                       # Model outputs and CSV exports
├── dbt/
│   └── dissertation_dbt/              # dbt transformation project
└── sqlmesh/
    └── dissertation_sqlmesh/          # SQLMesh pipeline project
```

---

## Dataset

The synthetic dataset simulates **104 weeks (2 years)** of marketing activity with documented data generation for reproducibility and parameter recovery validation.

### Media Channels (5)
| Variable | Description |
|---|---|
| `tv_spend` | Weekly TV advertising spend (£) |
| `digital_spend` | Weekly digital/display advertising spend (£) |
| `social_spend` | Weekly social media advertising spend (£) |
| `search_spend` | Weekly paid search advertising spend (£) |
| `radio_spend` | Weekly radio advertising spend (£) |

### UX Metrics (5) — The Novel Contribution
| Variable | Description | UX Construct |
|---|---|---|
| `nps_score` | Net Promoter Score (0–10) | Customer satisfaction |
| `bounce_rate` | Website bounce rate (%) | Engagement quality |
| `session_duration` | Average session duration (seconds) | Engagement depth |
| `pages_per_session` | Average pages viewed per session | Content engagement |
| `conversion_rate` | Website conversion rate (%) | UX effectiveness |

### Target Variable
| Variable | Description |
|---|---|
| `sales` | Weekly revenue (£) |

---

## Technical Stack

### Data Engineering Pipeline
```
Raw CSV → PostgreSQL (storage) → dbt (transformation) → SQLMesh (scheduling)
                                        ↓
                              stg_mmm_weekly_data (staging)
                                        ↓
                         mart_mmm_channel_performance (mart)
```

### Infrastructure
| Component | Tool | Purpose |
|---|---|---|
| Virtual Machine | OrbStack (Ubuntu 25.10) | Isolated compute environment |
| Database | PostgreSQL 17 | Raw and transformed data storage |
| Analytical DB | DuckDB | In-notebook analytics |
| Transformation | dbt-core 1.11 | Data modelling and testing |
| Orchestration | SQLMesh | Pipeline scheduling and state management |
| Notebooks | Jupyter Lab | Interactive development environment |
| LLM (local) | Ollama + DeepSeek-R1 | Research assistance (offline) |

---

## Notebooks

### Notebook 01 — PyMC-Marketing (Bayesian MMM)
**Framework:** PyMC-Marketing v0.18.2 | PyMC v5.28.1
**Approach:** Full Bayesian inference via MCMC sampling (NUTS)
**Key Features Demonstrated:**
- Geometric adstock transformation for media carryover effects
- Logistic saturation curves for diminishing returns
- UX metrics as control variables in Bayesian model
- Posterior distribution analysis and credible intervals
- Media contribution decomposition
- Budget optimisation under uncertainty

### Notebook 02 — Meridian (Google Bayesian MMM)
**Framework:** Meridian v1.5.3
**Approach:** Bayesian hierarchical modelling with JAX backend
**Key Features Demonstrated:**
- JAX-accelerated MCMC sampling
- Hill saturation response curves per channel
- UX metric correlation analysis with sales
- Counterfactual scenario analysis
- mROAS (marginal Return on Ad Spend) estimation

### Notebook 03 — Robyn (Meta MMM)
**Framework:** Robyn v3.12.1
**Language:** R (IRkernel)
**Approach:** Ridge regression + Nevergrad multi-objective optimisation
**Key Features Demonstrated:**
- Adstock transformation with decay parameters
- Saturation modelling with Hill function
- UX metrics as organic variables
- Multi-trial Pareto-optimal model selection
- Budget allocation optimisation

### Notebook 04 — Data Engineering Pipeline
**Tools:** DuckDB, dbt, SQLMesh, PostgreSQL
**Purpose:** Demonstrates production-ready data engineering foundation for MMM
**Key Features Demonstrated:**
- dbt staging and mart models for MMM data
- SQLMesh incremental pipeline with weekly scheduling
- DuckDB in-notebook analytics
- Data quality and lineage documentation

---

## How to Run

### Prerequisites
- OrbStack (macOS) or Docker with Ubuntu 22.04+
- Miniconda / Anaconda
- PostgreSQL 15+
- R 4.x with IRkernel

### Python Setup
```bash
git clone https://github.com/terrymhennah/mmm-ux-integration.git
cd mmm-ux-integration
pip install -r requirements.txt
```

### Database Setup
```bash
# Load data into PostgreSQL
psql -U admin -h localhost -d dissertation -c "\COPY mmm_weekly_data FROM 'data/mmm_dissertation_data.csv' CSV HEADER;"

# Run dbt transformations
cd dbt/dissertation_dbt
dbt run
```

### Launch Jupyter
```bash
jupyter lab
```
Navigate to `notebooks/` and run cells sequentially.

> **Note:** MCMC sampling cells (PyMC and Meridian model fitting) require 20–40 minutes each. All other cells run in under 1 minute.

---

## Roadmap

### Phase 1 — Proof of Concept ✅ (Current)
- [x] UX-enhanced MMM implemented across all 3 frameworks
- [x] Data engineering pipeline (dbt + SQLMesh + PostgreSQL)
- [x] Synthetic dataset with 5 media channels + 5 UX metrics
- [x] Jupyter notebooks with full documentation

### Phase 2 — Full Dissertation (In Development)
- [ ] Standard MMM baseline (media only) for each framework
- [ ] Controlled comparison: Standard vs Enhanced (R², MAPE, RMSE)
- [ ] 80/20 train/test split with out-of-sample evaluation
- [ ] Cross-framework consistency analysis (CV of UX effect estimates)
- [ ] Parameter recovery validation against known ground truth
- [ ] Quarto interactive dashboards (executive + analyst + technical)
- [ ] New synthetic dataset with documented true parameters

---

## Research Context

This work addresses an identified gap in the MMM literature: whilst Unified Marketing Measurement (UMM) frameworks integrate MMM with multi-touch attribution, none of the leading open-source implementations incorporate UX quality metrics as model parameters. This research bridges econometric marketing measurement and conversion rate optimisation (CRO).

**Key References:**
- Jin et al. (2017) — Bayesian methods for media mix modelling with carryover and shape effects. Google Inc.
- PyMC Labs (2025) — PyMC-Marketing: Bayesian marketing toolbox
- Google Developers (2025) — Meridian: Bayesian inference
- Facebook Experimental (2024) — Robyn: Open-source marketing mix modeling

---

## Author

**Terry M. Hennah**
MSc Data Science Dissertation
GitHub: [@terrymhennah](https://github.com/terrymhennah)

---

*This repository is part of an MSc dissertation project. The proof of concept implementation demonstrates technical feasibility. Statistical conclusions should not be drawn from this POC phase — full comparative analysis is forthcoming in the dissertation.*
