# %%
import datetime

import pandas as pd
import sqlalchemy

import mlflow

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

mlflow.set_tracking_uri(uri="http://192.168.1.100:8081")
mlflow.set_experiment(experiment_id=123789007337937125)
mlflow.autolog()

# %%

def report_metrics(y_true, y_proba, base,  cohort=0.5):

        y_pred = (y_proba[:,1]>cohort).astype(int)

        acc = metrics.accuracy_score(y_true, y_pred)
        auc = metrics.roc_auc_score(y_true, y_proba[:,1])
        precision = metrics.precision_score(y_true, y_pred)
        recall = metrics.recall_score(y_true, y_pred)

        res = {
            f'{base} Acurárica': acc,
            f'{base} Curva Roc': auc,
            f"{base} Precisão": precision,
            f"{base} Recall": recall,
            }

        return res

with mlflow.start_run():

    onehot = encoding.OneHotEncoder(variables=cat_features,
                                    drop_last=True)

    model = ensemble.GradientBoostingClassifier(random_state=42)

    params = {"learning_rate": [0.01,0.1,0.2,0.5,0.75,0.9,0.99],
            "n_estimators": [50,100,200,500],
            "subsample": [0.1,0.5,0.9],
            "min_samples_leaf":[5,10,25,50,100]
            }

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

    # Ajuste de modelo
    model_pipeline.fit(X_train, y_train)

    y_train_proba = model_pipeline.predict_proba(X_train)
    y_test_proba = model_pipeline.predict_proba(X_test)
    y_oot_proba = model_pipeline.predict_proba(df_oot[features])

    report = {}
    report.update(report_metrics(y_train, y_train_proba, 'treino'))
    report.update(report_metrics(y_test, y_test_proba, 'teste'))
    report.update(report_metrics(df_oot[target], y_oot_proba, 'ott'))
    
    mlflow.log_metrics(report)
