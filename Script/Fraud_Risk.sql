-- 1. Risk concentration
SELECT 
    state,
    city,
    lat,
    long,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud,
    SUM(amt) AS total_transaction_value,
    SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END) AS fraud_value,
    ROUND(SUM(is_fraud) / COUNT(*), 4) AS fraud_rate
FROM bank
GROUP BY state, city, lat, long
HAVING SUM(is_fraud) > 0;

-- 2. Spending habits
SELECT 
    category,
    COUNT(*) AS tx_count,
    SUM(is_fraud) AS fraud_cases,
    SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END) AS fraud_value,
    ROUND(SUM(is_fraud) / COUNT(*), 4) AS fraud_rate
FROM bank
GROUP BY category
ORDER BY fraud_rate DESC;

-- 3. Transaction hour
SELECT 
    EXTRACT(HOUR FROM CAST(trans_date_trans_time AS TIMESTAMP)) AS hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    AVG(CASE WHEN is_fraud = 1 THEN amt END) AS avg_fraud_amount
FROM bank
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 4. Amount bucket
SELECT 
    CASE
        WHEN amt < 50 THEN 'Under $50'
        WHEN amt < 200 THEN '$50-$200'
        WHEN amt < 500 THEN '$200-$500'
        ELSE 'Above $500'
    END AS amount_bucket,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(SUM(is_fraud) / COUNT(*), 4) AS fraud_rate
FROM bank
GROUP BY amount_bucket
ORDER BY fraud_rate DESC;

-- 5. Overview
SELECT
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud_cases,
    SUM(amt) AS total_transaction_value,
    SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END) AS fraud_value,
    ROUND(SUM(is_fraud) / COUNT(*), 4) AS fraud_rate
FROM bank;