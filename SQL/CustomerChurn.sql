/*
Customer Churn Analysis - SQL Server
Database: ChurnDB
Table: dbo.CustomerChurn

Purpose:
1. Create the ChurnDB database.
2. Create the CustomerChurn table.
3. Prepare the table for the Telco Customer Churn dataset.

Note: The CSV import path is machine-specific, so the data import step is
intentionally left as a placeholder. Update the path before using BULK INSERT.
*/

-- ============================================================
-- 1. Create database
-- ============================================================
IF DB_ID('ChurnDB') IS NULL
BEGIN
    CREATE DATABASE ChurnDB;
END;
GO

USE ChurnDB;
GO

-- ============================================================
-- 2. Create CustomerChurn table
-- ============================================================
IF OBJECT_ID('dbo.CustomerChurn', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CustomerChurn
    (
        CustomerID          VARCHAR(20)    NOT NULL,
        gender              VARCHAR(20)    NULL,
        SeniorCitizen       BIT            NULL,
        Partner              VARCHAR(10)    NULL,
        Dependents          VARCHAR(10)    NULL,
        tenure              INT            NULL,
        PhoneService        VARCHAR(10)    NULL,
        MultipleLines       VARCHAR(30)    NULL,
        InternetService     VARCHAR(30)    NULL,
        OnlineSecurity      VARCHAR(30)    NULL,
        OnlineBackup        VARCHAR(30)    NULL,
        DeviceProtection    VARCHAR(30)    NULL,
        TechSupport         VARCHAR(30)    NULL,
        StreamingTV         VARCHAR(30)    NULL,
        StreamingMovies     VARCHAR(30)    NULL,
        Contract            VARCHAR(30)    NULL,
        PaperlessBilling    VARCHAR(10)    NULL,
        PaymentMethod       VARCHAR(50)    NULL,
        MonthlyCharges      DECIMAL(10,2)  NULL,
        TotalCharges        DECIMAL(12,2)  NULL,
        Churn                VARCHAR(10)    NULL
    );
END;
GO

-- ============================================================
-- 3. Basic validation queries
-- ============================================================
SELECT COUNT(*) AS TotalCustomers
FROM dbo.CustomerChurn;
GO

SELECT TOP 10 *
FROM dbo.CustomerChurn;
GO

SELECT Churn, COUNT(*) AS CustomerCount
FROM dbo.CustomerChurn
GROUP BY Churn;
GO

-- ============================================================
-- 4. Check missing values in important columns
-- ============================================================
SELECT
    SUM(CASE WHEN CustomerID IS NULL OR LTRIM(RTRIM(CustomerID)) = '' THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS MissingTotalCharges,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS MissingMonthlyCharges,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS MissingTenure
FROM dbo.CustomerChurn;
GO

-- ============================================================
-- 5. Duplicate CustomerID check
-- ============================================================
SELECT CustomerID, COUNT(*) AS RecordCount
FROM dbo.CustomerChurn
GROUP BY CustomerID
HAVING COUNT(*) > 1;
GO

-- ============================================================
-- 6. Overall churn analysis
-- ============================================================
SELECT
    Churn,
    COUNT(*) AS TotalCustomers,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM dbo.CustomerChurn
GROUP BY Churn;
GO

-- ============================================================
-- 7. Contract-wise churn analysis
-- ============================================================
SELECT
    Contract,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.CustomerChurn
GROUP BY Contract
ORDER BY ChurnRate DESC;
GO

-- ============================================================
-- 8. Tenure-group churn analysis
-- ============================================================
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48'
        ELSE '49+'
    END AS TenureGroup,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.CustomerChurn
GROUP BY
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48'
        ELSE '49+'
    END
ORDER BY MIN(tenure);
GO

-- ============================================================
-- 9. Internet-service churn analysis
-- ============================================================
SELECT
    InternetService,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.CustomerChurn
GROUP BY InternetService
ORDER BY ChurnRate DESC;
GO

-- ============================================================
-- 10. Charge-category churn analysis
-- ============================================================
SELECT
    CASE
        WHEN MonthlyCharges >= 80 THEN 'High'
        WHEN MonthlyCharges >= 40 THEN 'Medium'
        ELSE 'Low'
    END AS ChargeCategory,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.CustomerChurn
GROUP BY
    CASE
        WHEN MonthlyCharges >= 80 THEN 'High'
        WHEN MonthlyCharges >= 40 THEN 'Medium'
        ELSE 'Low'
    END
ORDER BY ChurnRate DESC;
GO
