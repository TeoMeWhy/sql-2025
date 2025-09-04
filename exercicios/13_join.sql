-- 13. Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?

WITH alunos_dia01 AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE  substr(DtCriacao,1,10) = '2025-08-25'
),

tb_dia_cliente AS (

    SELECT t1.IdCliente,
        substr(t2.DtCriacao, 1,10) AS dtDia,
        count(*) AS qtdeInteracoes

    FROM alunos_dia01 AS t1

    LEFT JOIN transacoes AS t2
    ON t1.IdCliente = t2.IdCliente
    AND t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao < '2025-08-30'

    GROUP BY t1.IdCliente, substr(t2.DtCriacao, 1,10)

    ORDER BY t1.IdCliente, dtDia

),

tb_rn AS (

    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeInteracoes DESC, dtDia) AS rn
    FROM tb_dia_cliente

)

SELECT *
FROM tb_rn
WHERE rn = 1