-- Qual dia da semana quem mais pedidos em 2025?

SELECT 
       strftime('%w', substr(DtCriacao, 1,10)) AS diaSemana,
       count(DISTINCT IdTransacao) AS qtdeTransacao,
       count(IdTransacao) AS qtdeTransacao2,
       count(*) AS qtdeTransacao3

FROM transacoes

WHERE substr(DtCriacao,1,4) = '2025'

GROUP BY 1
ORDER BY 2 DESC