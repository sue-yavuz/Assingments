--Factorial Function 
--Create a scalar-valued function that returns the factorial of a number you gave it.
USE SampleRetail
GO

--Factorial Function
--Saved to Programmability -> Scalar-Valued Function
CREATE OR ALTER FUNCTION factorial (
	@input INT
) 
RETURNS INT
AS
BEGIN
	DECLARE
	@result INT = 1
	
	--RETURN NULL IF NEGATIF
	IF @input<0 
		BEGIN 
		RETURN NULL 
		END
	--RETURN 1 IF ZERO
	ELSE IF @input=0 
		BEGIN 
		RETURN 1 
		END
	ELSE
		--CALC RESULT IF POSITIVE NUMBER
		WHILE @input>0
		BEGIN
			set @result *= @input
			set @input -= 1
		END
	RETURN @result
END
GO

-- CALL FUNCTION
select	dbo.factorial(-5) negatif
		,dbo.factorial(0) zero
		,dbo.factorial(5) pozitif;
GO

-- CALL FUNCTION WITH DECLARE
DECLARE
@num_neg INT = -5,
@num_zero INT = 0,
@num_poz INT = 5

select	dbo.factorial(@num_neg) negatif
		,dbo.factorial(@num_zero) zero
		,dbo.factorial(@num_poz) pozitif;
GO


-- CALL FUNCTION WITH FROM-FROM
SELECT	dbo.factorial(number) 
FROM	(
	VALUES (-3),(-2),(-1),(0),(1),(2),(3)
) tbl(number)
GO


-- CALL FUNCTION WITH RECURSIVE
WITH tbl(number) AS (
    SELECT -5
  UNION ALL
    SELECT number+3 FROM tbl
	WHERE	number<5
)
SELECT	dbo.factorial(number) 
FROM	tbl 
GO