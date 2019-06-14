---
title: 練習以gensim訓練詞向量
subtitle: 利用wiki data來建立word2vec向量模型
tags: [gensim, word, vector, wiki, LOPE]
date: '2019-05-23'
author: Yolanda Chen
mysite: /yolanda_chen/
comment: yes
---


### Modules


```python
from collections import Counter
import nltk
import json
import pandas
import pickle
import gensim
from gensim import corpora, models, similarities, matutils
from gensim.corpora import WikiCorpus
from gensim import models
import logging
from gensim.models import word2vec
from sklearn import feature_extraction
from sklearn.feature_extraction.text import TfidfVectorizer
import logging
import sys
import jieba
```

# 1. 取得語料
### 1-1 取得中文維基數據，本次練習是採用 2018/12/20 的資料。（https://zh.wikipedia.org/wiki/Wikipedia:%E6%95%B0%E6%8D%AE%E5%BA%93%E4%B8%8B%E8%BD%BD）
### 1-2 將下載後的維基數據置於與專案同個目錄，再使用wiki_to_txt.py從 xml 中提取出維基文


```python
input_file = 'zhwiki-20181220-pages-articles.xml.bz2'
f = open('zhwiki.txt', encoding='utf8', mode='w')
wiki =  gensim.corpora.WikiCorpus(input_file, lemmatize=False, dictionary={})
for text in wiki.get_texts():
    str_line = ' '.join(text)
    f.write(str_line+'\n')
```


```python
{
  "name": "Traditional Chinese to Simplified Chinese",
  "segmentation": {
    "type": "mmseg",
    "dict": {
      "type": "ocd",
      "file": "TSPhrases.ocd"
    }
  },
  "conversion_chain": [{
    "dict": {
      "type": "group",
      "dicts": [{
        "type": "ocd",
        "file": "TSPhrases.ocd"
      }, {
        "type": "ocd",
        "file": "TSCharacters.ocd"
      }]
    }
  }]
}
```

# 2. 使用 OpenCC 將維基文章統一轉換為繁體中文


```python
# opencc -i zhwiki.txt -o zhwiki_tw.txt -c s2twp.json
```

# 3.  使用jieba 對文本斷詞，並去除停用詞


```python
def main():

    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

    # jieba custom setting.
    jieba.set_dictionary('/Users/airmac/Desktop/PTT/crawler/userdictionary/dict2_PTT.txt')

    # load stopwords set
    stopword_set = set()
    with open('/Users/airmac/Desktop/PTT/crawler/stopwords.txt','r', encoding='utf-8') as stopwords:
        for stopword in stopwords:
            stopword_set.add(stopword.strip('\n'))

    output = open('wiki_seg.txt', 'w', encoding='utf-8')
    with open('zhwiki_tw.txt', 'r', encoding='utf-8') as content :
        for texts_num, line in enumerate(content):
            line = line.strip('\n')
            words = jieba.cut(line, cut_all=False)
            for word in words:
                if word not in stopword_set:
                    output.write(word + ' ')
            output.write('\n')

            if (texts_num + 1) % 10000 == 0:
                logging.info("已完成前 %d 行的斷詞" % (texts_num + 1))
    output.close()

if __name__ == '__main__':
    main()
```

# 4. 使用gensim 的 word2vec 模型進行訓練


```python
def main():

    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)
    sentences = word2vec.LineSentence('./wiki_seg.txt') #specify file name
    model_SG = word2vec.Word2Vec(sentences, size=250, window = 10, sg = 1, min_count = 3)

    #保存模型，供日後使用
    model_SG.save("word2vec.model_wiki")

    #模型讀取方式
    model_SG = word2vec.Word2Vec.load("word2vec.model_wiki")

if __name__ == "__main__":
    main()
```

    2019-05-22 22:01:52,765 : WARNING : consider setting layer size to a multiple of 4 for greater performance
    2019-05-22 22:01:52,770 : INFO : collecting all words and their counts
    2019-05-22 22:01:52,778 : INFO : PROGRESS: at sentence #0, processed 0 words, keeping 0 word types
    2019-05-22 22:01:52,866 : INFO : collected 33301 word types from a corpus of 102451 raw words and 60 sentences
    2019-05-22 22:01:52,868 : INFO : Loading a fresh vocabulary
    2019-05-22 22:01:52,919 : INFO : effective_min_count=3 retains 5983 unique words (17% of original 33301, drops 27318)
    2019-05-22 22:01:52,920 : INFO : effective_min_count=3 leaves 71078 word corpus (69% of original 102451, drops 31373)
    2019-05-22 22:01:52,951 : INFO : deleting the raw counts dictionary of 33301 items
    2019-05-22 22:01:52,955 : INFO : sample=0.001 downsamples 21 most-common words
    2019-05-22 22:01:52,960 : INFO : downsampling leaves estimated 68690 word corpus (96.6% of prior 71078)
    2019-05-22 22:01:52,994 : INFO : estimated required memory for 5983 words and 250 dimensions: 14957500 bytes
    2019-05-22 22:01:52,996 : INFO : resetting layer weights
    2019-05-22 22:01:53,179 : INFO : training model with 3 workers on 5983 vocabulary and 250 features, using sg=1 hs=0 sample=0.001 negative=5 window=10
    2019-05-22 22:01:54,255 : INFO : EPOCH 1 - PROGRESS: at 90.00% examples, 50287 words/s, in_qsize 3, out_qsize 0
    2019-05-22 22:01:54,341 : INFO : worker thread finished; awaiting finish of 2 more threads
    2019-05-22 22:01:54,418 : INFO : worker thread finished; awaiting finish of 1 more threads
    2019-05-22 22:01:54,431 : INFO : worker thread finished; awaiting finish of 0 more threads
    2019-05-22 22:01:54,433 : INFO : EPOCH - 1 : training on 102451 raw words (68607 effective words) took 1.2s, 54897 effective words/s
    2019-05-22 22:01:55,467 : INFO : EPOCH 2 - PROGRESS: at 91.67% examples, 57833 words/s, in_qsize 2, out_qsize 1
    2019-05-22 22:01:55,469 : INFO : worker thread finished; awaiting finish of 2 more threads
    2019-05-22 22:01:55,581 : INFO : worker thread finished; awaiting finish of 1 more threads
    2019-05-22 22:01:55,588 : INFO : worker thread finished; awaiting finish of 0 more threads
    2019-05-22 22:01:55,589 : INFO : EPOCH - 2 : training on 102451 raw words (68708 effective words) took 1.2s, 59635 effective words/s
    2019-05-22 22:01:56,674 : INFO : EPOCH 3 - PROGRESS: at 73.33% examples, 38248 words/s, in_qsize 5, out_qsize 0
    2019-05-22 22:01:56,902 : INFO : worker thread finished; awaiting finish of 2 more threads
    2019-05-22 22:01:56,957 : INFO : worker thread finished; awaiting finish of 1 more threads
    2019-05-22 22:01:56,963 : INFO : worker thread finished; awaiting finish of 0 more threads
    2019-05-22 22:01:56,964 : INFO : EPOCH - 3 : training on 102451 raw words (68678 effective words) took 1.4s, 50068 effective words/s
    2019-05-22 22:01:57,988 : INFO : EPOCH 4 - PROGRESS: at 91.67% examples, 58560 words/s, in_qsize 2, out_qsize 1
    2019-05-22 22:01:57,990 : INFO : worker thread finished; awaiting finish of 2 more threads
    2019-05-22 22:01:58,048 : INFO : worker thread finished; awaiting finish of 1 more threads
    2019-05-22 22:01:58,060 : INFO : worker thread finished; awaiting finish of 0 more threads
    2019-05-22 22:01:58,061 : INFO : EPOCH - 4 : training on 102451 raw words (68717 effective words) took 1.1s, 62989 effective words/s
    2019-05-22 22:01:59,027 : INFO : worker thread finished; awaiting finish of 2 more threads
    2019-05-22 22:01:59,083 : INFO : EPOCH 5 - PROGRESS: at 98.33% examples, 64132 words/s, in_qsize 1, out_qsize 1
    2019-05-22 22:01:59,085 : INFO : worker thread finished; awaiting finish of 1 more threads
    2019-05-22 22:01:59,087 : INFO : worker thread finished; awaiting finish of 0 more threads
    2019-05-22 22:01:59,090 : INFO : EPOCH - 5 : training on 102451 raw words (68663 effective words) took 1.0s, 67162 effective words/s
    2019-05-22 22:01:59,092 : INFO : training on a 512255 raw words (343373 effective words) took 5.9s, 58084 effective words/s
    2019-05-22 22:01:59,094 : INFO : saving Word2Vec object under word2vec.model_wiki, separately None
    2019-05-22 22:01:59,096 : INFO : not storing attribute vectors_norm
    2019-05-22 22:01:59,098 : INFO : not storing attribute cum_table
    2019-05-22 22:01:59,421 : INFO : saved word2vec.model_wiki
    2019-05-22 22:01:59,425 : INFO : loading Word2Vec object from word2vec.model_wiki
    2019-05-22 22:01:59,651 : INFO : loading wv recursively from word2vec.model_wiki.wv.* with mmap=None
    2019-05-22 22:01:59,652 : INFO : setting ignored attribute vectors_norm to None
    2019-05-22 22:01:59,655 : INFO : loading vocabulary recursively from word2vec.model_wiki.vocabulary.* with mmap=None
    2019-05-22 22:01:59,657 : INFO : loading trainables recursively from word2vec.model_wiki.trainables.* with mmap=None
    2019-05-22 22:01:59,662 : INFO : setting ignored attribute cum_table to None
    2019-05-22 22:01:59,664 : INFO : loaded word2vec.model_wiki


# 5. 測試訓練模型


```python
def main():
	logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)
	model_SG = word2vec.Word2Vec.load("word2vec.model_wiki")

	print("提供 3 種測試模式\n")
	print("輸入一個詞，則去尋找前一百個該詞的相似詞")
	print("輸入兩個詞，則去計算兩個詞的餘弦相似度")
	print("輸入三個詞，進行類比推理")

	while True:
		try:
			query = input()
			q_list = query.split()

			if len(q_list) == 1:
				print("相似詞前 100 排序")
				res = model_SG.most_similar(q_list[0],topn = 100)
				for item in res:
					print(item[0]+","+str(item[1]))

			elif len(q_list) == 2:
				print("計算 Cosine 相似度")
				res = model_SG.similarity(q_list[0],q_list[1])
				print(res)
			else:
				print("%s之於%s，如%s之於" % (q_list[0],q_list[2],q_list[1]))
				res = model_SG.most_similar([q_list[0],q_list[1]], [q_list[2]], topn= 100)
				for item in res:
					print(item[0]+","+str(item[1]))
			print("----------------------------")
		except Exception as e:
			print(repr(e))

if __name__ == "__main__":
	main()
```

    2019-05-23 21:00:20,461 : INFO : loading Word2Vec object from word2vec.model_wiki
    2019-05-23 21:00:20,708 : INFO : loading wv recursively from word2vec.model_wiki.wv.* with mmap=None
    2019-05-23 21:00:20,709 : INFO : setting ignored attribute vectors_norm to None
    2019-05-23 21:00:20,714 : INFO : loading vocabulary recursively from word2vec.model_wiki.vocabulary.* with mmap=None
    2019-05-23 21:00:20,716 : INFO : loading trainables recursively from word2vec.model_wiki.trainables.* with mmap=None
    2019-05-23 21:00:20,718 : INFO : setting ignored attribute cum_table to None
    2019-05-23 21:00:20,721 : INFO : loaded word2vec.model_wiki


    提供 3 種測試模式
    
    輸入一個詞，則去尋找前一百個該詞的相似詞
    輸入兩個詞，則去計算兩個詞的餘弦相似度
    輸入三個詞，進行類比推理
    維基


    /Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/ipykernel_launcher.py:17: DeprecationWarning: Call to deprecated `most_similar` (Method will be removed in 4.0.0, use self.wv.most_similar() instead).
    2019-05-23 21:00:33,550 : INFO : precomputing L2-norms of word weight vectors
    /Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/gensim/matutils.py:737: FutureWarning: Conversion of the second argument of issubdtype from `int` to `np.signedinteger` is deprecated. In future, it will be treated as `np.int64 == np.dtype(int).type`.
      if np.issubdtype(vec.dtype, np.int):


    相似詞前 100 排序
    鮑姆,0.9982941150665283
    塔能,0.9981815814971924
    專利,0.997909665107727
    奇異,0.9978553056716919
    傳送,0.9976803064346313
    坎寧安,0.9976129531860352
    下載,0.9974729418754578
    執行緒,0.9974358081817627
    git,0.9973118305206299
    原生,0.9972920417785645
    標,0.9972141981124878
    搜尋,0.9971519112586975
    磁帶機,0.9970462918281555
    相容性,0.9967495203018188
    power,0.996607780456543
    group,0.9965818524360657
    芬蘭赫爾辛,0.9965640902519226
    python,0.9965051412582397
    赫爾辛,0.9964991807937622
    用來,0.9964420795440674
    一份,0.9963663816452026
    用語,0.9963191747665405
    讀,0.9962285757064819
    專訪,0.996159553527832
    提議,0.9960776567459106
    起訴,0.995819628238678
    分享,0.9955840110778809
    路徑,0.9955559968948364
    應器,0.995527446269989
    美國國家,0.9954522848129272
    文學手,0.9951719045639038
    environment,0.995078980922699
    保證,0.9950613379478455
    理器,0.9950302839279175
    理察,0.9950070381164551
    指南,0.9949942827224731
    md,0.9949941635131836
    人選,0.99495530128479
    辦法,0.9949389696121216
    貝爾,0.9949385523796082
    屬,0.9949334263801575
    基大學,0.99492347240448
    ic,0.9949181079864502
    語法,0.994899570941925
    冊,0.9948554039001465
    縮,0.9948363304138184
    right,0.994832456111908
    nova,0.9948011636734009
    符,0.9947088956832886
    螢幕,0.9946956634521484
    幀,0.9946808815002441
    office,0.9946743249893188
    腦,0.9946178197860718
    視訊,0.9945335984230042
    佇列,0.9945131540298462
    多方面,0.9943578243255615
    創立者,0.994349479675293
    移除,0.9942220449447632
    傳記,0.9942188858985901
    賣,0.9941517114639282
    點,0.9941226243972778
    版權,0.994106113910675
    圍紀,0.9940536022186279
    根基,0.9939604997634888
    協定,0.9939593076705933
    debunking,0.9938493967056274
    工會,0.9938369989395142
    許多種,0.9937776327133179
    而來,0.9936307072639465
    此為,0.9935781955718994
    url,0.9934848546981812
    條款,0.9933880567550659
    馮諾,0.9933698773384094
    黑客,0.9932782649993896
    托勒密,0.9932543039321899
    是關,0.9930625557899475
    丹尼斯,0.9930038452148438
    教科書,0.9929787516593933
    學作,0.9929201006889343
    更名,0.9928343892097473
    瓦茲本,0.992814302444458
    simula,0.992810845375061
    通常會,0.9927802085876465
    沃德,0.9927790760993958
    wacom,0.9926408529281616
    一代,0.9926127195358276
    單元,0.9925980567932129
    學分,0.9925013184547424
    移植,0.9923980832099915
    學時,0.9923934936523438
    geographic,0.9923598766326904
    快點,0.9922834038734436
    small,0.9922333359718323
    並不,0.9922270178794861
    認證,0.9922029972076416
    安德魯,0.9921829700469971
    當年,0.9921236038208008
    有益,0.9920326471328735
    預設,0.9920238852500916
    dec,0.9919708967208862
    ----------------------------


# 6. 分析結果提取


```python
model_SG = word2vec.Word2Vec.load("word2vec.model_wiki")
```
