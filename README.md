# PollinatorSearch

Este código foi projetado para realizar buscas por artigos científicos relacionados à polinização de diferentes espécies de acordo com um conjunto de palavras-chave. Os resultados da busca são coletados e organizados em uma lista contendo informações relevantes sobre os artigos, incluindo título, autores, ano de publicação, palavras-chave, URL e referência bibliográfica.

Aqui está uma descrição passo a passo da funcionalidade do código:

Para a lista de abelhas (Listbees.py)
1. Carregamento das Especies:
   - Carrega uma lista de espécies a partir de um arquivo Excel chamado `especies.xlsx`.

2. Palavras-chave de Polinização:
   - Define uma lista de palavras-chave relacionadas à polinização, como "polinizacao", "polinizador", "flores" e "pollinator".

3. Busca e Coleta de Dados:
   - Itera sobre cada espécie e cada palavra-chave para buscar artigos relacionados.
   - Faz chamadas à API do CrossRef para buscar artigos que correspondam à combinação de espécie e palavra-chave.
   - Para cada artigo encontrado, coleta informações como título, autores, ano de publicação, URL e referência bibliográfica. Caso alguma informação esteja faltando, é fornecida uma mensagem indicando a indisponibilidade.

4. Armazenamento dos Dados:
   - Cria uma lista chamada `dados_artigos` para armazenar os dados de cada artigo encontrado.
   - Cada conjunto de informações de artigo é adicionado como um dicionário à lista, contendo campos como `'Título'`, `'Autor(es)'`, `'Ano'`, `'Palavras-chave'`, `'URL'` e `'Referência Bibliográfica'`.

5. Salvamento em Arquivo Excel:
   - Converte a lista de dicionários `dados_artigos` em um DataFrame do pandas para facilitar o manuseio dos dados.
   - Salva o DataFrame em um arquivo Excel chamado `dados_artigos.xlsx`. O arquivo contém uma planilha com todas as informações coletadas dos artigos.

6. Conclusão:
Esse código automatiza a busca e coleta de informações sobre artigos científicos relacionados à polinização, organizando os dados em um formato legível e acessível em um arquivo Excel. Isso pode ser útil para a criação de bases de dados ou revisões bibliográficas em estudos sobre polinização.

