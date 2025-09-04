-- Lista de transações com apenas 1 ponto;

SELECT IdTransacao,
       QtdePontos

FROM transacoes

WHERE QtdePontos = 1