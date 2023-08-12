import openpyxl

# Carregar a planilha
planilha = openpyxl.load_workbook('testenativas.xlsx')
planilha_ativa = planilha.active

# Obter os valores da coluna "genero"
genero_column = planilha_ativa['A']

# Preencher os espaços vazios com base na linha anterior
valor_anterior = None
for cell in genero_column:
    if cell.value is None:
        cell.value = valor_anterior
    else:
        valor_anterior = cell.value

# Salvar as alterações
planilha.save('testenativas_modificado.xlsx')
