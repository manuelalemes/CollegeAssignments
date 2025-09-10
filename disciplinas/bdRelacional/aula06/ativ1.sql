INSERT INTO evento_usuario (id_evento, id_usuario) VALUES
(1, 1),  -- Diego Ramos relatou "Granizo em Curitiba"
(2, 2);  -- Elisa Martins relatou "Vazamento em Indústria"

-- Consulta: data/hora (mais antigos primeiro)
SELECT id_evento, titulo, data_hora
FROM evento
ORDER BY data_hora ASC;

-- Consulta: ORDER BY + LIMIT (3 eventos mais recentes)
SELECT id_evento, titulo, data_hora
FROM evento
ORDER BY data_hora DESC
LIMIT 3;