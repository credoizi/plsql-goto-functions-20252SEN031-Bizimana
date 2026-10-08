-- =====================================================================
-- test_functions.sql : tests B1-B4 with normal, NULL and error cases
-- =====================================================================
SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- B1 fn_annual_salary ---');
  DBMS_OUTPUT.PUT_LINE('1800000 -> ' || fn_annual_salary(1800000));
  DBMS_OUTPUT.PUT_LINE('NULL    -> ' || NVL(TO_CHAR(fn_annual_salary(NULL)), 'NULL'));
  BEGIN
    DBMS_OUTPUT.PUT_LINE('-5      -> ' || fn_annual_salary(-5));
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-5      -> error caught: ' || SQLERRM);
  END;

  DBMS_OUTPUT.PUT_LINE('--- B2 fn_years_of_service ---');
  DBMS_OUTPUT.PUT_LINE('2012-03-01 -> ' || fn_years_of_service(DATE '2012-03-01'));
  DBMS_OUTPUT.PUT_LINE('NULL       -> ' || NVL(TO_CHAR(fn_years_of_service(NULL)), 'NULL'));
  BEGIN
    DBMS_OUTPUT.PUT_LINE('future     -> ' || fn_years_of_service(SYSDATE + 365));
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('future     -> error caught: ' || SQLERRM);
  END;

  DBMS_OUTPUT.PUT_LINE('--- B3 fn_calculate_tax (expected 0, 0, 4000, 8000, 23000, 728000) ---');
  DBMS_OUTPUT.PUT_LINE('0       -> ' || fn_calculate_tax(0));
  DBMS_OUTPUT.PUT_LINE('60000   -> ' || fn_calculate_tax(60000));
  DBMS_OUTPUT.PUT_LINE('80000   -> ' || fn_calculate_tax(80000));
  DBMS_OUTPUT.PUT_LINE('100000  -> ' || fn_calculate_tax(100000));
  DBMS_OUTPUT.PUT_LINE('150000  -> ' || fn_calculate_tax(150000));
  DBMS_OUTPUT.PUT_LINE('2500000 -> ' || fn_calculate_tax(2500000));
  BEGIN
    DBMS_OUTPUT.PUT_LINE('-100    -> ' || fn_calculate_tax(-100));
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-100    -> error caught: ' || SQLERRM);
  END;

  DBMS_OUTPUT.PUT_LINE('--- B4 fn_dept_name ---');
  DBMS_OUTPUT.PUT_LINE('ward 3    -> ' || fn_dept_name(3));
  DBMS_OUTPUT.PUT_LINE('ward 99   -> ' || fn_dept_name(99));
  DBMS_OUTPUT.PUT_LINE('ward NULL -> ' || fn_dept_name(NULL));
END;
/
