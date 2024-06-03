SELECT *

FROM customers AS t1

LEFT JOIN transactions AS t2
ON t1.idCustomer = t2.idCustomer

LEFT JOIN transactions_product AS t3
ON t2.idTransaction = t3.idTransaction
