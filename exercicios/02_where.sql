-- Lista de pedidos realizados no fim de semana;

SELECT IdTransacao,
       DtCriacao,
       strftime('%w', datetime(substr(DtCriacao,1,19))) AS diaSemana

FROM transacoes

WHERE strftime('%w', datetime(substr(DtCriacao,1,19))) IN ('6','0')