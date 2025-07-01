-- Create Credential
CREATE DATABASE SCOPED CREDENTIAL cred_synapse
WITH IDENTITY = 'Managed Identity'


-- Create External Source: Silver to read and Gold to push data
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://awstorageadls.dfs.core.windows.net/silver',
    CREDENTIAL = cred_synapse
)

CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://awstorageadls.dfs.core.windows.net/gold',
    CREDENTIAL = cred_synapse
)

--Create External File format

CREATE EXTERNAL FILE FORMAT format_parquet
WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)


-- Now Create External Tables

CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.sales;

CREATE EXTERNAL TABLE gold.extcustomers
WITH (
    LOCATION = 'extcustomers',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.customers;

CREATE EXTERNAL TABLE gold.extcalendar
WITH (
    LOCATION = 'extcalendar',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.calendar;

CREATE EXTERNAL TABLE gold.extproducts
WITH (
    LOCATION = 'extproducts',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.products;

CREATE EXTERNAL TABLE gold.extproducts_subcat
WITH (
    LOCATION = 'extproducts_subcat',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.products_subcategories;

CREATE EXTERNAL TABLE gold.extproducts_cat
WITH (
    LOCATION = 'extproducts_cat',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.products_categories;

CREATE EXTERNAL TABLE gold.extreturns
WITH (
    LOCATION = 'extreturns',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.returns;

CREATE EXTERNAL TABLE gold.extterritories 
WITH (
    LOCATION = 'extterritories ',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.territories ;


