# %%

import pandas as pd
import sqlalchemy
from sqlalchemy import exc

print("Scrip para execução de modelos iniciado!")


print("Carregando modelo...")
model_series = pd.read_pickle("../../models/rf_teo_fim_curso.pkl")
model_series

print("Carregando base para score...")
engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")
with open("etl.sql", 'r') as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

print("Realizando predições...")
pred = model_series['model'].predict_proba(df[model_series['features']])
proba_churn = pred[:,1]

print("Persistindo dados...")
df_predict = df[['dtRef', 'idCustomer']].copy()
df_predict['probaChurn'] = proba_churn.copy()
df_predict = (df_predict.sort_values("probaChurn", ascending=False)
                        .reset_index(drop=True))

with engine.connect() as con:
    state = f"DELETE FROM tb_churn WHERE dtRef = '{df_predict['dtRef'].min()}';"

    try:
        state = sqlalchemy.text(state)
        con.execute(state)
        con.commit()
    except exc.OperationalError as err:
        print("Tabela ainda não existe...")

df_predict.to_sql("tb_churn", engine, if_exists='append', index=False)

print("Fim.")