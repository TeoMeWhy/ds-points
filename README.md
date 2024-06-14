# Data Science & Points

[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

<img src="https://i.ibb.co/cc3d5Lq/teomewhy-A-little-child-wizard-wearing-a-purple-cloak-using-h-d359021c-4186-4e11-9693-a6e4f1b1b7c5-3.png" alt="teomewhy-A-little-child-wizard-wearing-a-purple-cloak-using-h-d359021c-4186-4e11-9693-a6e4f1b1b7c5-3" border="0" width=800>

Projeto de aplicação em Data Science do início ao fim. Um pipeline completo para solução de dados.

- [Sobre](#sobre)
  - [Contexto](#contexto)
  - [Etapas](#etapas)
  - [Pré-requisitos](#pré-requisitos)
- [Desafio](#desafio)
- [Sobre o autor](#sobre-o-autor)
- [Como apoiar](#apoie-essa-inciativa)

Este material está sob a licença: [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

## Sobre
Coinstruimos uma solução de Data Science, aplicando técnicas de Machine Learning para um problema de negócios específico.

Tudo foi desenvolvido ao vivo no canal [Téo Me Why](https://teomewhy.org) e disponibilizado para nossos Subs da Twitch e Membros do YouTube.

Assina aqui: [Twitch](https://www.twitch.tv/collections/jg9itHOO1ReLcw) / [YouTube](https://www.youtube.com/playlist?list=PLvlkVRRKOYFQOkwDvfgCvKi9-I1jQXiy7)

### Contexto
Temos os dados de nossos usuários de sistema de pontos do canal. Com base nisso, desejamos identificar ações e produtos de dados que aumentem o engajamento de nossos usuários.

Assim, pensamos em construir um projeto de Data Science que aborde todas as etapas necessárias para construção de um produto de dados.

### Etapas
- Construção de Feature Store;
- Processamento das safras;
- Construção da variável resposta;
- Construção da ABT (*Analytical Base Table*);
- Treinamento de modelos preditivos;
- Deploy;

### Pré-requisitos

#### Disciplinas

Para ter uma melhor experiência com nosso projeto, vale a pena conferir as seguintes playlists totalmente gratuitas:

- [Git/GitHub](https://www.youtube.com/playlist?list=PLvlkVRRKOYFQ3cfYPjLeQ0KvrQ8bG5H11)
- [Python](https://www.youtube.com/playlist?list=PLvlkVRRKOYFRXdquucikNbwYeFzzzYIGb)
- [Pandas](https://www.youtube.com/playlist?list=PLvlkVRRKOYFSl-XCxNQ1u3uOLvDnYxupG)
- [Estatística](https://www.youtube.com/playlist?list=PLvlkVRRKOYFSWIyhwq4Nu8sNd_GfOi1tj)
- [Machine Learning](https://www.youtube.com/playlist?list=PLvlkVRRKOYFTXcpttQSZmv1wDg7F3uH7o)

#### Materiais

- :arrow_lower_right: [Baixe os dados aqui!](https://drive.google.com/drive/folders/1JLzofrtaVQdo0PdUysNWjNsBdAaI21EJ?usp=sharing) :arrow_lower_left:
- :arrow_lower_right: [Acesso a Apresentação aqui!](https://docs.google.com/presentation/d/1zMTsaAeoMX9ico13PVd7_tOffE8kUH-IOA5kCjSYIx8/edit?usp=sharing) :arrow_lower_left:

#### Softwares
- [Python/Anaconda](anaconda.com/download)
- [VSCode](https://code.visualstudio.com/download)
  - [Extensão Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
  - [Extensão Jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)
  - [Extensão SQLite](https://marketplace.visualstudio.com/items?itemName=alexcvzz.vscode-sqlite)
  - [Extensão SQLTools SQLite](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-sqlite)

#### Setup

Com as ferramentas necessários instaladas, podemos criar nosso *enviroment* a partir do Anaconda (conda):

```bash
conda create --name ds_points python=3.
conda activate ds_points

pip install -r requirements.txt
```

## Desafio

Durante o nosso curso realizamos o treinamento de um modelo Random Forest com GridSearch. A partir deste modelo, obtivemos as seguintes métricas:

| Base  | Acurárica | Curva Roc |	Precisão | Recall   |
| :---: | :---:     | :---:     | ---:     | :---:    |
| **Train** | 0.819401  | 0.913987  |	0.770598 | 0.845745 |
| **Test**  | 0.747634  | 0.817416  |	0.684848 | 0.801418 |
| **Oot**   | 0.741602  | 0.814528  |	0.669291 | 0.594406 |

Utilize os dados [deste link](https://docs.google.com/spreadsheets/d/1zcP7CKDcqEkhK2b_g27yGY226ZaX_kX4UxBsNQfM9RQ/edit?usp=sharing) para tentar melhorar a performance do modelo na base Out of Time (oot).

Considere:

```python

target = 'flChurn'
features = df_train.columns[3:].tolist()

# Dataframe oot
df_oot = df[df['dtRef']==df['dtRef'].max()]

# Dataframe de treino
df_train = df[df['dtRef']<df['dtRef'].max()]

X_train, X_test, y_train, y_test = model_selection.train_test_split(df_train[features],
                                                                    df_train[target],
                                                                    random_state=42,
                                                                    train_size=0.8,
                                                                    stratify=df_train[target])

```

## Sobre o autor

Téo é um entusiasta do universo de dados, traz consigo uma rica jornada nas esferas de Data Science e Analytics. Como líder, destacou-se na condução estratégica de equipes, liderando pessoas e projetos de Advanced Analytics. Sua visão inovadora, não apenas transformou a cultura organizacional, mas também impulsionou a implementação de diversos projetos de dados, integrando de maneira eficiente áreas cruciais da empresa.

Além de suas realizações profissionais, Teo nutre uma paixão dedicada à democratização do conhecimento na área de dados e tecnologia. Por meio de sua iniciativa educacional, Téo Me Why, ele compartilha insights valiosos, promove treinamentos envolventes e disponibiliza material autoral, alcançando uma audiência global. Sua abordagem acessível e inspiradora tem impactado milhares de entusiastas, tornando o aprendizado sobre dados mais inclusivo e estimulante.

<div> 
  <a href="https://instagram.com/teomewhy" target="_blank"><img src="https://img.shields.io/badge/-Instagram-%23E4405F?style=for-the-badge&logo=instagram&logoColor=white" target="_blank"></a>
  <a href="https://www.linkedin.com/in/teocalvo/" target="_blank"><img src="https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank"></a> 
  <a href="https://www.twitch.tv/teomewhy" target="_blank"><img src="https://img.shields.io/badge/Twitch-9146FF?style=for-the-badge&logo=twitch&logoColor=white" target="_blank"></a>
  <a href="https://www.youtube.com/channel/UC-Xa9J9-B4jBOoBNIHkMMKA" target="_blank"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" target="_blank"></a>
</div>

## Apoie essa inciativa!

Realizamos um trabalho de educação na área de dados de forma gratuita, então todo apoio é importante. Confira as diferentes maneiras de nos apoiar:

- 💵 Chave Pix: pix@teomewhy.org
- 💶 LivePix: [livepix.gg/teomewhy](livepix.gg/teomewhy)
- 💷 GitHub Sponsors: [github.com/sponsors/TeoMeWhy](github.com/sponsors/TeoMeWhy)
- 💴 ApoiaSe: [apoia.se/teomewhy](apoia.se/teomewhy)
- 🎥 Membro no YouTube: [youtube.com/@teomewhy/membership](https://www.youtube.com/@teomewhy/membership)
- 🎮 Sub na Twitch: [twitch.tv/teomewhy](https://www.twitch.tv/teomewhy)
- 💌 Newsletter: [teomewhy.substack.com](https://teomewhy.substack.com/)
