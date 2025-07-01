/*************************
    CREATE VIEWS
*************************/

-- Calendar
-- CREATE VIEW gold.calendar
-- AS
-- SELECT *
-- FROM OPENROWSET (
--                     BULK 'https://awstorageadls.dfs.core.windows.net/silver/Calendar/',
--                     FORMAT = 'PARQUET'
--     ) AS calendar;

-- Sales
CREATE VIEW gold.sales
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Sales/',
                    FORMAT = 'PARQUET'
    ) AS sales;

-- Products
CREATE VIEW gold.Products
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Products/',
                    FORMAT = 'PARQUET'
    ) AS Products;

--Products_Subcategories
CREATE VIEW gold.Products_Subcategories
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Products_Subcategories/',
                    FORMAT = 'PARQUET'
    ) AS Products_Subcategories;


--Products_Categories
CREATE VIEW gold.Products_Categories
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Products_Categories/',
                    FORMAT = 'PARQUET'
    ) AS Products_Categories;

--Customers
CREATE VIEW gold.Customers
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Customers/',
                    FORMAT = 'PARQUET'
    ) AS Customers;

--Returns
CREATE VIEW gold.Returns
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Returns/',
                    FORMAT = 'PARQUET'
    ) AS Returns;

--Territories
CREATE VIEW gold.Territories
AS
SELECT *
FROM OPENROWSET (
                    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Territories/',
                    FORMAT = 'PARQUET'
    ) AS Territories;





