# %%
import datetime

import pandas as pd
import sqlalchemy

from sklearn import ensemble
from sklearn import metrics
from sklearn import model_selection
from sklearn import pipeline

from feature_engine import encoding

# %%

# Aqui eu tenho a conexão com o banco de dados
engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")

# Aqui eu tenho a query
with open('abt.sql', 'r') as open_file:
    query = open_file.read()

# Aqui processa e tras os dados
df = pd.read_sql(query, engine)

df.head()
# %%
## Separação de bases entrei treino e oot

df_oot = df[df['dtRef']==df['dtRef'].max()]
df_train = df[df['dtRef']<df['dtRef'].max()]

# %%

target = 'flChurn'
features = df_train.columns[3:].tolist()

# %%

X_train, X_test, y_train, y_test = model_selection.train_test_split(df_train[features],
                                                                    df_train[target],
                                                                    random_state=42,
                                                                    train_size=0.8,
                                                                    stratify=df_train[target])

print("Taxa de resposta na base de Train:", y_train.mean())
print("Taxa de resposta na base de Test:", y_test.mean())
# %%
cat_features = X_train.dtypes[X_train.dtypes == 'object'].index.tolist()
num_features = list(set(features) - set(cat_features))

# %%
X_train[cat_features].describe()
X_train[cat_features].drop_duplicates()

# %%
X_train[num_features].describe().T

# %%
X_train[num_features].isna().sum().max()

# %%

onehot = encoding.OneHotEncoder(variables=cat_features,
                                drop_last=True)

model = ensemble.RandomForestClassifier(random_state=42,
                                        min_samples_leaf=25)

params = {"min_samples_leaf": [10,25,50,75, 100],
          "n_estimators": [100,200,500,1000],
          "criterion":['gini', 'entropy'],
          "max_depth":[5,8,10,12,15]}

grid = model_selection.GridSearchCV(model,
                                    param_grid=params,
                                    cv=3,
                                    scoring='roc_auc',
                                    n_jobs=-2,
                                    verbose=3)

model_pipeline = pipeline.Pipeline([
    ('One Hot Encode', onehot),
    ('Modelo', grid)
])

# %%

# Ajuste de modelo
model_pipeline.fit(X_train, y_train)

# Aplicação do modelo em diferentes bases de dados
y_train_proba = model_pipeline.predict_proba(X_train)
y_test_proba = model_pipeline.predict_proba(X_test)
y_oot_proba = model_pipeline.predict_proba(df_oot[features])

def report_metrics(y_true, y_proba, cohort=0.5):

    y_pred = (y_proba[:,1]>cohort).astype(int)

    acc = metrics.accuracy_score(y_true, y_pred)
    auc = metrics.roc_auc_score(y_true, y_proba[:,1])
    precision = metrics.precision_score(y_true, y_pred)
    recall = metrics.recall_score(y_true, y_pred)

    res = {
        'Acurárica': acc,
        'Curva Roc': auc,
        "Precisão": precision,
        "Recall": recall,
        }

    return res

report_train = report_metrics(y_train, y_train_proba)
report_train['base'] = 'Train'

report_test = report_metrics(y_test, y_test_proba)
report_test['base'] = 'Test'

report_oot = report_metrics(df_oot[target], y_oot_proba)
report_oot['base'] = 'Oot'

df_metrics = pd.DataFrame([report_train,report_test,report_oot])
print(df_metrics)

# %%

model_series = pd.Series({
    "model": model_pipeline,
    "features": features,
    "metrics": df_metrics,
    "dt_train": datetime.datetime.now()
})

model_series.to_pickle("../../models/rf_teo_fim_curso.pkl")
