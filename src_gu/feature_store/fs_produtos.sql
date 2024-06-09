WITH tb_transactions_product AS (
    SELECT t1.*, 
    NameProduct, 
    QuantityProduct
    FROM transactions t1
    LEFT JOIN transactions_product t2
    ON t1.idTransaction = t2.idTransaction
    WHERE t1.dtTransaction < '{date}'
    AND t1.dtTransaction >= date('{date}', '-21 day')
),
tb_share AS (
    SELECT idCustomer,
    SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END) as QtdeChatMessage,
    SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN QuantityProduct ELSE 0 END) as QtdeResgatarPonei,
    SUM(CASE WHEN NameProduct = "Lista de presença" THEN QuantityProduct ELSE 0 END) as QtdeListaPresenca,
    SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN QuantityProduct ELSE 0 END) as QtdeTrocaStreamElements,
    SUM(CASE WHEN NameProduct = "Presença Streak" THEN QuantityProduct ELSE 0 END) as QtdePresencaStreak, 
    SUM(CASE WHEN NameProduct = "Airflow Lover" THEN QuantityProduct ELSE 0 END) as QtdeAirflowLover,
    SUM(CASE WHEN NameProduct = "R Lover" THEN QuantityProduct ELSE 0 END) as QtdeRLover,
    SUM(CASE WHEN NameProduct = "ChatMessage" THEN pointsTransaction ELSE 0 END) as pointsChatMessage,
    SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN pointsTransaction ELSE 0 END) as pointsResgatarPonei,
    SUM(CASE WHEN NameProduct = "Lista de presença" THEN pointsTransaction ELSE 0 END) as pointsListaPresenca,
    SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN pointsTransaction ELSE 0 END) as pointsTrocaStreamElements,
    SUM(CASE WHEN NameProduct = "Presença Streak" THEN pointsTransaction ELSE 0 END) as pointsPresencaStreak, 
    SUM(CASE WHEN NameProduct = "Airflow Lover" THEN pointsTransaction ELSE 0 END) as pointsAirflowLover,
    SUM(CASE WHEN NameProduct = "R Lover" THEN pointsTransaction ELSE 0 END) as pointsRLover,
    1.0 * SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeChatMessage,
    1.0 * SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeResgatarPonei,
    1.0 * SUM(CASE WHEN NameProduct = "Lista de presença" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeListaPresenca,
    1.0 * SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeTrocaStreamElements,
    1.0 * SUM(CASE WHEN NameProduct = "Presença Streak" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdePresencaStreak, 
    1.0 * SUM(CASE WHEN NameProduct = "Airflow Lover" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeAirflowLover,
    1.0 * SUM(CASE WHEN NameProduct = "R Lover" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) as pctdeRLover, 
    1.0 * SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END)/COUNT(DISTINCT DATE(dtTransaction)) as avgChatLive
    FROM tb_transactions_product
    GROUP BY idCustomer
),
tb_group AS (
    SELECT idCustomer, 
    NameProduct, 
    SUM(QuantityProduct) as qtd, 
    SUM(pointsTransaction) as pts
    FROM tb_transactions_product
    GROUP BY idCustomer, NameProduct
), 
tb_rn as (
    SELECT *, 
    ROW_NUMBER() OVER (PARTITION BY idCustomer ORDER BY qtd DESC, pts DESC) as rnQtd 
    FROM tb_group
    ORDER BY idCustomer
),
tb_prod_max as (
    SELECT * 
    FROM tb_rn
    WHERE rnQtd = 1
)
SELECT '{date}' as dtRef,
t1.*, 
t2.NameProduct as prodMax_qtd
FROM tb_share t1
LEFT JOIN tb_prod_max t2
ON t1.idCustomer = t2.idCustomer