import pandas as pd

# Muda a cnfiguração para exibir tudo
pd.set_option('display.max_rows', None)  # Para mostrar todas as linhas
pd.set_option('display.max_columns', None)  # Para mostrar todas as colunas
pd.set_option('display.width', None)  # Para não limitar a largura
pd.set_option('display.max_colwidth', None)  # Para não truncar o conteúdo das colunas

tabela = pd.read_csv("educacao_internet_brasil_2018_2024.csv")

# Tipo de dados da tabela
print(tabela.dtypes)

# Ajusta confirmando todos para numéricos ou substituindo por NaN e neste caso serão ignorados no caso.
tabela["percentual_com_acesso_internet"] = pd.to_numeric(tabela["percentual_com_acesso_internet"], errors='coerce')
tabela["taxa_alfabetizacao"] = pd.to_numeric(tabela["taxa_alfabetizacao"], errors='coerce')
tabela["percentual_com_ensino_superior"] = pd.to_numeric(tabela["percentual_com_ensino_superior"], errors='coerce')
tabela["renda_media_domiciliar"] = pd.to_numeric(tabela["renda_media_domiciliar"], errors='coerce')

# Drop estado, groupby ano, calcula média do restante.
media_brasil_ano = tabela.drop(columns=["estado"]).groupby("ano").mean()

# Merge da tabela original com as médias por ano (associando a média do ano ao estado)
tabela_com_media = pd.merge(tabela, media_brasil_ano, on="ano", suffixes=("", "_media"))

# Função para verificar se está acima ou abaixo da média
def comparar_com_media(row, coluna):
    if row[coluna] > row[coluna + "_media"]:
        return "Acima da média"
    elif row[coluna] < row[coluna + "_media"]:
        return "Abaixo da média"
    else:
        return "Na média"

# Aplicar a comparação para cada indicador
tabela_com_media["acesso_internet_comparacao"] = tabela_com_media.apply(comparar_com_media, axis=1, coluna="percentual_com_acesso_internet")
tabela_com_media["alfabetizacao_comparacao"] = tabela_com_media.apply(comparar_com_media, axis=1, coluna="taxa_alfabetizacao")
tabela_com_media["ensino_superior_comparacao"] = tabela_com_media.apply(comparar_com_media, axis=1, coluna="percentual_com_ensino_superior")
tabela_com_media["renda_media_comparacao"] = tabela_com_media.apply(comparar_com_media, axis=1, coluna="renda_media_domiciliar")

# Exibir o resultado final
imprimir = tabela_com_media[["estado", "ano", "percentual_com_acesso_internet", "acesso_internet_comparacao",
                        "taxa_alfabetizacao", "alfabetizacao_comparacao", "percentual_com_ensino_superior", 
                        "ensino_superior_comparacao", "renda_media_domiciliar", "renda_media_comparacao"]]

print(imprimir)

# Criar o DataFrame
df = pd.DataFrame(imprimir)

# Gerar um arquivo HTML
df.to_html("saida.html")

# Abrir automaticamente no navegador (usando a biblioteca webbrowser)
import webbrowser
webbrowser.open("saida.html")