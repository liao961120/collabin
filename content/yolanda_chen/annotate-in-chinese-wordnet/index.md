---
title: "How to annotate in Chinese WordNet (CWN)"
subtitle: "中文詞彙網路標記小實作"
author: "Yolanda Chen"
date: "2019-03-15"
mysite: /yolanda_chen/
tags: ['cwn', 'annotation', 'lope']
comment: true
---

# How to annotate in Chinese WordNet (CWN)

## 在cwn.lite計畫中，如何標記新的lemma以及相關features是重要的。
## 在此，我們利用cwn的資料以及Sean大神的程式碼來做一點cwn標記的小實作，共分為基本graph query以及annotation兩大部分。

## I. Cwn Graph Query


```python
%load_ext autoreload
%autoreload 2
```


```python
import pickle
from CwnGraph import CwnBase, CwnAnnotator
from CwnGraph import CwnRelationType
```


```python
# load in cwn data base
cwn = CwnBase("data/cwn_graph.pyobj")
```


```python
# sense node 數目
len(cwn.V)
```




    90780



### 查詢synset以及其sense：以「看」的synset為例


```python
lemmas = cwn.find_lemma("看")
print(lemmas)
```

    [<CwnLemma: 看看_1>, <CwnLemma: 看起來_1>, <CwnLemma: 看相_1>, <CwnLemma: 看似_1>, <CwnLemma: 看成_1>, <CwnLemma: 看作_1>, <CwnLemma: 看做_1>, <CwnLemma: 看_2>, <CwnLemma: 看倌_1>, <CwnLemma: 看來_1>, <CwnLemma: 看出_1>, <CwnLemma: 看_1>, <CwnLemma: 看開_1>, <CwnLemma: 看慣_1>, <CwnLemma: 看上_1>, <CwnLemma: 看懂_1>, <CwnLemma: 看病_1>, <CwnLemma: 看官_1>, <CwnLemma: 看好_1>, <CwnLemma: 看去_1>, <CwnLemma: 看見_1>, <CwnLemma: 看齊_1>, <CwnLemma: 看法_1>, <CwnLemma: 看到_1>, <CwnLemma: 看跌_1>, <CwnLemma: 看門狗_1>, <CwnLemma: 看護_1>, <CwnLemma: 看台_1>, <CwnLemma: 看得見_1>, <CwnLemma: 看守所_1>, <CwnLemma: 看臺_1>, <CwnLemma: 看守_1>, <CwnLemma: 看穿_1>, <CwnLemma: 看錯_1>, <CwnLemma: 看透_1>, <CwnLemma: 看家_1>, <CwnLemma: 看不起_1>, <CwnLemma: 看得起_1>, <CwnLemma: 看樣子_1>, <CwnLemma: 看書_1>, <CwnLemma: 看電視_1>]


### 查詢synset以及其sense：以「看看_1」的sense為例


```python
lemma0 = lemmas[0]
senses = lemma0.senses
print(senses)
```

    [<CwnSense[04004301](看看): 用眼睛察覺，但限於不經意或時間短暫。>, <CwnSense[04004302](看看): 仔細察看特定對象。>, <CwnSense[04004303](看看): 仔細觀察，做為判斷或決定的標準。>, <CwnSense[04004304](看看): 透過視覺來理解或欣賞。>, <CwnSense[04004305](看看): 拜訪、探望後述對象。>, <CwnSense[04004306](看看): 醫生診治病人。>, <CwnSense[04004307](看看): 病人接受診治。>, <CwnSense[04004308](看看): 思考後述問題，以便做出決定。>, <CwnSense[04004309](看看): 時態標記。表事件或動作的嘗試貌，表時間短暫或不經意。>, <CwnSense[04004310](看看): 檢查。>]


### 查詢sense的例句和PoS


```python
senses[0].data()
```




    {'annot': {},
     'def': '用眼睛察覺，但限於不經意或時間短暫。',
     'examples': ['欸欸欸，你<看看>，這我們的存款簿，怎麼好幾個月都沒存錢進去了？',
      '找本書，找一個山明水秀的地方，好好的輕鬆一下、靜一靜、<看看>書。',
      '最近常經過這些擠滿人的書店，才鼓起勇氣不妨進去<看看>，為什麼那麼吸引人？',
      '天未明時，我走到屋外，抬頭<看看>天空，只見月兒彎彎，群星為伴，讓人感覺到那分寂靜之美。',
      '廣場的對面是一個像高雄火車站那樣的建築物。我<看看>車站的名字，那站名是我聞所未聞的。'],
     'node_type': 'sense',
     'pos': 'VC'}



### 查詢synset以及其sense：查詢「看看_1」每個sense與其他lemma/sense的語意關係


```python
for sense_x in senses:
    print(sense_x)
    print(sense_x.relations)
    print("--")
```

    <CwnSense[04004301](看看): 用眼睛察覺，但限於不經意或時間短暫。>
    [('hypernym', <CwnSense[04018301](視): 用眼睛察覺。>), ('hypernym', <CwnSense[06755201](觀望): 用眼睛察覺。>), ('hypernym', <CwnSense[07074701](覽): 用眼睛察覺。>), ('hypernym', <CwnSense[09186103](窺): 用眼睛察覺。>), ('hypernym', <CwnSense[09126701](睹): 用眼睛察覺。>), ('hypernym', <CwnSense[04004501](看): 用眼睛察覺。>), ('hyponym(rev)', <CwnSense[04004501](看): 用眼睛察覺。>), ('hyponym(rev)', <CwnSense[04018301](視): 用眼睛察覺。>), ('hyponym(rev)', <CwnSense[06755201](觀望): 用眼睛察覺。>)]
    --
    <CwnSense[04004302](看看): 仔細察看特定對象。>
    [('synonym', <CwnSense[06529201](觀察): 仔細察看特定對象。>), ('varword', <CwnSense[06667502](看到): 仔細察看特定對象，強調動作的結果。>), ('synonym', <CwnSense[04004502](看): 仔細察看特定對象。>), ('synonym', <CwnSense[06596301](觀): 仔細察看特定對象。>), ('synonym(rev)', <CwnSense[06529201](觀察): 仔細察看特定對象。>), ('synonym(rev)', <CwnSense[04004502](看): 仔細察看特定對象。>), ('synonym(rev)', <CwnSense[06596301](觀): 仔細察看特定對象。>), ('varword(rev)', <CwnSense[06667502](看到): 仔細察看特定對象，強調動作的結果。>)]
    --
    <CwnSense[04004303](看看): 仔細觀察，做為判斷或決定的標準。>
    [('synonym', <CwnSense[04004503](看): 仔細觀察，做為判斷或決定的標準。>), ('synonym', <CwnSense[08057603](相): 仔細觀察，做為判斷或決定的標準。>), ('synonym', <CwnSense[06020203](卜): 仔細觀察，做為判斷或決定的標準。>), ('synonym(rev)', <CwnSense[08057603](相): 仔細觀察，做為判斷或決定的標準。>), ('synonym(rev)', <CwnSense[04004503](看): 仔細觀察，做為判斷或決定的標準。>), ('synonym(rev)', <CwnSense[06020203](卜): 仔細觀察，做為判斷或決定的標準。>)]
    --
    <CwnSense[04004304](看看): 透過視覺來理解或欣賞。>
    [('synonym', <CwnSense[06517401](觀賞): 透過視覺來理解或欣賞。>), ('synonym', <CwnSense[09126702](睹): 透過視覺來理解或欣賞。>), ('synonym', <CwnSense[07087601](閱): 透過視覺來理解或欣賞。>), ('synonym', <CwnSense[04004504](看): 透過視覺來理解或欣賞。>), ('synonym', <CwnSense[06596302](觀): 透過視覺來理解或欣賞。>), ('synonym(rev)', <CwnSense[06517401](觀賞): 透過視覺來理解或欣賞。>), ('synonym(rev)', <CwnSense[04004504](看): 透過視覺來理解或欣賞。>), ('synonym(rev)', <CwnSense[06596302](觀): 透過視覺來理解或欣賞。>), ('synonym(rev)', <CwnSense[07087601](閱): 透過視覺來理解或欣賞。>), ('synonym(rev)', <CwnSense[09126702](睹): 透過視覺來理解或欣賞。>)]
    --
    <CwnSense[04004305](看看): 拜訪、探望後述對象。>
    [('synonym', <CwnSense[04004507](看): 拜訪、探望後述對象。>), ('synonym(rev)', <CwnSense[04004507](看): 拜訪、探望後述對象。>)]
    --
    <CwnSense[04004306](看看): 醫生診治病人。>
    [('synonym', <CwnSense[05197701](看病): 醫生診治病人。>), ('synonym', <CwnSense[04004508](看): 醫生診治病人。>), ('synonym(rev)', <CwnSense[04004508](看): 醫生診治病人。>), ('synonym(rev)', <CwnSense[05197701](看病): 醫生診治病人。>)]
    --
    <CwnSense[04004307](看看): 病人接受診治。>
    [('synonym', <CwnSense[05197702](看病): 病人接受診治。>), ('synonym', <CwnSense[04004509](看): 病人接受診治。>), ('synonym(rev)', <CwnSense[04004509](看): 病人接受診治。>), ('synonym(rev)', <CwnSense[05197702](看病): 病人接受診治。>)]
    --
    <CwnSense[04004308](看看): 思考後述問題，以便做出決定。>
    [('synonym', <CwnSense[05202701](考慮): 思考後述問題，以便做出決定。>), ('synonym', <CwnSense[05070703](思索): 思考後述問題，以便做出決定。>), ('synonym', <CwnSense[06721403](研究): 思考後述問題，以便做出決定。>), ('synonym', <CwnSense[07083404](研): 思考後述問題，以便做出決定。>), ('synonym', <CwnSense[06767401](考量): 思考後述問題，以便做出決定。>), ('synonym(rev)', <CwnSense[05070703](思索): 思考後述問題，以便做出決定。>), ('synonym(rev)', <CwnSense[05202701](考慮): 思考後述問題，以便做出決定。>), ('synonym(rev)', <CwnSense[06721403](研究): 思考後述問題，以便做出決定。>), ('synonym(rev)', <CwnSense[07083404](研): 思考後述問題，以便做出決定。>), ('synonym(rev)', <CwnSense[06767401](考量): 思考後述問題，以便做出決定。>)]
    --
    <CwnSense[04004309](看看): 時態標記。表事件或動作的嘗試貌，表時間短暫或不經意。>
    [('hypernym', <CwnSense[04004512](看): 時態標記。表事件或動作的嘗試貌。>), ('hyponym(rev)', <CwnSense[04004512](看): 時態標記。表事件或動作的嘗試貌。>)]
    --
    <CwnSense[04004310](看看): 檢查。>
    []
    --


## II. Annotation


```python
annot = CwnAnnotator(cwn, "cwn_testing")
```

### 利用上述方式查詢lemma，若cwn內不存在該lemma，則可以直接新增lemma, sense以及其他相關資訊。
### 若已存在該lemma，那就直接新增相關資訊就好。


```python
# 發現lemma"五神無主"不存在並新增它
findlemma = cwn.find_lemma('五神無主')
findlemma
new_lemma = annot.create_lemma('五神無主')
new_lemma
```




    <CwnLemma: 五神無主_1>




```python
# 發現已存在的lemma「振奮」沒有任何sense，要新增一個sense
my_lemmas = cwn.find_lemma("振奮")
my_lemma = my_lemmas[0]
print(my_lemma)
print(my_lemma.senses)
```

    <CwnLemma: 振奮_1>
    []



```python
# Add zhuyin
my_lemma.zhuyin = "ㄓㄣˋㄈㄣˋ"
annot.set_lemma(my_lemma)
```


```python
# Add sense
my_sense = annot.create_sense("以特定事件鼓勵特定對象，使其增加該事件正面精神特質。")
my_sense
```




    <CwnSense[cwn_testing_000006](----): 以特定事件鼓勵特定對象，使其增加該事件正面精神特質。>




```python
# Add PoS and example
my_sense.pos = "V"
my_sense.examples = ["謝總的鼓勵總是<振奮>人心。"]
annot.set_sense(my_sense)
```


```python
# See the structure
annot.V
```




    {'132394': {'annot': {},
      'lemma': '振奮',
      'lemma_sno': 1,
      'node_type': 'lemma',
      'zhuyin': 'ㄓㄣˋㄈㄣˋ'},
     'cwn_testing_000001': {'annot': {},
      'lemma': '五神無主',
      'lemma_sno': 1,
      'node_type': 'lemma',
      'zhuyin': ''},
     'cwn_testing_000002': {'annot': {},
      'def': '以特定事件鼓勵特定對象，使其增加該事件正面精神特質。',
      'examples': ['謝總的鼓勵總是<振奮>人心。'],
      'node_type': 'sense',
      'pos': 'V'},
     'cwn_testing_000003': {'annot': {},
      'lemma': '五神無主',
      'lemma_sno': 1,
      'node_type': 'lemma',
      'zhuyin': ''},
     'cwn_testing_000004': {'annot': {},
      'def': '以特定事件鼓勵特定對象，使其增加該事件正面精神特質。',
      'examples': ['謝總的鼓勵總是<振奮>人心。'],
      'node_type': 'sense',
      'pos': 'V'},
     'cwn_testing_000005': {'annot': {},
      'lemma': '五神無主',
      'lemma_sno': 1,
      'node_type': 'lemma',
      'zhuyin': ''},
     'cwn_testing_000006': {'annot': {},
      'def': '以特定事件鼓勵特定對象，使其增加該事件正面精神特質。',
      'examples': ['謝總的鼓勵總是<振奮>人心。'],
      'node_type': 'sense',
      'pos': 'V'}}



### 連接senses之間的語意關係


```python
# Look into a existed sense
my_lemmas_2 = cwn.find_lemma("激")
my_lemma_2 = my_lemmas_2[4]
my_lemma_2.senses[3]
```




    <CwnSense[07076504](激): 以特定事件鼓勵特定對象，使其增加該事件正面精神特質。>




```python
# create_relation(src_id, tgt_id, rel_type)
rel1 = annot.create_relation(my_lemma_2.senses[3].id, my_sense.id, CwnRelationType.synonym)
rel2 = annot.create_relation(my_sense.id, my_lemma_2.senses[3].id, CwnRelationType.synonym)
print(rel1, rel2)
tablet_has_sense = annot.create_relation(my_sense.id, my_lemma_2.senses[3].id, CwnRelationType.has_sense)
```

    <CwnRelation> synonym: 07076504 -> cwn_testing_000006 <CwnRelation> synonym: cwn_testing_000006 -> 07076504



```python
# See the relations regarding the sense
annot.E
```




    {('07076504', 'cwn_testing_000002'): {'annot': {}, 'edge_type': 'synonym'},
     ('07076504', 'cwn_testing_000004'): {'annot': {}, 'edge_type': 'synonym'},
     ('07076504', 'cwn_testing_000006'): {'annot': {}, 'edge_type': 'synonym'},
     ('cwn_testing_000002', '07076504'): {'annot': {}, 'edge_type': 'has_sense'},
     ('cwn_testing_000004', '07076504'): {'annot': {}, 'edge_type': 'has_sense'},
     ('cwn_testing_000006', '07076504'): {'annot': {}, 'edge_type': 'has_sense'}}




```python
# session結束 自動匯出json檔
annot.save()
```

### 根據GWA core verb(5000_bc.xml)，目前已嘗試加入約十餘組cwn沒有cover到的lemma，結果如annot資料夾中所示。


```python

```
