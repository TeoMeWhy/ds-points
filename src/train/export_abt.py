# %%

import pandas as pd
import sqlalchemy

from sklearn import model_selection

engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")

# %%
with open("abt.sql", 'r') as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

oot = df[df['dtRef'] == df['dtRef'].max()].copy()
df_train = df[df['dtRef'] < df['dtRef'].max()].copy()

train, test = model_selection.train_test_split(df_train,
                                               random_state=42,
                                               stratify=df_train['flChurn'])

train['partition_set_name'] = 'train'
test['partition_set_name'] = 'test'
oot['partition_set_name'] = 'oot'

# %%

df_full = pd.concat( [train,test,oot], axis=0, ignore_index=True )
df_full.to_csv("../../data/abt_churn_20240620.csv", index=False, sep=";")
