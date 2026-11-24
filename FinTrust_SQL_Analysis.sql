CREATE database FinTrust_db;

USE FinTrust_db;
show tables;

-- 1. How many customers are in FinTrust?

SELECT COUNT(*) AS Total_Customers
FROM fintrust_customer_data;


-- 2. How many transactions were recorded?

SELECT COUNT(*) AS Total_Transactions
FROM fintrust_transaction_data;


-- 3. What is the total transaction value?

SELECT
    SUM(
        CAST(
            REPLACE(
                REPLACE(
                    REPLACE(Amount_NGN, '$', ''),
                    ',',
                    ''
                ),
                ' ',
                ''
            ) AS DECIMAL(15,2)
        )
    ) AS Total_Transaction_Value
FROM fintrust_transaction_data;


-- 4. Which transaction types have the highest transaction activity and value?

SELECT
    Transaction_Type,
    COUNT(*) AS Transaction_Count,
    SUM(
        CAST(
            REPLACE(REPLACE(REPLACE(Amount_NGN, '$', ''), ',', ''), ' ', '')
            AS DECIMAL(15,2)
        )
    ) AS Total_Value
FROM fintrust_transaction_data
GROUP BY Transaction_Type
ORDER BY Transaction_Count DESC, Total_Value DESC;


-- 5. Which channels are most frequently used?

SELECT
    Channel,
    COUNT(*) AS Transaction_Count,
    SUM(
        CAST(
            REPLACE(REPLACE(REPLACE(Amount_NGN, '$', ''), ',', ''), ' ', '')
            AS DECIMAL(15,2)
        )
    ) AS Total_Value
FROM fintrust_transaction_data
GROUP BY Channel
ORDER BY Transaction_Count DESC;


-- 6. What is the distribution of transaction statuses?

SELECT
    Transaction_Status,
    COUNT(*) AS Transaction_Count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM fintrust_transaction_data),
        2
    ) AS Percentage
FROM fintrust_transaction_data
GROUP BY Transaction_Status
ORDER BY Transaction_Count DESC;


-- 7. Which transaction types have the highest number of transactions?

SELECT
    Transaction_Type,
    COUNT(*) AS Transaction_Count
FROM fintrust_transaction_data
GROUP BY Transaction_Type
ORDER BY Transaction_Count DESC;


-- 8. What is the pattern of risk-review transactions?

SELECT
    Risk_Review_Flag,
    COUNT(*) AS Transaction_Count,

    ROUND(
        SUM(
            CAST(
                REPLACE(REPLACE(REPLACE(Amount_NGN, '$', ''), ',', ''), ' ', '')
                AS DECIMAL(15,2)
            )
        ),
        2
    ) AS Total_Value,

    ROUND(
        AVG(
            CAST(
                REPLACE(REPLACE(REPLACE(Amount_NGN, '$', ''), ',', ''), ' ', '')
                AS DECIMAL(15,2)
            )
        ),
        2
    ) AS Average_Value

FROM fintrust_transaction_data
GROUP BY Risk_Review_Flag
ORDER BY Transaction_Count DESC;
