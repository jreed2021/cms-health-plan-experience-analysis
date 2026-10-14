# MySQL Import Schema Notes

The analysis-ready CSV was imported with MySQL Workbench's **Table Data Import Wizard**.

The first import loaded only **298 of 308 rows** because some CMS reporting codes were being forced into numeric fields. The schema was corrected and the file was re-imported. Both the total-row count and distinct reporting-unit count then returned **308**.

Use these field types when importing:

| Column | MySQL type |
|---|---|
| REPORTING_UNIT_ID | TEXT |
| Issuer_Id | INT |
| State | TEXT |
| Plan_Type | TEXT |
| Global_rate | TEXT |
| Global_score | TEXT |
| S1_rate | INT / BIGINT |
| S1_score | DOUBLE |
| S2_rate | TEXT |
| S2_score | TEXT |
| S3_rate | TEXT |
| S3_score | TEXT |
| N_COMPLETED_SURVEYS | BIGINT |
| RESPONSE_RATE | TEXT |
| RATE_HP_SCORE_ADJ | DOUBLE |
| RATE_HEALTH_CARE_SCORE_ADJ | DOUBLE |
| GETCAREQUICK_SCORE_ADJ | DOUBLE |
| GETNEEDEDCARE_SCORE_ADJ | DOUBLE |
| CUSTOMERSERVICE_SCORE_ADJ | DOUBLE |
| EXPERIENCEWITHCOST_SCORE_ADJ | DOUBLE |
| CARECOORD_SCORE_ADJ | DOUBLE |
| ACCESSINFO_SCORE_ADJ | DOUBLE |

CMS-coded fields such as `NG` and `CSR-I` must remain text where they can occur.
