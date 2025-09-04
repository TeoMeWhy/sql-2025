SELECT 
       sum(QtdePontos),
       
       sum(CASE
           WHEN QtdePontos > 0 THEN QtdePontos
           END) AS qtdePontosPositivos,

       sum(CASE
           WHEN QtdePontos < 0 THEN QtdePontos
           ELSE 0
           END) AS qtdePontosNegativos,

        count(CASE
              WHEN QtdePontos < 0 THEN QtdePontos
              END) AS qtdeTransacaoNegativas

FROM transacoes

WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'