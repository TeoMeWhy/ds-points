# %%

import pandas as pd

from sklearn import model_selection
from sklearn import ensemble
from sklearn import pipeline
from sklearn import metrics

from feature_engine import selection
from feature_engine import encoding

# %%

## SAMPLE
df = pd.read_excel("../../data/abt_churn.xlsx")

target = 'flChurn'
features = df.columns.tolist()[4:]

# %%
### DATA PARTITION
df_oot = df[ df['dtRef'] == df['dtRef'].max()]

df_train = df[ df['dtRef'] < df['dtRef'].max()]

# %%
### SAMPLING

X_train, X_test, y_train, y_test = model_selection.train_test_split(
    df_train[features], df_train[target],
    train_size=0.8,
    random_state=42,
    stratify=df_train[target]
)

print("Taxa de resposta Train:", y_train.mean())
print("Taxa de resposta Test:", y_test.mean())

# %%
## EXPLORE
describe = X_train.describe()
na_values = X_train.isna().sum().sort_values()

df_eda = X_train
df_eda[target] = y_train
df_eda.groupby(["flChurn"]).describe().T.head(50)

# %%
## MODIFY

cat_features = X_train.dtypes[X_train.dtypes == 'object'].index.tolist()
X_train[cat_features]

to_drop = ['pointsPorDia', 'avgChatLive']

drop = selection.DropFeatures(features_to_drop=to_drop)
onehot = encoding.OneHotEncoder(variables=['productMaxQtde'])

# %%
# MODEL

model = ensemble.RandomForestClassifier(random_state=42)

params = {
    "max_depth": [4,5,8,10,15],
    "min_samples_leaf": [10,15,20,50,100],
    "n_estimators":[100,200,500]
}

grid = model_selection.GridSearchCV(model,
                                    param_grid=params,
                                    scoring='roc_auc',
                                    cv=3,
                                    n_jobs=10)

# %%

model_pipe = pipeline.Pipeline([
    ('drop', drop),
    ('onehot', onehot),
    ('model', grid)
])

model_pipe.fit(X_train[features], y_train)

# %%
## ASSESS

train_pred = model_pipe.predict_proba(X_train[features])
test_pred = model_pipe.predict_proba(X_test[features])
oot_pred = model_pipe.predict_proba(df_oot[features])

auc_train = metrics.roc_auc_score(y_train, train_pred[:,1])
auc_test = metrics.roc_auc_score(y_test, test_pred[:,1])
auc_oot = metrics.roc_auc_score(df_oot[target], oot_pred[:,1])

print("AUC Score train:", auc_train)
print("AUC Score test:", auc_test)
print("AUC Score oot:", auc_oot)

metrics_values = {
    "train": auc_train,
    "test": auc_test,
    "oot": auc_oot,
}

model_export = pd.Series(
    {
        "model":model_pipe,
        "features":features,
        "metrics": metrics_values,
     }
)

model_export.to_pickle("../../models/rf_2024_06_19.pkl")