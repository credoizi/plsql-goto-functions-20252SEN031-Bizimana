-- =====================================================================
-- test_validate_payroll.sql : tests C1 on every invoice
-- Expected: invoices 1-4 VALID; 5-8 INVALID; 999 not found.
-- =====================================================================
SET SERVEROUTPUT ON;

BEGIN
  FOR r IN (SELECT invoice_id FROM invoices ORDER BY invoice_id) LOOP
    DBMS_OUTPUT.PUT_LINE('Invoice ' || r.invoice_id || ' -> ' || fn_validate_payroll(r.invoice_id));
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Invoice 999 -> ' || fn_validate_payroll(999));
END;
/

-- Same function used directly in SQL
SELECT invoice_id, status, fn_validate_payroll(invoice_id) AS validation_result
FROM   invoices
ORDER BY invoice_id;
