SELECT IdProduto,
       count(*)

FROM transacao_produto

GROUP BY IdProduto;

SELECT IdCliente,
       sum(QtdePontos) AS totalPontos,
       count(IdTransacao)

FROM transacoes

WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'

GROUP BY IdCliente
HAVING sum(QtdePontos) >= 4000

ORDER BY sum(QtdePontos) DESC
;