# 🏗️ End-to-End Data Engineering Project on Azure (Lakehouse Architecture)
<p align="center">
![image](https://github.com/user-attachments/assets/d16d18eb-7f25-47ec-8caf-4d1a6b06b706)


## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Architecture Overview](#architecture-overview)
- [🔧 Tools & Technologies Used](#-tools--technologies-used)
- [🔹 Bronze Layer – Raw Data Ingestion](#-bronze-layer--raw-data-ingestion)
- [🥂 Silver Layer – Transformation with Databricks](#-silver-layer--transformation-with-databricks)
- [🥇 Gold Layer – Synapse Analytics & Semantic Modeling](#-gold-layer--synapse-analytics--semantic-modeling)
- [📊 Power BI – Reporting](#-power-bi--reporting)
- [✅ Highlights](#-highlights)

***

## Project Overview
This project demonstrates a complete modern data engineering pipeline using Azure services, following the Bronze → Silver → Gold layered architecture. The pipeline is dynamic and metadata-driven, enabling scalable ingestion, transformation, and analytics using Azure Data Factory, Databricks, Synapse Analytics, and Power BI.

## Architecture Overview
This project follows the Lakehouse Architecture pattern with the following components:
- Ingestion via Azure Data Factory from HTTP API.
- Bronze layer for raw data storage.
- Databricks for transformation into Silver layer.
- Synapse for business logic and Gold layer modeling.
- Power BI for reporting.

***

## 🔧 Tools & Technologies Used
- **Azure Data Factory**: Metadata-driven, parameterized pipeline for scalable ingestion.
- **Azure Data Lake Gen2**: Storage layers (Bronze, Silver, Gold).
- **Visual Studio Code**: Created JSON metadata file to control pipeline logic.
- **Azure Databricks**: PySpark-based transformation, outputs stored in Parquet.
- **Azure Synapse Analytics**: Serverless SQL for modeling, views, and external tables.
- **Power BI**: Reporting and dashboarding layer.
- **Azure Managed Identity**: Secure authentication across services.

***

## 🔹 Bronze Layer – Raw Data Ingestion
**Goal:** Ingest multiple CSV files from an HTTP API using a dynamic, metadata-driven pipeline.

### Key Steps:
- Created a JSON file in VS Code containing parameters like `p_relative_url`, `p_sink_folder`, and `p_filename` for each dataset.
```json
{
  "p_relative_url": "Gbemiclassic/DE_Project/refs/heads/main/AdventureWorks_Returns.csv",
  "p_sink_folder": "Returns",
  "p_filename": "Returns.csv"
}
```
- Defined `Base_URL` in linked service.
- Created parameterized dataset with `Rel_URL` and `Sink_Folder`.
- Used Lookup activity to read JSON (unchecked "First Row Only").
- Connected a ForEach loop to run a Copy activity for each file..

#### Parameter Mapping Example:

Source → item().p_relative_url

Sink folder → item().p_sink_folder

💡 Result: A scalable and reusable ingestion pipeline that loaded all files into structured folders in the Bronze container of ADLS Gen2.

***

## 🥂 Silver Layer – Transformation with Databricks
**Goal:** Clean, standardize, and optimize raw data from Bronze.

### Key Steps:
- Registered an Azure App (SPN) with `Storage Blob Data Contributor` role.
- In Databricks:
  - Authenticated with SPN credentials.
  - Loaded raw data using PySpark.
  - Cleaned, casted types, handled nulls, and enriched data.
  - Wrote transformed data as Parquet into Silver container.

The notebook used for the silver layer transformation can be found here 
**Result:** Efficient, analytics-ready data stored in optimized columnar format.

***

## 🥇 Gold Layer – Synapse Analytics & Semantic Modeling
**Goal:** Create business-curated data layer and enable external access.

### Business Logic:
- Created a serverless database
- Created SQL views in the dbo schema from Silver layer using `OPENROWSET`:

Sample Query
```sql
CREATE VIEW gold.sales AS
SELECT *
FROM OPENROWSET (
    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Sales/',
    FORMAT = 'PARQUET'
) AS sales;
```
- Denormalized products table to include the product categories and subcategories.
- Derived other fields based on business requirements e.g. income categories from raw income values.

### Synapse Setup:
```sql
-- Create Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPasswordHere';

-- Create Scoped Credential
CREATE DATABASE SCOPED CREDENTIAL cred_synapse
WITH IDENTITY = 'Managed Identity';

-- Create External Data Sources
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://awstorageadls.dfs.core.windows.net/silver',
    CREDENTIAL = cred_synapse
);

CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://awstorageadls.dfs.core.windows.net/gold',
    CREDENTIAL = cred_synapse
);

-- Create File Format
CREATE EXTERNAL FILE FORMAT format_parquet
WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
```


### Gold Tables:
- Created external tables using CREATE EXTERNAL TABLE ... AS SELECT from views:

Sample Query
```sql
CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.sales;
```

**Result:** Query-optimized, business-curated datasets accessible by downstream tools.

***

## 📊 Power BI – Reporting
- Connected Power BI to Synapse Serverless SQL.
- Loaded Gold external tables.
- Built dashboards to visualize KPIs, trends, and insights.

***

## ✅ Highlights
- Scalable, **metadata-driven ingestion** using Lookup and ForEach.
- Clear separation: **Bronze → Silver → Gold**.
- Secure, **SPN-based Databricks** authentication.
- Fast, scalable querying using **Parquet + Synapse External Tables**.
- **Power BI** reporting powered by a robust data foundation.

---

# <p align="center">Thank you for reading! 😎</p>

