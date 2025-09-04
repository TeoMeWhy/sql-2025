-- Selecione produtos que contêm ‘churn’ no nome

SELECT *

FROM produtos

-- Churn_10pp
-- Churn_2pp
-- Churn_5pp

-- WHERE DescProduto = 'Churn_10pp'
-- OR DescProduto = 'Churn_2pp'
-- OR DescProduto = 'Churn_5pp'

-- WHERE DescProduto LIKE 'churn%'
-- WHERE DescCateogriaProduto = 'churn_model'

WHERE DescProduto IN ('Churn_10pp', 'Churn_2pp', 'Churn_5pp')
