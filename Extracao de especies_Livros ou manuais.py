import camelot
import pandas as pd

# Caminho para o arquivo PDF
pdf_path = "MMA2022.pdf"

# Extrair tabelas do PDF
tables = camelot.read_pdf(pdf_path, flavor="stream", pages="all")

# Converter as tabelas em DataFrames do pandas
dataframes = [table.df for table in tables]

# Juntar todos os DataFrames em um único DataFrame
combined_df = pd.concat(dataframes, ignore_index=True)

# Salvar o DataFrame em um arquivo Excel
excel_file = "MMA2022.xlsx"
combined_df.to_excel(excel_file, index=False)

print("Tabelas extraídas e salvas em formato Excel.")
