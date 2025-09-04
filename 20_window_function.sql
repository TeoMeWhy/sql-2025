WITH cliente_dia AS (

    SELECT 
        DISTINCT
        IdCliente,
        substr(DtCriacao,1,10) AS dtDia

    FROM transacoes
    WHERE substr(DtCriacao,1,4) = '2025'
    ORDER BY IdCliente, dtDia

),

tb_lag AS (

    SELECT *,
        lag(dtDia) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagDia
    FROM cliente_dia

),

tb_diff_dt AS (

    SELECT *,
        julianday(dtDia) - julianday(lagDia) AS DtDiff
    FROM tb_lag

),

avg_cliente AS (

    SELECT IdCliente,
           avg(DtDiff) AS avgDia
    FROM tb_diff_dt
    GROUP BY IdCliente

)

SELECT avg(avgDia)
FROM avg_cliente