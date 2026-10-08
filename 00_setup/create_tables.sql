-- =====================================================================
-- 00_setup/create_tables.sql
-- =====================================================================

SET SERVEROUTPUT ON;

-- ---------------------------------------------------------------------
-- 2. WARDS  (lookup table, used by the ward-name function in B4)
-- ---------------------------------------------------------------------
CREATE TABLE wards (
  ward_id     NUMBER(4)     CONSTRAINT pk_wards PRIMARY KEY,
  ward_name   VARCHAR2(50)  NOT NULL,
  floor_no    NUMBER(2),
  daily_rate  NUMBER(10,2)  CONSTRAINT ck_ward_rate CHECK (daily_rate >= 0)
);

-- ---------------------------------------------------------------------
-- 3. DOCTORS  (monthly_salary in RWF; used for A2, B1, B2, B3)
-- ---------------------------------------------------------------------
CREATE TABLE doctors (
  doctor_id       NUMBER(6)     CONSTRAINT pk_doctors PRIMARY KEY,
  first_name      VARCHAR2(30)  NOT NULL,
  last_name       VARCHAR2(30)  NOT NULL,
  specialty       VARCHAR2(40),
  hire_date       DATE          NOT NULL,
  monthly_salary  NUMBER(10,2)  CONSTRAINT ck_doc_salary CHECK (monthly_salary >= 0),
  ward_id         NUMBER(4)     CONSTRAINT fk_doc_ward REFERENCES wards(ward_id)
);

-- ---------------------------------------------------------------------
-- 4. PATIENTS
-- ---------------------------------------------------------------------
CREATE TABLE patients (
  patient_id      NUMBER(6)     CONSTRAINT pk_patients PRIMARY KEY,
  first_name      VARCHAR2(30)  NOT NULL,
  last_name       VARCHAR2(30)  NOT NULL,
  gender          CHAR(1)       CONSTRAINT ck_pat_gender CHECK (gender IN ('M','F')),
  birth_date      DATE,
  phone           VARCHAR2(15),
  insurance_type  VARCHAR2(10)  DEFAULT 'NONE'
                                CONSTRAINT ck_pat_ins CHECK (insurance_type IN ('RSSB','MMI','PRIVATE','NONE')),
  ward_id         NUMBER(4)     CONSTRAINT fk_pat_ward REFERENCES wards(ward_id),
  admission_date  DATE
);

-- ---------------------------------------------------------------------
-- 5. INVOICES  (billing records; validated in Task C1)
--    total_amount   = consultation_fee + medication_cost + room_cost
--    tax_amount     = tax applied on total_amount
--    amount_due     = total_amount + tax_amount - insurance_covered
--    (No CHECKs on the totals, so invalid rows can be inserted to test C1)
-- ---------------------------------------------------------------------
CREATE TABLE invoices (
  invoice_id        NUMBER(8)     CONSTRAINT pk_invoices PRIMARY KEY,
  patient_id        NUMBER(6)     NOT NULL
                                  CONSTRAINT fk_inv_patient REFERENCES patients(patient_id),
  doctor_id         NUMBER(6)     CONSTRAINT fk_inv_doctor REFERENCES doctors(doctor_id),
  invoice_date      DATE          NOT NULL,
  consultation_fee  NUMBER(10,2),
  medication_cost   NUMBER(10,2),
  room_cost         NUMBER(10,2),
  total_amount      NUMBER(10,2),
  tax_amount        NUMBER(10,2),
  insurance_covered NUMBER(10,2),
  amount_due        NUMBER(10,2),
  status            VARCHAR2(10)  DEFAULT 'PENDING'
                                  CONSTRAINT ck_inv_status CHECK (status IN ('PENDING','PAID','CANCELLED'))
);

-- ---------------------------------------------------------------------
-- 6. Sample data: WARDS
-- ---------------------------------------------------------------------
INSERT INTO wards VALUES (1, 'Outpatient',  0,      0);
INSERT INTO wards VALUES (2, 'General',     1,  40000);
INSERT INTO wards VALUES (3, 'Maternity',   2,  60000);
INSERT INTO wards VALUES (4, 'Pediatrics',  2,  50000);
INSERT INTO wards VALUES (5, 'ICU',         3, 150000);

-- ---------------------------------------------------------------------
-- 7. Sample data: DOCTORS (varied salaries and hire dates)
-- ---------------------------------------------------------------------
INSERT INTO doctors VALUES (201, 'Aline',    'Uwera',      'General Medicine', DATE '2012-03-01', 1800000, 2);
INSERT INTO doctors VALUES (202, 'Eric',     'Ndayisaba',  'Surgery',          DATE '2016-07-15', 2500000, 5);
INSERT INTO doctors VALUES (203, 'Josiane',  'Mukeshimana','Pediatrics',       DATE '2019-01-20', 1400000, 4);
INSERT INTO doctors VALUES (204, 'Patrick',  'Habimana',   'Obstetrics',       DATE '2021-09-10', 1200000, 3);
INSERT INTO doctors VALUES (205, 'Claire',   'Ingabire',   'General Medicine', DATE '2024-02-05',  700000, 1);
-- Doctor with NO ward (tests the "not found / NULL" case in B4)
INSERT INTO doctors VALUES (206, 'Samuel',   'Nkurunziza', 'Radiology',        DATE '2023-05-18',  900000, NULL);

-- ---------------------------------------------------------------------
-- 8. Sample data: PATIENTS
-- ---------------------------------------------------------------------
INSERT INTO patients VALUES (1001, 'Marie',   'Uwimana',   'F', DATE '1990-04-12', '0788000001', 'RSSB',    1, DATE '2026-09-01');
INSERT INTO patients VALUES (1002, 'Jean',    'Bizimana',  'M', DATE '1975-11-30', '0788000002', 'MMI',     5, DATE '2026-09-03');
INSERT INTO patients VALUES (1003, 'Diane',   'Mukamana',  'F', DATE '2001-02-25', '0788000003', 'NONE',    1, DATE '2026-09-05');
INSERT INTO patients VALUES (1004, 'Emmanuel','Niyonzima', 'M', DATE '1968-08-08', '0788000004', 'PRIVATE', 2, DATE '2026-09-07');
INSERT INTO patients VALUES (1005, 'Aimee',   'Kayitesi',  'F', DATE '2015-06-19', '0788000005', 'RSSB',    4, DATE '2026-09-10');
INSERT INTO patients VALUES (1006, 'Olivier', 'Nshuti',    'M', DATE '1983-12-02', '0788000006', 'NONE',    NULL, DATE '2026-09-12');
INSERT INTO patients VALUES (1007, 'Sandrine','Umutoni',   'F', DATE '1995-09-14', '0788000007', 'MMI',     3, DATE '2026-09-15');
INSERT INTO patients VALUES (1008, 'Felix',   'Habiyaremye','M',DATE '1950-01-05', '0788000008', 'RSSB',    2, DATE '2026-09-18');

-- ---------------------------------------------------------------------
-- 9. Sample data: INVOICES (rows 1-4 valid, rows 5-8 deliberately BAD for C1)
-- ---------------------------------------------------------------------
-- valid rows
INSERT INTO invoices VALUES (1, 1001, 205, DATE '2026-09-01',  20000,  15000,      0,  35000,   6300,  21000,  20300, 'PAID');
INSERT INTO invoices VALUES (2, 1004, 201, DATE '2026-09-10',  30000,  45000, 120000, 195000,  35100, 117000, 113100, 'PENDING');
INSERT INTO invoices VALUES (3, 1003, 205, DATE '2026-09-05',  15000,   8000,      0,  23000,   4140,      0,  27140, 'PAID');
INSERT INTO invoices VALUES (4, 1002, 202, DATE '2026-09-08',  50000, 120000, 300000, 470000,  84600, 376000, 178600, 'PENDING');
-- bad: total_amount does not equal fee + medication + room (should be 35000)
INSERT INTO invoices VALUES (5, 1005, 203, DATE '2026-09-12',  25000,  10000,      0,  45000,   8100,      0,  53100, 'PENDING');
-- bad: insurance_covered is NULL
INSERT INTO invoices VALUES (6, 1007, 204, DATE '2026-09-16',  20000,   5000,      0,  25000,   4500,   NULL,  29500, 'PENDING');
-- bad: insurance covers more than the bill, so amount_due is negative
INSERT INTO invoices VALUES (7, 1008, 201, DATE '2026-09-19',  10000,   5000,      0,  15000,   2700,  40000, -22300, 'PENDING');
-- bad: all amounts are zero
INSERT INTO invoices VALUES (8, 1006, 206, DATE '2026-09-13',      0,      0,      0,      0,      0,      0,      0, 'PENDING');

COMMIT;

-- ---------------------------------------------------------------------
-- 10. Quick verification
-- ---------------------------------------------------------------------
SELECT 'WARDS'    AS table_name, COUNT(*) AS row_count FROM wards
UNION ALL SELECT 'DOCTORS',  COUNT(*) FROM doctors
UNION ALL SELECT 'PATIENTS', COUNT(*) FROM patients
UNION ALL SELECT 'INVOICES', COUNT(*) FROM invoices;
