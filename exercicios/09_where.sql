-- Listar todas as transações adicionando uma coluna nova sinalizando 
-- “alto”, “médio” e “baixo” para o valor dos pontos [<10 ; <500; >=500]


SELECT
       IdTransacao,
       QtdePontos,

       CASE
            WHEN QtdePontos < 10 THEN 'Baixo'
            WHEN QtdePontos < 500 THEN 'Médio'
            ELSE 'Alto'
       END AS FlQtdePontos 

FROM transacoes

ORDER BY QtdePontos desc