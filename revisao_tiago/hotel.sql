CREATE TABLE hospede (
	cod INT PRIMARY KEY NOT NULL,
	nome VARCHAR(50) NOT NULL,
	dt_nasc DATE NOT NULL
);

CREATE TABLE categoria (
	cod INT PRIMARY KEY NOT NULL,
	valor DECIMAL(10, 2) NOT NULL,
	nome VARCHAR(45) NOT NULL
);

CREATE TABLE apartamento (
	num INT PRIMARY KEY NOT NULL,
	cod_cat INT NOT NULL REFERENCES categoria(cod) 
);

CREATE TABLE funcionario (
	cod INT PRIMARY KEY NOT NULL,
	dt_nasc DATE NOT NULL,
	nome VARCHAR(50) NOT NULL
);

CREATE TABLE hospedagem (
	cod INT PRIMARY KEY NOT NULL,
	dt_ent DATE NOT NULL,
	dt_sai DATE NOT NULL,
	cod_hosp INT NOT NULL REFERENCES hospede(cod),
	num_ap INT NOT NULL REFERENCES apartamento(num),
	cod_func INT NOT NULL REFERENCES funcionario(cod)
);

-- Records for hospede
INSERT INTO hospede (cod, nome, dt_nasc)
VALUES 
    (1, 'Luiz', '2001-05-05'),
    (2, 'Camila', '2004-06-15'),
    (3, 'Marcos', '1998-11-22'),
    (4, 'Ana', '1995-03-18'),
    (5, 'Pedro', '2002-09-30');

-- Records for categoria
INSERT INTO categoria (cod, valor, nome)
VALUES
    (1, 150.00, 'Standard'),
    (2, 250.00, 'Deluxe'),
    (3, 400.00, 'Premium'),
    (4, 600.00, 'Suíte Executiva'),
    (5, 1000.00, 'Presidencial');

-- Records for apartamento
INSERT INTO apartamento (num, cod_cat)
VALUES
    (101, 1),
    (102, 1),
    (201, 2),
    (202, 2),
    (301, 3),
    (302, 3),
    (401, 4),
    (501, 5);

-- Records for funcionario
INSERT INTO funcionario (cod, dt_nasc, nome)
VALUES
    (1, '1985-03-15', 'Carlos'),
    (2, '1990-07-22', 'Juliana'),
    (3, '1988-11-05', 'Roberto'),
    (4, '1992-04-30', 'Fernanda'),
    (5, '1987-09-18', 'Gustavo');

-- Records for hospedagem (all in 2025)
INSERT INTO hospedagem (cod, dt_ent, dt_sai, cod_hosp, num_ap, cod_func)
VALUES
    (1, '2025-01-10', '2025-01-15', 1, 101, 1),
    (2, '2025-02-12', '2025-02-18', 2, 201, 2),
    (3, '2025-03-15', '2025-03-20', 3, 301, 3),
    (4, '2025-04-20', '2025-04-25', 4, 401, 4),
    (5, '2025-05-22', '2025-05-28', 5, 501, 5);

-- 1. Nomes das categorias que possuam preços entre R$ 100,00 e R$ 200,00.
SELECT nome FROM categoria
WHERE valor BETWEEN 100.00 AND 200.00;

-- 2. Nomes das categorias cujos nomes possuam a palavra ‘Luxo’. :/ 'Deluxe'
SELECT nome FROM categoria 
WHERE nome LIKE 'Deluxe%';

-- 3. Número dos apartamentos que estão ocupados, ou seja, a data de saída 
-- está vazia.
-- alter table for receive null on "dt_sai"
ALTER TABLE hospedagem
ALTER COLUMN dt_sai DROP NOT NULL;

UPDATE hospedagem 
SET dt_sai = NULL
WHERE dt_sai > CURRENT_DATE;

SELECT * FROM hospedagem;

SELECT num_ap AS ap_ocupado FROM hospedagem 
WHERE dt_sai IS NULL;

-- 4. Número dos apartamentos cuja categoria tenha 
-- código 1, 2, 3, 11, 34, 54, 24, 12. 
SELECT num AS num_ap FROM apartamento
WHERE cod_cat IN (1, 2, 3 ,11, 34, 54, 24, 12);

-- 5. Todas as informações dos apartamentos cujas categorias
-- iniciam com a palavra ‘Luxo’.
SELECT num, cod_cat FROM apartamento a
JOIN categoria c ON a.cod_cat = c.cod
WHERE c.nome LIKE 'Luxo%'

-- 6. Quantidade de apartamentos cadastrados no sistema.
SELECT COUNT(*) AS qtd_ap FROM apartamento;

-- 7. Somatório dos preços das categorias.
SELECT SUM(valor) AS somatorio_categorias FROM categoria;

-- 8. Média de preços das categorias.
SELECT CAST(AVG(valor) AS DECIMAL(10, 2)) AS avg_categoria FROM categoria;

-- 9. Maior preço de categoria.
SELECT MAX(valor) AS maior_valor_cat FROM categoria;

-- 10. Menor preço de categoria.
SELECT MIN(valor) AS menor_valor_cat FROM categoria;

-- 11. Nome dos hóspedes que nasceram após 1° de janeiro de 1970.
SELECT nome FROM hospede
WHERE dt_nasc > '1970-01-01'

-- 12. Quantidade de hóspedes.
SELECT COUNT(*) AS qtd_hospede FROM hospede;

-- 13. Altere a tabela Hóspede, acrescentando o campo "Nacionalidade".
ALTER TABLE hospede 
ADD COLUMN nacionalidade VARCHAR(30) NOT NULL DEFAULT 'Brasileiro';

-- 14. A data de nascimento do hóspede mais velho.
SELECT MIN(dt_nasc) AS dt_nasc_hosp_mais_velho FROM hospede;

-- 15. A data de nascimento do hóspede mais novo.
SELECT MAX(dt_nasc) AS dt_nasc_hosp_mais_novo FROM hospede;

-- 16. O nome do hóspede mais velho
SELECT nome FROM hospede
WHERE dt_nasc = (
	SELECT MIN(dt_nasc) FROM hospede
)

SELECT nome, MIN(dt_nasc) AS dt_nasc FROM hospede
GROUP BY nome
ORDER BY dt_nasc
LIMIT 1;

-- 17. Reajuste em 10% o valor das diárias das categorias.
SELECT * FROM categoria;

UPDATE categoria
SET valor = valor + valor * 0.10

-- 18 O número do apartamento mais caro ocupado pelo João
INSERT INTO hospede(cod, nome, dt_nasc) 
VALUES 
	(6, 'João', '1990-01-01');

INSERT INTO hospedagem (cod, dt_ent, dt_sai, cod_hosp, num_ap, cod_func)
VALUES
	(6, '2025-05-20', NULL, 6, 302, 2);

INSERT INTO hospedagem (cod, dt_ent, dt_sai, cod_hosp, num_ap, cod_func)
VALUES
	(7, '2025-05-21', NULL, 6, 401, 3);


SELECT ho.num_ap, h.nome, c.valor FROM hospedagem ho
JOIN hospede h ON ho.cod_hosp = h.cod
JOIN apartamento a ON ho.num_ap = a.num
JOIN categoria c ON a.cod_cat = c.cod
WHERE h.nome LIKE 'João%'
GROUP BY ho.num_ap, h.nome, c.valor
ORDER BY c.valor DESC, h.nome
LIMIT 1;

-- 19. O nome dos hóspedes que nunca se hospedaram no apartamento 201.
SELECT * FROM hospedagem;

SELECT h.nome FROM hospede h
JOIN hospedagem ho ON h.cod = ho.cod_hosp
JOIN apartamento a ON ho.num_ap = a.num
WHERE ho.num_ap NOT IN (201)
GROUP BY h.nome


-- 20 O nome dos hóspedes que nunca se hospedaram em apartamentos 
-- da categoria LUXO.
SELECT h.nome FROM hospede h
JOIN hospedagem ho ON h.cod = ho.cod_hosp
JOIN apartamento a ON ho.num_ap = a.num
JOIN categoria c ON a.cod_cat = c.cod
WHERE c.nome NOT IN (
	SELECT nome FROM categoria
	WHERE nome LIKE 'Deluxe'
)
GROUP BY h.nome

-- 21. O nome do hóspede mais velho que foi atendido pelo atendente 
-- mais novo.
INSERT INTO hospedagem (cod, dt_ent, dt_sai, cod_hosp, num_ap, cod_func)
VALUES
    (8, '2025-05-22', NULL , 1, 101, 4);

SELECT h.nome FROM hospede h
JOIN hospedagem ho ON h.cod = ho.cod_hosp
JOIN funcionario f ON ho.cod_func = f.cod
WHERE f.dt_nasc IN (
	SELECT MAX(dt_nasc) FROM funcionario
)
ORDER BY h.dt_nasc
LIMIT 1;

-- 22. O nome da categoria mais cara que foi ocupado pelo 
-- hóspede mais velho.
SELECT c.nome FROM categoria c
JOIN apartamento a ON c.cod = a.cod_cat
JOIN hospedagem ho ON ho.num_ap = a.num
JOIN hospede h ON ho.cod_hosp = h.cod
WHERE h.dt_nasc IN (
	SELECT MIN(dt_nasc) FROM hospede
)
ORDER BY c.valor DESC
LIMIT 1;


-- continuação - Lista 02

-- 1. Listagem dos hóspedes contendo nome e data de nascimento, 
-- ordenada em ordem crescente por nome e decrescente por data
-- de nascimento
SELECT nome, dt_nasc FROM hospede
ORDER BY nome, dt_nasc DESC;

-- 2. Listagem contendo os nomes das categorias, ordenados 
-- alfabeticamente. A coluna de
-- nomes deve ter a palavra ‘Categoria’ como título.
SELECT nome AS categoria FROM categoria
ORDER BY nome;

-- 3. Listagem contendo os valores de diárias e os números dos 
-- apartamentos, ordenada em
-- ordem decrescente de valor.
SELECT c.valor, a.num FROM categoria c
JOIN apartamento a ON c.cod = a.cod_cat
ORDER BY c.valor DESC;

-- 4. Categorias que possuem apenas um apartamento.
SELECT nome AS categoria FROM categoria c
JOIN apartamento a ON c.cod = a.cod_cat
GROUP BY nome
HAVING COUNT(*) = 1

-- 5. Listagem dos nomes dos hóspedes brasileiros com mês e ano
-- de nascimento, por ordem
-- decrescente de idade e por ordem crescente de nome do hóspede.
SELECT * FROM hospede;

SELECT nome, EXTRACT(MONTH FROM dt_nasc) AS mes_nasc, 
EXTRACT(YEAR FROM dt_nasc) AS ano_nasc FROM hospede 
WHERE nacionalidade LIKE 'Brasileiro%'
ORDER BY dt_nasc DESC, nome;

-- 6. Listagem com 3 colunas, nome do hóspede, número do apartamento
-- e quantidade (número
-- de vezes que aquele hóspede se hospedou naquele apartamento), em 
-- ordem decrescente de quantidade. 
SELECT h.nome, a.num, COUNT(*) AS qtd_vzs FROM hospede h
JOIN hospedagem ho ON h.cod = ho.cod_hosp
JOIN apartamento a ON ho.num_ap = a.num
GROUP BY h.nome, a.num
ORDER BY COUNT(*) DESC

-- 7. Categoria cujo nome tenha comprimento superior a 15 caracteres.
SELECT nome AS categoria FROM categoria
WHERE LENGTH(nome) > 15;

-- 8.  Número dos apartamentos ocupados no ano de 2017 com o respectivo
-- nome da sua categoria. 
SELECT a.num AS num_ap, c.nome AS categoria FROM apartamento a
JOIN categoria c ON a.cod_cat = c.cod
JOIN hospedagem ho ON a.num = ho.num_ap
WHERE EXTRACT(YEAR FROM ho.dt_ent) = 2017
GROUP BY c.nome, a.num

-- 9.

-- 10.
CREATE TABLE reserva (
	cod SERIAL PRIMARY KEY,
	dt_efetuada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	dt_prev_ent DATE NOT NULL,
	dt_prev_sai DATE NOT NULL,
	cod_hosp INT NOT NULL REFERENCES hospede(cod),
	cod_func INT NOT NULL REFERENCES funcionario(cod),
	cod_cat_desejada INT NOT NULL REFERENCES categoria(cod),
	num_ap_confirmado INT REFERENCES apartamento(num),
	status_reserva VARCHAR(20) NOT NULL DEFAULT 'Pendente',

	CONSTRAINT chk_datas_reserva CHECK (dt_prev_sai > dt_prev_ent),
	CONSTRAINT chk_status_reserva CHECK (status_reserva IN (
		'Pendente', 'Confirmada', 'Cancelada', 'No-show'))
);

INSERT INTO reserva (dt_prev_ent, dt_prev_sai, cod_hosp, cod_func, cod_cat_desejada, num_ap_confirmado, status_reserva)
VALUES
('2025-06-10', '2025-06-15', 1, 1, 1, NULL, 'Pendente'),
('2025-07-01', '2025-07-07', 2, 2, 2, 201, 'Confirmada'),
('2025-08-05', '2025-08-10', 3, 3, 3, NULL, 'Cancelada'),
('2025-09-12', '2025-09-18', 4, 4, 4, 401, 'Confirmada'),
('2025-11-20', '2025-11-25', 5, 5, 5, NULL, 'Pendente');

SELECT
    r.cod AS codigo_reserva,
    r.dt_efetuada AS data_reserva_feita,
    r.dt_prev_ent AS entrada_prevista,
    r.dt_prev_sai AS saida_prevista,
    h.nome AS nome_hospede,
    f.nome AS nome_funcionario,
    c.nome AS categoria_desejada,
    r.num_ap_confirmado AS apartamento_confirmado,
    r.status_reserva
FROM
    reserva r
JOIN
    hospede h ON r.cod_hosp = h.cod
JOIN
    funcionario f ON r.cod_func = f.cod
JOIN
    categoria c ON r.cod_cat_desejada = c.cod
ORDER BY
    r.cod;

ALTER TABLE funcionario
ADD COLUMN salario DECIMAL(10, 2) DEFAULT 1800.00
CONSTRAINT chk_salario_positivo CHECK (salario>= 0);

SELECT * FROM funcionario;

-- 11. Mostre o nome e o salário de cada funcionário. Extraordinariamente,
-- cada funcionário
-- receberá um acréscimo neste salário de 10 reais para cada hospedagem realizada.
SELECT
    f.nome AS nome_funcionario,
    COALESCE(f.salario, 0.00) AS salario_base,
    COUNT(ho.cod) AS quantidade_hospedagens,
    (COALESCE(f.salario, 0.00) + (COUNT(ho.cod) * 10.00)) AS novo_salario_com_acrescimo
FROM
    funcionario f
LEFT JOIN
    hospedagem ho ON f.cod = ho.cod_func
GROUP BY
    f.cod, f.nome, f.salario 
ORDER BY
    f.nome;

-- 12. Listagem das categorias cadastradas e para aquelas que possuem apartamentos,
-- relacionar também o número do apartamento, ordenada pelo nome da categoria e pelo
-- número do apartamento.
SELECT c.nome AS categoria, a.num AS num_ap FROM categoria c
LEFT JOIN apartamento a ON c.cod = a.cod_cat
ORDER BY c.nome, a.num;

-- 13. Listagem das categorias cadastradas e para aquelas que possuem
--apartamentos, relacionar também o número do apartamento, ordenada 
-- pelo nome da categoria e pelo número do
-- apartamento. Para aquelas que não possuem apartamentos associados,
-- escrever "não possui apartamento"
SELECT 
	c.nome AS categoria,
	CASE 
		WHEN a.num IS NULL THEN 'não possui apartamento'
		ELSE CAST(a.num AS VARCHAR)
	END AS info_ap
FROM categoria c
LEFT JOIN apartamento a ON c.cod = a.cod_cat
ORDER BY c.nome, a.num;

-- 14. O nome dos funcionário que atenderam o João (hospedando ou 
-- reservando) ou que hospedaram ou reservaram apartamentos da 
-- categoria luxo.

-- Parte 1: Funcionários que atenderam o hóspede 'João' em hospedagens
SELECT f.nome AS nome_funcionario FROM funcionario f
JOIN hospedagem ho ON f.cod = ho.cod_func
JOIN hospede h ON ho.cod_hosp = h.cod
WHERE h.nome = 'João'

UNION -- O UNION combina os resultados e remove duplicatas

-- Parte 2: Funcionários que atenderam o hóspede 'João' em reservas
SELECT f.nome FROM funcionario f
JOIN reserva re ON f.cod = re.cod_func
JOIN hospede h ON re.cod_hosp = h.cod
WHERE h.nome = 'João'

UNION

-- Parte 3: Funcionários que registraram hospedagens em apartamentos da categoria 'Luxo'
SELECT f.nome
FROM funcionario f
JOIN hospedagem ho ON f.cod = ho.cod_func
JOIN apartamento a ON ho.num_ap = a.num
JOIN categoria c ON a.cod_cat = c.cod
WHERE c.nome = 'Deluxe'

UNION

-- Parte 4: Funcionários que registraram reservas para a categoria 'Luxo' (via categoria desejada)
SELECT f.nome
FROM funcionario f
JOIN reserva re ON f.cod = re.cod_func
JOIN categoria c ON re.cod_cat_desejada = c.cod
WHERE c.nome = 'Deluxe'

UNION

-- Parte 5: Funcionários que registraram reservas para apartamentos confirmados da categoria 'Luxo'
SELECT f.nome
FROM funcionario f
JOIN reserva re ON f.cod = re.cod_func
JOIN apartamento a ON re.num_ap_confirmado = a.num -- Esta junção implica que num_ap_confirmado não é nulo
JOIN categoria c ON a.cod_cat = c.cod
WHERE c.nome = 'Deluxe';

-- 15. O código das hospedagens realizadas pelo hóspede mais velho que se 
-- hospedou no apartamento mais caro
WITH hospedagens_cat_mais_caras AS (
    SELECT
        ho.cod AS cod_hospedagem,
        h.dt_nasc,
        h.cod AS cod_hospede
    FROM
        hospedagem ho
    JOIN
        hospede h ON ho.cod_hosp = h.cod
    JOIN
        apartamento a ON ho.num_ap = a.num
    JOIN
        categoria c ON a.cod_cat = c.cod
    WHERE
        c.valor = (SELECT MAX(c_inner.valor) FROM categoria c_inner)
),
hosp_mais_velho_nas_categorias_caras AS (
    SELECT
        MIN(dt_nasc) AS dt_nasc_mais_velha
    FROM
        hospedagens_cat_mais_caras
)
SELECT
    hcmc.cod_hospedagem
FROM
    hospedagens_cat_mais_caras hcmc
JOIN
    hosp_mais_velho_nas_categorias_caras hmvc ON hcmc.dt_nasc = hmvc.dt_nasc_mais_velha;

SELECT * FROM hospedagem;

-- 16. Sem usar subquery, o nome dos hóspedes que nasceram na mesma data do 
-- hóspede de código 2
SELECT h.nome FROM hospede h
JOIN hospede h2 ON h.dt_nasc = h2.dt_nasc
WHERE h.cod = 2

-- 17. O nome do hóspede mais velho que se hospedou na categoria mais cara 
-- no ano de 2017.
WITH cat_mais_cara AS (
	SELECT MAX(valor) AS valor_max FROM categoria
),
hosp_cat_mais_cara_2025 AS (
	SELECT h.nome AS nome_hospede, h.dt_nasc FROM hospedagem ho
	JOIN apartamento a ON ho.num_ap = a.num
	JOIN categoria c ON a.cod_cat = c.cod
	JOIN cat_mais_cara cmc ON c.valor = cmc.valor_max
	JOIN hospede h ON ho.cod_hosp = h.cod
	WHERE EXTRACT(YEAR FROM ho.dt_ent) = 2025
),
dt_nasc_mais_velho AS (
	SELECT MIN(dt_nasc) AS min_dt_nasc FROM hosp_cat_mais_cara_2025
)

SELECT DISTINCT hcmc.nome_hospede FROM hosp_cat_mais_cara_2025 hcmc
JOIN dt_nasc_mais_velho dnmv ON hcmc.dt_nasc = dnmv.min_dt_nasc;

-- 18. O nome das categorias que foram reservadas pela Maria ou que
-- foram ocupadas pelo João quando ele foi atendido pelo Joaquim
SELECT c.nome FROM categoria c
JOIN apartamento a ON c.cod = a.cod_cat
JOIN hospedagem ho ON a.num = ho.num_ap
JOIN hospede h ON ho.cod_hosp = h.cod
WHERE h.nome = 'Maria'

UNION

SELECT c.nome FROM categoria c
JOIN apartamento a ON c.cod = a.cod_cat
JOIN hospedagem ho ON a.num = ho.num_ap
JOIN hospede h ON ho.cod_hosp = h.cod
JOIN funcionario f ON ho.cod_func = f.cod
WHERE h.nome = 'João' AND f.nome = 'Joaquim';

-- 19.  O nome e a data de nascimento dos funcionários, além do valor
-- de diária mais cara reservado por cada um deles.
SELECT f.nome, f.dt_nasc, MAX(c.valor) AS diaria_mais_cara FROM funcionario f
LEFT JOIN hospedagem ho ON f.cod = ho.cod_func
LEFT JOIN apartamento a ON ho.num_ap = a.num
LEFT JOIN categoria c ON a.cod_cat = c.cod
GROUP BY f.cod, f.nome, f.dt_nasc
ORDER BY f.nome

-- 20.  A quantidade de apartamentos ocupados por cada 
-- um dos hóspedes (mostrar o nome).
SELECT h.nome AS hospede, COUNT(DISTINCT ho.num_ap) AS qtd_ap_distintos_ocupados
FROM hospede h
LEFT JOIN hospedagem ho ON h.cod = ho.cod_hosp
GROUP BY h.cod, h.nome
ORDER BY h.nome;

-- 21.  A relação com o nome dos hóspedes, a data de entrada, a data de saída
-- e o valor total pago em diárias (não é necessário considerar a hora de entrada
-- e saída, apenas as datas).
SELECT 
	h.nome AS hospede, ho.dt_ent, ho.dt_sai,
	(ho.dt_sai - ho.dt_ent) AS num_noites,
	((ho.dt_sai - ho.dt_ent)) * c.valor AS tt_pg_diaria
FROM hospede h
JOIN hospedagem ho ON h.cod = ho.cod_hosp
JOIN apartamento a ON ho.num_ap = a.num
JOIN categoria c ON a.cod_cat  = c.cod
WHERE ho.dt_ent IS NOT NULL AND ho.dt_sai IS NOT NULL
ORDER BY h.nome, ho.dt_ent

-- 22. O nome dos hóspedes que já se hospedaram em todos os apartamentos do hotel
WITH
	count_ap_por_hosp AS (
		SELECT h.cod AS cod_hospede, h.nome AS nome_hospede,
		COUNT(DISTINCT ho.num_ap) AS qtd_ap_distintos_ocupados
		FROM hospede h
		JOIN hospedagem ho ON h.cod = ho.cod_hosp
		GROUP BY h.cod, h.nome
	),
	tt_ap_hotel AS (
		SELECT COUNT(DISTINCT num) AS qtd_tt_ap
		FROM apartamento
	)
SELECT caph.nome_hospede FROM count_ap_por_hosp caph
WHERE caph.qtd_ap_distintos_ocupados = (
	SELECT qtd_tt_ap FROM tt_ap_hotel
)