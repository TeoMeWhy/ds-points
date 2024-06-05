WITH tb_pontos_d AS (

    SELECT idCustomer,

        SUM(pointsTransaction) AS saldoPointsD21,

        SUM(CASE WHEN dtTransaction >= DATE('{date}', '-14 day')
                        THEN pointsTransaction
                    ELSE 0
                END) AS saldoPointsD14,

        SUM(CASE WHEN dtTransaction >= DATE('{date}', '-7 day')
                        THEN pointsTransaction
                    ELSE 0
                END) AS saldoPointsD7,


        SUM(CASE WHEN pointsTransaction > 0
                        THEN pointsTransaction
                    ELSE 0
                END) AS pointsAcumuladosD21,

        SUM(CASE WHEN pointsTransaction > 0
                    AND dtTransaction >= DATE('{date}', '-14 day')
                        THEN pointsTransaction
                    ELSE 0
            END) AS pointsAcumuladosD14,

            SUM(CASE WHEN pointsTransaction > 0
                    AND dtTransaction >= DATE('{date}', '-7 day')
                        THEN pointsTransaction
                    ELSE 0
            END) AS pointsAcumuladosD7,


        SUM(CASE WHEN pointsTransaction < 0
                        THEN pointsTransaction
                    ELSE 0
                END) AS pointsResgatadosD21,

        SUM(CASE WHEN pointsTransaction < 0
                    AND dtTransaction >= DATE('{date}', '-14 day')
                        THEN pointsTransaction
                    ELSE 0
            END) AS pointsResgatadosD14,

        SUM(CASE WHEN pointsTransaction < 0
                    AND dtTransaction >= DATE('{date}', '-7 day')
                        THEN pointsTransaction
                    ELSE 0
            END) AS pointsResgatadosD7


    FROM transactions

    WHERE dtTransaction < '{date}'
    AND dtTransaction >= DATE('{date}', '-21 day')

    GROUP BY idCustomer

),

tb_vida AS (

    SELECT t1.idCustomer,
            SUM(t2.pointsTransaction) AS saldoPoints,
            SUM(CASE
                    WHEN t2.pointsTransaction > 0
                        THEN t2.pointsTransaction
                    ELSE 0
                END) AS pointsAcumuladosVida,
            SUM(CASE
                    WHEN t2.pointsTransaction < 0
                        THEN t2.pointsTransaction
                    ELSE 0
                END) AS pointsResgatadosVida,

            CAST(max(julianday('{date}') - julianday(dtTransaction)) AS INTEGER) + 1 AS diasVida

    FROM tb_pontos_d AS t1

    LEFT JOIN transactions AS t2
    ON t1.idCustomer = t2.idCustomer

    WHERE t2.dtTransaction < '{date}'

    GROUP BY t1.idCustomer

),

tb_join AS (

    SELECT  
            t1.*,
            t2.saldoPoints,
            t2.pointsAcumuladosVida,
            t2.pointsResgatadosVida,
            1.0 * t2.pointsAcumuladosVida / t2.diasVida AS pointsPorDia

    FROM tb_pontos_d As t1

    LEFT JOIN tb_vida AS t2
    ON t1.idCustomer = t2.idCustomer

)


SELECT 
        '{date}' AS dtRef,
        *
FROM tb_join