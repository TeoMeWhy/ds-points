WITH tb_rfv AS (
    
    SELECT 

            idCustomer,
            cast(min(julianday('2024-06-04') - julianday(dtTransaction))
                AS INTEGER) +1 AS recenciaDias,

            COUNT(DISTINCT DATE(dtTransaction)) AS frequenciaDias,

            SUM(CASE 
                    WHEN pointsTransaction > 0 THEN pointsTransaction
                END) AS valorPoints

    FROM transactions

    WHERE dtTransaction < '2024-06-04'
    AND dtTransaction >= DATE('2024-06-04', '-21 day')

    GROUP BY idCustomer

),

tb_idade AS (


    SELECT 
        t1.idCustomer,
        cast(max(julianday('2024-06-04') - julianday(t2.dtTransaction))
                    AS INTEGER) +1 AS idadeBaseDias

    FROM tb_rfv AS t1

    LEFT JOIN transactions AS t2
    ON t1.idCustomer = t2.idCustomer
                    
    GROUP BY t2.idCustomer

)

SELECT t1.*,
        t2.idadeBaseDias,
        t3.flEmail

FROM tb_rfv AS t1

LEFT JOIN tb_idade AS t2
ON t1.idCustomer = t2.idCustomer

LEFT JOIN customers AS t3
ON t1.idCustomer = t3.idCustomer