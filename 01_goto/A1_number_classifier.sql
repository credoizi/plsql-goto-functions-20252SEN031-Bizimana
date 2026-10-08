-- =====================================================================
-- A1: Number Classifier (using GOTO)
-- Classifies a number as POSITIVE / NEGATIVE / ZERO and EVEN / ODD.
-- Change v_num and run again to test other values (e.g. 17, -4, 0, 10).
-- =====================================================================
SET SERVEROUTPUT ON;

DECLARE
  v_num NUMBER := 17;   -- <<< change this value to test
BEGIN
  DBMS_OUTPUT.PUT_LINE('Number tested: ' || v_num);

  -- Step 1: sign
  IF v_num > 0 THEN
    GOTO is_positive;
  ELSIF v_num < 0 THEN
    GOTO is_negative;
  ELSE
    GOTO is_zero;
  END IF;

  <<is_positive>>
  DBMS_OUTPUT.PUT_LINE('Sign   : POSITIVE');
  GOTO check_parity;

  <<is_negative>>
  DBMS_OUTPUT.PUT_LINE('Sign   : NEGATIVE');
  GOTO check_parity;

  <<is_zero>>
  DBMS_OUTPUT.PUT_LINE('Sign   : ZERO');

  -- Step 2: even or odd
  <<check_parity>>
  IF MOD(v_num, 2) = 0 THEN
    GOTO is_even;
  ELSE
    GOTO is_odd;
  END IF;

  <<is_even>>
  DBMS_OUTPUT.PUT_LINE('Parity : EVEN');
  GOTO end_program;

  <<is_odd>>
  DBMS_OUTPUT.PUT_LINE('Parity : ODD');

  <<end_program>>
  DBMS_OUTPUT.PUT_LINE('Classification finished.');
END;
/
