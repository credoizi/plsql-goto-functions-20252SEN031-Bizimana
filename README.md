# PL/SQL GOTO Statements and Functions - Hospital Billing System

**Course:** Database Development with PL/SQL (INSY 8311)
**Instructor:** Eric Maniraguha
**Student:** Bizimana Credo | **Student ID:** 20252SEN031
**Assignment:** Individual Assignment III - PL/SQL GOTO Statements and Functions
**Database:** Oracle Database 21c, pluggable database `HOSPITALDB`, schema `MYADMIN`, tool: Oracle SQL Developer

---

## 1. Project description

For this assignment I chose a **Hospital Billing System**. The database stores the hospital wards, the doctors who work in them, the patients who are admitted, and the invoices issued to patients. Each invoice records the consultation fee, medication cost, room cost, total, tax, the amount covered by insurance, and the amount the patient still owes.

I used this scenario to practise PL/SQL **GOTO statements** (Part A), **stored functions** (Part B), and a **combined task** (Part C) where a function uses GOTO to validate invoices.

## 2. Database structure

| Table | Purpose | Main columns |
|---|---|---|
| `wards` | Hospital wards (lookup table) | `ward_id`, `ward_name`, `floor_no`, `daily_rate` |
| `doctors` | Doctors and their salaries | `doctor_id`, `first_name`, `last_name`, `specialty`, `hire_date`, `monthly_salary`, `ward_id` |
| `patients` | Patients and their insurance | `patient_id`, `first_name`, `last_name`, `gender`, `birth_date`, `insurance_type`, `ward_id`, `admission_date` |
| `invoices` | Billing records | `invoice_id`, `patient_id`, `doctor_id`, `invoice_date`, `consultation_fee`, `medication_cost`, `room_cost`, `total_amount`, `tax_amount`, `insurance_covered`, `amount_due`, `status` |

**Relationships:** `doctors.ward_id` and `patients.ward_id` reference `wards`; `invoices.patient_id` references `patients`; `invoices.doctor_id` references `doctors`.

**Sample data:** 5 wards, 6 doctors, 8 patients, 8 invoices. The data includes edge cases on purpose: a doctor and a patient without a ward, and invoices 5 to 8 contain errors (wrong total, NULL insurance, negative amount due, zero amounts) so the validator in C1 has something to detect.

## 3. Tasks completed

### Part A - GOTO

| Task | File | What it does |
|---|---|---|
| A1 | `A1_number_classifier.sql` | Classifies a number as positive, negative or zero, and as even or odd, using GOTO labels. |
| A2 | `A2_salary_review.sql` | Loops through all doctors and uses GOTO to skip doctors with no salary and to choose a raise band (10%, 5% or 2%). Doctors with 10 or more years of service get 2% extra. |
| A3 | `A3_illegal_goto.sql` | Shows an illegal GOTO that jumps into an IF block (compile error), followed by the corrected version with the label moved outside the IF. |
| A4 | `A4_rewrite_no_goto.sql` | Rewrites A1 and A2 without GOTO, using IF / ELSIF and CASE. |

### Part B - Functions

| Task | Function | What it does |
|---|---|---|
| B1 | `fn_annual_salary(p_monthly_salary)` | Returns monthly salary x 12. Returns NULL for NULL input and raises error -20001 for a negative salary. |
| B2 | `fn_years_of_service(p_hire_date)` | Returns the number of complete years since the hire date. Returns NULL for NULL input and raises error -20002 for a future date. |
| B3 | `fn_calculate_tax(p_monthly_salary)` | Progressive tax: 0% up to 60,000; 20% of the part between 60,000 and 100,000; above 100,000 it is 8,000 plus 30% of the excess. Raises error -20003 for a negative salary. |
| B4 | `fn_dept_name(p_ward_id)` | Returns the ward name for a ward id (the hospital version of "department name"). Returns `No ward assigned` for NULL and `Unknown ward` when the id does not exist (handles `NO_DATA_FOUND`). |
| B5 | `B5_functions_in_select.sql` | Uses B1 to B4 inside `SELECT`, `WHERE`, `ORDER BY` and `GROUP BY` queries. |

### Part C - Combined task

| Task | File | What it does |
|---|---|---|
| C1 | `fn_validate_payroll(p_invoice_id)` | Validates an invoice and returns `VALID` or `INVALID: <reason>`. It checks that the invoice exists, no required amount is NULL, insurance is not NULL, the total is not zero, the total equals fee + medication + room, the amount due is not negative, and amount due = total + tax - insurance. GOTO jumps to a labelled error message for each failed check. |
| C2 | `docs/REFLECTION.md` | My written reflection. |

## 4. Test results

- `test_functions.sql` tests B1 to B4 with normal values, NULL values and invalid values. For example, `fn_calculate_tax(150000)` returns 23,000 and `fn_dept_name(3)` returns `Maternity`.
- `test_validate_payroll.sql` runs C1 on every invoice. Invoices 1 to 4 are `VALID`; invoices 5 to 8 are `INVALID` with the reason shown; invoice 999 returns `INVALID: invoice not found`.
- Screenshots of the outputs are in the `screenshots/` folder.

## 5. Notes

- The tax bands in B3 are simplified for learning purposes and do not include social security contributions.
- Because A3 contains a deliberate error, the first block of that file is expected to fail with a compile error. The second block is the fix.
