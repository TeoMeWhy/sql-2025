-- Qual o produto com mais pontos transacionados?

SELECT IdProduto,
       sum(VlProduto * QtdeProduto) AS totalPontos,
       sum(QtdeProduto) AS qtdevenda

FROM transacao_produto

GROUP BY IdProduto
ORDER BY sum(VlProduto) DESC