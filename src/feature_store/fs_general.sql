WITH tb_rfv AS (

    SELECT 

        idCustomer,

        CAST(min(julianday('2024-06-04') - julianday(dtTransaction))
            AS INTEGER) + 1 AS recenciaDias,

        COUNT(DISTINCT DATE(dtTransaction)) AS frequenciaDias,

        SUM(CASE
                WHEN pointsTransaction > 0 THEN pointsTransaction
            END) AS valorPoints

    FROM transactions

    WHERE dtTransaction < '2024-06-04'
    AND dtTransaction >= DATE('2024-06-04', '-21 day')

    GROUP BY idCustomer

)

SELECT *

FROM tb_rfv