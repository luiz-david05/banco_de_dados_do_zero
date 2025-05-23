CREATE TABLE fornecedor (
    cod INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR
);

CREATE TABLE titulo (
    cod INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE livro (
    cod INT PRIMARY KEY,
    cod_titulo INT REFERENCES titulo(cod),
    qtd_estoque INT NOT NULL DEFAULT 0,
    valor_uni DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_qtd_estoque CHECK (qtd_estoque >= 0)
);

CREATE TABLE pedido (
    cod INT,
    cod_fornecedor INT,
    dt_pedido DATE,
    hr_pedido TIME,
    valor_tt_pedido DECIMAL(12, 2),
    qtd_itens_pedido INT
);

CREATE TABLE item_pedido (
    cod_livro INT,
    cod_pedido INT,
    qtd_item INT,
    valor_tt_item DECIMAL(10, 2)
);

CREATE TABLE controla_alteracao (
    id_log SERIAL PRIMARY KEY,
    operacao_realizada VARCHAR(10) NOT NULL,
    dt_e_hr TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    usuario_modificador VARCHAR(50) DEFAULT CURRENT_USER,
    cod_livro_afetado INT NOT NULL,
    cod_titulo_antigo INT,
    cod_titulo_novo INT,
    qtd_estoque_velha INT,
    qtd_estoque_nova INT
);

-- records of fornecedor
INSERT INTO fornecedor (cod, nome, endereco) 
VALUES
    (1, 'Distribuidora Alfa', 'Rua dos Livros, 123, Cidade A'),
    (2, 'Fornecedora Beta', 'Av. Principal, 456, Cidade B'),
    (3, 'Editora Gama', 'Praça Central, 789, Cidade C');

-- records of titulo
INSERT INTO titulo (cod, descricao) 
VALUES
  (101, 'SQL para Iniciantes'),
  (102, 'Avançando em PostgreSQL'),
  (103, 'Design de Bancos de Dados'),
  (104, 'O Universo dos Triggers');

-- records of livro
INSERT INTO livro (cod, cod_titulo, qtd_estoque, valor_uni) 
VALUES
  (1001, 101, 50, 45.00),
  (1002, 102, 30, 79.90),
  (1003, 103, 25, 60.50),
  (1004, 101, 15, 47.50),
  (1005, 104, 5, 35.00);

-- records of pedido
INSERT INTO Pedido (cod, cod_fornecedor, dt_pedido, hr_pedido, valor_tt_pedido, qtd_itens_pedido) 
VALUES
  (1, 1, '2024-02-05', '10:30:00', 0.00, 0),
  (2, 2, '2024-02-15', '14:00:00', 0.00, 0),
  (3, 1, '2024-03-10', '11:15:00', 0.00, 0),
  (4, 3, '2024-02-20', '09:00:00', 0.00, 0);

-- records of item_pedido
INSERT INTO Item_pedido (cod_livro, cod_pedido, qtd_item, valor_tt_item) 
VALUES
  (1001, 1, 10, 450.00), -- 10 * 45.00
  (1002, 1, 5, 399.50),  -- 5 * 79.90
  (1003, 2, 12, 726.00), -- 12 * 60.50
  (1001, 3, 7, 315.00),  -- 7 * 45.00 (pedido de março)
  (1004, 4, 20, 950.00); -- 20 * 47.50

-- 2.a) Mostre o nome dos fornecedores que venderam mais de X reais no 
-- mês de fevereiro de 2024
CREATE OR REPLACE VIEW view_vendas_fornecedor_fevereiro_2024 AS
SELECT f.nome, SUM(p.valor_tt_pedido) AS tt_vendido_fevereiro FROM fornecedor f
JOIN pedido p ON f.cod = p.cod_fornecedor
WHERE p.dt_pedido >= '2024-02-01' AND p.dt_pedido <= '2024-02-29'
GROUP BY f.nome

SELECT nome FROM view_vendas_fornecedor_fevereiro_2024
WHERE tt_vendido_fevereiro > 100.00;

-- b)
SELECT nome FROM view_vendas_fornecedor_fevereiro_2024
ORDER BY tt_vendido_fevereiro DESC
LIMIT 1;

-- c)
SELECT nome FROM view_fornecedor_fevereiro_2024
WHERE tt_vendido_fevereiro = (
	SELECT MAX(tt_vendido_fevereiro) 
	FROM view_vendas_fornecedor_fevereiro_2024
)

-- 3.
CREATE OR REPLACE FUNCTION valida_pedido()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.cod IS NULL THEN RAISE EXCEPTION 'cod_pedido n pode ser nulo'; END IF;
	IF NEW.cod_fornecedor IS NULL THEN RAISE EXCEPTION 'cod_fornecedor n pode ser 
	nulo em pedido'; END IF;
	IF NEW.dt_pedido IS NULL THEN RAISE EXCEPTION 'dt_pedido n pode ser nula'; END IF;
	IF NEW.valor_tt_pedido IS NULL THEN RAISE EXCEPTION 'valor_tt_pedido n pode ser nulo'; END IF;
	IF NEW.qtd_itens_pedido IS NULL THEN RAISE EXCEPTION 'qtd_itens_pedido n pode ser nulo'; END IF;

	IF TG_OP = 'INSERT' THEN
		IF EXISTS (SELECT 1 FROM pedido WHERE cod = NEW.cod) THEN
			RAISE EXCEPTION 'Violacao da pk: cod % ja existe em pedido', NEW.cod;
		END IF;
	ELSIF TG_OP = 'UPDATE' THEN
		IF NEW.cod IS DISTINCT FROM OLD.cod AND EXISTS (SELECT 1 FROM pedido WHERE
		cod = NEW.cod) THEN RAISE EXCEPTION 'Violacao da pk: cod % ja existe ao tentar atualizar', NEW.cod;
		END IF;
	END IF;

	IF NOT EXISTS (SELECT 1 FROM fornecedor WHERE cod = NEW.cod) THEN
		RAISE EXCEPTION 'Violacao da fk: cod % nao existe na tabela fornecedor', NEW.cod;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_pedido
BEFORE INSERT OR UPDATE ON pedido
FOR EACH ROW EXECUTE FUNCTION valida_pedido();