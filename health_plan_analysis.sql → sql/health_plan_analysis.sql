-- CMS Medical Care Ratings vs Enrollee Experience
-- MySQL reporting and validation queries used in the project

-- 1. Create and select the project database
CREATE DATABASE IF NOT EXISTS cms_health_plan_analysis;
USE cms_health_plan_analysis;

-- The analysis-ready CSV was imported with MySQL Workbench's
-- Table Data Import Wizard as qrs_enrollee_experience.

-- 2. Validate the imported table
SELECT COUNT(*)
FROM qrs_enrollee_experience;

SELECT COUNT(DISTINCT REPORTING_UNIT_ID) AS unique_reporting_units
FROM qrs_enrollee_experience;

DESCRIBE qrs_enrollee_experience;

SELECT *
FROM qrs_enrollee_experience
LIMIT 5;

-- 3. Average enrollee experience by Medical Care star rating
SELECT
    S1_rate AS medical_care_rating,
    COUNT(*) AS reporting_units,
    ROUND(AVG(RATE_HP_SCORE_ADJ), 2) AS avg_experience_score,
    ROUND(MIN(RATE_HP_SCORE_ADJ), 2) AS min_experience_score,
    ROUND(MAX(RATE_HP_SCORE_ADJ), 2) AS max_experience_score
FROM qrs_enrollee_experience
GROUP BY S1_rate
ORDER BY S1_rate;

-- 4. Average experience by plan type
SELECT
    Plan_Type,
    COUNT(*) AS reporting_units,
    ROUND(AVG(RATE_HP_SCORE_ADJ), 2) AS avg_experience_score
FROM qrs_enrollee_experience
GROUP BY Plan_Type
ORDER BY avg_experience_score DESC;

-- 5. Average experience by state
-- Require at least 3 reporting units to reduce very small-group comparisons.
SELECT
    State,
    COUNT(*) AS reporting_units,
    ROUND(AVG(RATE_HP_SCORE_ADJ), 2) AS avg_experience_score
FROM qrs_enrollee_experience
GROUP BY State
HAVING COUNT(*) >= 3
ORDER BY avg_experience_score DESC;

-- 6. High Medical Care performers with comparatively lower enrollee experience
SELECT
    REPORTING_UNIT_ID,
    State,
    Plan_Type,
    S1_rate AS medical_care_rating,
    ROUND(S1_score, 2) AS medical_care_score,
    ROUND(RATE_HP_SCORE_ADJ, 2) AS experience_score
FROM qrs_enrollee_experience
WHERE S1_rate >= 4
ORDER BY RATE_HP_SCORE_ADJ ASC
LIMIT 15;

-- 7. Largest Medical Care / enrollee experience gaps
SELECT
    REPORTING_UNIT_ID,
    State,
    Plan_Type,
    S1_rate AS medical_care_rating,
    ROUND(S1_score, 2) AS medical_care_score,
    ROUND(RATE_HP_SCORE_ADJ, 2) AS experience_score,
    ROUND(S1_score - RATE_HP_SCORE_ADJ, 2) AS score_gap
FROM qrs_enrollee_experience
WHERE S1_rate >= 4
ORDER BY score_gap DESC
LIMIT 15;
