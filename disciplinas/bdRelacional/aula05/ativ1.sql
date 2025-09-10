INSERT INTO categoria_usuario (nome, descricao) VALUES
('Supervisor', 'Usuário com privilégios para revisar e validar eventos'),
('Operador', 'Usuário que realiza o cadastro e atualização de eventos'),
('Visitante', 'Usuário com acesso limitado à visualização de eventos');

INSERT INTO usuario (nome, email, senha_hash, id_categoria) VALUES
('Diego Ramos', 'diego.ramos@email.com', 'hash987', 1),
('Elisa Martins', 'elisa.martins@email.com', 'hash654', 2),
('Fernando Lopes', 'fernando.lopes@email.com', 'hash321', 3);

INSERT INTO tipo_evento (nome, descricao) VALUES
('Tempestade de Granizo', 'Evento envolvendo queda de granizo com danos potenciais'),
('Vazamento Químico', 'Acidente envolvendo substâncias perigosas'),
('Terremoto', 'Abalo sísmico de intensidade variada');

INSERT INTO estado (sigla_estado, nome_estado) VALUES
('PR', 'Paraná'),
('RS', 'Rio Grande do Sul'),
('SC', 'Santa Catarina');

INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado) VALUES
(-25.428954, -49.267137, 'Curitiba', 'PR'),
(-30.034647, -51.217658, 'Porto Alegre', 'RS'),
(-27.595377, -48.548050, 'Florianópolis', 'SC');

INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Granizo em Curitiba', 'Telhados danificados por granizo intenso', '2025-09-07 16:45:00', 'Ativo', 1, 1),
('Vazamento em Indústria', 'Vazamento de produto químico no distrito industrial', '2025-09-06 09:10:00', 'Em Monitoramento', 2, 2),
('Tremor em Santa Catarina', 'Pequeno terremoto sentido na região central', '2025-09-03 23:30:00', 'Resolvido', 3, 3);

SELECT id_usuario, nome, email FROM usuario;

SELECT id_evento, titulo, status FROM evento;

SELECT titulo, descricao, status 
FROM evento
WHERE status = 'Ativo';

SELECT nome, email 
FROM usuario
WHERE id_categoria = 1;