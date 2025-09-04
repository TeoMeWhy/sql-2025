SELECT IdCliente,
        
        QtdePontos,
        QtdePontos + 10 AS QtdePontosPlus10,
        QtdePontos * 2 AS QtdePontosDouble,
        
        DtCriacao,
        
        substr(DtCriacao, 1, 19) AS dtSubString,
        
        datetime(substr(DtCriacao, 1, 19)) AS dtCriacaoNova,

        strftime('%w', datetime(substr(DtCriacao, 1, 19))) AS diaSemana

FROM clientes
