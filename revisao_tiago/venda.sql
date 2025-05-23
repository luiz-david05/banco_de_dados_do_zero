CREATE TABLE venda (
    cod SERIAL PRIMARY KEY,
    nome_vendedor VARCHAR(50) NOT NULL,
    dt_venda DATE NOT NULL,
    valor DECIMAL(10, 2) NOT NULL
)

INSERT INTO venda (nome_vendedor, dt_venda, valor) 
VALUES
    ('Ana', '2024-03-05', 150.00),
    ('Bruno', '2024-03-10', 200.00),
    ('Carla', '2024-03-12', 300.00),
    ('Ana', '2024-03-15', 250.00),
    ('Davi', '2024-03-20', 100.00),
    ('Bruno', '2024-03-25', 350.00),
    ('Carla', '2024-02-10', 180.00), 
    ('Ana', '2024-04-01', 220.00), 
    ('Davi', '2024-03-28', 570.00), 
    ('Bruno', '2024-03-02', 120.00);

CREATE OR REPLACE VIEW vendas_vendedor_marco_2024 AS
SELECT nome_vendedor, SUM(valor) AS tt_vendido_marco 
FROM venda
WHERE dt_venda >= '2024-03-01' AND dt_venda <= '2024-03-31'
GROUP BY nome_vendedor;

-- 2.1 Mostre o nome dos vendedores que venderam mais de X reais
-- no mês de março de 2024
SELECT nome_vendedor FROM vendas_vendedor_marco_2024
WHERE tt_vendido_marco > 350.00;

-- 2.2 Mostre o nome de um dos vendedores que mais vendeu no mês
-- de março de 2024
SELECT nome_vendedor FROM vendas_vendedor_marco_2024
ORDER BY tt_vendido_marco DESC
LIMIT 1;

-- 3. Sem usar "select na cláusula from", qual o nome do(s) 
-- vendedor(es) que mais vendeu no mês de março de 2024 ?
SELECT nome_vendedor FROM vendas_vendedor_marco_2024
WHERE tt_vendido_marco = (
	SELECT MAX(tt_vendido_marco) FROM vendas_vendedor_marco_2024
)