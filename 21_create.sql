-- Quantidade de transações Acumuladas ao longo do tempo (diário)?

DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS

WITH tb_diario AS (
    
    SELECT substr(DtCriacao,1,10) AS dtDia,
           count(distinct IdTransacao) AS qtdTransacao

    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (
    SELECT *,
            sum(qtdTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

    FROM tb_diario
)

SELECT *
FROM tb_acum
;

select * from relatorio_diario;