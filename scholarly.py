import scholarly
import pandas as pd

# Carregar a lista de espécies do arquivo especies.xlsx
df = pd.read_excel('especies.xlsx')
especies = df['Especie'].tolist()

# Palavras-chave relacionadas à polinização
palavras_chave = ['polinizacao', 'polinizador', 'flores', 'pollinator']

# Iterar sobre as espécies e palavras-chave para buscar os artigos
for especie in especies:
    for palavra_chave in palavras_chave:
        query = f'{especie} {palavra_chave}'

        print(f"Buscando artigos para '{query}'...")

        search_query = scholarly.search_pubs_query(query)

        # Iterar sobre os resultados da pesquisa
        for result in search_query:
            print(f"Título: {result['bib']['title']}")
            print(f"Autor(es): {', '.join(result['bib']['author'])}")
            print(f"Ano: {result['bib']['pub_year']}")
            print(f"Resumo: {result['bib']['abstract']}")
            print("-" * 50)

print("Busca concluída.")
