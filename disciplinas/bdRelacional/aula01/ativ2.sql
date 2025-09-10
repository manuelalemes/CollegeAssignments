CREATE TABLE cliente (
    nome_cliente VARCHAR(100) PRIMARY KEY,
    cidade_cliente VARCHAR(100),
    endereco_cliente VARCHAR(200)
);

CREATE TABLE conta (
    numero_conta INT PRIMARY KEY,
    nome_agencia VARCHAR(100),
    saldo DECIMAL(12,2),
    FOREIGN KEY (nome_agencia) REFERENCES agencia(nome_agencia)
);

CREATE TABLE emprestimo (
    numero_emprestimo INT PRIMARY KEY,
    nome_agencia VARCHAR(100),
    valor DECIMAL(12,2),
    FOREIGN KEY (nome_agencia) REFERENCES agencia(nome_agencia)
);

CREATE TABLE agencia (
    nome_agencia VARCHAR(100) PRIMARY KEY,
    cidade_agencia VARCHAR(100),
    depositos DECIMAL(15,2)
);

CREATE TABLE cliente_conta (
    nome_cliente VARCHAR(100),
    numero_conta INT,
    PRIMARY KEY (nome_cliente, numero_conta),
    FOREIGN KEY (nome_cliente) REFERENCES cliente(nome_cliente),
    FOREIGN KEY (numero_conta) REFERENCES conta(numero_conta)
);