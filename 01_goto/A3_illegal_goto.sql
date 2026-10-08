-- =====================================================================
-- A3: Illegal GOTO and Fix
-- RULE: PL/SQL does NOT allow a GOTO to jump INTO an IF block, LOOP
--       or nested block. It can only jump to a label that is in the
--       same block or an enclosing block.
-- Part 1 is ILLEGAL and is expected to fail with PLS-00375.
-- Part 2 is the FIXED version and runs correctly.
-- Take ONE screenshot showing the error and the fixed output.
-- =====================================================================
SET SERVEROUTPUT ON;

-- ---------------------------------------------------------------------
-- PART 1: ILLEGAL (jumps into an IF block) -> compile error expected
-- ---------------------------------------------------------------------
DECLARE
  v_amount_due NUMBER := 0;
BEGIN
  GOTO fully_covered;                 -- ILLEGAL: label is inside the IF below

  IF v_amount_due = 0 THEN
    <<fully_covered>>
    DBMS_OUTPUT.PUT_LINE('Invoice is fully covered by insurance.');
  END IF;
END;
/

-- ---------------------------------------------------------------------
-- PART 2: FIXED (label moved OUTSIDE the IF block, same block as GOTO)
-- ---------------------------------------------------------------------
DECLARE
  v_amount_due NUMBER := 0;
BEGIN
  IF v_amount_due = 0 THEN
    GOTO fully_covered;               -- legal: label is in the enclosing block
  END IF;

  DBMS_OUTPUT.PUT_LINE('Patient still owes: ' || v_amount_due);
  GOTO end_check;

  <<fully_covered>>
  DBMS_OUTPUT.PUT_LINE('Invoice is fully covered by insurance.');

  <<end_check>>
  DBMS_OUTPUT.PUT_LINE('Check finished.');
END;
/
