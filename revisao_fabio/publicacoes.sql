CREATE TABLE assunto (
	cod INT PRIMARY KEY NOT NULL,
	descricao VARCHAR(45) NOT NULL
)

CREATE TABLE editora (
	cod INT PRIMARY KEY NOT NULL,
	cnpj CHAR(14) UNIQUE NOT NULL,
	razao_social VARCHAR(45) NOT NULL
)

CREATE TABLE nacionalidade (
	cod INT PRIMARY KEY NOT NULL,
	descricao VARCHAR(45) NOT NULL
)

CREATE TABLE autor (
	cod INT PRIMARY KEY NOT NULL,
	cpf CHAR(11) UNIQUE NOT NULL,
	nome VARCHAR(45) NOT NULL,
	dt_nascimento DATE NOT NULL,
	cod_nacionalidade INT NOT NULL REFERENCES nacionalidade(cod)
	-- FOREIGN KEY (cod_nacionalidade) REFERENCES nacionalidade(cod)
)

CREATE TABLE livro (
	cod INT PRIMARY KEY NOT NULL,
	isbn CHAR(13) UNIQUE NOT NULL,
	titulo VARCHAR(45) NOT NULL,
	valor DECIMAL(10, 2) NOT NULL,
	dt_lancamento DATE NOT NULL,
	cod_assunto INT NOT NULL REFERENCES assunto(cod),
	cod_editora INT NOT NULL REFERENCES editora(cod)
	-- FOREIGN KEY (cod_assunto) REFERENCES assunto(cod)
	-- FOREIGN KEY (cod_editora) REFERENCES editora(cod)
)

CREATE TABLE autor_livro (
	cod_autor INT NOT NULL REFERENCES autor(cod),
	cod_livro INT NOT NULL REFERENCES livro(cod),
	PRIMARY KEY (cod_autor, cod_livro)
)

-- records of nacionalidade
INSERT INTO nacionalidade (cod, descricao) 
VALUES
	(1, 'Brasileira'),
	(2, 'Americana'),
	(3, 'Britânica'),
	(4, 'Francesa');

-- records of assunto
INSERT INTO assunto (cod, descricao) 
VALUES
	(1, 'Ficção Científica'),
	(2, 'Fantasia'),
	(3, 'Romance'),
	(4, 'Técnico'),
	(5, 'Biografia');

-- records of editora
INSERT INTO editora (cod, cnpj, razao_social) 
VALUES
	(1, '12345678000101', 'Editora Arqueiro'),
	(2, '98765432000102', 'Companhia das Letras'),
	(3, '45678912000103', 'Editora Rocco'),
	(4, '32165498000104', 'Saraiva'),
	(5, '89165498000105', 'Books Editora');

-- record of autor
INSERT INTO autor (cod, cpf, nome, dt_nascimento, cod_nacionalidade) 
VALUES
	(1, '11122233344', 'Machado de Assis', '1839-06-21', 1),
	(2, '22233344455', 'Stephen King', '1947-09-21', 2),
	(3, '33344455566', 'J.K. Rowling', '1965-07-31', 3),
	(4, '44455566677', 'George Orwell', '1903-06-25', 3),
	(5, '55566677788', 'Clarice Lispector', '1920-12-10', 1),
	(6, '66677788899', 'Paulo Coelho', '1947-08-27', 1);

-- record of livro
INSERT INTO livro (cod, isbn, titulo, valor, dt_lancamento, cod_assunto, cod_editora) 
VALUES
	(1, '9788525434559', 'Dom Casmurro', 39.90, '1899-01-01', 3, 2),
	(2, '9788599296360', 'It: A Coisa', 69.90, '1986-09-15', 1, 1),
	(3, '9788532511010', 'Harry Potter e a Pedra Filosofal', 49.90, '1997-06-26', 2, 3),
	(4, '9788535914849', '1984', 35.50, '1949-06-08', 1, 2),
	(5, '9788501103345', 'A Hora da Estrela', 29.90, '1977-01-01', 3, 4),
	(6, '9788501104346', 'O Alquimista', 59.90, '1988-08-27', 3, 5);

-- Relacionamentos autor_livro
INSERT INTO autor_livro (cod_autor, cod_livro) VALUES
	(1, 1),  -- Machado de Assis escreveu Dom Casmurro
	(2, 2),  -- Stephen King escreveu It: A Coisa
	(3, 3),  -- J.K. Rowling escreveu Harry Potter
	(4, 4),  -- George Orwell escreveu 1984
	(5, 5),  -- Clarice Lispector escreveu A Hora da Estrela
	(6, 6); -- Paulo Coelho escreveu O Alquimista

-- a) Livros que possuam preços entre R$ 100,00 e R$ 200,00.
SELECT titulo AS livros_entre_100_200_reais FROM livro
WHERE valor BETWEEN 100.00 AND 200.00

-- b) Livros cujos títulos possuam a palavra ‘Banco’.
SELECT titulo AS livros_palavra_banco FROM livro
WHERE titulo LIKE 'Banco%'

-- c) Livros que foram lançados há mais de 5 anos.
SELECT titulo, dt_lancamento FROM livro
WHERE dt_lancamento < '2019-01-01';

-- d) Quantidade total de livros.
SELECT COUNT(*) AS qtd_total_livros FROM livro;

-- e) Soma total dos preços dos livros.
SELECT SUM(valor) AS valor_total_livros FROM livro;

-- f) Maior preço dos livros.
SELECT titulo AS livro_mais_caro, valor FROM livro
WHERE valor = (
	SELECT MAX(valor) FROM livro
);

-- g) Quantidade de livros para cada assunto.
SELECT a.descricao AS assunto, COUNT(l.titulo) AS qtd_livros FROM assunto a
JOIN livro l ON a.cod = l.cod_assunto
GROUP BY a.descricao
ORDER BY a.descricao DESC;

-- h) Assuntos cujo preço médio dos livros ultrapassa R$ 50,00.
SELECT a.descricao AS assunto, CAST(AVG(l.valor) AS DECIMAL(10, 2)) AS valor_medio FROM assunto a
JOIN livro l ON a.cod = l.cod_assunto
GROUP BY a.descricao
HAVING AVG(l.valor) > 50;

-- O HAVING é uma cláusula do SQL que filtra resultados de 
-- grupos após a aplicação da cláusula GROUP BY
-- Ele funciona de forma semelhante ao WHERE, mas enquanto o WHERE 
-- filtra linhas individuais antes do 
-- agrupamento, o HAVING filtra os grupos resultantes.

-- livros por assunto
SELECT a.descricao AS assunto, l.titulo, l.valor FROM assunto a
JOIN livro l ON a.cod = l.cod_assunto
GROUP BY a.descricao, l.titulo, valor
ORDER BY a.descricao

-- i) Assuntos que possuem pelo menos 2 livros.
SELECT a.descricao AS assunto, COUNT(*) AS qtd_livros FROM assunto a
JOIN livro l ON a.cod = l.cod_assunto
GROUP BY a.descricao
HAVING COUNT(*) >= 2
ORDER BY a.descricao DESC;

-- j) Nome e CPF dos autores que nasceram após 1° de janeiro de 1970.
SELECT * FROM autor;

SELECT nome, cpf, dt_nascimento FROM autor
WHERE dt_nascimento > '1970-01-01';

-- k) Nome e CPF dos autores que não são brasileiros.
SELECT nome, cpf FROM autor
WHERE cod_nacionalidade > 1;

SELECT a.nome, a.cpf, n.descricao AS nacionalidade FROM autor a
JOIN nacionalidade n ON a.cod_nacionalidade = n.cod
WHERE n.descricao NOT IN (
	SELECT descricao FROM nacionalidade
	WHERE descricao LIKE 'Brasileira%'
)

-- l) Listagem dos livros contendo título, assunto 
-- e preço, ordenada em ordem crescente por assunto.

SELECT l.titulo, a.descricao AS assunto, l.valor FROM livro l
JOIN assunto a ON a.cod = l.cod_assunto
ORDER BY a.descricao;

-- m) Listagem contendo os preços e os títulos dos livros, ordenada em 
-- ordem decrescente de preço.
SELECT titulo, valor FROM livro
ORDER BY valor DESC;

-- n) Listagem dos nomes dos autores brasileiros com mês e ano de nascimento,
-- por ordem decrescente de idade e por ordem crescente de nome do autor.
SELECT a.nome, EXTRACT(MONTH FROM a.dt_nascimento) AS mes_nascimento, EXTRACT(YEAR FROM a.dt_nascimento)
AS ano_nascimento 
FROM autor a
JOIN nacionalidade n ON a.cod_nacionalidade = n.cod
WHERE n.descricao LIKE 'Brasileira%'
ORDER BY a.dt_nascimento, a.nome

-- o) Listagem das editoras e dos títulos dos livros lançados pela editora,
-- ordenada por nome da editora e pelo título do livro.
SELECT e.razao_social, l.titulo  FROM editora e
JOIN livro l ON e.cod = l.cod_editora
ORDER BY e.razao_social, l.titulo

-- p) Listagem de assuntos, contendo os títulos dos livros dos respectivos
-- assuntos, ordenada pela descrição do assunto.
SELECT a.descricao AS assunto, l.titulo FROM assunto a
JOIN livro l ON a.cod = l.cod_assunto
ORDER BY a.descricao

-- q) Listagem dos nomes dos autores e os livros de sua autoria, ordenada pelo 
-- nome do autor.
SELECT a.nome, l.titulo 
FROM autor a
JOIN autor_livro au ON a.cod = au.cod_autor
JOIN livro l ON l.cod = au.cod_livro
ORDER BY a.nome

-- r) Editoras que publicaram livros escritos pelo autor ‘Machado de Assis’.
SELECT e.razao_social, l.titulo FROM editora e
JOIN livro l ON e.cod = l.cod_editora
JOIN autor_livro au ON au.cod_livro = l.cod
JOIN autor a ON au.cod_autor = a.cod
WHERE a.nome LIKE 'Machado de Assis';

-- s) preço do livro mais caro publicado pela editora ‘Books Editora’ 
-- sobre banco de dados.
SELECT * FROM editora

SELECT MAX(l.valor) AS valor, l.titulo FROM livro l
JOIN editora e ON e.cod = l.cod_editora
JOIN assunto a ON a.cod = l.cod_assunto
WHERE e.razao_social LIKE 'Books Editora%' AND a.descricao LIKE 'Romance%'
GROUP BY l.valor, l.titulo

-- t) Nome e CPF do autor brasileiro que tenha nascido antes de 1° de janeiro de 1950
-- e os títulos dos livros de sua autoria, ordenado pelo nome do autor e pelo título do livro.
SELECT a.nome, a.cpf, l.titulo FROM autor a
JOIN nacionalidade n ON a.cod_nacionalidade = n.cod
JOIN autor_livro au ON a.cod = au.cod_autor
JOIN livro l ON au.cod_livro = l.cod
WHERE n.descricao LIKE 'Brasileira%'
AND a.dt_nascimento < '1950-01-01'
ORDER BY a.nome, l.titulo