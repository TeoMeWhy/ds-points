SELECT cluster_recencia,
        cluster_fv,
        count(*)
FROM customer_profile

group by 1,2