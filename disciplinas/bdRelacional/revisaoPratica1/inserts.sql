INSERT INTO loja (nome, cidade) VALUES 
('Power Games Recife', 'Recife'),
('Next Level Store', 'Fortaleza'),
('Gamer Zone POA', 'Porto Alegre');
 
INSERT INTO cliente (nome, email, cidade) VALUES
('Lucas Fernandes', 'lucas.fernandes@email.com', 'Recife'),
('Juliana Castro', 'juliana.castro@email.com', 'Fortaleza'),
('Ricardo Silva', 'ricardo.silva@email.com', 'Porto Alegre');
 
INSERT INTO jogo (titulo, ano_lancamento, genero) VALUES
('Dragon Blast', 2022, 'Aventura'),
('Racing Storm', 2020, 'Corrida'),
('Galaxy Wars', 2024, 'Estratégia');
 
INSERT INTO compra (data_compra, id_cliente, id_loja) VALUES
('2025-09-03', 1, 1),
('2025-09-04', 2, 2);

INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(1, 1, 1),
(1, 2, 1);

INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(2, 1, 2),
(2, 3, 1);