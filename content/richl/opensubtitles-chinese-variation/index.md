---
title: 'OpenSubtitles: Chinese Variation'
subtitle: ''
tags: ["nlp", "python", "opensubtitles", "chinese", "variation", LOPE]
date: '2019-04-26'
author: Richard Lian
mysite: /richl/
comment: yes
---


These are subtitles from the OpenSubtitles corpus along with some of my own that I crawled. 

There are a ton of subtitles that are literal translations of each other. I tried my best to filter them out. This is the result...

The goal is to find some interesting things between Taiwan Mandarin and Mainland Mandarin...


```python
from collections import Counter
from itertools import chain
import pickle
import string

from jseg import Jieba
from opencc import OpenCC
from zhon.hanzi import punctuation
```


```python
with open('all_subs.txt') as f:
    subs = [line.strip().split('\t') for line in f.readlines()]
```


```python
# [TM, MM]
subs[:10]
```




    [['你老是跟我說', '你老是告诉我'],
     ['你不擔心它變得比人類聰明嗎？', '创世纪不仅为消费者打造'],
     ['就我一人', '让我去。'],
     ['各位，安全是第一優先', '他在那儿逗她笑'],
     ['喂媽媽', '喂,妈'],
     ['我想是的我不認為我還有淚', '大概不再有了'],
     ['我的意思是馬上就要', '表示我现在就要!'],
     ['-你「覺得」？', '我觉得你会在这边用早餐'],
     ['你是如何回答的', '对'],
     ['丹，你怎麼了？', '洗碗洗碗!']]




```python
tm, mm = zip(*subs)
```


```python
print(len(tm), len(mm))
```

    2953619 2953619



```python
s2tw = OpenCC('s2tw')
```


```python
# Going to use Jseg, so I'll convert to traditional
mm = [s2tw.convert(line) for line in mm]
```


```python
j = Jieba()
tm_seg = [j.seg(line) for line in tm]
mm_seg = [j.seg(line) for line in mm]
```

    DEBUG:jseg.jieba:loading default dictionary



```python
# segmenting actually takes a super long time. Probably should have used multiprocessing...
with open('tm_seg.pkl', 'wb') as f:
    pickle.dump(tm_seg, f)
with open('mm_seg.pkl', 'wb') as f:
    pickle.dump(mm_seg, f)
```


```python
tm_seg[0], mm_seg[0]
```




    (('你', '老是', '跟', '我', '說'), ('你', '老是', '告訴', '我'))




```python
# use chain.from_iterable() to flatten a list of lists
tm_flat = chain.from_iterable(tm_seg)
mm_flat = chain.from_iterable(mm_seg)
```


```python
# it is an itertools.chain object
type(tm_flat)
```




    itertools.chain




```python
tm_count = Counter(tm_flat)
mm_count = Counter(mm_flat)
```


```python
with open('baidu_stopwords.txt') as f:
    stopwords = [s2tw.convert(s) for s in f.read().split('\n')]
```


```python
# remove stopwords
for s in stopwords:
    if s in tm_count:
        del tm_count[s]
    if s in mm_count:
        del mm_count[s]
# remove punctuation
for p in list(punctuation + string.punctuation):
    if p in tm_count:
        del tm_count[p]
    if p in mm_count:
        del mm_count[p]
```


```python
# not sure what I can gather from this...
for t, m in zip(tm_count.most_common(50), mm_count.most_common(50)):
    print(t, m)
```

    ('說', 100901) ('知道', 104963)
    ('知道', 99615) ('說', 103681)
    ('他們', 92660) ('他們', 97454)
    ('會', 86571) ('會', 86729)
    ('想', 75782) ('想', 77671)
    ('沒有', 56905) ('沒有', 61480)
    ('做', 52416) ('做', 56454)
    ('沒', 47848) ('現在', 50511)
    ('現在', 46849) ('沒', 47361)
    ('妳', 41502) ('裡', 33924)
    ('不會', 32791) ('不會', 33755)
    ('事', 32227) ('告訴', 32420)
    ('告訴', 29883) ('事', 31524)
    ('走', 28838) ('需要', 30272)
    ('需要', 28717) ('走', 29971)
    ('先生', 27811) ('先生', 29005)
    ('不能', 26325) ('已經', 28895)
    ('次', 26280) ('不能', 27154)
    ('已經', 25307) ('次', 26872)
    ('什么', 24435) ('覺得', 24653)
    ('真的', 24097) ('喜歡', 24528)
    ('喜歡', 23293) ('真的', 23885)
    ('快', 22933) ('東西', 23537)
    ('覺得', 22313) ('謝謝', 22772)
    ('種', 22002) ('種', 22300)
    ('謝謝', 21854) ('快', 21980)
    ('東西', 21768) ('不要', 20994)
    ('我要', 20897) ('我要', 20659)
    ('不要', 20727) ('我會', 20542)
    ('我會', 19727) ('問題', 20202)
    ('問題', 19424) ('好了', 19939)
    ('兩', 19129) ('兩', 19270)
    ('看到', 18919) ('可能', 19264)
    ('好了', 18905) ('應該', 19154)
    ('應該', 18838) ('看到', 18968)
    ('找', 18569) ('個人', 18891)
    ('可能', 18534) ('太', 18341)
    ('太', 18167) ('找', 18077)
    ('個人', 17916) ('時間', 17453)
    ('裡', 17690) ('請', 17445)
    ('請', 17183) ('中', 16255)
    ('幫', 16802) ('工作', 16023)
    ('時間', 16211) ('幫', 16000)
    ('工作', 15217) ('孩子', 15972)
    ('找到', 15022) ('一下', 15645)
    ('中', 15003) ('更', 15562)
    ('一下', 14977) ('找到', 15510)
    ('真', 14858) ('相信', 14989)
    ('聽', 14667) ('看看', 14861)
    ('相信', 14646) ('聽', 14775)



```python

```
