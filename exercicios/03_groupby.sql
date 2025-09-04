-- Qual cliente fez mais transações no ano de 2024?

SELECT IdCliente,
       count(*),
       count(DISTINCT IdTransacao) 

FROM transacoes

WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'

-- WHERE strftime('%Y', substr(DtCriacao, 1, 19)) = '2024'
-- WHERE substr(DtCriacao, 1, 4) = '2024'

GROUP BY IdCliente

ORDER BY count(*) DESC

LIMIT 1