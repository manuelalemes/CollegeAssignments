-- 1. Criar tabelas
-- -------------------------
DROP TABLE IF EXISTS serie_temporal CASCADE;
DROP TABLE IF EXISTS parametro CASCADE;
DROP TABLE IF EXISTS reservatorio CASCADE;

CREATE TABLE reservatorio (
    id_reservatorio SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);

CREATE TABLE parametro (
    id_parametro SERIAL PRIMARY KEY,
    nome_parametro VARCHAR(150) NOT NULL
);

-- serie_temporal contém id_reservatorio para este exercício (modo simplificado)
CREATE TABLE serie_temporal (
    id_serie SERIAL PRIMARY KEY,
    id_reservatorio INT NOT NULL REFERENCES reservatorio(id_reservatorio),
    id_parametro INT NOT NULL REFERENCES parametro(id_parametro),
    valor NUMERIC(12,4) NOT NULL,
    data_hora TIMESTAMP NOT NULL
);

-- -------------------------
-- 2. Inserts de exemplo
-- -------------------------
INSERT INTO reservatorio (nome) VALUES
('Jaguari'),
('Paraibuna'),
('Cachoeira do França'),
('Santa Branca');

INSERT INTO parametro (nome_parametro) VALUES
('pH'),
('Oxigênio Dissolvido'),
('Temperatura');

-- Inserir medições
-- Jaguari (tem Oxigênio Dissolvido e pH)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
(
  (SELECT id_reservatorio FROM reservatorio WHERE nome = 'Jaguari'),
  (SELECT id_parametro FROM parametro WHERE nome_parametro = 'Oxigênio Dissolvido'),
  6.80,
  '2025-01-10 09:00:00'
),
(
  (SELECT id_reservatorio FROM reservatorio WHERE nome = 'Jaguari'),
  (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
  7.20,
  '2025-01-10 09:05:00'
);

-- Paraibuna (apenas pH)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
(
  (SELECT id_reservatorio FROM reservatorio WHERE nome = 'Paraibuna'),
  (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
  6.90,
  '2025-02-20 10:00:00'
);

-- Cachoeira do França (apenas pH)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
(
  (SELECT id_reservatorio FROM reservatorio WHERE nome = 'Cachoeira do França'),
  (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
  7.60,
  '2025-03-15 11:00:00'
);

-- Santa Branca (apenas Oxigênio Dissolvido)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
(
  (SELECT id_reservatorio FROM reservatorio WHERE nome = 'Santa Branca'),
  (SELECT id_parametro FROM parametro WHERE nome_parametro = 'Oxigênio Dissolvido'),
  7.00,
  '2025-04-01 08:00:00'
);

-- ====================================================
-- CONSULTAS PASSO A PASSO – PARÂMETRO: "Oxigênio Dissolvido"
-- ====================================================

-- -------------------------
-- Passo 1: Conferir parâmetros
-- -------------------------
SELECT * 
FROM parametro;

-- -------------------------
-- Passo 2: Subconsulta isolada (IDs de reservatórios)
-- -------------------------
SELECT DISTINCT st.id_reservatorio
FROM serie_temporal st
JOIN parametro p ON st.id_parametro = p.id_parametro
WHERE p.nome_parametro = 'Oxigênio Dissolvido';

-- -------------------------
-- Passo 3: Consulta completa usando IN
-- -------------------------
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE r.id_reservatorio IN (
    SELECT DISTINCT st.id_reservatorio
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE p.nome_parametro = 'Oxigênio Dissolvido'
)
ORDER BY r.nome;

-- -------------------------
-- Passo 4: Mesma consulta usando EXISTS
-- -------------------------
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE EXISTS (
    SELECT 1
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'Oxigênio Dissolvido'
)
ORDER BY r.nome;

-- -------------------------
-- Passo 5: Comparar desempenho (opcional)
-- -------------------------
EXPLAIN ANALYZE
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE r.id_reservatorio IN (
    SELECT DISTINCT st.id_reservatorio
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE p.nome_parametro = 'Oxigênio Dissolvido'
);

EXPLAIN ANALYZE
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE EXISTS (
    SELECT 1
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'Oxigênio Dissolvido'
);

-- ====================================================
-- CONSULTA EXTRA: Média, mínimo e máximo de Oxigênio Dissolvido por reservatório
-- ====================================================
SELECT 
    r.nome AS reservatorio,
    (SELECT AVG(valor) FROM serie_temporal st 
     JOIN parametro p ON st.id_parametro = p.id_parametro
     WHERE st.id_reservatorio = r.id_reservatorio
       AND p.nome_parametro = 'Oxigênio Dissolvido') AS media_oxigenio,
    (SELECT MIN(valor) FROM serie_temporal st 
     JOIN parametro p ON st.id_parametro = p.id_parametro
     WHERE st.id_reservatorio = r.id_reservatorio
       AND p.nome_parametro = 'Oxigênio Dissolvido') AS minimo_oxigenio,
    (SELECT MAX(valor) FROM serie_temporal st 
     JOIN parametro p ON st.id_parametro = p.id_parametro
     WHERE st.id_reservatorio = r.id_reservatorio
       AND p.nome_parametro = 'Oxigênio Dissolvido') AS maximo_oxigenio
FROM reservatorio r
ORDER BY r.nome;