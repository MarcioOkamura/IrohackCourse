Select *
From comex_db.tb_c_cgce
	Where co_cgce_n1 in ('1','4')
;

/*
co_cgce_n1: 
1 - BENS DE CAPITAL (BK)
4 - COMBUSTÍVEIS E LUBRIFICANTES
*/

--limit 10;

Select *
From comex_db.tb_c_fatagreg
Limit 10;

--items importados para producao
Select *
From comex_db.tb_c_ncm
	Where 1=1
	and co_isic_classe in ('2011','2012','2029','2821','9000') 
	and co_exp_subset in ('1499','0906')
	--and no_ncm_por like '%ertili%'
	--and co_siit = '2000'
	Order by co_siit, co_isic_classe, co_exp_subset
-- Limit 20
;
/*
	co_siit = '2000'
	co_isic_classe in ('2011','2012','2029','2821','9000') --a classe abaixo define melhor
	co_exp_subset in ('1499','0906')
	OUTPUT co_ncm
*/

--items importados petroleo
Select *
From comex_db.tb_c_ncm
	Where 1=1
	and co_isic_classe in ('1920','8999') 
	and co_siit in('3000')
	Order by co_siit, co_isic_classe, co_exp_subset
 --Limit 20
;

--items exportados
Select *
From comex_db.tb_c_ncm
	Where 1=1
	--and co_isic_classe in ('1040','1061','1062','1071','1072','1074','1079','1080','1101','1102') 
	and co_exp_subset in ('8099')
	--and no_ncm_por like '%milho%'
	and co_siit in ('4000','9000')
	Order by co_siit, co_isic_classe, co_exp_subset
-- Limit 20

--	OUTPUT co_ncm
;

Select distinct no_sec_por
From comex_db.tb_c_ncmsh
	Where 1=1
	--and no_sec_por like '%milho%'
Limit 20
;
--somente animais

Select *
From comex_db.tb_c_unidade
	Where 1=1
Limit 20;
--co_unid --codigo da unidade

Select *
From comex_db.tb_c_via
	Where 1=1
Order by 1
Limit 20
;

-- entrada de fertilizantes e petroleo deve ser preferencialmente maritima, mas vai que...
-- saida eh pelos nossos portos, mas vai que ...
--co_via in ('00','01','02','06','07','14','15','99')

Select *
From comex_db.tb_cambio
	Where 1=1
Limit 0040
;
-- coluna data_cambio ajudara a converter td a dolar

Select *
From comex_db.tb_exporta
	Where 1=1
Limit 30
;


--
--co_ncm
--co_pais
--co_urf
--soma vl_fob

Select *
From comex_db.tb_importa
	Where 1=1
Limit 30;

/*
co_ano
,co_mes
,co_ncm
,co_unid
,co_pais
,co_via
,qt_estat
,kg_liquido
,vl_fob + vl_frete + vl_seguro
*/
--
--co_ncm
--co_pais
--co_urf
--soma vl_fob
--soma vl_frete
--soma vl_seguro

Select distinct no_sh2_por
From comex_db.tb_sh2_impexp
	Where 1=1
Limit 30
;


/* Qual valor do petroleo importador por mes ano: */
Drop View comex_db.Preco_Petroleo;
Create View comex_db.Preco_Petroleo as (
	Select cast(A.co_ano as INT) as co_ano
	,cast(A.co_mes as INT) as co_mes
	,A.co_ncm
	,A.co_unid
	,A.co_pais
	,A.co_via
	,sum(A.qt_estat) as qt_estat
	,sum(A.kg_liquido) as kg_liquido
	,sum(A.vl_fob) as vlr
	From comex_db.tb_importa as A
		Left join comex_db.tb_c_ncm as B ON (A.co_ncm = B.co_ncm) 
		Where 1=1
		and (B.co_isic_classe in ('1920','8999') and B.co_siit in('3000'))
		and A.co_via in ('00','01','07')
		and cast(A.co_ano as INT) >= '1997' --Inicio da serie de fertilizantes
	Group by
		cast(A.co_ano as INT) 
		,cast(A.co_mes as INT) 
		,A.co_ncm
		,A.co_unid
		,A.co_pais
		,A.co_via
	)
;

/* Qual volume e valor do fertlizante importado por mes ano: */
Drop View comex_db.Preco_Fertlizantes;
Create View comex_db.Preco_Fertlizantes as (
	Select cast(A.co_ano as INT) as co_ano
	,cast(A.co_mes as INT) as co_mes
	,A.co_ncm
	,A.co_unid
	,A.co_pais
	,A.co_via
	,sum(A.qt_estat) as qt_estat
	,sum(A.kg_liquido) as kg_liquido
	,sum(A.vl_fob) as vlr
	From comex_db.tb_importa as A
		Left join comex_db.tb_c_ncm as B ON (A.co_ncm = B.co_ncm) 
		Where 1=1
		and (co_isic_classe in ('2011','2012','2029','2821','9000')
		and co_exp_subset in ('1499','0906'))
		and A.co_via in ('00','01','07')
		and cast(A.co_ano as INT) >= '1997' --Inicio da serie de fertilizantes
	Group by
		cast(A.co_ano as INT) 
		,cast(A.co_mes as INT)
		,A.co_ncm
		,A.co_unid
		,A.co_pais
		,A.co_via
	)
;

/* Exportacoes de graos e derivados */
Drop View comex_db.Preco_Exportacoes;
Create View comex_db.Preco_Exportacoes as (
	Select cast(A.co_ano as INT) as co_ano
	,cast(A.co_mes as INT) as co_mes
	,A.co_ncm
	,A.co_unid
	,A.co_pais
	,A.co_via
	,sum(A.qt_estat) as qt_estat
	,sum(A.kg_liquido) as kg_liquido
	,sum(A.vl_fob) as vlr
	From comex_db.tb_exporta as A
		Left join comex_db.tb_c_ncm as B ON (A.co_ncm = B.co_ncm) 
		Where 1=1
		and (co_exp_subset in ('8099')
		and co_siit in ('4000','9000'))
		and A.co_via in ('00','01','07')
		and cast(A.co_ano as INT) >= '1997' --Inicio da serie de fertilizantes
	Group by
		cast(A.co_ano as INT)
	,	cast(A.co_mes as INT)
		,A.co_ncm
		,A.co_unid
		,A.co_pais
		,A.co_via
	)
;

/*
Fertlizantes sao comprados antes (no planejamento), mas devem chegar no principio de cada producao para
reduzir gasto de armazenagem. Assim sera agrupado por semestre de recepcao e verificado o semestre sequinte
a producao.
Assim os meses de Julho a Dezembro sera S1 do ano seguinte e os meses de Jan a Jun sera S2 do mesmo ano.
Ja os combustiveus sao adquiridos no decorrer de toda producao, seja para transporte dos insumos para o
interior do pais, seja para trazer o produto final para os portos ou para locomover os navios ate o destino.
Assim os meses de Julho a Dezembro sera S2 do mesmo ano e os meses de Jan a Jun sera S1 do mesmo ano.
Assim sera somado no semestre de cada producao.
A producao sera somada em cada semestre. Somando as producoes de primeiro e segundo semestre
Assim os meses de Julho a Dezembro sera S2 do mesmo ano e os meses de Jan a Jun sera S1 do mesmo ano.
*/

Select *
From comex_db.Preco_Fertlizantes
Limit 50
;

--converter texto em numero
--converter numero em texto
--concatenar

Select
	Case When co_mes in ('07','08','09','10','11','12') Then '1'
		When co_mes in ('01','02','03','04','05','06') Then '2' End as SafraSemestre
	,Case When co_mes in ('07','08','09','10','11','12') Then co_ano +1
		When co_mes in ('01','02','03','04','05','06') Then co_ano End as SafraAno
	,count(*) as QUANT
	From comex_db.Preco_Fertlizantes
	Group by 1,2
	Order by 2,1
;

Select
	Case When co_mes in ('07','08','09','10','11','12') Then '2'
		When co_mes in ('01','02','03','04','05','06') Then '1' End as SafraSemestre
	,Case When co_mes in ('07','08','09','10','11','12') Then co_ano
		When co_mes in ('01','02','03','04','05','06') Then co_ano End as SafraAno
	,count(*) as QUANT
	From comex_db.Preco_Petroleo
	Group by 1,2
	Order by 2,1
;

Select
	Case When co_mes in ('07','08','09','10','11','12') Then '2'
		When co_mes in ('01','02','03','04','05','06') Then '1' End as SafraSemestre
	,Case When co_mes in ('07','08','09','10','11','12') Then co_ano
		When co_mes in ('01','02','03','04','05','06') Then co_ano End as SafraAno
	,count(*) as QUANT
	From comex_db.Preco_Exportacoes
	Group by 1,2
	Order by 2,1
;

/*
Avaliacao sera feita pelo volume total, mas devera ser ponderada ja que nao traz a area plantada para
que tenhamos uma referencia relativa:
Melhora de produtividade
Melhora do preco por saca
etc...

Ou seja, cada uma das tabelas devera trazer o valor VLR / Unidade de medida
*/


/*
A analise levara em conta os paises de origem e destino
Assim, uma possivel analise do preco para a guerra entre Russia e Ucrania
Para isto, qual o codigo destes dois paises?
*/

/*
Depois de trabalhada as 3 tabelas, joins chaveado pelas Safras (Semestre ano) em que trara:
Preco medio do petroleo em dolar e as quantidades importadas
Preco medio do fertilizante em dolar e as quantidades importadas
Preco medio do produto vendido e as quantidades exportadas

O Output sera o preco medio, ja que o volume exportado pode contemplar o volume armazenado de safras anteriores

Algumas informacoes podem ser agregadas manualmente depois:
El nino
La nina
Variacao cambial (USD) no periodo
*/

--RUSSIA: 676
--UCRANIA: 831
--BRASIL: 105

/*

Depois de falar com Pedro e Adriano:

ano
mes
produto 
kilos
valor financeiro

Python: Media movel 12M
Diagrama de fase - diferenca de fase (meses)
Diagrama de fase cruzado - panda rolling, shift, diff

primeiro modelo
tabelas por paises

*/
Select A.co_mes
	,A.co_ano

From(
	Select distinct co_mes
		,co_ano
	From comex_db.Preco_Exportacoes
	union 
	Select distinct co_mes
		,co_ano
	From comex_db.Preco_Fertlizantes
	union
	Select distinct co_mes
		,co_ano
	From comex_db.Preco_Petroleo) as A
	Left join (
		Select 
			co_ano
			,co_mes
			,sum(kg_liquido
			,vlr
	) as B on (A.co_mes = B.co_mes and A.co_ano = B.co_ano)
	Left join () as C on (A.co_mes = C.co_mes and A.co_ano = C.co_ano)
	Left join () as D on (A.co_mes = D.co_mes and A.co_ano = D.co_ano)
/*
Apresentacao
valor, preco por kilo
*/

Drop View comex_db.ppt_consolidado;
Create View comex_db.ppt_consolidado as (
Select co_ano
		,co_mes
		,Produtos
		,Pais_Origem
		,co_via
		,kg_liquido
		,vlr
		,vlr/kg_liquido as vlr_por_kg
From (
	Select cast(A.co_ano as INT) as co_ano
		,cast(A.co_mes as INT) as co_mes
		,case when (B.co_isic_classe in ('1920','8999') and B.co_siit in('3000')) then 'Petroleo'
			when (co_isic_classe in ('2011','2012','2029','2821','9000') and co_exp_subset in ('1499','0906')) then 'Fertilizantes'
			else 'OutrosProd' end Produtos
		,case when co_pais = '676' then 'Russia'
			when co_pais = '831' then 'Ucrania'
			else 'Outros' end Pais_Origem
		,A.co_via
		,sum(A.kg_liquido) as kg_liquido
		,sum(A.vl_fob) as vlr
		From comex_db.tb_importa as A
			Left join comex_db.tb_c_ncm as B ON (A.co_ncm = B.co_ncm) 
			Where 1=1
			and cast(A.co_ano as INT) >= '1997' --Inicio da serie de fertilizantes
		Group by
			cast(A.co_ano as INT) 
			,cast(A.co_mes as INT) 
			,case when (B.co_isic_classe in ('1920','8999') and B.co_siit in('3000')) then 'Petroleo'
			when (co_isic_classe in ('2011','2012','2029','2821','9000') and co_exp_subset in ('1499','0906')) then 'Fertilizantes'
			else 'OutrosProd' end 
			,case when co_pais = '676' then 'Russia'
			when co_pais = '831' then 'Ucrania'
			else 'Outros' end
			,A.co_via) as Temporario
Union
Select co_ano
		,co_mes
		,Produtos
		,Pais_Origem
		,co_via
		,kg_liquido
		,vlr
		,vlr/kg_liquido as vlr_por_kg
From (
	Select cast(A.co_ano as INT) as co_ano
		,cast(A.co_mes as INT) as co_mes
		,case when (co_exp_subset in ('8099') and co_siit in ('4000','9000')) then 'Graos'
			else 'OutrosProd' end Produtos
		,case when co_pais = '676' then 'Russia'
			when co_pais = '831' then 'Ucrania'
			else 'Outros' end Pais_Origem
		,A.co_via
		,sum(A.kg_liquido) as kg_liquido
		,sum(A.vl_fob) as vlr
		From comex_db.tb_exporta as A
			Left join comex_db.tb_c_ncm as B ON (A.co_ncm = B.co_ncm) 
			Where 1=1
			and cast(A.co_ano as INT) >= '1997' --Inicio da serie de fertilizantes
		Group by
			cast(A.co_ano as INT) 
			,cast(A.co_mes as INT) 
			,case when (co_exp_subset in ('8099') and co_siit in ('4000','9000')) then 'Graos'
			else 'OutrosProd' end
			,case when co_pais = '676' then 'Russia'
			when co_pais = '831' then 'Ucrania'
			else 'Outros' end
			,A.co_via) as Temporario_2
	
)
;

/*
*/