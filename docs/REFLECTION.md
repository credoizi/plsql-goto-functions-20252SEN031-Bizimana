# Reflection (C2)

**Course:** Database Development with PL/SQL (INSY 8311)
**Project:** Hospital Billing System

## 1. What did I learn about GOTO in PL/SQL?

I learned that `GOTO` makes the program jump to a label written as `<<label_name>>`. After the jump, execution continues from that label instead of the next line. I used it in A1 to move between sections (sign, then even or odd), and in A2 to skip doctors with no salary and to select a raise band. I also learned that a label must always be followed by an executable statement, which is why I needed `NULL;` at the end of the loop in A2.

## 2. Why is GOTO usually discouraged, and when could it still be useful?

GOTO makes the flow of a program harder to follow, because the reader has to search for labels to know where the code goes next. When there are many jumps the code becomes confusing and difficult to change without breaking something. Structured statements such as `IF`, `CASE` and loops show the logic in order.

GOTO can still be useful in a few cases, for example to jump to one common place at the end of a block when many different checks fail. In C1, I used it so each failed validation check jumps to its own error message and returns it.

## 3. What was the illegal GOTO in A3, and why did it fail?

In A3, the `GOTO` tried to jump to a label that was placed **inside** an `IF` block. PL/SQL does not allow a GOTO to jump into an IF block, a loop or another nested block. It can only jump to a label in the same block or in an enclosing block. The compiler rejected it with an error (PLS-00375, illegal GOTO statement). I fixed it by moving the label outside the IF block, so the GOTO is inside the IF and the label is in the enclosing block, which is allowed.

## 4. How did rewriting without GOTO (A4) change the code?

Without GOTO, the code became shorter and easier to read from top to bottom. In A1 I used two simple `IF / ELSIF / ELSE` statements. In A2 I used a `CASE` expression to pick the raise percentage and an `IF` to skip doctors with no salary. There are no labels, so I do not have to follow jumps. The results are the same as the GOTO versions, which showed me that GOTO is usually not necessary.

## 5. What are the advantages of stored functions, including using them inside SQL (B5)?

A stored function is written once and stored in the database, so it can be reused anywhere. If the tax rule changes, I only change `fn_calculate_tax` and every query that uses it gets the new rule. Functions also keep logic in one tested place, validate inputs (for example, rejecting negative salaries), and make queries shorter. In B5, I called the functions directly inside `SELECT`, `WHERE`, `ORDER BY` and `GROUP BY`, for example to show each doctor's annual salary, years of service and ward name in one query.

## 6. What was the hardest part of this assignment, and how did I solve it?

The hardest part was the database setup. My first run of the table script failed with `ORA-01031: insufficient privileges`, because my user `MYADMIN` in the pluggable database did not have permission to create tables. All the later `INSERT` errors (`ORA-00942`) happened only because the tables did not exist. I solved it by connecting as SYSDBA, switching to my pluggable database with `ALTER SESSION SET CONTAINER`, and granting the needed privileges (`CREATE SESSION`, `CREATE TABLE`, `CREATE PROCEDURE`, and others) to `MYADMIN`. After that I reconnected and the script ran successfully. I also had a problem with a multi-line query being split by SQL Developer, which I solved by running the count queries separately.

This taught me to read the first error in the output carefully, because later errors are often just a result of it.
