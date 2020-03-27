---
title: Memes(II)
subtitle: ''
tags: [lope]
date: '2020-03-26'
author: Jessica
mysite: /jessica/
comment: yes
---


## Sentence Embedding

### 1. Enviornment Setup


```python
#pip install -U pandas
```

    Collecting pandas
    [?25l  Downloading https://files.pythonhosted.org/packages/4a/6a/94b219b8ea0f2d580169e85ed1edc0163743f55aaeca8a44c2e8fc1e344e/pandas-1.0.3-cp37-cp37m-manylinux1_x86_64.whl (10.0MB)
    [K     |████████████████████████████████| 10.0MB 7.5MB/s eta 0:00:01    |██████████████████████████▉     | 8.4MB 7.5MB/s eta 0:00:01
    [?25hRequirement already satisfied, skipping upgrade: python-dateutil>=2.6.1 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from pandas) (2.8.1)
    Requirement already satisfied, skipping upgrade: numpy>=1.13.3 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from pandas) (1.17.4)
    Collecting pytz>=2017.2 (from pandas)
      Using cached https://files.pythonhosted.org/packages/e7/f9/f0b53f88060247251bf481fa6ea62cd0d25bf1b11a87888e53ce5b7c8ad2/pytz-2019.3-py2.py3-none-any.whl
    Requirement already satisfied, skipping upgrade: six>=1.5 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from python-dateutil>=2.6.1->pandas) (1.13.0)
    Installing collected packages: pytz, pandas
    Successfully installed pandas-1.0.3 pytz-2019.3
    [33mWARNING: You are using pip version 19.2.3, however version 20.0.2 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.[0m
    Note: you may need to restart the kernel to use updated packages.



```python
#pip install -U xlrd
```

    Collecting xlrd
      Using cached https://files.pythonhosted.org/packages/b0/16/63576a1a001752e34bf8ea62e367997530dc553b689356b9879339cf45a4/xlrd-1.2.0-py2.py3-none-any.whl
    Installing collected packages: xlrd
    Successfully installed xlrd-1.2.0
    [33mWARNING: You are using pip version 19.2.3, however version 20.0.2 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.[0m
    Note: you may need to restart the kernel to use updated packages.



```python
#pip install -U sentence-transformers
```

    Collecting sentence-transformers
      Using cached https://files.pythonhosted.org/packages/07/32/e3d405806ea525fd74c2c79164c3f7bc0b0b9811f27990484c6d6874c76f/sentence-transformers-0.2.5.1.tar.gz
    Collecting transformers==2.3.0 (from sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/50/10/aeefced99c8a59d828a92cc11d213e2743212d3641c87c82d61b035a7d5c/transformers-2.3.0-py3-none-any.whl
    Collecting tqdm (from sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/47/55/fd9170ba08a1a64a18a7f8a18f088037316f2a41be04d2fe6ece5a653e8f/tqdm-4.43.0-py2.py3-none-any.whl
    Collecting torch>=1.0.1 (from sentence-transformers)
    [?25l  Downloading https://files.pythonhosted.org/packages/1a/3b/fa92ece1e58a6a48ec598bab327f39d69808133e5b2fb33002ca754e381e/torch-1.4.0-cp37-cp37m-manylinux1_x86_64.whl (753.4MB)
    [K     |████████████████████████████████| 753.4MB 47kB/s  eta 0:00:01    |█▋                              | 38.2MB 1.3MB/s eta 0:08:55     |██▍                             | 57.3MB 4.0MB/s eta 0:02:53     |██████████████▎                 | 337.4MB 3.0MB/s eta 0:02:17     |████████████████▋               | 391.0MB 1.5MB/s eta 0:04:07     |█████████████████▋              | 415.9MB 1.0MB/s eta 0:05:36     |█████████████████████▌          | 506.8MB 1.6MB/s eta 0:02:33     |█████████████████████▋          | 508.5MB 1.3MB/s eta 0:03:12     |██████████████████████          | 519.8MB 778kB/s eta 0:05:01     |████████████████████████▉       | 585.2MB 622kB/s eta 0:04:31     |█████████████████████████▊      | 605.5MB 778kB/s eta 0:03:10     |██████████████████████████▏     | 616.3MB 1.0MB/s eta 0:02:15     |████████████████████████████▏   | 662.3MB 225kB/s eta 0:06:45     |████████████████████████████▋   | 673.1MB 1.5MB/s eta 0:00:55     |██████████████████████████████▊ | 724.4MB 515kB/s eta 0:00:57
    [?25hRequirement already satisfied, skipping upgrade: numpy in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from sentence-transformers) (1.17.4)
    Collecting scikit-learn (from sentence-transformers)
    [?25l  Downloading https://files.pythonhosted.org/packages/41/b6/126263db075fbcc79107749f906ec1c7639f69d2d017807c6574792e517e/scikit_learn-0.22.2.post1-cp37-cp37m-manylinux1_x86_64.whl (7.1MB)
    [K     |████████████████████████████████| 7.1MB 1.1MB/s eta 0:00:01
    [?25hCollecting scipy (from sentence-transformers)
    [?25l  Downloading https://files.pythonhosted.org/packages/dd/82/c1fe128f3526b128cfd185580ba40d01371c5d299fcf7f77968e22dfcc2e/scipy-1.4.1-cp37-cp37m-manylinux1_x86_64.whl (26.1MB)
    [K     |████████████████████████████████| 26.1MB 1.1MB/s eta 0:00:01
    [?25hCollecting nltk (from sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/f6/1d/d925cfb4f324ede997f6d47bea4d9babba51b49e87a767c170b77005889d/nltk-3.4.5.zip
    Requirement already satisfied, skipping upgrade: requests in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from transformers==2.3.0->sentence-transformers) (2.22.0)
    Collecting sentencepiece (from transformers==2.3.0->sentence-transformers)
    [?25l  Downloading https://files.pythonhosted.org/packages/11/e0/1264990c559fb945cfb6664742001608e1ed8359eeec6722830ae085062b/sentencepiece-0.1.85-cp37-cp37m-manylinux1_x86_64.whl (1.0MB)
    [K     |████████████████████████████████| 1.0MB 674kB/s eta 0:00:01
    [?25hCollecting boto3 (from transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/bb/dc/7747cca8223bb62b8c2cc7aa65f860a9f0d454fbf8566e6da2d61e27fdcd/boto3-1.12.25-py2.py3-none-any.whl
    Collecting sacremoses (from transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/a6/b4/7a41d630547a4afd58143597d5a49e07bfd4c42914d8335b2a5657efc14b/sacremoses-0.0.38.tar.gz
    Collecting regex!=2019.12.17 (from transformers==2.3.0->sentence-transformers)
    [?25l  Downloading https://files.pythonhosted.org/packages/49/6b/b8dbb406ff9c1df97ca591050ba9b7252b1b4d491555d182d463ea72cc11/regex-2020.2.20-cp37-cp37m-manylinux2010_x86_64.whl (689kB)
    [K     |████████████████████████████████| 696kB 409kB/s eta 0:00:01
    [?25hCollecting joblib>=0.11 (from scikit-learn->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/28/5c/cf6a2b65a321c4a209efcdf64c2689efae2cb62661f8f6f4bb28547cf1bf/joblib-0.14.1-py2.py3-none-any.whl
    Requirement already satisfied, skipping upgrade: six in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from nltk->sentence-transformers) (1.13.0)
    Requirement already satisfied, skipping upgrade: chardet<3.1.0,>=3.0.2 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from requests->transformers==2.3.0->sentence-transformers) (3.0.4)
    Requirement already satisfied, skipping upgrade: urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from requests->transformers==2.3.0->sentence-transformers) (1.25.7)
    Requirement already satisfied, skipping upgrade: certifi>=2017.4.17 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from requests->transformers==2.3.0->sentence-transformers) (2019.11.28)
    Requirement already satisfied, skipping upgrade: idna<2.9,>=2.5 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from requests->transformers==2.3.0->sentence-transformers) (2.8)
    Collecting jmespath<1.0.0,>=0.7.1 (from boto3->transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/a3/43/1e939e1fcd87b827fe192d0c9fc25b48c5b3368902bfb913de7754b0dc03/jmespath-0.9.5-py2.py3-none-any.whl
    Collecting s3transfer<0.4.0,>=0.3.0 (from boto3->transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/69/79/e6afb3d8b0b4e96cefbdc690f741d7dd24547ff1f94240c997a26fa908d3/s3transfer-0.3.3-py2.py3-none-any.whl
    Collecting botocore<1.16.0,>=1.15.25 (from boto3->transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/6f/00/476ae0cc6410c198c30ac397b2c3dc4cba9033ac80741f923510514a328c/botocore-1.15.25-py2.py3-none-any.whl
    Collecting click (from sacremoses->transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/dd/c0/4d8f43a9b16e289f36478422031b8a63b54b6ac3b1ba605d602f10dd54d6/click-7.1.1-py2.py3-none-any.whl
    Collecting docutils<0.16,>=0.10 (from botocore<1.16.0,>=1.15.25->boto3->transformers==2.3.0->sentence-transformers)
      Using cached https://files.pythonhosted.org/packages/22/cd/a6aa959dca619918ccb55023b4cb151949c64d4d5d55b3f4ffd7eee0c6e8/docutils-0.15.2-py3-none-any.whl
    Requirement already satisfied, skipping upgrade: python-dateutil<3.0.0,>=2.1 in /home/jl8394/.pyenv/versions/3.7.5/envs/humor/lib/python3.7/site-packages (from botocore<1.16.0,>=1.15.25->boto3->transformers==2.3.0->sentence-transformers) (2.8.1)
    Building wheels for collected packages: sentence-transformers, nltk, sacremoses
      Building wheel for sentence-transformers (setup.py) ... [?25ldone
    [?25h  Created wheel for sentence-transformers: filename=sentence_transformers-0.2.5.1-cp37-none-any.whl size=67079 sha256=3d32eee8cbc4072860b5da8bcfe9d961400aef1d56a48ae77fcf5f98f345d96c
      Stored in directory: /home/jl8394/.cache/pip/wheels/22/ca/b4/7ca542b411730a8840f8e090df2ddacffa1c4dd9f209684c19
      Building wheel for nltk (setup.py) ... [?25ldone
    [?25h  Created wheel for nltk: filename=nltk-3.4.5-cp37-none-any.whl size=1449906 sha256=e5bfd347e740447d49895dcefa10908119773ef5444c94bbc001dc9a7063e397
      Stored in directory: /home/jl8394/.cache/pip/wheels/96/86/f6/68ab24c23f207c0077381a5e3904b2815136b879538a24b483
      Building wheel for sacremoses (setup.py) ... [?25ldone
    [?25h  Created wheel for sacremoses: filename=sacremoses-0.0.38-cp37-none-any.whl size=884628 sha256=00a0dae7ea903d508c8dd7bbb586c1a8444b188c9fd399869f20ab623ce19b8b
      Stored in directory: /home/jl8394/.cache/pip/wheels/6d/ec/1a/21b8912e35e02741306f35f66c785f3afe94de754a0eaf1422
    Successfully built sentence-transformers nltk sacremoses
    Installing collected packages: sentencepiece, jmespath, docutils, botocore, s3transfer, boto3, regex, click, joblib, tqdm, sacremoses, transformers, torch, scipy, scikit-learn, nltk, sentence-transformers
    Successfully installed boto3-1.12.25 botocore-1.15.25 click-7.1.1 docutils-0.15.2 jmespath-0.9.5 joblib-0.14.1 nltk-3.4.5 regex-2020.2.20 s3transfer-0.3.3 sacremoses-0.0.38 scikit-learn-0.22.2.post1 scipy-1.4.1 sentence-transformers-0.2.5.1 sentencepiece-0.1.85 torch-1.4.0 tqdm-4.43.0 transformers-2.3.0
    [33mWARNING: You are using pip version 19.2.3, however version 20.0.2 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.[0m
    Note: you may need to restart the kernel to use updated packages.



```python
import pandas as pd
import pandas
import csv
```

### 2. 讀取檔案: 梗圖的字幕及模板名稱（均為句子）


```python
rd1= pd.read_excel("Annotation.xlsx", sheet_name='Offensive')
Offocr=rd1.iloc[:,1]
Offocr=list(Offocr)
```


```python
Offtm=rd1.iloc[:,2]
Offtm=list(Offtm)
```


```python
rd2= pd.read_excel("Annotation.xlsx", sheet_name='Non-offensive')
Nfocr=rd2.iloc[:,1]
Nfocr=list(Nfocr)

```


```python
rd2= pd.read_excel("Annotation.xlsx", sheet_name='Non-offensive')
Nftm=rd2.iloc[:,2]
Nftm=list(Nftm)
```

### 3. 將句子轉化為 sentence embedding


```python
from sentence_transformers import SentenceTransformer
```

#### Pre-trained English models: BERT-base model with mean-tokens pooling


```python
model = SentenceTransformer('bert-base-nli-mean-tokens')
```

    100%|██████████| 405M/405M [05:52<00:00, 1.15MB/s]   


#### Pre-trained Multilingual Models


```python
model2=SentenceTransformer('distiluse-base-multilingual-cased')
```

#### Map a sentence to a sentence embedding


```python
sentences = Nftm
sentence_embeddings = model2.encode(sentences)
#sentences[0] #for checking
```

Note:跑出來的話檔案會太大，所以先＃掉


```python
#for sentence, embedding in zip(sentences, sentence_embeddings):
    #print("Sentence:", sentence)
    #print("Embedding:", embedding)
    #print("")
```

### 4. 將句子及embedding寫入CSV檔


```python
with open('nftm.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerows(zip(sentences, sentence_embeddings))
```

### Reference:
- [PyPi: sentence-transformers 0.2.5.1](https://pypi.org/project/sentence-transformers/#pretrained-models)
- [Richer Sentence Embeddings using Sentence-BERT — Part I](https://medium.com/genei-technology/richer-sentence-embeddings-using-sentence-bert-part-i-ce1d9e0b1343)

