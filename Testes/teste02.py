import pandas as pd

# Carregar os dados do CSV
tabela = pd.read_csv("educacao_internet_brasil_2018_2024.csv")

# Pela console
print(tabela)

# Criar o DataFrame
df = pd.DataFrame(tabela)

# Gerar um arquivo HTML
df.to_html("tabela_educacao.html")

# Abrir automaticamente no navegador (usando a biblioteca webbrowser)
import webbrowser
webbrowser.open("tabela_educacao.html")