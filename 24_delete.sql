DELETE FROM relatorio_diario
WHERE strftime('%w', substr(dtDia,1,10)) = '0';

SELECT * FROM relatorio_diario;