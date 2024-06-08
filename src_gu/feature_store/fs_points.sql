WITH tb_pontos_d AS (
    SELECT 
    idCustomer,
        SUM(CASE 
            WHEN dtTransaction >= DATE('{date}', '-21 day') 
            then pointsTransaction 
            ELSE 0 END) as saldoPointsD21,
        SUM(CASE 
            WHEN dtTransaction >= DATE('{date}', '-14 day') 
            then pointsTransaction 
            ELSE 0 END) as saldoPointsD14,
        SUM(CASE 
            WHEN dtTransaction >= DATE('{date}', '-7 day') 
            then pointsTransaction 
            ELSE 0 END) as saldoPointsD7,
        SUM(CASE WHEN pointsTransaction > 0 then pointsTransaction ELSE 0 END) as saldoPointsAcumuladoD21, 
        SUM(CASE 
            WHEN pointsTransaction > 0 AND 
            dtTransaction >= DATE('{date}', '-14 day') then pointsTransaction 
            ELSE 0 END) as saldoPointsAcumuladoD14, 
        SUM(CASE 
            WHEN pointsTransaction > 0 AND 
            dtTransaction >= DATE('{date}', '-7 day') then pointsTransaction 
            ELSE 0 END) as saldoPointsAcumuladoD7, 
        SUM(CASE WHEN pointsTransaction < 0 then pointsTransaction ELSE 0 END) as pointsResgatadosD21,
        SUM(CASE 
            WHEN pointsTransaction < 0 AND 
            dtTransaction >= DATE('{date}', '-14 day') then pointsTransaction 
            ELSE 0 END) as pointsResgatadosD14,
        SUM(CASE 
            WHEN pointsTransaction < 0 AND 
            dtTransaction >= DATE('{date}', '-7 day') then pointsTransaction 
            ELSE 0 END) as pointsResgatadosD7
    FROM transactions
    WHERE dtTransaction < '{date}'
    AND dtTransaction >= date('{date}', '-21 day')
    GROUP BY idCustomer
), 
tb_vida AS (
    SELECT t1.idCustomer, 
    SUM(t2.pointsTransaction) AS saldoPoints,
    SUM(CASE WHEN t2.pointsTransaction > 0 then t2.pointsTransaction ELSE 0 END) as pointsAcumuladosVida,
    SUM(CASE WHEN t2.pointsTransaction < 0 then t2.pointsTransaction ELSE 0 END) as pointsResgatadosVida,
    CAST(max(julianday('{date}') - julianday(DATE(t2.dtTransaction))) as INT) + 1 AS diasVida
    FROM tb_pontos_d as t1
    LEFT JOIN transactions as t2
    ON t1.idCustomer = t2.idCustomer
    WHERE T2.dtTransaction < '{date}'
    GROUP BY t2.idCustomer
),
tb_join AS (
    SELECT t1.*, 
    t2.saldoPoints, 
    t2.pointsAcumuladosVida, 
    t2.pointsResgatadosVida, 
    1.0 * t2.pointsAcumuladosVida / t2.diasVida as pointsDia
    FROM tb_pontos_d as t1
    LEFT JOIN tb_vida as t2 
    ON t1.idCustomer = t2.idCustomer
)
SELECT * FROM tb_join