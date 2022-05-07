<img src="https://bit.ly/2VnXWr2" alt="Ironhack Logo" width="100"/>

# Preço e Demanda de Comodities 
# <i>Serie Temporal</i>

* Marcio R. Okamura*

* DAPT64 - NOV21, Sao Paulo, 07 de Maio de 2022 *

## Conteudo
- [Descriçao do Projeto](#project-description)
- [Hipotese e questionamentos](#hypotheses-/-questions)
- [Dataset](#dataset)
- [Mineraçao dos Dados](#cleaning)
- [Analises](#analysis)
- [Modelo de treinamento e Avaliaçoes](#model-training-and-evaluation)
- [Conclusao](#conclusion)
- [Próximos passos](#future-work)
- [Workflow](#workflow)
- [Organizaçao do Projeto](#organization)
- [Links](#links)

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
*Include this section only if you chose to include ML in your project.*
* Describe how you trained your model, the results you obtained, and how you evaluated those results.

<a name="conclusion"></a>

## Conclusao
* Summarize your results. What do they mean?
* What can you say about your hypotheses?
* Interpret your findings in terms of the human-understandable question you try to answer.

<a name="future-work"></a>

## Próximos passos
Address any questions you were unable to answer, or any next steps or future extensions to your project.

<a name="workflow"></a>

## Workflow
Outline the workflow you used in your project. What were the steps?
How will you test the success of your analysis or algorithm?

<a name="organization"></a>

## Organizaçao do Projeto
How did you organize yourself? Did you use any tools?

<a name="links"></a>

## Links
Include the links to your repository, slides and trello. Feel free to include any other links associated to your project. 

[Repository](https://github.com/)  
[Slides](https://slides.com/)  
[Trello](https://trello.com/en)  
