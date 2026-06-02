-- ============================================================
-- Student Performance Analysis
-- SQL Analysis: Pass Rates, Subject Averages, Score Distributions
-- ============================================================


-- ============================================================
-- SECTION 1: TABLE SCHEMA
-- ============================================================

CREATE TABLE student_grades (
    student_id      INTEGER,
    gender          TEXT,          -- 'Male' | 'Female'
    grade_level     INTEGER,       -- 9 to 12
    student_category TEXT,         -- 'Advanced' | 'Intermediate' | 'Beginner'
    subject         TEXT,
    score           INTEGER,       -- 0–100
    pass_fail       TEXT           -- 'Pass' if score >= 50, else 'Fail'
);


-- ============================================================
-- SECTION 2: DATA LOADING  (SQLite example)
-- ============================================================
-- If using SQLite CLI:
--   .mode csv
--   .import data/students.csv student_grades


-- ============================================================
-- SECTION 3: OVERVIEW
-- ============================================================

-- Total records and unique students
SELECT
    COUNT(*)                    AS total_records,
    COUNT(DISTINCT student_id)  AS total_students,
    COUNT(DISTINCT subject)     AS total_subjects
FROM student_grades;


-- ============================================================
-- SECTION 4: PASS RATES BY SUBJECT
-- ============================================================

SELECT
    subject,
    COUNT(*)                                        AS total_entries,
    SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN pass_fail = 'Fail' THEN 1 ELSE 0 END) AS failed,
    ROUND(
        100.0 * SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    )                                               AS pass_rate_pct
FROM student_grades
GROUP BY subject
ORDER BY pass_rate_pct DESC;


-- ============================================================
-- SECTION 5: SUBJECT AVERAGES BY STUDENT CATEGORY
-- ============================================================

SELECT
    subject,
    student_category,
    COUNT(*)            AS students,
    ROUND(AVG(score), 2) AS avg_score,
    MIN(score)          AS min_score,
    MAX(score)          AS max_score
FROM student_grades
GROUP BY subject, student_category
ORDER BY subject, 
    CASE student_category
        WHEN 'Advanced'     THEN 1
        WHEN 'Intermediate' THEN 2
        WHEN 'Beginner'     THEN 3
    END;


-- ============================================================
-- SECTION 6: PASS RATE BY STUDENT CATEGORY
-- ============================================================

SELECT
    student_category,
    COUNT(*)                                                    AS total_records,
    SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END)         AS passed,
    ROUND(
        100.0 * SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    )                                                           AS pass_rate_pct
FROM student_grades
GROUP BY student_category
ORDER BY pass_rate_pct DESC;


-- ============================================================
-- SECTION 7: SCORE DISTRIBUTION (GRADE BANDS)
-- ============================================================

SELECT
    subject,
    SUM(CASE WHEN score >= 90 THEN 1 ELSE 0 END) AS A_90_100,
    SUM(CASE WHEN score >= 75 AND score < 90 THEN 1 ELSE 0 END) AS B_75_89,
    SUM(CASE WHEN score >= 60 AND score < 75 THEN 1 ELSE 0 END) AS C_60_74,
    SUM(CASE WHEN score >= 50 AND score < 60 THEN 1 ELSE 0 END) AS D_50_59,
    SUM(CASE WHEN score < 50 THEN 1 ELSE 0 END) AS F_below_50
FROM student_grades
GROUP BY subject
ORDER BY subject;


-- ============================================================
-- SECTION 8: GENDER-WISE AVERAGE SCORE PER SUBJECT
-- ============================================================

SELECT
    subject,
    gender,
    COUNT(*)             AS students,
    ROUND(AVG(score), 2) AS avg_score,
    ROUND(
        100.0 * SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    )                    AS pass_rate_pct
FROM student_grades
GROUP BY subject, gender
ORDER BY subject, gender;


-- ============================================================
-- SECTION 9: GRADE LEVEL PERFORMANCE
-- ============================================================

SELECT
    grade_level,
    ROUND(AVG(score), 2)                                         AS overall_avg,
    ROUND(
        100.0 * SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    )                                                            AS pass_rate_pct
FROM student_grades
GROUP BY grade_level
ORDER BY grade_level;


-- ============================================================
-- SECTION 10: TOP 10 STUDENTS BY AVERAGE SCORE
-- ============================================================

SELECT
    student_id,
    gender,
    grade_level,
    student_category,
    ROUND(AVG(score), 2)  AS avg_score,
    SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) AS subjects_passed
FROM student_grades
GROUP BY student_id, gender, grade_level, student_category
ORDER BY avg_score DESC
LIMIT 10;


-- ============================================================
-- SECTION 11: AT-RISK STUDENTS (Average score < 50)
-- ============================================================

SELECT
    student_id,
    gender,
    grade_level,
    student_category,
    ROUND(AVG(score), 2)   AS avg_score,
    COUNT(*)               AS total_subjects,
    SUM(CASE WHEN pass_fail = 'Fail' THEN 1 ELSE 0 END) AS subjects_failed
FROM student_grades
GROUP BY student_id, gender, grade_level, student_category
HAVING avg_score < 50
ORDER BY avg_score ASC;


-- ============================================================
-- SECTION 12: SUBJECT × CATEGORY SUMMARY (Final Summary Table)
-- ============================================================

SELECT
    subject,
    student_category,
    COUNT(DISTINCT student_id)                                    AS student_count,
    ROUND(AVG(score), 2)                                          AS avg_score,
    ROUND(
        100.0 * SUM(CASE WHEN pass_fail = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    )                                                             AS pass_rate_pct,
    SUM(CASE WHEN score >= 90 THEN 1 ELSE 0 END)                  AS grade_A,
    SUM(CASE WHEN score >= 75 AND score < 90 THEN 1 ELSE 0 END)   AS grade_B,
    SUM(CASE WHEN score >= 60 AND score < 75 THEN 1 ELSE 0 END)   AS grade_C,
    SUM(CASE WHEN score >= 50 AND score < 60 THEN 1 ELSE 0 END)   AS grade_D,
    SUM(CASE WHEN score < 50 THEN 1 ELSE 0 END)                   AS grade_F
FROM student_grades
GROUP BY subject, student_category
ORDER BY subject,
    CASE student_category
        WHEN 'Advanced'     THEN 1
        WHEN 'Intermediate' THEN 2
        WHEN 'Beginner'     THEN 3
    END;
