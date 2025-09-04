-- Lista de clientes com 100 a 200 pontos (inclusive ambos);

SELECT IdCliente,
       QtdePontos 

FROM clientes

-- WHERE QtdePontos BETWEEN 100 AND 200
WHERE QtdePontos >= 100
AND QtdePontos <= 200
