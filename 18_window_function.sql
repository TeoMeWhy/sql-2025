
WITH tb_sumario_dias AS (

    SELECT substr(DtCriacao, 1,10) AS dtDia,
        count(distinct IdTransacao) AS qtdeTransacao

    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    GROUP BY dtDia

)

SELECT *,
       sum(qtdeTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

FROM tb_sumario_dias