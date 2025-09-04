-- Lista de transações com o produto “Resgatar Ponei”;

SELECT *

FROM transacao_produto AS t1

WHERE t1.IdProduto = (
    SELECT IdProduto
    FROM produtos
    WHERE DescProduto = 'Resgatar Ponei'
)