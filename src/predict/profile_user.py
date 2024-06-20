# %%

import pandas as pd
import sqlalchemy
import datetime

cluster_recencia = pd.read_pickle("../../models/cluster_recencia.pkl")
cluster_fv = pd.read_pickle("../../models/cluster_fv.pkl")
model_churn = pd.read_pickle("../../models/rf_2024_06_19.pkl")

# %%

engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")

with open("etl.sql", 'r') as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

# %%

df['prob_churn'] = model_churn['model'].predict_proba(df[model_churn['features']])[:,1]
df['cluster_recencia'] = cluster_recencia['model'].predict(df[cluster_recencia['features']])
df['cluster_fv'] = cluster_fv['model'].predict(df[cluster_fv['features']])

columns = ['dtRef', 'idCustomer', 'prob_churn','cluster_recencia','cluster_fv']

df_final = df[columns].copy()
df_final['dtUpdate'] = datetime.datetime.now()

df_final.to_sql('customer_profile', engine, index=False, if_exists='replace')
# %%
