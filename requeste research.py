import requests
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

##### Para salvar em pdf ########
# Carregar a lista de espécies do arquivo especies.xlsx
import pandas as pd

df = pd.read_excel('especies.xlsx')
especies = df['Especie'].tolist()

# Palavras-chave relacionadas à polinização
palavras_chave = ['polinizacao', 'polinizador', 'flores', 'pollinator']

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

            # Extrair e formatar os nomes dos autores
            authors = []
            for author in article.get('author', []):
                if 'given' in author and 'family' in author:
                    author_name = f"{author['given']} {author['family']}"
                elif 'name' in author:
                    author_name = author['name']
                else:
                    author_name = 'Autor desconhecido'
                authors.append(author_name)

            # Verificar a data de publicação
            if 'published-print' in article:
                pub_date = str(article['published-print']['date-parts'][0][0])
            elif 'published-online' in article:
                pub_date = str(article['published-online']['date-parts'][0][0])
            else:
                pub_date = 'N/A'

            # Criar um arquivo PDF para cada artigo
            pdf_filename = f"artigo_{index}.pdf"
            c = canvas.Canvas(pdf_filename, pagesize=letter)
            c.drawString(100, 750, "Título: " + title)
            c.drawString(100, 730, "Autor(es): " + ', '.join(authors))
            c.drawString(100, 710, "Ano: " + pub_date)
            c.drawString(100, 690, "Palavras-chave: " + query)
            c.save()

            print(f"Artigo salvo em {pdf_filename}")

        print("-" * 50)

print("Busca concluída.")
