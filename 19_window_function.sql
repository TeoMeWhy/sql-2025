WITH tb_cliente_dia AS (

    SELECT IdCliente,
        substr(DtCriacao, 1,10) AS dtDia,
        count(distinct IdTransacao) AS qtdeTransacao

    FROM transacoes

    WHERE dtCriacao >= '2025-08-25'
    AND dtCriacao < '2025-08-30'

    GROUP BY IdCliente, dtDia

),

tb_lag AS (

    SELECT *,
        sum(qtdeTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS acum,
        lag(qtdeTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagTransacao

    FROM tb_cliente_dia

)

SELECT *,
        1.* qtdeTransacao / lagTransacao


FROM tb_lag