-- Quantos clientes tem email cadastrado?

SELECT sum(FlEmail)
FROM clientes;

SELECT count(*)
FROM clientes
WHERE FlEmail = 1;