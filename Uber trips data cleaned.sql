--First glance at data--
select *
from ubertrips 

--At first glance, I realize that we need to: 
--1.Standarize start and end date format
--2.Populate Property Address data
--3.Remove Duplicates


--1. Standarize sales date format.
 --Start and end Date format includes the hour on it. So, I created 2 new columns named Start_date2  and End_date2 converted to date format.
 --Now it can be usedd to do further analysis based on date in Tableau.

SELECT Start_date, CONVERT (Date, Start_date)
FROM ubertrips

ALTER TABLE ubertrips
ADD Start_date2 Date

UPDATE ubertrips
SET Start_date2 = CONVERT (Date, Start_date)

SELECT End_date, CONVERT (Date, End_date)
FROM ubertrips

ALTER TABLE ubertrips
ADD end_date2 DATE

UPDATE ubertrips
SET End_date2 = CONVERT (Date, End_date)

SELECT Start_date, End_date, Start_date2, End_date2
FROM ubertrips

--2.Populate Purpose data
-- I realized that some fields in the purpose column were empty so I populated and removed those fields.

delete from uber.ubertrips
where purpose ='' or start = 'Unknown Location' or stop = 'Unknown Location'

SELECT Purpose
FROM ubertrips

--3.Remove duplicates
-- First, we need to identify the duplicates using CTE and ROW_NUMBER
-- ROW_NUMBER assignes a number to every row with information that should be unique in every property as id,start_date, end_date, start, stop, miles, purpose etc, And shows the number of times a row with the same data appears in the dataset.
-- Once the CTE is defined, we can DELETE the duplicates ie. rows that appered more than 1 time in the dataset

with RowNumCTE as(
    Select *,
	ROW_NUMBER () over (
	Partition by id,
                 start_date,
				 end_date,
				 Start_date2,
				 end_date2,
				 start,
                 stop,
                 miles,
                 purpose
				 Order BY
				 id
				 ) as row_num
From ubertrips
)
Select*
FROM RowNumCTE
WHERE row_num>1

--Now let's delete any duplicates
with RowNumCTE as(
SELECT *,
	ROW_NUMBER () over (
	Partition by id,
                 start_date,
				 end_date,
				 Start_date2,
				 end_date2,
				 start,
                 stop,
                 miles,
                 purpose
				 Order BY
				 id
				 ) as row_num
From ubertrips
)
DELETE
FROM RowNumCTE
WHERE row_num>1

