import requests
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import pandas as pd
from openpyxl import Workbook

# Carregar a lista de espécies do arquivo especies.xlsx
df = pd.read_excel('especies.xlsx')
especies = df['Especie'].tolist()

# Palavras-chave relacionadas à polinização
palavras_chave = ['polinizacao', 'polinizador', 'flores', 'pollinator']

# Lista para armazenar os dados dos artigos
dados_artigos = []

# Iterar sobre as espécies e palavras-chave para buscar os artigos
for especie in especies:
    for palavra_chave in palavras_chave:
        query = f'{especie} {palavra_chave}'

        print(f"Buscando artigos para '{query}'...")

        url = f"https://api.crossref.org/works?query={query}"
        response = requests.get(url)
        data = response.json()

        articles = data['message']['items']

        # Iterar sobre os resultados da pesquisa
        for index, article in enumerate(articles, start=1):
            if 'title' in article:
                title = article['title'][0]
            else:
                title = "Título não disponível"

            authors = []
            for author in article.get('author', []):
                if 'given' in author and 'family' in author:
                    author_name = f"{author['given']} {author['family']}"
                elif 'name' in author:
                    author_name = author['name']
                else:
                    author_name = 'Autor desconhecido'
                authors.append(author_name)

            if 'published-print' in article:
                pub_date = str(article['published-print']['date-parts'][0][0])
            elif 'published-online' in article:
                pub_date = str(article['published-online']['date-parts'][0][0])
            else:
                pub_date = 'N/A'

            if 'URL' in article:
                article_url = article['URL']
            else:
                article_url = 'URL não disponível'

            if 'reference' in article:
                reference = article['reference']
            else:
                reference = 'Referência bibliográfica não disponível'

            # Adicionar dados do artigo à lista
            dados_artigos.append({
                'Título': title,
                'Autor(es)': ', '.join(authors),
                'Ano': pub_date,
                'Palavras-chave': query,
                'URL': article_url,
                'Referência Bibliográfica': reference
            })

            print(f"Artigo {index} adicionado à lista de dados")

        print("-" * 50)

print("Busca concluída.")

# Salvar os dados em um arquivo Excel
df_resultado = pd.DataFrame(dados_artigos)
df_resultado.to_excel('dados_artigos.xlsx', index=False)

print("Dados salvos em dados_artigos.xlsx")
