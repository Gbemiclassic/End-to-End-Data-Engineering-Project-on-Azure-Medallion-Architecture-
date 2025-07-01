🏗️ End-to-End Data Engineering Project on Azure (Lakehouse Architecture)
This project demonstrates a complete modern data engineering pipeline using Azure services, following the Bronze → Silver → Gold layered architecture. The pipeline is dynamic and metadata-driven, enabling scalable ingestion, transformation, and analytics with Azure Data Factory, Databricks, Azure Synapse Analytics, and Power BI.

📌 Architecture Overview
![image](https://github.com/user-attachments/assets/bb65ab28-456e-47b7-9b13-dd2b60ca620a)


🛠️ Tools & Technologies Used
Azure Data Factory – Metadata-driven, parameterized pipeline for scalable ingestion.

Azure Data Lake Gen2 – Storage layers (Bronze, Silver, Gold).

Visual Studio Code – Created metadata JSON file to control pipeline logic.

Azure Databricks – PySpark-based transformation, stored outputs in Parquet format.

Azure Synapse Analytics (Serverless SQL) – Created views, external tables with business logic.

Power BI – Reporting and visualization on Gold layer.

Azure Managed Identity – Secure authentication with scoped credentials.

🔸 Bronze Layer – Raw Data Ingestion
Goal: Ingest multiple CSV files from an HTTP-based API using a dynamic, metadata-driven pipeline.

✅ Key Steps:
Created a metadata .json file in VS Code listing all the API files:

json
Copy
Edit
{
  "p_relative_url": "Gbemiclassic/DE_Project/refs/heads/main/AdventureWorks_Returns.csv",
  "p_sink_folder": "Returns",
  "p_filename": "Returns.csv"
}
Defined Base_URL in a linked service.

Created a parameterized dataset with Rel_URL and Sink_Folder.

Used Lookup activity to read the JSON (unchecked First Row Only).

Connected a ForEach loop to run a Copy activity for each file.

Parameter mapping example:

Source → item().p_relative_url

Sink folder → item().p_sink_folder

💡 Result: A scalable and reusable ingestion pipeline that loaded all files into structured folders in the Bronze container of ADLS Gen2.

🥈 Silver Layer – Transformation with Databricks
Goal: Clean, standardize, and optimize raw data from Bronze.

✅ Key Steps:
Created an Azure App Registration (SPN) and assigned it Storage Blob Data Contributor access on ADLS Gen2.

Used Databricks to:

Authenticate using the SPN credentials.

Load raw data from Bronze using PySpark.

Clean, cast types, handle nulls, and perform light joins or enrichment.

Wrote cleaned datasets as Parquet files to the Silver container.

💡 Result: Efficient, analytics-ready data stored in a columnar format for fast querying and scalability.

🥇 Gold Layer – Synapse Analytics & Semantic Modeling
Goal: Apply business logic, create curated datasets, and enable external access for BI tools.

✅ Synapse Setup:
Created Serverless SQL Database

Created a Master Key

sql
Copy
Edit
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPasswordHere';
Created a Database Scoped Credential

sql
Copy
Edit
CREATE DATABASE SCOPED CREDENTIAL cred_synapse
WITH IDENTITY = 'Managed Identity';
Created External Data Sources

sql
Copy
Edit
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
Defined External File Format

sql
Copy
Edit
CREATE EXTERNAL FILE FORMAT format_parquet
WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
✅ Business Logic:
Created SQL Views in the dbo schema from the Parquet files in Silver using OPENROWSET:

sql
Copy
Edit
CREATE VIEW gold.sales AS
SELECT *
FROM OPENROWSET (
    BULK 'https://awstorageadls.dfs.core.windows.net/silver/Sales/',
    FORMAT = 'PARQUET'
) AS sales;
Denormalized tables (e.g., products with categories and subcategories).

Created derived fields like income categories from raw income values.

✅ External Tables for Gold Layer:
Created gold schema.

Created external tables using CREATE EXTERNAL TABLE ... AS SELECT from views:

sql
Copy
Edit
CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
) AS
SELECT * FROM gold.sales;
💡 Result: Gold layer tables now query-ready for downstream applications with fast, scalable access.

📊 Power BI – Reporting on Gold Layer
Connected Power BI to Azure Synapse Serverless SQL.

Loaded Gold external tables as datasets.

Built visuals showing trends, KPIs, and actionable insights.

✅ Highlights
✅ Scalable, metadata-driven ingestion using Lookup and ForEach.

✅ Clean separation of concerns across Bronze → Silver → Gold.

✅ SPN-based secure authentication for Databricks.

✅ Efficient querying and modeling with Synapse external tables and views.

✅ Power BI dashboards built on optimized Gold layer data.
