SELECT * FROM Blinkit_data;

-- Check my Data 
SELECT DISTINCT
	Item_Fat_Content
FROM blinkit_data;

-- Updating my Columns

UPDATE Blinkit_data
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('low fat', 'LF') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

--  A. KPI REQUIREMENTS

-- Total Sales
SELECT 
CAST (SUM(Total_Sales)/ 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM blinkit_data

-- Average Sales
SELECT 
CAST (AVG(Total_Sales) AS INT) AS Average_Sales
FROM blinkit_data

-- Total_Orders
SELECT 
	COUNT(*) AS No_of_Orders
FROM Blinkit_data

-- Average Rating
SELECT
CAST (AVG(Rating) AS DECIMAL(5,1)) AS Average_Rating
FROM blinkit_data

-- B. GRANULAR REQUIREMENTS

-- Total Sales By Fat Content

SELECT
Item_Fat_Content,
CONCAT(CAST(SUM(Total_Sales)/ 1000 AS INT),'K') AS Total_Sales
FROM Blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

--Total Sales By Item Type

SELECT 
    Item_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS _Total_Sales
FROM Blinkit_data
GROUP BY Item_Type
ORDER BY _Total_Sales DESC ;

-- Fat Content By Outlet Type For Total Sales

SELECT
Outlet_Location_Type,
ISNULL([Regular],0) AS Regular,
ISNULL([Low Fat],0) AS Low_Fat
FROM
(
SELECT 
	Outlet_Location_Type,
	Item_Fat_Content,
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS _Total_Sales
FROM Blinkit_data
GROUP BY Outlet_Location_Type,Item_Fat_Content
) 
AS SourceTable
PIVOT
(
SUM(_Total_Sales)
FOR Item_Fat_Content IN ([Regular],[Low Fat])
) AS PivotTable

-- Total Sales By Outlet Establishment

SELECT 
Outlet_Establishment_Year,
CONCAT(CAST(SUM(Total_Sales)/ 1000 AS INT),'K') AS Total_Sales
FROM Blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY CAST(SUM(Total_Sales)/ 1000 AS INT) DESC

-- CHARTS REQUIREMENTS

-- Percentage of Sales By Outlet Size

SELECT
Outlet_Size,
CONCAT(CAST(SUM(Total_Sales)/ 1000 AS INT),'K') AS Total_Sales,
CONCAT(CAST(SUM(Total_Sales)*100.0/SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)),'%') AS [%_OF_Sales]
FROM Blinkit_data
GROUP BY Outlet_Size
ORDER BY SUM(Total_Sales) DESC

--Sales By Outlet Location
SELECT 
Outlet_Location_Type,
CONCAT(CAST(SUM(Total_Sales)/ 1000 AS INT),'K') AS Total_Sales
FROM Blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type ASC

-- All Metrices By Outlet Type

SELECT 
Outlet_Type,
CONCAT(CAST(SUM(Total_Sales)/ 1000 AS INT),'K') AS Total_Sales,
CAST (AVG(Total_Sales) AS INT) AS Average_Sales,
CAST (AVG(Rating) AS DECIMAL(5,1)) AS Average_Rating,
COUNT(Outlet_Type) AS No_of_Orders
FROM Blinkit_data
GROUP BY Outlet_Type
ORDER BY SUM(Total_Sales) DESC
