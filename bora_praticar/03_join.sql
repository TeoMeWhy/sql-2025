-- Qual mês tivemos mais lista de presença assinada?

SELECT 
       substr(t1.DtCriacao, 1, 7) AS anoMes,
       count(distinct t1.IdTransacao) AS qtdeTransacao

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE t3.DescProduto = 'Lista de presença'

GROUP BY substr(t1.DtCriacao, 1, 7)
ORDER BY qtdeTransacao DESC