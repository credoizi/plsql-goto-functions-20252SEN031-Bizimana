-- =====================================================================
-- B4: fn_dept_name  (hospital version: returns the WARD name)
-- Looks up a ward name by ward_id.
--   NULL ward_id      -> 'No ward assigned'
--   id not in WARDS   -> 'Unknown ward'   (NO_DATA_FOUND handled)
-- Requires the WARDS table from 00_setup/create_tables.sql
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_dept_name (
  p_ward_id IN NUMBER
) RETURN VARCHAR2
IS
  v_name wards.ward_name%TYPE;
BEGIN
  IF p_ward_id IS NULL THEN
    RETURN 'No ward assigned';
  END IF;

  SELECT ward_name
  INTO   v_name
  FROM   wards
  WHERE  ward_id = p_ward_id;

  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Unknown ward';
END fn_dept_name;
/

SHOW ERRORS FUNCTION fn_dept_name;
