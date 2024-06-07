SELECT 
        t1.dtRef,
        t1.idCustomer,
        t1.recenciaDias,
        t1.frequenciaDias,
        t1.valorPoints,
        t1.idadeBaseDias,
        t1.flEmail,
        t3.qtdPointsManha,
        t3.qtdPointsTarde,
        t3.qtdPointsNoite,
        t3.pctPointsManha,
        t3.pctPointsTarde,
        t3.pctPointsNoite,
        t3.qtdTransacoesManha,
        t3.qtdTransacoesTarde,
        t3.qtdTransacoesNoite,
        t3.pctTransacoesManha,
        t3.pctTransacoesTarde,
        t3.pctTransacoesNoite,
        t4.saldoPointsD21,
        t4.saldoPointsD14,
        t4.saldoPointsD7,
        t4.pointsAcumuladosD21,
        t4.pointsAcumuladosD14,
        t4.pointsAcumuladosD7,
        t4.pointsResgatadosD21,
        t4.pointsResgatadosD14,
        t4.pointsResgatadosD7,
        t4.saldoPoints,
        t4.pointsAcumuladosVida,
        t4.pointsResgatadosVida,
        t4.pointsPorDia,
        t5.qtdeChatMessage,
        t5.qtdeListaPresença,
        t5.qtdeResgatarPonei,
        t5.qtdeTrocaPontos,
        t5.qtdePresençaStreak,
        t5.qtdeAirflowLover,
        t5.qtdeRLover,
        t5.pointsChatMessage,
        t5.pointsListaPresença,
        t5.pointsResgatarPonei,
        t5.pointsTrocaPontos,
        t5.pointsPresençaStreak,
        t5.pointsAirflowLover,
        t5.pointsRLover,
        t5.pctChatMessage,
        t5.pctListaPresença,
        t5.pctResgatarPonei,
        t5.pctTrocaPontos,
        t5.pctPresençaStreak,
        t5.pctAirflowLover,
        t5.pctRLover,
        t5.avgChatLive,
        t5.productMaxQtde,
        t6.qtdeDiasD21,
        t6.qtdeDiasD14,
        t6.qtdeDiasD7,
        t6.avgLiveMinutes,
        t6.sumLiveMinutes,
        t6.minLiveMinutes,
        t6.maxLiveMinutes,
        t6.qtdeTransacaoVida,
        t6.avgTransacaoDia

FROM fs_general AS t1

LEFT JOIN fs_horario AS t3
ON t1.idCustomer = t3.idCustomer
AND t1.dtRef = t3.dtRef

LEFT JOIN fs_points AS t4
ON t1.idCustomer = t4.idCustomer
AND t1.dtRef = t4.dtRef

LEFT JOIN fs_produtos AS t5
ON t1.idCustomer = t5.idCustomer
AND t1.dtRef = t5.dtRef

LEFT JOIN fs_transacoes AS t6
ON t1.idCustomer = t6.idCustomer
AND t1.dtRef = t6.dtRef

WHERE t1.DtRef = date('now')