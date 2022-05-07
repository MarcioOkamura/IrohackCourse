<img src="https://bit.ly/2VnXWr2" alt="Ironhack Logo" width="100"/>

# Preço e Demanda de Comodities 
# <i>Serie Temporal</i>

* Marcio R. Okamura

* DAPT64 - NOV21, Sao Paulo, 07 de Maio de 2022 

## Conteudo
- [Descriçao do Projeto](#project-description)
- [Hipotese e questionamentos](#hypotheses-/-questions)
- [Dataset](#dataset)
- [Mineraçao dos Dados](#cleaning)
- [Analises](#analysis)
- [Modelo de treinamento e Avaliaçoes](#model-training-and-evaluation)
- [Conclusao](#conclusion)
- [Próximos passos](#future-work)

<a name="project-description"></a>

## Descriçao do Projeto
Este projeto deseja ter uma aproximaçao dos preços e/ou demanda das comodities comercializadas pelo Brasil dada a guerra na Ucrania.

<a name="hypotheses-/-questions"></a>

## Hipoteses e questionamentos
* Qual o comportamento do preço das comodities versus alguns dos insumos? 
* Com tudo mais constante, como se comportara o preço das comodities? 
* Qual o impacto da guerra para o preço das comodities?
* Qual a expectativa de preço com a guerra?  

<a name="dataset"></a>

## Dataset
* A principio este estudo utiliza a base de dados de comercio exterior disponibilizado pelo governo brasileiro:
https://www.gov.br/produtividade-e-comercio-exterior/pt-br/assuntos/comercio-exterior/estatisticas/base-de-dados-bruta 

<a name="cleaning"></a>

## Mineraçao dos Dados
Os dados para analise correspondem a somente 3 categoria de toda importaçao e exportaçao do Brasil:
* Petroleo
* Fertilizantes
* Graos e derivados

Com estas 3 categorias iniciamos a obtençao da relaçao entre elas para determinaçao do preco do graos por kilo exportado, neste primeiro estagio indifere se houve ou nao houve algum beneficiamento do grao para exportaçao.

Construida a relaçao entre as variaveis, agrega-se a informaçao dos paises em questao (Russia e Ucrania) para que seja possivel mensurar o impacto destes dos pais para a produçao nacional

Inicia-se a construçao do modelo final

<a name="analysis"></a>

## Analises
Nos primeiros passos nao se encontra sazionalidade na importaçao do petroleo, entretanto para a importaçao dos fertilizantes e exportaçao dos graos temos uma janela de 12 meses.

Após a primeira constataçao se buscou a relaçao das tres variaveis deslocando no tempo as variaveis "input", aqui temos o primeiro output que a variaçao do preco do petroleo nos ultimos 6 meses e a variaçao do preco dos fertilizantes nos ultimos 3 meses tem o "mesmo comportamento"

Dado este primeiro "output" buscamos como os insumos compoe o preço final, para obter um modelo compreensivel se utilizou un PLS.

Com segundo "output", buscamos introduzir a variavel pais para que tenhamos a relaçao destes paises no preco final, onde encontramos uma alta relaçao com a Russia em virtude da alta participaçao na importaçao dos insumos 

A etapa de analise exploratoria foi muito rica para interpretaçao dos resultados.

<a name="model-training-and-evaluation"></a>

## Modelo de treinamento e Avaliaçoes
O modelo incia com a relacao temporal de cada variavel e relacao entre elas. Umas vez definido o primeiro output, o modeo consiste em um PLS para que seja interpretavel e se obtenha as variaveis que melhor descreve o preço dos graos.

Uma vez que se obtem este modelo, abrimos cada uma das variaveis em Russia, Ucrania e Outros paises para verificarmos se ha ou nao ha diferenca dos modelos.

Neste caso no se observou grandes variacoes.

Por fim a criaçao de cenarios para avaliarmos o impacto da guerra da Ucrania para o preço em USD das comodities brasileiras, para isto utilizamos esta planilha para descrever os cenarios:
https://docs.google.com/spreadsheets/d/1a31oy4yINquYtl9WaQD-K2JZ72c1_4tolLv5-SJ_vQY/edit?usp=sharing

Esta planilha define um cenario baseado em 4 variaveis:
* Final da guerra
* Aumento do consumo de petroleo
* Aumento do consumo de fertilizantes
* Aumento da exportaçao

Dado este cenario tivemos uma resultado contra intuitivo que o preço tende a baixar, baseado nas variaveis que estamos analisando, ou seja, a analise descreve que ha outras variaveis que nao estao sendo capturadas pelo modelo que possivel fara com que haja outras relacoes para composiçao dos preços.

<a name="conclusion"></a>

## Conclusao
O resultado permite atribuir algumas conclusoes, como:
* A possibilidade de uma aumento do consumo de graos no mercado interno (caso o USD se mantenha em R$4.60,
* Caso contrario o volume de exportaçao será mais vantajoso embora o preço reduza (em USD),
* Há a possibilidade do governo brasileiro aumentar ou reduzir as aliquotas de exportaçao para controle do IPCA15 (inflaçao),
* Adoçao de novas tecnologias "caras" que em escala sejam mais vantajosa caso haja aumento na utilizaçao.


<a name="future-work"></a>

## Próximos passos
Como proximos passos, será necessario buscar novas variaveis que permita uma descriçao melhor do modelo e menores erros, com isto buscar ter outras respostas de negocios como cenarios de aumento de area plantada ou introduçao de novas tecnologias para aumento da produçao.

Analisar outros impactos macro economicos que permita tirar novas relacoes e estudos
