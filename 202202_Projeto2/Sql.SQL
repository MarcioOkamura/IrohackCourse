-- Deleta tabelas caso elas ja exista
--DROP SCHEMA IF EXISTS db_projeto_cinema CASCADE;
CREATE SCHEMA db_projeto_cinema;

-- Cria tabela de genero e MPAA

-- GENERO
CREATE TABLE postgres.db_projeto_cinema.TB_GENEROS
(
	id_genero VARCHAR(256) NOT NULL PRIMARY KEY -- chave do filme
	,desc_genero VARCHAR(256) 
);
-- MPAA
CREATE TABLE postgres.db_projeto_cinema.TB_MPAA
(
	id_mpaa VARCHAR(256) NOT NULL PRIMARY KEY -- chave do filme
	,desc_mpaa VARCHAR(256) 
);

-- Mescla dos dois
CREATE TABLE postgres.db_projeto_cinema.TB_MODELO_FORECAST
(
	id_genero VARCHAR(256) NOT NULL
	,id_mpaa VARCHAR(256) NOT NULL --
	,id_modelo_forecast VARCHAR(256)
	,FOREIGN KEY (id_genero) REFERENCES postgres.db_projeto_cinema.TB_GENEROS(id_genero)
	,FOREIGN KEY (id_mpaa) REFERENCES postgres.db_projeto_cinema.TB_MPAA(id_mpaa)
);

-- Cria tabela de datas:
CREATE TABLE postgres.db_projeto_cinema.TB_DATA
(
	data_aaaammdd TIMESTAMP NOT NULL PRIMARY KEY -- dia da analise
	,dia_semana VARCHAR(256) NOT NULL -- qual dia da semana
	,feriado VARCHAR(256)  -- esta data eh feriado
	,estacao VARCHAR(256)  -- qual estacao do ano se encontra
	,semana_do_mes INT 
);

-- Cria tabelas tag:
CREATE TABLE postgres.db_projeto_cinema.TB_PRODUTORAS
(
	produtora_link VARCHAR(256) NOT NULL PRIMARY KEY -- 
	,desc_produtora VARCHAR(256) NOT NULL
);


--Tabelas de dados:
CREATE TABLE postgres.db_projeto_cinema.TB_FILMES
(
	release_link VARCHAR(256) NOT NULL -- chave do filme
	,nome_release VARCHAR(256) NOT NULL -- nome do filme
	,imdb_link VARCHAR(256) -- chave para imdb
	,entrada_em_cartaz TIMESTAMP -- referencia
	,saida_de_cartaz TIMESTAMP -- referencia
	,orcamento BIGINT 
	,produtora_link VARCHAR(256)  
	,salas_exibidas BIGINT 
	,expectadores BIGINT 
	,mpaa VARCHAR(256) 
	,duracao_do_filme TIMESTAMP 
	,id_genero VARCHAR(256) 
	,watch_time_minutes INT  -- tag no boxofficemojo
	,link_poster VARCHAR(256) 
	,PRIMARY KEY (release_link)
	--,FOREIGN KEY (produtora_link) REFERENCES postgres.db_projeto_cinema.TB_PRODUTORAS(produtora_link)
	--,FOREIGN KEY (id_genero) REFERENCES postgres.db_projeto_cinema.TB_GENEROS(id_genero)
);


-- Cria tabelas faturamento mercado domestico (EUA)
CREATE TABLE postgres.db_projeto_cinema.TB_FATURAMENTO
(
	release_link VARCHAR(256) NOT NULL -- 
	,data_aaaammdd TIMESTAMP NOT NULL -- 
	,posicao_atual INT  -- 
	,posicao_anterior INT --
	,salas_em_exibicao INT  --
	,faturamento_diario BIGINT --
	,tag_analise VARCHAR(256) 
	,FOREIGN KEY (release_link) REFERENCES postgres.db_projeto_cinema.TB_FILMES(release_link)
	,FOREIGN KEY (data_aaaammdd) REFERENCES postgres.db_projeto_cinema.TB_DATA(data_aaaammdd)
);

CREATE TABLE postgres.db_projeto_cinema.FAT_DOMESTICO
(
	--sera utilizada para fazer update da tabela filmes
	release_link VARCHAR(256) NOT NULL -- 
	,faturamento_us BIGINT --
	,faturamento_intl BIGINT --
	,FOREIGN KEY (release_link) REFERENCES postgres.db_projeto_cinema.TB_FILMES(release_link)
);

CREATE TABLE postgres.db_projeto_cinema.TEMP_FILMES
(
	--sera utilizada para fazer update da tabela filmes
	release_link VARCHAR(256) NOT NULL -- 
	,data_aaaammdd TIMESTAMP -- 
	,posicao_atual INT -- 
	,posicao_anterior INT --
	,salas_em_exibicao INT--
	,faturamento_diario BIGINT --
	,tag_analise VARCHAR(256) 
);

CREATE TABLE postgres.db_projeto_cinema.TEMP_FILMES_DADOS
(
	--sera utilizada para fazer update da tabela filmes
	release_link VARCHAR(256) NOT NULL -- 
	,fat_us BIGINT -- 
	,fat_intl BIGINT -- 
	,fat_total BIGINT --
	,espectadores BIGINT--
	,orcamento BIGINT --
);

Select count(*) From postgres.db_projeto_cinema.TB_FILMES;
Select count(*) From postgres.db_projeto_cinema.TB_DATA;
Select count(*) From postgres.db_projeto_cinema.TB_PRODUTORAS;
Select count(*) From postgres.db_projeto_cinema.TB_GENEROS;
Select count(*) From postgres.db_projeto_cinema.TB_MPAA;
Select count(*) From postgres.db_projeto_cinema.TB_FATURAMENTO;
Select count(*) From postgres.db_projeto_cinema.TB_MODELO_FORECAST;
SELECT count(*) FROM db_projeto_cinema."TEMP_FILMES_DADOS";
Select count(*) From postgres.db_projeto_cinema.TEMP_FILMES;

--Tenho orcamento de todos os filmes?
Select A.release_link
	,',' as sepador
	From postgres.db_projeto_cinema.TB_FILMES as A
	LEFT JOIN db_projeto_cinema."TEMP_FILMES_DADOS" as B on (A.release_link = B.release_link)
	Where B.release_link is null
	GROUP BY 1;



-- teste de dados: 
Select distinct release_link
	From postgres.db_projeto_cinema.TB_FATURAMENTO
	Where release_link  = 'rl876971521'
	--Limit 1000
;

Select *
	From postgres.db_projeto_cinema.TB_FATURAMENTO
	Where release_link  = 'rl876971521'
	--Limit 1000
;

Select *
	From postgres.db_projeto_cinema.TB_FILMES
	Where release_link  = 'rl876971521'
	Limit 100
;

CREATE VIEW postgres.db_projeto_cinema.VW_LANCAMENTO_FILME AS
(
	SELECT
		C.*
		,DATE_PART('day', C.ultimo_dia - C.lancamento) as em_cartaz
	FROM
	(SELECT
		A.release_link
		,MIN(B.data_aaaammdd) as lancamento
		,MAX(B.data_aaaammdd) as ultimo_dia
		,MIN(B.posicao_atual) as melhor_ranking
		,MAX(B.posicao_atual) as pior_ranking
	FROM postgres.db_projeto_cinema.TB_FILMES as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FATURAMENTO as B on (A.release_link = B.release_link)
	GROUP BY A.release_link
	) as C
);

-- Lancamentos de cada filme, dias em cartas e melhores posicoes
SELECT
		C.*
		,DATE_PART('day', C.ultimo_dia - C.lancamento) as em_cartaz
	FROM
	(SELECT
		A.release_link
		,MIN(B.data_aaaammdd) as lancamento
		,MAX(B.data_aaaammdd) as ultimo_dia
		,MIN(B.posicao_atual) as melhor_ranking
		,MAX(B.posicao_atual) as pior_ranking
	FROM postgres.db_projeto_cinema.TB_FILMES as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FATURAMENTO as B on (A.release_link = B.release_link)
	GROUP BY A.release_link
	) as C



-- Sintaxe de Update 
--UPDATE Customers
--SET ContactName='Juan'
--WHERE Country='Mexico';

-- domestico x total
-- linha do tempo
-- share de produtora 
-- margem por produtora (bin / faixa / box plot)
-- capital limitado -  mpaa e genero
-- dispersao do investimento por filme
-- margem neste grupo

-- domestico x total
CREATE VIEW postgres.db_projeto_cinema.VW_DOMESTIC_RATIO_PRODUTORA AS
(
	SELECT
		B.produtora_link
		,SUM(A.fat_us) as DOMESTICO
		,SUM(A.fat_intl) as INTERNACIONAL
	FROM postgres.db_projeto_cinema.TEMP_FILMES_DADOS as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FILMES as B on (A.release_link = B.release_link)
	GROUP BY B.produtora_link
);

DROP VIEW postgres.db_projeto_cinema.VW_MARGEM_POR_FILME;
CREATE VIEW postgres.db_projeto_cinema.VW_MARGEM_POR_FILME AS
(
	SELECT
		A.release_link
		, B.fat_total/B.orcamento as margem_filme
	FROM postgres.db_projeto_cinema.TB_FILMES as A
	INNER JOIN postgres.db_projeto_cinema.TEMP_FILMES_DADOS as B on (A.release_link = B.release_link)
);

DROP VIEW postgres.db_projeto_cinema.VW_MARGEM_POR_PRODUTORA;
CREATE VIEW postgres.db_projeto_cinema.VW_MARGEM_POR_PRODUTORA AS
(
	SELECT
		 A.produtora_link
		, B.fat_total/B.orcamento as margem_filme
	FROM postgres.db_projeto_cinema.TB_FILMES as A
	INNER JOIN postgres.db_projeto_cinema.TEMP_FILMES_DADOS as B on (A.release_link = B.release_link)
);

-- linha do tempo

--DROP VIEW postgres.db_projeto_cinema.VW_FAT_DIARIO;
CREATE VIEW postgres.db_projeto_cinema.VW_FAT_DIARIO AS
(
	SELECT
		A.data_aaaammdd
		,B.produtora_link
		,MIN(A.posicao_atual) as melhor_posicao
		,'TOTAL' as TIPO
		,SUM(A.faturamento_diario) as FATURAMENTO
	FROM postgres.db_projeto_cinema.TB_FATURAMENTO as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FILMES as B on (A.release_link = B.release_link)
	GROUP BY 1,2
	
	UNION

	SELECT
		A.data_aaaammdd
		,B.produtora_link
		,MIN(A.posicao_atual) as melhor_posicao
		,'TOP1' as TIPO
		,SUM( CASE WHEN A.posicao_atual = 1 THEN A.faturamento_diario ELSE 0 END) as FATURAMENTO	
	FROM postgres.db_projeto_cinema.TB_FATURAMENTO as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FILMES as B on (A.release_link = B.release_link)
	GROUP BY 1,2
	
	UNION
	
	SELECT
		A.data_aaaammdd
		,B.produtora_link
		,MIN(A.posicao_atual) as melhor_posicao
		,'TOP10' as TIPO
		,SUM( CASE WHEN A.posicao_atual <= 10 THEN A.faturamento_diario ELSE 0 END) as FATURAMENTO	
	FROM postgres.db_projeto_cinema.TB_FATURAMENTO as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FILMES as B on (A.release_link = B.release_link)
	GROUP BY 1,2
	
	UNION
	
	SELECT
		A.data_aaaammdd
		,B.produtora_link
		,MIN(A.posicao_atual) as melhor_posicao
		,'ACIMA_TOP10' as TIPO
		,SUM( CASE WHEN A.posicao_atual > 10 THEN A.faturamento_diario ELSE 0 END) as FATURAMENTO	
	FROM postgres.db_projeto_cinema.TB_FATURAMENTO as A
	LEFT JOIN postgres.db_projeto_cinema.TB_FILMES as B on (A.release_link = B.release_link)
	GROUP BY 1,2
	
);

SELECT * FROM db_projeto_cinema."TEMP_FILMES_DADOS" LIMIT 10;

-- Slide 1:
SELECT
	'US' as REGIAO
	,SUM(CAST(REPLACE(REPLACE(FAT_US,',',''),'$','') as NUMERIC)) as FAT
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"

UNION

SELECT
	'INTL' as REGIAO
	,SUM(CAST(REPLACE(REPLACE(FAT_INTL,',',''),'$','') as NUMERIC)) as FAT
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"
--UNION
--
--SELECT
--	'TOTAL' as REGIAO
--	,SUM(CAST(REPLACE(REPLACE(fat_total,',',''),'$','') as NUMERIC)) as FAT
--	FROM db_projeto_cinema."TEMP_FILMES_DADOS"
;	

SELECT
	'FILMES' as METRICA
	,COUNT(*) as VALOR
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"

UNION

SELECT
	'ORCAMENTO' as METRICA
	,SUM(CAST(REPLACE(REPLACE(ORCAMENTO,',',''),'$','') as NUMERIC)) as VALOR
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"

UNION

SELECT
	'ESPECTADORES' as METRICA
	,SUM(CAST(REPLACE(REPLACE(FAT_INTL,',',''),'$','') as NUMERIC)) as VALOR
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"

UNION

SELECT
	'MARGEM' as METRICA
	,SUM(CAST(REPLACE(REPLACE(FAT_TOTAL,',',''),'$','') as NUMERIC))/SUM(CAST(REPLACE(REPLACE(ORCAMENTO,',',''),'$','') as NUMERIC)) -1 as VALOR
	FROM db_projeto_cinema."TEMP_FILMES_DADOS"
;

-- Slide2:
SELECT * FROM postgres.db_projeto_cinema.VW_FAT_DIARIO;

-- slide 3 : (produtora)
SELECT * FROM postgres.db_projeto_cinema.TB_FILMES LIMIT 5;

-- melhor posicao por produtora e vezes nesta posicao
CREATE VIEW postgres.db_projeto_cinema.VW_MELHOR_POSICAO_PRODUTORA AS
(
	SELECT
		produtora_link
		,min(melhor_posicao) as melhor_posicao
		,count(release_link) as qtd_filmes_total
		FROM
		(
		SELECT
			A.produtora_link
			,A.release_link
			,MIN(B.posicao_atual) as melhor_posicao
			FROM postgres.db_projeto_cinema.TB_FILMES as A
			LEFT JOIN postgres.db_projeto_cinema.TB_FATURAMENTO as B on (A.release_link = B.release_link)
			GROUP BY 1,2
		) as C
		GROUP BY 1
		ORDER BY 2, 3 desc
);

Select SUM(qtd_filmes_total) FROM postgres.db_projeto_cinema.VW_MELHOR_POSICAO_PRODUTORA;

Select * FROM postgres.db_projeto_cinema.VW_MELHOR_POSICAO_PRODUTORA LIMIT 100;

-- Melhor rating ate 3 com pelo menos 3 filmes: Grandes Produtoras
-- Melhor rating ate 3 com menos de 3 filmes: Pequeno Sucessos
-- Else : Pequenas Produtoras

--DROP VIEW postgres.db_projeto_cinema.VW_CLASS_PRODUTORA;
CREATE VIEW postgres.db_projeto_cinema.VW_CLASS_PRODUTORA AS
(
	SELECT 
	E.*
	, CASE
			WHEN E.QTD_FILMES >= 100 THEN 'GRANDES PRODUTORAS'
			WHEN E.QTD_FILMES >= 5 AND E.MELHOR_POSICAO < 5 THEN 'GRANDES PRODUTORAS'
			WHEN E.QTD_FILMES < 5 AND E.MELHOR_POSICAO < 5 THEN 'PEQUENA PRODUTORAS - TOP 5'
			ELSE 'PEQUENA PRODUTORA'
			END as CLASS_PROD
	FROM(
	SELECT
	produtora_link
	,melhor_posicao
	,SUM(Count_melhor_posicao) as QTD_FILMES_MELHOR_POSICAO
	,COUNT(release_link) as QTD_FILMES
	FROM
	(SELECT
		A.release_link
		,MIN(C.posicao_atual)
	 	,B.melhor_posicao
		,MAX(CASE WHEN C.posicao_atual = B.melhor_posicao THEN 1 Else 0 END) as Count_melhor_posicao
		,B.produtora_link

		FROM postgres.db_projeto_cinema.TB_FILMES as A
		LEFT JOIN postgres.db_projeto_cinema.VW_MELHOR_POSICAO_PRODUTORA as B on (A.produtora_link = B.produtora_link)
		LEFT JOIN postgres.db_projeto_cinema.TB_FATURAMENTO as C on (A.release_link = C.release_link)
	 GROUP BY 1,3,5
	) as D
	GROUP BY 1,2
	ORDER BY 2, 3 desc, 4 desc) as E
 );

SELECT SUM(QTD_FILMES) FROM postgres.db_projeto_cinema.VW_CLASS_PRODUTORA;

SELECT * FROM postgres.db_projeto_cinema.VW_CLASS_PRODUTORA;

--DROP VIEW postgres.db_projeto_cinema.VW_FILME_PRODUTORA_MARGEM;
CREATE VIEW postgres.db_projeto_cinema.VW_FILME_PRODUTORA_MARGEM AS
(
	SELECT
	A.release_link
	,A.produtora_link
	,(CAST(REPLACE(REPLACE(B.fat_total,',',''),'$','') as NUMERIC)) as RECEITAS
	,(CAST(REPLACE(REPLACE(B.orcamento,',',''),'$','') as NUMERIC)) as INVESTIMENTO
	,CAST(REPLACE(REPLACE(B.fat_total,',',''),'$','') as NUMERIC)/CAST(REPLACE(REPLACE(B.orcamento,',',''),'$','') as NUMERIC) -1 as MARGEM_FILME
	FROM postgres.db_projeto_cinema.TB_FILMES as A
	LEFT JOIN postgres.db_projeto_cinema."TEMP_FILMES_DADOS" as B on (A.release_link = B.release_link)	
);


SELECT count(*) FROM postgres.db_projeto_cinema.VW_CLASS_PRODUTORA;

SELECT count(*) FROM postgres.db_projeto_cinema.VW_FILME_PRODUTORA_MARGEM;

SELECT *
	FROM postgres.db_projeto_cinema.VW_FILME_PRODUTORA_MARGEM
	ORDER BY 5;

SELECT
	data_aaaammdd
	,DATE_PART('month', data_aaaammdd)
	FROM postgres.db_projeto_cinema.TB_DATA
	LIMIT 10;

SELECT * FROM postgres.db_projeto_cinema.TB_DATA LIMIT 10;

SELECT B.data_aaaammdd
	,B.dia_semana
	,B.feriado
	,B.estacao
	,DATE_PART('month', B.data_aaaammdd) 
	,SUM(faturamento_diario) as FAT
	FROM postgres.db_projeto_cinema.TB_DATA as B
	INNER JOIN postgres.db_projeto_cinema.TB_FATURAMENTO as A ON (A.data_aaaammdd = B.data_aaaammdd)
	GROUP BY 1,2,3,4,5
;
