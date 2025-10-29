-- E1: Listar quantos livros cada autor possui
-- Devolve o nome do autor e a contagem total de livros associados a ele
SELECT
	a.nome,
	COUNT(l.id_livro) AS total_livros
FROM autor a

JOIN livro l ON a.id_autor = l.id_autor

GROUP BY a.nome;


-- E2: Mostra a média de ano de publicação dos livros por autor
-- Retorna o nome do autor e a média (arredondada) do ano de publicação de seus livros
SELECT
	a.nome,
	TRUNC(AVG(l.ano_publicacao)) AS media_ano_publicacao
FROM autor a

JOIN livro l ON a.id_autor = l.id_autor

GROUP BY a.nome;


-- E3: Listar o total de livros emprestados por aluno
-- Retorna o nome do aluno e a contagem total de livros que ele já emprestou
SELECT
	a.nome,
	COUNT(el.id_livro) AS total_livros_emprestados
FROM aluno a

JOIN emprestimo e ON a.id_aluno = e.id_aluno
JOIN emprestimoLivro el ON e.id_emprestimo = el.id_emprestimo

GROUP BY a.nome;


-- E4: Mostra o total de empréstimos (eventos) por curso
-- Retorna o nome do curso e quantos eventos de empréstimo foram realizados por alunos desse curso
SELECT
	a.curso,
	COUNT(e.id_emprestimo) AS total_eventos_emprestimo
FROM aluno a

JOIN emprestimo e ON a.id_aluno = e.id_aluno

GROUP BY a.curso;


-- E5: Exibir apenas os autores que possuem mais de 1 livro cadastrado
-- Devolve os autores e sua contagem de livros, apenas se a contagem for maior que 1
SELECT
	a.nome,
	COUNT(l.id_livro) AS total_livros
FROM autor a

JOIN livro l ON a.id_autor = l.id_autor

GROUP BY a.nome
HAVING COUNT(l.id_livro) > 1;