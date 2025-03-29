use [BlinkIT DB];

select *
from [BlinkIT Tables];

-- Data Cleaning


-- Standardizing Data
update [BlinkIT Tables]
set Item_Fat_Content =
	case
		when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
		when Item_Fat_Content = 'reg' then 'Regular'
		else Item_Fat_Content
		end;

-- Check Data Values
select distinct Item_Fat_Content
from [BlinkIT Tables];


-- Looking for KPI's

select cast(sum(Total_Sales)/1000000.0 as decimal (10,2))
as Total_Sales_in_Million
from [BlinkIT Tables]; -- Total Sales in Million


select cast(avg(Total_Sales)as int)
as Average_Sales
from [BlinkIT Tables];-- Average Sales


select count(*)
as No_Of_Orders
from [BlinkIT Tables];-- Quantity of Orders


select cast (avg(Rating) as decimal(10,1)) 
as Average_Rating
from [BlinkIT Tables];-- Average Rating


select Item_Fat_Content, CAST(sum(Total_Sales) as decimal (10,2))
as Total_Sales
from [BlinkIT Tables]
group by Item_Fat_Content;-- Total Sales by Fat Content


select Item_Type, cast(sum(Total_Sales) as decimal (10,2))
as Total_Sales
from [BlinkIT Tables]
group by Item_Type
order by Total_Sales
desc;-- Total Sales by Item Type


SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM [dbo].[BlinkIT Tables]
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [dbo].[BlinkIT Tables]
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year; -- Total Sales by Outlet Establishment


SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM [dbo].[BlinkIT Tables]
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;-- Percentage Sales by Outlet Size


SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [dbo].[BlinkIT Tables]
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;-- Sales by Outlet Location


SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM [dbo].[BlinkIT Tables]
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC; --All Metrics by Outlet Type

