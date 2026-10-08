-- =====================================================================
-- A2: Salary Review (using GOTO inside a loop)
-- For each doctor:
--   * skip doctors with no salary (GOTO next_doctor)
--   * choose a raise band with GOTO:
--        salary < 1,000,000        -> 10%
--        salary < 2,000,000        ->  5%
--        otherwise                 ->  2%
--   * add 2% extra if years of service >= 10
-- Requires: table DOCTORS and function fn_years_of_service (B2).
-- =====================================================================
SET SERVEROUTPUT ON;

DECLARE
  v_years   NUMBER;
  v_pct     NUMBER;
  v_new_sal NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== DOCTOR SALARY REVIEW ===');

  FOR r IN (SELECT doctor_id,
                   first_name || ' ' || last_name AS doc_name,
                   monthly_salary,
                   hire_date
            FROM   doctors
            ORDER BY doctor_id)
  LOOP
    -- skip doctors without a valid salary
    IF r.monthly_salary IS NULL OR r.monthly_salary = 0 THEN
      DBMS_OUTPUT.PUT_LINE(r.doc_name || ': skipped (no salary)');
      GOTO next_doctor;
    END IF;

    -- choose band
    IF r.monthly_salary < 1000000 THEN
      GOTO low_band;
    ELSIF r.monthly_salary < 2000000 THEN
      GOTO mid_band;
    ELSE
      GOTO high_band;
    END IF;

    <<low_band>>
    v_pct := 10;
    GOTO apply_review;

    <<mid_band>>
    v_pct := 5;
    GOTO apply_review;

    <<high_band>>
    v_pct := 2;

    <<apply_review>>
    v_years := fn_years_of_service(r.hire_date);
    IF v_years >= 10 THEN
      v_pct := v_pct + 2;     -- loyalty bonus
    END IF;

    v_new_sal := ROUND(r.monthly_salary * (1 + v_pct / 100));

    DBMS_OUTPUT.PUT_LINE(r.doc_name
      || ' | years: ' || v_years
      || ' | old: '   || r.monthly_salary
      || ' | raise: ' || v_pct || '%'
      || ' | new: '   || v_new_sal);

    <<next_doctor>>
    NULL;   -- a label must be followed by a statement
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=== REVIEW COMPLETE ===');
END;
/
