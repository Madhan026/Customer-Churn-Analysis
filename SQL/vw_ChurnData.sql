/*
Customer Churn Analysis - SQL Server View
Database: ChurnDB
View: dbo.vw_ChurnData

Purpose:
Create a clean analysis view used by Python and Power BI.
*/

USE ChurnDB;
GO

-- Drop the old view when it already exists.
IF OBJECT_ID('dbo.vw_ChurnData', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ChurnData;
GO

CREATE VIEW dbo.vw_ChurnData
AS
SELECT
    CustomerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn,

    -- Derived tenure group
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48'
        ELSE '49+'
    END AS TenureGroup,

    -- Derived monthly-charge category
    CASE
        WHEN MonthlyCharges >= 80 THEN 'High'
        WHEN MonthlyCharges >= 40 THEN 'Medium'
        ELSE 'Low'
    END AS ChargeCategory

FROM dbo.CustomerChurn;
GO

-- ============================================================
-- View validation
-- ============================================================
SELECT COUNT(*) AS TotalRows
FROM dbo.vw_ChurnData;
GO

SELECT TOP 10 *
FROM dbo.vw_ChurnData;
GO
