# CMS Medical Care Ratings vs Enrollee Experience

## Project Question

**Are stronger CMS Medical Care ratings associated with better enrollee-reported health plan experiences?**

This project compares CMS Marketplace Medical Care performance with member-reported health plan experience using a multi-tool analytics workflow: **Python → MySQL → Tableau**.

## Key Findings

- Final analytical sample: **308 reporting units**.
- Average enrollee experience did **not** increase consistently as Medical Care star ratings increased.
- Mean adjusted experience scores by Medical Care rating were:
  - 1 star: **73.76**
  - 2 stars: **73.43**
  - 3 stars: **71.08**
  - 4 stars: **70.17**
  - 5 stars: **73.45**
- Pearson correlation between Medical Care Score and adjusted Health Plan Rating: **-0.132**.
- Spearman correlation: **-0.159**.
- Target-variable skewness was **-0.151**, indicating a roughly symmetric distribution.
- Several 4- and 5-star Medical Care reporting units had large differences between Medical Care scores and enrollee experience scores.

The results suggest that strong Medical Care performance and strong member experience are related but distinct dimensions of health plan performance.

## Workflow

### Python

Python was used for:

- loading and profiling the CMS public-use files
- checking data types, duplicates, and missingness
- identifying CMS reporting codes such as `CSR-I`
- converting analytical fields to numeric values
- creating the `REPORTING_UNIT_ID` join key
- validating reporting-unit overlap before merging
- performing a one-to-one merge
- creating the 308-row analysis-ready dataset
- descriptive statistics and distribution review
- skewness, Pearson correlation, and Spearman correlation

See:
- [Data Intake & Cleaning Notebook](notebooks/01_data_intake_cleaning.ipynb)
- [Exploratory Analysis Notebook](notebooks/02_exploratory_analysis.ipynb)

### MySQL

The analysis-ready CSV was imported into `cms_health_plan_analysis.qrs_enrollee_experience`. MySQL was used to:

- reconcile row counts between Python and MySQL
- confirm 308 unique reporting units
- summarize experience by Medical Care rating
- compare plan types
- compare state-level averages with a minimum sample-size rule
- identify high Medical Care performers with comparatively low enrollee experience
- calculate the Medical Care / enrollee experience score gap

The first MySQL import loaded only **298 rows** because CMS-coded text values were incorrectly assigned numeric field types. After the import schema was corrected, both `COUNT(*)` and `COUNT(DISTINCT REPORTING_UNIT_ID)` returned **308**.

See:
- [SQL Analysis Script](sql/health_plan_analysis.sql)

### Tableau

Tableau Public was used as the presentation layer. The final dashboard contains:

1. **Average Enrollee Experience by Medical Care Rating**
2. **Medical Care Score vs Enrollee Experience** with a trend line
3. **Largest Medical Care–Experience Gaps** among 4- and 5-star reporting units

Because Tableau Public does not provide the same direct MySQL connectivity as Tableau Desktop, the reconciled 308-row CSV was used as the Tableau data source after the MySQL validation step.

## Repository Structure

```text
cms-health-plan-experience-analysis/
├── data_raw/
│   └── README.md
├── data_clean/
│   └── cms_qrs_enrollee_experience_clean.csv
├── notebooks/
│   ├── 01_data_intake_cleaning.ipynb
│   └── 02_exploratory_analysis.ipynb
├── sql/
│   ├── health_plan_analysis.sql
│   └── import_schema_notes.md
├── visuals/
│   ├── cms_health_plan_dashboard.png
│   └── article_preview.png
├── sources/
│   └── data_sources.md
├── requirements.txt
└── README.md
```

## Data Preparation Notes

The raw QRS dataset included CMS-specific reporting codes. In the primary Medical Care fields, `CSR-I` represented reporting units without a usable numeric Medical Care component score/rating for this analysis. These values were preserved in the raw data and converted to missing values only in analytical copies.

All 331 QRS reporting units matched a record in the Enrollee Survey. Twenty-three QRS reporting units lacked numeric Medical Care values, leaving **308** reporting units in the final analytical sample.

## Interpretation

The analysis does **not** show that stronger Medical Care causes worse member experience. The observed relationships are associations, not causal effects, and the measures capture different constructs. The score-gap calculation was used as a screening tool to identify large divergences, not as a target that plans are expected to reduce to zero.

## Data Sources

Public CMS Marketplace Quality Initiatives data were used throughout the project. See [CMS Marketplace Quality Initiatives Downloads](https://www.cms.gov/marketplace/about/health-insurance-quality-initiatives/downloads)

## Tableau Public

[View the Tableau dashboard](https://public.tableau.com/app/profile/janessa.reed/viz/CMSMedicalCareRatingsandEnrolleeExperience/Dashboard1)

## Medium Article

**Article link:** [Read the Medium article](https://medium.com/@reed.janessa21/does-a-higher-rated-health-plan-actually-mean-a-better-patient-experience-5209d96bfe1c?sharedUserId=reed.janessa21)

## Tools

- Python / pandas
- Jupyter Notebook
- MySQL Workbench
- Tableau Public
