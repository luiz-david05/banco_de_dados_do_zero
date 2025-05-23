CREATE TABLE cd (
  cod_cd INT PRIMARY KEY NOT NULL,
  nome_cd CHAR(45),
  dt_compra DATE DEFAULT CURRENT_DATE,
  valor_pago FLOAT,
  local_compra CHAR(45),
  album CHAR(1) NOT NULL CHECK (album IN ('S', 'N')),
  artista CHAR(50)
);

CREATE TABLE musica (
	cod_msc SERIAL PRIMARY KEY,
	nome_msc CHAR(45),
	duracao INT NOT NULL,
	cd_cod INT,
	FOREIGN KEY (cd_cod)  REFERENCES cd(cod_cd)
);


-- records of cd
INSERT INTO cd (cod_cd, nome_cd, valor_pago, local_compra, album, artista)
VALUES 
	(1, 'Na Pegada do Arrocha', 35.00, 'Amazon', 'S', 'Os Clones'),
	(2, 'Minha Santa Ines', 20.00, 'Mercado Livre', 'S', 'Raimundo Soldado'),
	(3, 'Reginaldo Rossi - Perfil', 65.00, 'Amazon', 'S', 'Reginaldo Rossi'),
	(4, '20 Super Sucessos', 34.00, 'Mercado Livre', 'S', 'Barto Galeno'),
	(5, 'Bruno e Marrone - Ao Vivo', 100.00, 'Amazon', 'S', 'Bruno e Marrone');

-- records of musica
INSERT INTO musica (nome_msc, duracao, cd_cod)
VALUES 
	-- os clones
	('Mulher Safada', 284, 1),
	('Que Mal Te Fiz Eu', 250, 1),
	-- raimundo soldado
	('Hoje Eu Vou Me Embriagar', 286, 2),
	('Meu Pai Ta Duro', 145, 2),
	-- reginaldo rossi
	('Meu Fracasso', 158, 3),
	('A Raposa e as Uvas', 231, 3),
	('Garçom', 245, 3),
	('Leviana', 254, 3),
	('Em Plena Lua De Mel', 265, 3),
	-- barto galeno
	('Saudade De Rosa', 186, 4),
	('No Toca-Fita do Meu Carro', 265, 4),
	-- bruno e marrone
	('Dormi Na Praça', 198, 5),
	('Boate Azul', 217, 5),
	('Te Amar Foi Ilusão', 245, 5); 

SELECT * FROM cd;
SELECT * FROM musica;

-- a) Mostrar os campos nome e data da compra dos CDs ordenados por nome
SELECT nome_cd, dt_compra FROM cd ORDER BY nome_cd;

-- b) Mostrar os campos nome e data da compra dos CDs classificados por data de compra em
-- ordem decrescente
SELECT nome_cd, dt_compra FROM cd ORDER BY dt_compra DESC;

-- c) Mostrar o total gasto com a compra dos CDs
SELECT SUM(valor_pago) AS total_pago_todos_cds FROM cd

-- d) Mostrar o nome do CD e o nome das músicas de todos CDs
SELECT c.nome_cd, m.nome_msc FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod;

-- e) Mostrar o nome e o artista de todas as músicas cadastradas
SELECT m.nome_msc, c.artista FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod;

-- f) Mostrar o tempo total de músicas cadastradas
SELECT SUM(duracao) AS duracao_total_mscs_cadastradas FROM musica;

-- g) Mostrar o número, nome e tempo das músicas do CD com o código 5 por ordem de
-- número
SELECT c.nome_cd, m.cod_msc, m.nome_msc, m.duracao FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
WHERE c.cod_cd = 5
ORDER BY m.cod_msc;

-- h) Mostrar o número, nome e tempo das músicas do CD com o nome “Reginaldo Rossi –
-- Perfil” por ordem de nome
SELECT c.nome_cd, m.nome_msc, m.duracao FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
WHERE c.nome_cd LIKE 'Reginaldo Rossi - Perfil%'
ORDER BY c.nome_cd

-- i) Mostrar o tempo total de músicas por CD
SELECT c.nome_cd, SUM(m.duracao) as duracao_total_mscs_por_cd FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
GROUP BY c.nome_cd

-- j) Mostrar a quantidade de músicas cadastradas
SELECT COUNT(*) qtd_mscs_cadastradas FROM musica

-- Mostrar a quantidade de músicas cadastradas por CD
SELECT c.nome_cd, COUNT(*) as qtd_mscs_cd FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
GROUP BY c.nome_cd

-- k) Mostrar a média de duração das músicas cadastradas
SELECT AVG(duracao) AS media_duracao_mscs_cadastradas FROM musica;

-- Mostrar a média de duração das músicas cadastradas por CD
SELECT c.nome_cd, CAST(AVG(m.duracao) AS NUMERIC(10,2)) as media_duracao_msc_cadastradas FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
GROUP BY c.nome_cd;

-- l) Mostrar a quantidade de CDs
SELECT COUNT(*) qtd_cds FROM cd;

-- m) Mostrar o nome das músicas do artista Reginaldo Rossi
SELECT m.nome_msc, c.artista FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
WHERE c.artista LIKE 'Reginaldo Rossi%';

-- n) Mostrar a quantidade de músicas por CDs
SELECT c.nome_cd, COUNT(*) as qtd_mscs_cd FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
GROUP BY c.nome_cd;

-- o) Mostrar o nome de todos os CDs comprados no “Submarino.com”
SELECT nome_cd AS qtd_cds_comprados_submarino FROM cd
WHERE local_compra LIKE 'Submarino.com%';

-- p) Mostrar uma listagem de músicas em ordem alfabética
SELECT nome_msc FROM musica
ORDER BY nome_msc;

-- Mostrar uma listagem de músicas e cds em ordem alfabética
SELECT c.nome_cd, m.nome_msc FROM cd c
JOIN musica m ON c.cod_cd = m.cd_cod
GROUP BY c.nome_cd, m.nome_msc
ORDER BY c.nome_cd;

-- q) Mostrar todos os CDs que são álbuns
SELECT nome_cd, album FROM cd
WHERE album LIKE 'S%';

-- r) Mostrar o CD que custou mais caro
SELECT nome_cd AS cd_mais_caro, valor_pago FROM cd
WHERE valor_pago = (
	SELECT MAX(valor_pago) FROM cd
)

-- s) Mostrar os CDs comprados em julho de 2024
SELECT nome_cd AS cd_comprado_julho_2024 FROM cd
WHERE dt_compra BETWEEN '01/07/2024' AND '31/07/2024';

SELECT nome_cd AS cd_comprado_abril_2025 FROM cd
WHERE dt_compra BETWEEN '01/04/2025' AND '30/04/2025';

-- t) Mostrar os CDs cujo valor pago esteja entre R$ 30,00 e R$ 50,00
SELECT nome_cd, valor_pago FROM cd
WHERE valor_pago BETWEEN 30.00 AND 50.00;