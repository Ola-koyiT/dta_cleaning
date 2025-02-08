USE HNG_TASKS

SELECT * 
FROM productdata

SELECT 
		Product_ID,
		Title,
		Bullet_points,
		CASE
			WHEN Bullet_Points = 'NULL' THEN 0
			WHEN Description = 'NULL' THEN 0
			ELSE 0
		END 
FROM productdata	
-----CHECKING FOR THE TOTAL NO OF ENTRY THAT HAS NULL VALUES (2,217 ROWS)
SELECT *
FROM productdata
WHERE Bullet_Points IS NULL
OR Description IS NULL

--REPLACING NULL VALUES WITH A DEFAULT VALUE------
SELECT
		Bullet_points, COALESCE(Bullet_points, 'None') AS Bullet_points_Upd,
		Description, COALESCE (Description, 'empty') AS Description_upd
FROM productdata

UPDATE productdata
SET Bullet_Points = 'None'
WHERE Bullet_Points IS NULL

UPDATE productdata
SET Description = 'Empty'
WHERE Description IS NULL
-------Removing unneccesary characters----

SELECT *
FROM productdata
WHERE Bullet_Points IS NULL
OR Description IS NULL


SELECT TRANSLATE(Bullet_Points, 'abc', '   ') AS cleaned_Bullet_Points
FROM productdata
----finding double entry
SELECT bullet_points, Product_Length, product_id, COUNT(*)
FROM productdata
GROUP BY Bullet_Points, Product_Length, Product_ID
HAVING COUNT(*) > 1;
SELECT COUNT (*) FROM productdata
---deleting extra characters
UPDATE productdata
SET Bullet_Points = REPLACE(Bullet_Points, '[', '')
---------------------
UPDATE productdata
SET Description = REPLACE(Description, '</b>', '')
---
UPDATE productdata
SET Description = REPLACE(Description, '<b>', '')
--
UPDATE productdata
SET Description = REPLACE(Description, '</p>', '')


SELECT DISTINCT Product_ID, 
				Product_Length,
				bullet_points
FROM productdata;
----deleting duplicate records---
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Bullet_Points, Product_Length ORDER BY Product_ID) AS row_num
    FROM productdata
)
DELETE FROM productdata 
WHERE Product_ID IN (SELECT Product_ID FROM CTE WHERE row_num > 1);

SELECT *
FROM productdata
----------------------
------------adding new column 
ALTER TABLE productdata ADD short_title NVARCHAR(50);

-----------Populating the new column
UPDATE productdata 
SET short_title = Bullet_Points + Title

---trimming bullet points column---
UPDATE productdata
SET Title = TRIM(SUBSTRING(
    REPLACE(REPLACE(REPLACE(Title, 'Set of', '['), 'Includes', ''), 'Features', ''), 1, 20));
---trimming bullet points column---
UPDATE productdata
SET Bullet_points = TRIM(SUBSTRING(
    REPLACE(REPLACE(REPLACE(Bullet_points, 'Set of', '['), 'Includes', ''), 'Features', ''), 1, 20))

---trimming description points column---
UPDATE productdata
SET Description = TRIM(SUBSTRING(
    REPLACE(REPLACE(REPLACE(Description, 'Set of', '['), 'Includes', ''), 'Features', ''), 1, 25))

	------END-----------

