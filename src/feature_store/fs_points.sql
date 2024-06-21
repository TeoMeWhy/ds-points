WITH tb_pontos_d AS (
    
    SELECT 
            
            idCustomer,

            SUM(CASE
                    WHEN pointsTransaction > 0 THEN pointsTransaction
                    ELSE 0
                END) AS pointsAcumulados,
            
            SUM(CASE
                    WHEN pointsTransaction > 0 
                    AND dtTransaction >= DATE('2024-06-04', '-7 day')
                    THEN pointsTransaction
                    ELSE 0
                END) AS pointsAcumuladosD7,
            
            SUM(CASE
                    WHEN pointsTransaction > 0 
                    AND dtTransaction >= DATE('2024-06-04', '-14 day')
                    THEN pointsTransaction
                    ELSE 0
                END) AS pointsAcumuladosD14,

            SUM(CASE
                    WHEN pointsTransaction < 0 THEN pointsTransaction
                    ELSE 0
                END) AS pointsResgatados,
            
            SUM(CASE
                    WHEN pointsTransaction < 0 THEN pointsTransaction
                    AND dtTransaction >= DATE('2024-06-04', '-7 day')
                    ELSE 0
                END) AS pointsResgatadosD7,
            
            SUM(CASE
                    WHEN pointsTransaction < 0 THEN pointsTransaction
                    AND dtTransaction >= DATE('2024-06-04', '-14 day')
                    ELSE 0
                END) AS pointsResgatadosD14
     

        FROM transactions

        WHERE dtTransaction < '2024-06-04'
        AND dtTransaction >= DATE('2024-06-04', '-21 day')

        GROUP BY idCustomer

),


tb_vida AS (
    SELECT 
            t1.idCustomer,

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

            CAST(MAX(julianday('2024-06-04') - julianday(dtTransaction)) AS INTEGER) + 1 AS diasVida


    FROM tb_pontos_d AS t1

    LEFT JOIN transactions AS t2
    ON t1.idCustomer = t2.idCustomer

    WHERE t2.dtTransaction < '2024-06-04'

    GROUP BY t1.idCustomer

),

tb_join AS (

SELECT 
        t1.*,
        t2.saldoPoints,
        t2.pointsAcumuladosVida,
        t2.pointsResgatadosVida,
        1.0 * t2.pointsAcumuladosVida / t2.diasVida AS pointsPorDia

FROM tb_pontos_d as t1

LEFT JOIN tb_vida as t2
ON t1.idCustomer = t2.idCustomer

)

SELECT * FROM tb_join




