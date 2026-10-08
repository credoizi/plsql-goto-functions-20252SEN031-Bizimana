-- =====================================================================
-- A4: Rewrite WITHOUT GOTO
-- Same logic as A1 (Number Classifier) and A2 (Salary Review),
-- but using only IF / ELSIF / CASE. Structured code is easier to read.
-- =====================================================================
SET SERVEROUTPUT ON;

-- ---------------------------------------------------------------------
-- A1 rewritten: Number Classifier
-- ---------------------------------------------------------------------
DECLARE
  v_num NUMBER := 17;   -- <<< change this value to test
BEGIN
  DBMS_OUTPUT.PUT_LINE('Number tested: ' || v_num);

  IF v_num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Sign   : POSITIVE');
  ELSIF v_num < 0 THEN
    DBMS_OUTPUT.PUT_LINE('Sign   : NEGATIVE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Sign   : ZERO');
  END IF;

  IF MOD(v_num, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Parity : EVEN');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Parity : ODD');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Classification finished.');
END;
/

-- ---------------------------------------------------------------------
-- A2 rewritten: Salary Review
-- ---------------------------------------------------------------------
DECLARE
  v_years   NUMBER;
  v_pct     NUMBER;
  v_new_sal NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== DOCTOR SALARY REVIEW (no GOTO) ===');

  FOR r IN (SELECT doctor_id,
                   first_name || ' ' || last_name AS doc_name,
                   monthly_salary,
                   hire_date
            FROM   doctors
            ORDER BY doctor_id)
  LOOP
    IF r.monthly_salary IS NULL OR r.monthly_salary = 0 THEN
      DBMS_OUTPUT.PUT_LINE(r.doc_name || ': skipped (no salary)');
    ELSE
      v_pct := CASE
                 WHEN r.monthly_salary < 1000000 THEN 10
                 WHEN r.monthly_salary < 2000000 THEN 5
                 ELSE 2
               END;

      v_years := fn_years_of_service(r.hire_date);
      IF v_years >= 10 THEN
        v_pct := v_pct + 2;
      END IF;

      v_new_sal := ROUND(r.monthly_salary * (1 + v_pct / 100));

      DBMS_OUTPUT.PUT_LINE(r.doc_name
        || ' | years: ' || v_years
        || ' | old: '   || r.monthly_salary
        || ' | raise: ' || v_pct || '%'
        || ' | new: '   || v_new_sal);
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=== REVIEW COMPLETE ===');
END;
/
