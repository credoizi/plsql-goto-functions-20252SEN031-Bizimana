-- =====================================================================
-- C1: fn_validate_payroll  (hospital version: validates an INVOICE)
-- Combines functions + GOTO. Returns 'VALID' or 'INVALID: <reason>'.
-- Checks, in order:
--   1. invoice exists
--   2. required amounts are not NULL
--   3. insurance_covered is not NULL
--   4. total_amount is not zero
--   5. total = consultation + medication + room
--   6. amount_due is not negative
--   7. amount_due = total + tax - insurance
-- Requires the INVOICES table from 00_setup/create_tables.sql
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_validate_payroll (
  p_invoice_id IN NUMBER
) RETURN VARCHAR2
IS
  v_inv      invoices%ROWTYPE;
  v_expected NUMBER;
BEGIN
  SELECT *
  INTO   v_inv
  FROM   invoices
  WHERE  invoice_id = p_invoice_id;

  IF v_inv.consultation_fee IS NULL OR v_inv.medication_cost IS NULL
     OR v_inv.room_cost IS NULL OR v_inv.total_amount IS NULL
     OR v_inv.tax_amount IS NULL OR v_inv.amount_due IS NULL THEN
    GOTO err_null_amount;
  END IF;

  IF v_inv.insurance_covered IS NULL THEN
    GOTO err_null_insurance;
  END IF;

  IF v_inv.total_amount = 0 THEN
    GOTO err_zero_total;
  END IF;

  v_expected := v_inv.consultation_fee + v_inv.medication_cost + v_inv.room_cost;
  IF v_inv.total_amount <> v_expected THEN
    GOTO err_total_mismatch;
  END IF;

  IF v_inv.amount_due < 0 THEN
    GOTO err_negative_due;
  END IF;

  IF v_inv.amount_due <> v_inv.total_amount + v_inv.tax_amount - v_inv.insurance_covered THEN
    GOTO err_due_mismatch;
  END IF;

  RETURN 'VALID';

  <<err_null_amount>>
  RETURN 'INVALID: a required amount is NULL';

  <<err_null_insurance>>
  RETURN 'INVALID: insurance_covered is NULL';

  <<err_zero_total>>
  RETURN 'INVALID: total amount is zero';

  <<err_total_mismatch>>
  RETURN 'INVALID: total does not equal fee + medication + room (expected '
         || v_expected || ', found ' || v_inv.total_amount || ')';

  <<err_negative_due>>
  RETURN 'INVALID: amount due is negative';

  <<err_due_mismatch>>
  RETURN 'INVALID: amount due does not equal total + tax - insurance';

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'INVALID: invoice not found';
END fn_validate_payroll;
/

SHOW ERRORS FUNCTION fn_validate_payroll;
