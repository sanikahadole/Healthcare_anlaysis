create database hospital_analysis;
use hospital_analysis;
CREATE TABLE patients (
    patient_id          INT PRIMARY KEY,
    name                VARCHAR(50),
    age                 INT,
    gender              VARCHAR(10),
    blood_type          VARCHAR(5),
    medical_condition   VARCHAR(30),
    date_of_admission   DATE,
    doctor              VARCHAR(50),
    hospital            VARCHAR(80),
    insurance_provider  VARCHAR(30),
    billing_amount      DECIMAL(10,2),
    room_number         INT,
    admission_type      VARCHAR(20),
    discharge_date      DATE,
    medication          VARCHAR(30),
    test_results        VARCHAR(20)
);

-- Records by gender
SELECT Gender, COUNT(*) AS record_count
FROM patients
GROUP BY Gender
ORDER BY record_count DESC;

-- Age group analysis
SELECT
  CASE
    WHEN Age < 18 THEN 'Under 18'
    WHEN Age BETWEEN 18 AND 29 THEN '18-29'
    WHEN Age BETWEEN 30 AND 44 THEN '30-44'
    WHEN Age BETWEEN 45 AND 59 THEN '45-59'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS record_count
FROM patients
WHERE Age IS NOT NULL
GROUP BY age_group
ORDER BY MIN(Age);

-- Most common diseases
SELECT medical_condition, COUNT(*) AS record_count
FROM patients
GROUP BY medical_condition
ORDER BY record_count DESC;

-- Treatment cost summary
SELECT
  COUNT(billing_amount) AS records_with_cost,
  ROUND(AVG(billing_amount), 2) AS average_cost,
  ROUND(MIN(billing_amount), 2) AS minimum_cost,
  ROUND(MAX(billing_amount), 2) AS maximum_cost,
  ROUND(SUM(billing_amount), 2) AS total_recorded_cost
FROM patients;

-- Monthly admissions / records
SELECT
  DATE_FORMAT( date_of_admission, '%Y-%m') AS admission_month,
  COUNT(*) AS admission_records
FROM patients
GROUP BY admission_month
ORDER BY admission_month;

-- Average hospital stay
SELECT 
    AVG(DATEDIFF(Discharge_Date, date_of_admission)) AS Average_Stay_Days
FROM patients;


-- 4.4 Rank diseases with a window function 
SELECT
  medical_condition,
  COUNT(*) AS record_count,
  DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS disease_rank
FROM patients
GROUP BY medical_condition;

