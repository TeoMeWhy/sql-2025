-- Saldo de pontos acumulado de cada usuário

WITH tb_cliente_dia AS (

    SELECT idCliente,
        substr(DtCriacao,1,10) AS dtDia,
        sum(QtdePontos) AS totalPontos,
        sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS pontosPos

    FROM transacoes
    GROUP BY IdCliente, dtDia
)

SELECT *,
       sum( totalPontos) OVER (PARTITION BY idCliente ORDER BY dtDia) AS saldoPontos,
       sum(pontosPos)  OVER (PARTITION BY idCliente ORDER BY dtDia) AS totalPontosPos

FROM tb_cliente_dia