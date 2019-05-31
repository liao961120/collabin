---
title: 視覺化兩語料的字詞頻率
subtitle: ''
tags: [lope]
date: '2019-05-31'
author: Don
mysite: /don/
comment: yes
---


這篇文章練習上次Sean所提供的程式碼與視覺化，練習用這樣的方式看下福盟與伴侶盟兩方語料的字詞是否有某一方特別愛用的詞。


```python
import re
from typing import List
from collections import Counter
from matplotlib import pyplot as plt
import pandas as pd
import numpy as np
import jieba
```

 ## 1. 匯入資料


```python
def read_text(fpath):
    fin = open(fpath, "r", encoding="UTF-8")
    text = fin.read().strip()
    cjk_pat = re.compile("[\u4e00-\u9fff]+")
    tokens_iter = jieba.cut(text)
    tokens_iter = filter(lambda x: cjk_pat.match(x), tokens_iter)
    tokens = list(tokens_iter)
    return tokens

def make_wfreq_series(tokens: List[str]):
    wfreq = Counter(tokens)
    series = pd.Series(wfreq)
    return series

pro = read_text("lgbtfamily.txt")
anti = read_text("lovefamily.txt")
series1 = make_wfreq_series(pro)
series2 = make_wfreq_series(anti)

```

## 2. Explorative Data Analysis

 ### 2.1. 將資料轉換成DataFrame

這一步要做的是將每個詞映射在一個二維平面上的點，該點的x座標是該詞在語料A中出現的頻率，而y座標為該詞出現在語料B中出現的頻率。


```python
bicorp = pd.DataFrame(dict(corpusA=series1, corpusB=series2))
bicorp.fillna(0, inplace=True)
bicorp['overall'] = bicorp.corpusA + bicorp.corpusB
bicorp.plot(x='corpusA', y='corpusB', kind='scatter')

```




    <matplotlib.axes._subplots.AxesSubplot at 0x10f92af98>




![png](index_files/index_7_1.png)


可以看到除了右上角有一個點之外（應該就是兩個語料都大量出現的一個詞），其他幾乎都擠在左下角。為了要讓擠在左下角的那一坨散開，我們可以使用log轉換，拉開距離。

### 2.2. 進行log轉換


```python
bicorp['log_corpusA'] = np.log(bicorp.corpusA+1)
bicorp['log_corpusB'] = np.log(bicorp.corpusB+1)
bicorp.plot(x='log_corpusA', y='log_corpusB', kind='scatter')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x115c47f60>




![png](index_files/index_10_1.png)


散開後，我們可以看見呈現沿著對角線分布的詞，而我們好奇的就是散佈在左上三角形中的詞（出現在語料B中大於語料庫A的）以及右下三角形的詞（出現在A語料中大於語料B的）。

### 2.3 計算對比分數（`log_corpusB - log_corpusA`）


```python
bicorp['contrast'] = bicorp.log_corpusB - bicorp.log_corpusA
bicorp.plot(x='log_corpusA', y='log_corpusB', c='contrast', 
    colormap='jet', kind='scatter')

```




    <matplotlib.axes._subplots.AxesSubplot at 0x1103a5400>




![png](index_files/index_13_1.png)


### 2.5 按出現在語料庫B（下福盟）中最特殊的詞排列


```python
bicorp.sort_values('contrast', ascending=False).head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>corpusA</th>
      <th>corpusB</th>
      <th>overall</th>
      <th>log_corpusA</th>
      <th>log_corpusB</th>
      <th>contrast</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>投稿</th>
      <td>0.0</td>
      <td>778.0</td>
      <td>778.0</td>
      <td>0.000000</td>
      <td>6.658011</td>
      <td>6.658011</td>
    </tr>
    <tr>
      <th>同運</th>
      <td>0.0</td>
      <td>577.0</td>
      <td>577.0</td>
      <td>0.000000</td>
      <td>6.359574</td>
      <td>6.359574</td>
    </tr>
    <tr>
      <th>附</th>
      <td>0.0</td>
      <td>265.0</td>
      <td>265.0</td>
      <td>0.000000</td>
      <td>5.583496</td>
      <td>5.583496</td>
    </tr>
    <tr>
      <th>最新消息</th>
      <td>0.0</td>
      <td>262.0</td>
      <td>262.0</td>
      <td>0.000000</td>
      <td>5.572154</td>
      <td>5.572154</td>
    </tr>
    <tr>
      <th>增刪</th>
      <td>0.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>0.000000</td>
      <td>5.525453</td>
      <td>5.525453</td>
    </tr>
    <tr>
      <th>須知</th>
      <td>0.0</td>
      <td>249.0</td>
      <td>249.0</td>
      <td>0.000000</td>
      <td>5.521461</td>
      <td>5.521461</td>
    </tr>
    <tr>
      <th>筆名</th>
      <td>0.0</td>
      <td>248.0</td>
      <td>248.0</td>
      <td>0.000000</td>
      <td>5.517453</td>
      <td>5.517453</td>
    </tr>
    <tr>
      <th>信時</th>
      <td>0.0</td>
      <td>247.0</td>
      <td>247.0</td>
      <td>0.000000</td>
      <td>5.513429</td>
      <td>5.513429</td>
    </tr>
    <tr>
      <th>色情</th>
      <td>0.0</td>
      <td>231.0</td>
      <td>231.0</td>
      <td>0.000000</td>
      <td>5.446737</td>
      <td>5.446737</td>
    </tr>
    <tr>
      <th>本站</th>
      <td>3.0</td>
      <td>545.0</td>
      <td>548.0</td>
      <td>1.386294</td>
      <td>6.302619</td>
      <td>4.916325</td>
    </tr>
  </tbody>
</table>
</div>



### 2.6 按出現在語料庫A(伴侶盟)中最特殊的詞排列


```python
bicorp.sort_values('contrast', ascending=True).head(10)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>corpusA</th>
      <th>corpusB</th>
      <th>overall</th>
      <th>log_corpusA</th>
      <th>log_corpusB</th>
      <th>contrast</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>祁家威</th>
      <td>27.0</td>
      <td>0.0</td>
      <td>27.0</td>
      <td>3.332205</td>
      <td>0.0</td>
      <td>-3.332205</td>
    </tr>
    <tr>
      <th>伊斯</th>
      <td>22.0</td>
      <td>0.0</td>
      <td>22.0</td>
      <td>3.135494</td>
      <td>0.0</td>
      <td>-3.135494</td>
    </tr>
    <tr>
      <th>縣長</th>
      <td>22.0</td>
      <td>0.0</td>
      <td>22.0</td>
      <td>3.135494</td>
      <td>0.0</td>
      <td>-3.135494</td>
    </tr>
    <tr>
      <th>費瑟</th>
      <td>17.0</td>
      <td>0.0</td>
      <td>17.0</td>
      <td>2.890372</td>
      <td>0.0</td>
      <td>-2.890372</td>
    </tr>
    <tr>
      <th>建物</th>
      <td>16.0</td>
      <td>0.0</td>
      <td>16.0</td>
      <td>2.833213</td>
      <td>0.0</td>
      <td>-2.833213</td>
    </tr>
    <tr>
      <th>小風</th>
      <td>16.0</td>
      <td>0.0</td>
      <td>16.0</td>
      <td>2.833213</td>
      <td>0.0</td>
      <td>-2.833213</td>
    </tr>
    <tr>
      <th>員警</th>
      <td>15.0</td>
      <td>0.0</td>
      <td>15.0</td>
      <td>2.772589</td>
      <td>0.0</td>
      <td>-2.772589</td>
    </tr>
    <tr>
      <th>雲林縣</th>
      <td>14.0</td>
      <td>0.0</td>
      <td>14.0</td>
      <td>2.708050</td>
      <td>0.0</td>
      <td>-2.708050</td>
    </tr>
    <tr>
      <th>師團</th>
      <td>14.0</td>
      <td>0.0</td>
      <td>14.0</td>
      <td>2.708050</td>
      <td>0.0</td>
      <td>-2.708050</td>
    </tr>
    <tr>
      <th>下福盟</th>
      <td>14.0</td>
      <td>0.0</td>
      <td>14.0</td>
      <td>2.708050</td>
      <td>0.0</td>
      <td>-2.708050</td>
    </tr>
  </tbody>
</table>
</div>



### 2.7 大量出現在兩個語料中的詞


```python
bicorp.sort_values('overall', ascending=False).head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>corpusA</th>
      <th>corpusB</th>
      <th>overall</th>
      <th>log_corpusA</th>
      <th>log_corpusB</th>
      <th>contrast</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>的</th>
      <td>4601.0</td>
      <td>22434.0</td>
      <td>27035.0</td>
      <td>8.434246</td>
      <td>10.018378</td>
      <td>1.584131</td>
    </tr>
    <tr>
      <th>是</th>
      <td>1017.0</td>
      <td>4913.0</td>
      <td>5930.0</td>
      <td>6.925595</td>
      <td>8.499844</td>
      <td>1.574248</td>
    </tr>
    <tr>
      <th>同性</th>
      <td>697.0</td>
      <td>4996.0</td>
      <td>5693.0</td>
      <td>6.548219</td>
      <td>8.516593</td>
      <td>1.968374</td>
    </tr>
    <tr>
      <th>在</th>
      <td>1133.0</td>
      <td>3873.0</td>
      <td>5006.0</td>
      <td>7.033506</td>
      <td>8.262043</td>
      <td>1.228536</td>
    </tr>
    <tr>
      <th>婚姻</th>
      <td>566.0</td>
      <td>3274.0</td>
      <td>3840.0</td>
      <td>6.340359</td>
      <td>8.094073</td>
      <td>1.753714</td>
    </tr>
    <tr>
      <th>有</th>
      <td>594.0</td>
      <td>2839.0</td>
      <td>3433.0</td>
      <td>6.388561</td>
      <td>7.951559</td>
      <td>1.562998</td>
    </tr>
    <tr>
      <th>對</th>
      <td>652.0</td>
      <td>2254.0</td>
      <td>2906.0</td>
      <td>6.481577</td>
      <td>7.720905</td>
      <td>1.239328</td>
    </tr>
    <tr>
      <th>為</th>
      <td>488.0</td>
      <td>2129.0</td>
      <td>2617.0</td>
      <td>6.192362</td>
      <td>7.663877</td>
      <td>1.471515</td>
    </tr>
    <tr>
      <th>和</th>
      <td>325.0</td>
      <td>2059.0</td>
      <td>2384.0</td>
      <td>5.786897</td>
      <td>7.630461</td>
      <td>1.843564</td>
    </tr>
    <tr>
      <th>也</th>
      <td>603.0</td>
      <td>1768.0</td>
      <td>2371.0</td>
      <td>6.403574</td>
      <td>7.478170</td>
      <td>1.074595</td>
    </tr>
  </tbody>
</table>
</div>



「同性」和「婚姻」這兩個詞很有趣，打敗了諸多功能詞，擠進兩語料常用詞前十名，尤其是在語料庫B中，「同性」一詞的使用甚至高於「在」一詞的使用。
