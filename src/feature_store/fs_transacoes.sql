WITH tb_transactions AS (

    SELECT *
    FROM transactions
    WHERE dtTransaction < '{date}'
    AND dtTransaction >= DATE('{date}', '-21 day')

),

tb_freq AS (

    SELECT 
        idCustomer,
        count(distinct date(dtTransaction)) AS qtdeDiasD21,
        count(distinct CASE WHEN dtTransaction > date('{date}', '-14 day') THEN date(dtTransaction) END) AS qtdeDiasD14,
        count(distinct CASE WHEN dtTransaction > date('{date}', '-7 day') THEN date(dtTransaction) END) AS qtdeDiasD7

    FROM tb_transactions

    GROUP BY idCustomer
),

tb_live_minutes AS (

    SELECT idCustomer,
        date(datetime(dtTransaction, '-3 hour')) AS dtTransactionDate,
        min(datetime(dtTransaction, '-3 hour')) AS dtInicio,
        max(datetime(dtTransaction, '-3 hour')) AS dtFim,
        (julianday(max(datetime(dtTransaction, '-3 hour'))) -
        julianday(min(datetime(dtTransaction, '-3 hour')))) * 24 * 60 AS liveMinutes

    FROM tb_transactions

    GROUP BY 1,2

),

tb_hours AS (

    SELECT idCustomer,
           AVG(liveMinutes) AS avgLiveMinutes,
           SUM(liveMinutes) AS sumLiveMinutes,
           MIN(liveMinutes) AS minLiveMinutes,
           MAX(liveMinutes) AS maxLiveMinutes
    FROM tb_live_minutes
    GROUP BY idCustomer
),

tb_vida AS (

    SELECT idCustomer,
           COUNT(DISTINCT idTransaction) AS qtdeTransacaoVida,
           COUNT(DISTINCT idTransaction) / (max(julianday('{date}') - julianday(dtTransaction))) AS avgTransacaoDia

    FROM transactions
    WHERE dtTransaction < '{date}'
    GROUP BY idCustomer

),

tb_join AS (

    SELECT t1.*,
            t2.avgLiveMinutes,
            t2.sumLiveMinutes,
            t2.minLiveMinutes,
            t2.maxLiveMinutes,
            t3.qtdeTransacaoVida,
            t3.avgTransacaoDia

    FROM tb_freq AS t1

    LEFT JOIN tb_hours AS t2
    ON t1.idCustomer = t2.idCustomer

    LEFT JOIN tb_vida AS t3
    ON t3.idCustomer = t1.idCustomer
)

SELECT 
    '{date}' AS dtRef,
    *

FROM tb_join