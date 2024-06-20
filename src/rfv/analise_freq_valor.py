# %%
import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn import cluster
from sklearn import tree
from sklearn import preprocessing

# %%
engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")

query = '''

SELECT *
FROM fs_general
WHERE dtRef = (select max(dtRef) FROM fs_general)

'''

df = pd.read_sql(query, engine)
df
# %%
plt.figure(dpi=400)
sns.set_theme(style="darkgrid")
sns.scatterplot(
    data=df,
    x="valorPoints",
    y="frequenciaDias",
)

plt.title("Frequencia vs Valor")
plt.show()
# %%


minmax = preprocessing.MinMaxScaler()

X_trans = minmax.fit_transform(df[['valorPoints','frequenciaDias']])

# cluster_method = cluster.KMeans(n_clusters=5)
cluster_method = cluster.AgglomerativeClustering(linkage='ward',n_clusters=5,)
cluster_method.fit(X_trans)

df['cluster'] = cluster_method.labels_

plt.figure(dpi=400)

for i in df['cluster'].unique():
    data = df[df['cluster']==i]
    sns.scatterplot(
    data=data,
    x="valorPoints",
    y="frequenciaDias",
    )

plt.hlines(7.5, xmin=0,xmax=3000)
plt.hlines(3.5, xmin=0,xmax=3000)
plt.hlines(10.5, xmin=0,xmax=3000)
plt.vlines(500, ymin=0,ymax=18)
plt.vlines(1500, ymin=0,ymax=18)

plt.show()
df.groupby("cluster")['idCustomer'].count()

# %%

def rf_cluster(row):

    if (row['valorPoints'] < 500):
        if (row['frequenciaDias'] < 3.5):
            return "01-BB"
    
        elif (row['frequenciaDias'] < 7.5):
            return "02-MB"
        
        elif (row['frequenciaDias'] < 10.5):
            return "03-AB"
        
        else:
            return "04-SB"

    elif (row['valorPoints'] < 1600):
        if (row['frequenciaDias'] < 3.5):
            return "05-BM"
    
        elif (row['frequenciaDias'] < 7.5):
            return "06-MM"
        
        elif (row['frequenciaDias'] < 10.5):
            return "07-AM"
        
        else:
            return "08-SM"
        
    else:
        if (row['frequenciaDias'] < 3.5):
            return "09-BA"
    
        elif (row['frequenciaDias'] < 7.5):
            return "10-MA"
        
        elif (row['frequenciaDias'] < 10.5):
            return "11-AA"
        
        else:
            return "12-SA"

df['cluster_rf'] = df.apply(rf_cluster, axis=1)

plt.figure(dpi=400)

for i in df['cluster_rf'].unique():
    data = df[df['cluster_rf']==i]
    sns.scatterplot(
    data=data,
    x="valorPoints",
    y="frequenciaDias",
    )

plt.title("Cluster Frequencia vs Valor")
plt.legend(df['cluster_rf'].unique())

# %%

clf = tree.DecisionTreeClassifier(random_state=42,
                                  min_samples_leaf=1,
                                  max_depth=None)

clf.fit(df[['frequenciaDias', 'valorPoints']], df['cluster_rf'])

model_freq_valor = pd.Series(
    {"model": clf,
    "features": ['frequenciaDias', 'valorPoints']}
)

model_freq_valor.to_pickle("../../models/cluster_fv.pkl")

# %%

