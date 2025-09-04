WITH tb_transacoes AS (

    SELECT IdTransacao,
           IdCliente,
           QtdePontos,
           datetime(substr(dtCriacao,1,19)) AS dtCriacao,
           julianday('{date}') - julianday(substr(dtCriacao,1,10)) AS diffDate,
           CAST(strftime('%H', substr(dtCriacao,1,19)) AS INTEGER) AS dtHora

    FROM transacoes
    WHERE dtCriacao < '{date}'
),

tb_cliente AS (

    SELECT IdCliente,
           datetime(substr(dtCriacao,1,19)) AS dtCriacao,
           julianday('{date}') - julianday(substr(dtCriacao,1,10)) AS idadeBase

    FROM clientes
),

tb_sumario_transacoes AS (

    SELECT IdCliente,

        count(IdTransacao) AS qtdeTransacoesVida,
        count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoes56,
        count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoes28,
        count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoes14,
        count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoes7,

        sum(qtdePontos) AS saldoPontos,

        min(diffDate) AS diasUltimaInteracao,

        sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS qtdePontosPosVida,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosPos56,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosPos28,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosPos14,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosPos7,

        sum(CASE WHEN qtdePontos < 0 THEN qtdePontos ELSE 0 END) AS qtdePontosNegVida,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg56,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg28,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg14,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg7

    FROM tb_transacoes
    GROUP BY IdCliente
),

tb_transacao_produto AS (

    SELECT t1.*,
        t3.DescProduto,
        t3.DescCateogriaProduto

    FROM tb_transacoes AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.idTransacao

    LEFT JOIN produtos AS t3
    ON t2.idProduto = t3.idProduto

),

tb_cliente_produto AS (

    SELECT IdCliente,
        DescProduto,
        count(*) AS qtdeVida,
        count(CASE WHEN diffDate <= 56 THEN idTransacao END) AS qtde56,
        count(CASE WHEN diffDate <= 28 THEN idTransacao END) AS qtde28,
        count(CASE WHEN diffDate <= 14 THEN idTransacao END) AS qtde14,
        count(CASE WHEN diffDate <= 7 THEN idTransacao END) AS qtde7

    FROM tb_transacao_produto
    GROUP BY idCliente, DescProduto

),

tb_cliente_produto_rn AS (

    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeVida DESC) AS rnVida,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde56 DESC) AS rn56,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde28 DESC) AS rn28,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde14 DESC) AS rn14,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde7 DESC) AS rn7

    FROM tb_cliente_produto

),

tb_cliente_dia AS (

    SELECT idCliente,
        strftime('%w', dtCriacao) AS dtDia,
        count(*) AS qtdTransacao

    FROM tb_transacoes
    WHERE diffDate <= 28
    GROUP BY idCliente, dtDia

),

tb_cliente_dia_rn AS (

    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtdTransacao DESC) as rnDia

    FROM tb_cliente_dia

),

tb_cliente_periodo AS (

    SELECT 
        idCliente,
        CASE
            WHEN dtHora BETWEEN 7 AND 12 THEN 'MANHÃ'
            WHEN dtHora BETWEEN 13 AND 18 THEN 'TARDE'
            WHEN dtHora BETWEEN 19 AND 23 THEN 'NOITE'
            ELSE 'MADRUGADA'
        END AS periodo,
            COUNT(*) AS qtdeTransacao

    FROM tb_transacoes
    WHERE diffDate <= 28

    GROUP BY 1,2

),

tb_cliente_periodo_rn AS (

    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtdeTransacao DESC) AS rnPeriodo

    FROM tb_cliente_periodo

),

tb_join AS (

    SELECT t1.*,
           t2.idadeBase,
           t3.DescProduto AS produtoVida,
           t4.DescProduto AS produto56,
           t5.DescProduto AS produto28,
           t6.DescProduto AS produto14,
           t7.DescProduto AS produto7,
           COALESCE(t8.dtDia, -1) AS dtDia,
           COALESCE(t9.periodo, 'SEM INFORMACAO') AS periodoMaisTransacao28

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.idCliente = t2.idCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente
    AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente
    AND t5.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente
    AND t6.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente
    AND t7.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND t8.rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.idCliente = t9.idCliente
    AND t9.rnPeriodo = 1

)

SELECT 
        '{date}' AS dtRef,
        *,
        1. * qtdeTransacoes28 / qtdeTransacoesVida AS engajamento28Vida

FROM tb_join

