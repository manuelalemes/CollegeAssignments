DROP TABLE IF EXISTS serie_temporal CASCADE;
DROP TABLE IF EXISTS campanha CASCADE;
DROP TABLE IF EXISTS parametro CASCADE;
DROP TABLE IF EXISTS instituicao CASCADE;
DROP TABLE IF EXISTS reservatorio CASCADE;

-- Tabela reservatorio
CREATE TABLE reservatorio (
    id_reservatorio SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);

-- Tabela instituicao
CREATE TABLE instituicao (
    id_instituicao SERIAL PRIMARY KEY,
    nome_instituicao VARCHAR(200) NOT NULL
);

-- Tabela campanha (liga reservatorio + instituicao)
CREATE TABLE campanha (
    id_campanha SERIAL PRIMARY KEY,
    id_reservatorio INT NOT NULL REFERENCES reservatorio(id_reservatorio),
    id_instituicao INT NOT NULL REFERENCES instituicao(id_instituicao),
    data_coleta DATE NOT NULL
);

-- Tabela parametro (lista de parâmetros medidos)
CREATE TABLE parametro (
    id_parametro SERIAL PRIMARY KEY,
    nome_parametro VARCHAR(150) NOT NULL
);

-- Tabela serie_temporal (medidas associadas à campanha e ao parâmetro)
CREATE TABLE serie_temporal (
    id_serie SERIAL PRIMARY KEY,
    id_campanha INT NOT NULL REFERENCES campanha(id_campanha),
    id_parametro INT NOT NULL REFERENCES parametro(id_parametro),
    valor NUMERIC(12,4) NOT NULL,
    data_hora TIMESTAMP NOT NULL
);

-- Inserts: reservatórios
INSERT INTO reservatorio (nome) VALUES
('Represa São João'),
('Lago Azul'),
('Barragem das Flores');

-- Inserts: instituições
INSERT INTO instituicao (nome_instituicao) VALUES
('Inst A'),
('Inst B'),
('Inst C');

-- Inserts: parâmetros
INSERT INTO parametro (nome_parametro) VALUES
('pH'),
('Oxigênio Dissolvido'),
('Temperatura');

-- Inserts: campanhas
-- Organizando campanhas de forma que algumas instituições tenham campanhas em múltiplos reservatórios
INSERT INTO campanha (id_reservatorio, id_instituicao, data_coleta) VALUES
-- Inst A faz campanhas em Represa São João e Lago Azul (2 reservatórios)
(1, 1, '2025-01-10'),
(1, 1, '2025-02-15'),
(2, 1, '2025-03-20'),
(2, 1, '2025-04-25'),
-- Inst B faz campanhas apenas em Lago Azul
(2, 2, '2025-05-05'),
(2, 2, '2025-06-10'),
-- Inst C faz campanhas em Barragem das Flores
(3, 3, '2025-07-12'),
(1, 1, '2025-08-15'); -- Inst A mais uma campanha em Represa São João

-- Inserts: séries temporais (usando id_parametro referenciando a tabela parametro)
-- Para facilitar leitura: id_parametro: 1=pH, 2=Oxigênio Dissolvido, 3=Temperatura
INSERT INTO serie_temporal (id_campanha, id_parametro, valor, data_hora) VALUES
(1, 1, 7.12, '2025-01-10 09:00:00'),
(1, 2, 6.25, '2025-01-10 09:05:00'),
(2, 1, 7.30, '2025-02-15 10:00:00'),
(2, 2, 5.90, '2025-02-15 10:05:00'),
(3, 1, 6.95, '2025-03-20 11:00:00'),
(3, 3, 22.50, '2025-03-20 11:05:00'),
(4, 1, 7.05, '2025-04-25 12:00:00'),
(5, 1, 7.50, '2025-05-05 09:30:00'),
(5, 2, 6.80, '2025-05-05 09:35:00'),
(6, 3, 23.10, '2025-06-10 10:20:00'),
(7, 1, 7.00, '2025-07-12 08:50:00'),
(8, 2, 6.50, '2025-08-15 09:00:00'); -- campanha 8 (id_campanha 8) medida para Inst A

-- ====================================================
-- CONSULTAS — Limnologia (exercícios)
-- ====================================================

-- Verifica se existem medições de pH
SELECT *
FROM serie_temporal st
JOIN parametro p ON st.id_parametro = p.id_parametro
WHERE p.nome_parametro = 'pH';

-- Lista apenas os reservatórios
SELECT r.nome AS reservatorio
FROM reservatorio r
ORDER BY r.nome;

--Adiciona subconsulta para calcular média do pH por reservatório
SELECT
    r.nome AS reservatorio,

    -- Subconsulta para calcular a média do pH
    (
        SELECT AVG(st.valor)::numeric(12,4)
        FROM serie_temporal st
        JOIN campanha c ON st.id_campanha = c.id_campanha
        JOIN parametro p ON st.id_parametro = p.id_parametro
        WHERE c.id_reservatorio = r.id_reservatorio  -- pega apenas medições deste reservatório
          AND p.nome_parametro = 'pH'               -- filtra apenas pH
    ) AS media_ph

FROM reservatorio r
ORDER BY r.nome;

--Adiciona subconsultas para calcular mínimo e máximo do pH
SELECT
    r.nome AS reservatorio,

    -- Média do pH
    (
        SELECT AVG(st.valor)::numeric(12,4)
        FROM serie_temporal st
        JOIN campanha c ON st.id_campanha = c.id_campanha
        JOIN parametro p ON st.id_parametro = p.id_parametro
        WHERE c.id_reservatorio = r.id_reservatorio
          AND p.nome_parametro = 'pH'
    ) AS media_ph,

    -- Mínimo do pH
    (
        SELECT MIN(st.valor)::numeric(12,4)
        FROM serie_temporal st
        JOIN campanha c ON st.id_campanha = c.id_campanha
        JOIN parametro p ON st.id_parametro = p.id_parametro
        WHERE c.id_reservatorio = r.id_reservatorio
          AND p.nome_parametro = 'pH'
    ) AS minimo_ph,

    -- Máximo do pH
    (
        SELECT MAX(st.valor)::numeric(12,4)
        FROM serie_temporal st
        JOIN campanha c ON st.id_campanha = c.id_campanha
        JOIN parametro p ON st.id_parametro = p.id_parametro
        WHERE c.id_reservatorio = r.id_reservatorio
          AND p.nome_parametro = 'pH'
    ) AS maximo_ph

FROM reservatorio r
ORDER BY r.nome;