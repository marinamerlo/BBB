install.packages("rvest")
library(rvest)
library(data.table)
library(dplyr)

rm(list=ls())

#vamos usar as informações dos participantes que está na Wikipedia.
#o dado está relativamente arrumado, com tabelas fáceis de raspar

#salvando o link do artigo:
url <- ("https://pt.wikipedia.org/wiki/Lista_de_participantes_do_Big_Brother_Brasil")

#usando o pacote rvest para extrair todos os elementos do tipo tabela da página
bbb <- url %>%
  read_html() %>%
  html_nodes("table") %>%
  html_table()

#o resultado é uma lista de 19 dataframes - desses, 18 são as listas de participantes.
# as tabelas contém a mesma informação:
# Nome da/o participante
# Data de nascimento
# Profissão/ocupação (declarada)
# Origem/Cidade natal
# Resultado/ordem de eliminação
# Número da nota de rodapé do artigo com as referências das informações

#O único problema é que a ordem das colunas muda entre os anos e não conseguimos juntar todos automaticamente

#fazemos dois loops para extrair as tabelas da lista de tabelas que o rvest coletou, renomear as colunas e juntar num banco só:

#para os BBB entre 2002 e 2012
participantes12 <- data.frame()
for (i in 1:12) {
  tabelas <- as.data.frame(bbb[[i]])
  names(tabelas) <- c("nome", "nascimento","profissao", "origem", "resultado", "ref")
  participantes12 <- rbind(participantes12, tabelas)
}

#para os BBB entre 2013 e 2018
participantes18 <- data.frame()
for (i in 13:18) {
  tabelas <- as.data.frame(bbb[[i]])
  names(tabelas) <- c("nome", "nascimento","origem", "profissao", "resultado", "ref")
  participantes18 <- rbind(participantes18, tabelas)
}

#juntando todos os anos:
participantes <- rbind(participantes12, participantes18)

profissoes <- participantes %>%
  select(profissao) %>%
  distinct()

