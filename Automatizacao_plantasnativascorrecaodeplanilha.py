import pandas as pd

# Carregar o arquivo Excel
excel_file = "Plantasnativas.xlsx"
df = pd.read_excel(excel_file)

# Criar a nova coluna "especie" mesclando "genero" e "Epiteto"
df['especie'] = df['genero'] + ' ' + df['Epiteto']

# Salvar o DataFrame atualizado de volta no arquivo Excel
df.to_excel(excel_file, index=False)

print("Coluna 'especie' adicionada com sucesso!")
