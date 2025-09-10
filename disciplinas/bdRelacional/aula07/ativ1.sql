-- Banco Escolar

CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_curso INT REFERENCES cursos(id_curso)
);

CREATE TABLE notas (
    id_nota SERIAL PRIMARY KEY,
    id_aluno INT REFERENCES alunos(id_aluno),
    id_disciplina INT REFERENCES disciplinas(id_disciplina),
    nota DECIMAL(5,2) NOT NULL
);

CREATE TABLE disciplinas (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_curso INT REFERENCES cursos(id_curso)
);

INSERT INTO cursos (id_curso, nome) VALUES
(1, 'Arquitetura e Urbanismo'),
(2, 'Biologia');

INSERT INTO alunos (id_aluno, nome, id_curso) VALUES
(1, 'Alice Souza', 1),
(2, 'Bruno Lima', 2),
(3, 'Carla Nunes', 1),
(4, 'Daniel Alves', 2),
(5, 'Eduarda Pires', 1);

INSERT INTO notas (id_aluno, id_disciplina, nota) VALUES
(1, 1, 8.5),
(2, 2, 6.0),
(3, 1, 9.0),
(4, 2, 5.5),
(5, 1, 10.0);

INSERT INTO disciplinas (id_disciplina, nome, id_curso) VALUES
(1, 'Geometria Descritiva', 1),
(2, 'Educação Ambiental', 2);  


SELECT COUNT(*) AS total_alunos
FROM alunos;

SELECT AVG(nota) AS media_geral_notas
FROM notas;

SELECT c.nome AS curso, COUNT(a.id_aluno) AS total_alunos
FROM cursos c
LEFT JOIN alunos a ON c.id_curso = a.id_curso
GROUP BY c.nome;

UPDATE notas
SET nota = 9.5
WHERE id_aluno = 3
  AND disciplina = 'Geometria Descritiva';


-- Conta Bancária

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL
);

CREATE TABLE contas (
    conta_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    numero_conta VARCHAR(20) UNIQUE NOT NULL,
    saldo DECIMAL(12,2) DEFAULT 0.00
);

CREATE TABLE transacoes (
    transacao_id SERIAL PRIMARY KEY,
    conta_id INT REFERENCES contas(conta_id),
    tipo VARCHAR(10) CHECK (tipo IN ('deposito','saque','transferencia')),
    valor DECIMAL(12,2) NOT NULL,
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO clientes (nome, cpf, data_nascimento) VALUES
('Ana Souza', '12345678901', '1990-05-12'),
('Carlos Mendes', '23456789012', '1985-03-23'),
('Fernanda Lima', '34567890123', '2000-11-02');

INSERT INTO contas (cliente_id, numero_conta, saldo) VALUES
(1, '1001', 1500.00),
(2, '1002', 2500.00),
(3, '1003', 500.00);

INSERT INTO transacoes (conta_id, tipo, valor, data_transacao) VALUES
(1, 'deposito', 500.00, '2025-09-01'),
(1, 'saque', 200.00, '2025-09-05'),
(2, 'deposito', 1000.00, '2025-09-06'),
(3, 'deposito', 300.00, '2025-09-08'),
(2, 'saque', 400.00, '2025-08-28'); 


SELECT COUNT(*) AS total_transacoes_mes
FROM transacoes
WHERE DATE_TRUNC('month', data_transacao) = DATE_TRUNC('month', CURRENT_DATE);

SELECT AVG(valor) AS media_depositos
FROM transacoes
WHERE tipo = 'deposito';

UPDATE contas
SET saldo = saldo + 300.00
WHERE numero_conta = '1001';


-- Atividade Prática

SELECT COUNT(*) AS total_clientes
FROM clientes;

SELECT SUM(saldo) AS saldo_total
FROM contas;

SELECT AVG(valor) AS media_saques
FROM transacoes
WHERE tipo = 'saque';