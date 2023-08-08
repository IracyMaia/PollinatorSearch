#pip install pandas

### Limpeza de dados ####

import pandas as pd

# Carregar o arquivo Excel
file_path = 'C:/Users/iracy/Documents/BeeDataBase/beefiltr.xlsx'
df = pd.read_excel(file_path, sheet_name='Planilha1', header=None)

# Remover linhas que contenham as expressões "cf.", "spp." ou "aff." na coluna B
expressions_to_remove = ['cf.', 'spp.', 'aff.']
df = df[~df[1].str.contains('|'.join(expressions_to_remove))]

# Remover linhas com apenas uma palavra ou menos de 12 caracteres
df = df[df.apply(lambda row: len(row[1].split()) > 1 and len(row[1]) >= 12, axis=1)]

# Filtrar e manter somente as duas primeiras palavras
df[1] = df[1].apply(lambda text: ' '.join(text.split()[:2]))

# Salvar o resultado de volta no arquivo Excel
df.to_excel('C:/Users/iracy/Documents/BeeDataBase/beefiltr_filtrado.xlsx', index=False, header=False)
