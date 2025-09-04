-- Lista de clientes com 0 (zero) pontos;

SELECT IdCliente,
       QtdePontos 

FROM clientes

WHERE QtdePontos = 0