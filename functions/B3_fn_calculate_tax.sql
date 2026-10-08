-- =====================================================================
-- B3: fn_calculate_tax
-- Progressive monthly income tax on a salary (simplified PAYE bands):
--     0        - 60,000   : 0%
--     60,001   - 100,000  : 20% of the part above 60,000
--     above 100,000       : 8,000 + 30% of the part above 100,000
-- NULL in -> NULL out. Negative amount -> raises an error.
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_calculate_tax (
  p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
  v_tax NUMBER;
BEGIN
  IF p_monthly_salary IS NULL THEN
    RETURN NULL;
  END IF;

  IF p_monthly_salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Salary cannot be negative.');
  END IF;

  IF p_monthly_salary <= 60000 THEN
    v_tax := 0;
  ELSIF p_monthly_salary <= 100000 THEN
    v_tax := (p_monthly_salary - 60000) * 0.20;
  ELSE
    v_tax := 8000 + (p_monthly_salary - 100000) * 0.30;
  END IF;

  RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/

SHOW ERRORS FUNCTION fn_calculate_tax;
