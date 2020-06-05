---
title: Chinese Variations IV
subtitle: New Parallel Corpus
tags: [nlp, chinese variations, python, parallel corpus, LOPE]
date: '2019-05-17'
author: Richard Lian
mysite: /richl/
comment: yes
---


After compiling my corpus, I used a portion which I believed to be of higher quality (closer to 1:1 string length) as training data to train a neural machine translation model. About 1,058,00 TM-MM pairs were used for training, 264,000 for validation, and 323,000 for testing.

I used [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py) with all default settings.

I also training a model using the original OpenSubtitles parallel corpus just to see the difference.

Below are the results.

You can also try the translation model at http://lopen.linguistics.ntu.edu.tw/chivar/translate/ !


```python
with open('test-src-new.txt') as f1, open('all_trans_test_new_pred') as f2, open('opensubs_test_new_pred') as f3:
    src = f1.read().split('\n')
    alltrans = f2.read().split('\n')
    opensubs = f3.read().split('\n')
```


```python
same, different = 0, 0
for s, a, o in zip(src, alltrans, opensubs):
    if a != o:
        different += 1
    elif a == o:
        same += 1

print(f'Total translations: {len(src)}')
print(f'AllTrans and OpenSubs have: {same:,} ({same/len(src):.2%}) identical translations ||| {different:,} ({different/len(src):.2%}) different translations.')
```

    Total translations: 323446
    AllTrans and OpenSubs have: 138,236 (42.74%) identical translations ||| 185,210 (57.26%) different translations.



```python
# What could predict if translations are different between models?
for s, a, o in zip(src, alltrans, opensubs):
    if a != o:
        print('Src:', s)
        print('AllTrans:', a)
        print('OpenSubs:', o)
        print('=' * 30)        
```

<a href='./data.html' target="_blank">View Large Data</a>

