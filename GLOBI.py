import requests
import pandas as pd

s = requests.Session()

def download(url, file):
    response = requests.get(url)        
    with open(file, "wb") as arquivo:   
        arquivo.write(response.content) 

data = pd.read_csv('tabela.csv')

loop = 0
for nome in data['Polinizador']:
    loop += 1
    print(f'Baixando os dados de {nome} -- {loop}|{len(data)}')
    url = f"https://api.globalbioticinteractions.org/interaction.csv?type=csv&interactionType=pollinates&limit=4096&offset=0&refutes=false&includeObservations=true&sourceTaxon={nome}&field=source_taxon_id&field=source_taxon_name&field=source_taxon_path&field=source_taxon_path_ids&field=source_specimen_occurrence_id&field=source_specimen_institution_code&field=source_specimen_collection_code&field=source_specimen_catalog_number&field=source_specimen_life_stage_id&field=source_specimen_life_stage&field=source_specimen_physiological_state_id&field=source_specimen_physiological_state&field=source_specimen_body_part_id&field=source_specimen_body_part&field=source_specimen_sex_id&field=source_specimen_sex&field=source_specimen_basis_of_record&field=interaction_type&field=target_taxon_id&field=target_taxon_name&field=target_taxon_path&field=target_taxon_path_ids&field=target_specimen_occurrence_id&field=target_specimen_institution_code&field=target_specimen_collection_code&field=target_specimen_catalog_number&field=target_specimen_life_stage_id&field=target_specimen_life_stage&field=target_specimen_physiological_state_id&field=target_specimen_physiological_state&field=target_specimen_body_part_id&field=target_specimen_body_part&field=target_specimen_sex_id&field=target_specimen_sex&field=target_specimen_basis_of_record&field=latitude&field=longitude&field=collection_time_in_unix_epoch&field=study_citation&field=study_url&field=study_source_citation&field=study_source_archive_uri"
    download(url, file=f"test{loop}.csv")

df = pd.read_csv('test1.csv')

df = df[['source_taxon_name','target_taxon_name','study_citation']]

for i in range(2, len(data)+1):
    df2 = pd.read_csv(f'test{i}.csv')[['source_taxon_name','target_taxon_name','study_citation']]
    df = pd.concat([df, df2], ignore_index=True)
    
df.to_csv('registros_admir.csv',index=False)