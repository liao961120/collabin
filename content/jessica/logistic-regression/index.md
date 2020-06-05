---
title: Applying logistic regression for classifying human-machine dialogue and human-human
  dialogue
subtitle: ''
tags: [lope]
date: '2019-05-03'
author: Jessica
mysite: /jessica/
comment: yes
---

Logistic Regression雖然名為迴歸，但常⽤於分類（⼆元或多類別）

人與對話機器人的對話取自[chatterbot訓練資料集](https://github.com/gunthercox/chatterbot-corpus)，人與人之間的對話取自[騰訊AI Lab 對話資料集](http://ai.tencent.com/ailab/upload/PapersUploads/A_Manually_Annotated_Chinese_Corpus_for_Non-task-oriented_Dialogue_System)，可參考[這篇](https://arxiv.org/pdf/1805.05542.pdf)論文。從兩資料集各隨機取出50 組單輪對話(均沒有特定主題)。接下來擷取兩組對話的量化特徵(詞彙豐富度、對話長度、句子平均長度、虛詞使用比率、各詞類使用頻率等等)共24個，將這些特徵視為X, 是否為人機對話為Y (是：1, 否：0)，藉此分類人人對話與人機對話。


```python
from sklearn import preprocessing, linear_model
import pandas as pd
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.feature_selection import f_regression
plt.style.use('ggplot')
plt.rcParams['font.family']='SimHei' #⿊體
```

讀入資料


```python
data = pd.read_excel('sample_50_anno.xlsx',sheet_name = None) 
lrdata=data.get('lr_data') # get a specific sheet to DataFrame
```

用
'Text Length','Different Words','Entropy','Simpson Index','Sentence Count','Sentence Length Average','Sentence Length Variance','Function Word Count','Function Word proportion','TTR','Na','Nb','Nc','Nd','Nh','D','T','VA','VB','VC','VD','VE','VH','C'這些數值資料來預測是否為人機對話


```python
df=lrdata[['Text Length','Different Words','Entropy','Simpson Index','Sentence Count','Sentence Length Average','Sentence Length Variance','Function Word Count','Function Word Proportion','TTR','Na','Nb','Nc','Nd','Nh','D','T','VA','VB','VC','VD','VE','VH','C','Machine']]
df.head()
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
      <th>Text Length</th>
      <th>Different Words</th>
      <th>Entropy</th>
      <th>Simpson Index</th>
      <th>Sentence Count</th>
      <th>Sentence Length Average</th>
      <th>Sentence Length Variance</th>
      <th>Function Word Count</th>
      <th>Function Word Proportion</th>
      <th>TTR</th>
      <th>...</th>
      <th>D</th>
      <th>T</th>
      <th>VA</th>
      <th>VB</th>
      <th>VC</th>
      <th>VD</th>
      <th>VE</th>
      <th>VH</th>
      <th>C</th>
      <th>Machine</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>23</td>
      <td>10</td>
      <td>2.262386</td>
      <td>0.107266</td>
      <td>15</td>
      <td>1.533333</td>
      <td>0.466667</td>
      <td>6</td>
      <td>0.260870</td>
      <td>0.435000</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>29</td>
      <td>14</td>
      <td>2.553682</td>
      <td>0.085000</td>
      <td>18</td>
      <td>1.611111</td>
      <td>6.277778</td>
      <td>5</td>
      <td>0.172414</td>
      <td>0.482759</td>
      <td>...</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>51</td>
      <td>22</td>
      <td>2.655133</td>
      <td>0.129291</td>
      <td>25</td>
      <td>2.040000</td>
      <td>7.240000</td>
      <td>2</td>
      <td>0.039216</td>
      <td>0.431373</td>
      <td>...</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12</td>
      <td>8</td>
      <td>2.043192</td>
      <td>0.135802</td>
      <td>7</td>
      <td>1.714286</td>
      <td>3.428571</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9</td>
      <td>8</td>
      <td>2.043192</td>
      <td>0.135802</td>
      <td>9</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>4</td>
      <td>0.444444</td>
      <td>0.888889</td>
      <td>...</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 25 columns</p>
</div>



切分訓練、測試資料


```python
x=df[['Text Length','Different Words','Entropy','Simpson Index','Sentence Count','Sentence Length Average','Sentence Length Variance','Function Word Count','Function Word Proportion','TTR','Na','Nb','Nc','Nd','Nh','D','T','VA','VB','VC','VD','VE','VH','C']]
y=df[['Machine']]

x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.3,random_state=2019) 

x_train
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
      <th>Text Length</th>
      <th>Different Words</th>
      <th>Entropy</th>
      <th>Simpson Index</th>
      <th>Sentence Count</th>
      <th>Sentence Length Average</th>
      <th>Sentence Length Variance</th>
      <th>Function Word Count</th>
      <th>Function Word Proportion</th>
      <th>TTR</th>
      <th>...</th>
      <th>Nh</th>
      <th>D</th>
      <th>T</th>
      <th>VA</th>
      <th>VB</th>
      <th>VC</th>
      <th>VD</th>
      <th>VE</th>
      <th>VH</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>95</th>
      <td>44</td>
      <td>29</td>
      <td>3.297037</td>
      <td>0.040175</td>
      <td>7</td>
      <td>6.285714</td>
      <td>215.428571</td>
      <td>12</td>
      <td>0.272727</td>
      <td>0.659091</td>
      <td>...</td>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>47</th>
      <td>13</td>
      <td>10</td>
      <td>2.138397</td>
      <td>0.147929</td>
      <td>9</td>
      <td>1.444444</td>
      <td>0.555556</td>
      <td>2</td>
      <td>0.153846</td>
      <td>0.769231</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>14</th>
      <td>15</td>
      <td>8</td>
      <td>2.043192</td>
      <td>0.135802</td>
      <td>9</td>
      <td>1.666667</td>
      <td>0.333333</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.533333</td>
      <td>...</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>81</th>
      <td>12</td>
      <td>9</td>
      <td>2.197225</td>
      <td>0.111111</td>
      <td>2</td>
      <td>6.000000</td>
      <td>18.000000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.750000</td>
      <td>...</td>
      <td>3</td>
      <td>4</td>
      <td>0</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>90</th>
      <td>14</td>
      <td>12</td>
      <td>2.484907</td>
      <td>0.083333</td>
      <td>2</td>
      <td>7.000000</td>
      <td>8.000000</td>
      <td>2</td>
      <td>0.142857</td>
      <td>0.857143</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>51</td>
      <td>22</td>
      <td>2.655133</td>
      <td>0.129291</td>
      <td>25</td>
      <td>2.040000</td>
      <td>7.240000</td>
      <td>2</td>
      <td>0.039216</td>
      <td>0.431373</td>
      <td>...</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>22</th>
      <td>33</td>
      <td>19</td>
      <td>2.902002</td>
      <td>0.057851</td>
      <td>20</td>
      <td>1.650000</td>
      <td>12.550000</td>
      <td>3</td>
      <td>0.090909</td>
      <td>0.575758</td>
      <td>...</td>
      <td>1</td>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>77</th>
      <td>44</td>
      <td>38</td>
      <td>3.612136</td>
      <td>0.027960</td>
      <td>2</td>
      <td>22.000000</td>
      <td>450.000000</td>
      <td>7</td>
      <td>0.159091</td>
      <td>0.863636</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>78</th>
      <td>19</td>
      <td>16</td>
      <td>2.751667</td>
      <td>0.065744</td>
      <td>2</td>
      <td>9.500000</td>
      <td>12.500000</td>
      <td>2</td>
      <td>0.105263</td>
      <td>0.842105</td>
      <td>...</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>41</th>
      <td>12</td>
      <td>6</td>
      <td>1.747868</td>
      <td>0.183673</td>
      <td>7</td>
      <td>1.714286</td>
      <td>0.285714</td>
      <td>2</td>
      <td>0.166667</td>
      <td>0.500000</td>
      <td>...</td>
      <td>1</td>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>25</th>
      <td>10</td>
      <td>6</td>
      <td>1.747868</td>
      <td>0.183673</td>
      <td>7</td>
      <td>1.428571</td>
      <td>0.571429</td>
      <td>1</td>
      <td>0.100000</td>
      <td>0.600000</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>92</th>
      <td>37</td>
      <td>34</td>
      <td>3.526361</td>
      <td>0.029412</td>
      <td>2</td>
      <td>18.500000</td>
      <td>364.500000</td>
      <td>7</td>
      <td>0.189189</td>
      <td>0.918919</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>34</th>
      <td>9</td>
      <td>5</td>
      <td>1.560710</td>
      <td>0.222222</td>
      <td>6</td>
      <td>1.500000</td>
      <td>0.500000</td>
      <td>1</td>
      <td>0.111111</td>
      <td>0.555556</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>73</th>
      <td>11</td>
      <td>9</td>
      <td>2.197225</td>
      <td>0.111111</td>
      <td>2</td>
      <td>5.500000</td>
      <td>0.500000</td>
      <td>3</td>
      <td>0.272727</td>
      <td>0.818182</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>66</th>
      <td>24</td>
      <td>21</td>
      <td>3.028029</td>
      <td>0.049587</td>
      <td>2</td>
      <td>12.000000</td>
      <td>50.000000</td>
      <td>2</td>
      <td>0.083333</td>
      <td>0.875000</td>
      <td>...</td>
      <td>4</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>74</th>
      <td>20</td>
      <td>11</td>
      <td>2.351257</td>
      <td>0.098765</td>
      <td>2</td>
      <td>10.000000</td>
      <td>0.000000</td>
      <td>6</td>
      <td>0.300000</td>
      <td>0.550000</td>
      <td>...</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>64</th>
      <td>10</td>
      <td>7</td>
      <td>1.945910</td>
      <td>0.142857</td>
      <td>2</td>
      <td>5.000000</td>
      <td>2.000000</td>
      <td>3</td>
      <td>0.300000</td>
      <td>0.700000</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>56</th>
      <td>32</td>
      <td>22</td>
      <td>3.044820</td>
      <td>0.050296</td>
      <td>6</td>
      <td>5.333333</td>
      <td>55.333333</td>
      <td>4</td>
      <td>0.125000</td>
      <td>0.687500</td>
      <td>...</td>
      <td>0</td>
      <td>5</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>96</th>
      <td>22</td>
      <td>20</td>
      <td>2.995732</td>
      <td>0.050000</td>
      <td>2</td>
      <td>11.000000</td>
      <td>18.000000</td>
      <td>3</td>
      <td>0.136364</td>
      <td>0.909091</td>
      <td>...</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>38</th>
      <td>10</td>
      <td>9</td>
      <td>2.197225</td>
      <td>0.111111</td>
      <td>9</td>
      <td>1.111111</td>
      <td>0.888889</td>
      <td>2</td>
      <td>0.200000</td>
      <td>0.900000</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>75</th>
      <td>10</td>
      <td>8</td>
      <td>2.079442</td>
      <td>0.125000</td>
      <td>2</td>
      <td>5.000000</td>
      <td>2.000000</td>
      <td>2</td>
      <td>0.200000</td>
      <td>0.800000</td>
      <td>...</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>76</th>
      <td>14</td>
      <td>10</td>
      <td>2.253858</td>
      <td>0.111111</td>
      <td>2</td>
      <td>7.000000</td>
      <td>32.000000</td>
      <td>2</td>
      <td>0.142857</td>
      <td>0.714286</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>12</td>
      <td>6</td>
      <td>1.732868</td>
      <td>0.187500</td>
      <td>6</td>
      <td>2.000000</td>
      <td>2.000000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>79</th>
      <td>19</td>
      <td>14</td>
      <td>2.599302</td>
      <td>0.078125</td>
      <td>2</td>
      <td>9.500000</td>
      <td>24.500000</td>
      <td>3</td>
      <td>0.157895</td>
      <td>0.736842</td>
      <td>...</td>
      <td>4</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>27</th>
      <td>20</td>
      <td>14</td>
      <td>2.599302</td>
      <td>0.078125</td>
      <td>14</td>
      <td>1.428571</td>
      <td>5.428571</td>
      <td>2</td>
      <td>0.100000</td>
      <td>0.700000</td>
      <td>...</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>18</td>
      <td>9</td>
      <td>2.069202</td>
      <td>0.142857</td>
      <td>14</td>
      <td>1.285714</td>
      <td>0.714286</td>
      <td>3</td>
      <td>0.166667</td>
      <td>0.500000</td>
      <td>...</td>
      <td>3</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>52</th>
      <td>26</td>
      <td>21</td>
      <td>3.014947</td>
      <td>0.051040</td>
      <td>2</td>
      <td>13.000000</td>
      <td>98.000000</td>
      <td>4</td>
      <td>0.153846</td>
      <td>0.807692</td>
      <td>...</td>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12</td>
      <td>8</td>
      <td>2.043192</td>
      <td>0.135802</td>
      <td>7</td>
      <td>1.714286</td>
      <td>3.428571</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>87</th>
      <td>136</td>
      <td>113</td>
      <td>4.699810</td>
      <td>0.009494</td>
      <td>6</td>
      <td>22.666667</td>
      <td>1899.333333</td>
      <td>17</td>
      <td>0.125000</td>
      <td>0.830882</td>
      <td>...</td>
      <td>2</td>
      <td>7</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>3</td>
    </tr>
    <tr>
      <th>60</th>
      <td>8</td>
      <td>6</td>
      <td>1.791759</td>
      <td>0.166667</td>
      <td>2</td>
      <td>4.000000</td>
      <td>8.000000</td>
      <td>1</td>
      <td>0.125000</td>
      <td>0.750000</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>53</th>
      <td>89</td>
      <td>69</td>
      <td>4.130615</td>
      <td>0.018685</td>
      <td>2</td>
      <td>44.500000</td>
      <td>2664.500000</td>
      <td>13</td>
      <td>0.146067</td>
      <td>0.775281</td>
      <td>...</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>5</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>33</th>
      <td>48</td>
      <td>20</td>
      <td>2.422693</td>
      <td>0.177285</td>
      <td>36</td>
      <td>1.333333</td>
      <td>4.666667</td>
      <td>5</td>
      <td>0.104167</td>
      <td>0.416667</td>
      <td>...</td>
      <td>1</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>7</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>61</th>
      <td>19</td>
      <td>17</td>
      <td>2.833213</td>
      <td>0.058824</td>
      <td>2</td>
      <td>9.500000</td>
      <td>12.500000</td>
      <td>4</td>
      <td>0.210526</td>
      <td>0.894737</td>
      <td>...</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>51</th>
      <td>11</td>
      <td>9</td>
      <td>2.197225</td>
      <td>0.111111</td>
      <td>2</td>
      <td>5.500000</td>
      <td>0.500000</td>
      <td>1</td>
      <td>0.090909</td>
      <td>0.818182</td>
      <td>...</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>9</td>
      <td>5</td>
      <td>1.609438</td>
      <td>0.200000</td>
      <td>5</td>
      <td>1.800000</td>
      <td>2.800000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.555556</td>
      <td>...</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>8</td>
      <td>4</td>
      <td>1.329661</td>
      <td>0.277778</td>
      <td>6</td>
      <td>1.333333</td>
      <td>0.666667</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>...</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>54</th>
      <td>31</td>
      <td>28</td>
      <td>3.319493</td>
      <td>0.036861</td>
      <td>2</td>
      <td>15.500000</td>
      <td>24.500000</td>
      <td>5</td>
      <td>0.161290</td>
      <td>0.903226</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>65</th>
      <td>14</td>
      <td>10</td>
      <td>2.302585</td>
      <td>0.100000</td>
      <td>4</td>
      <td>3.500000</td>
      <td>13.000000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.714286</td>
      <td>...</td>
      <td>3</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>89</th>
      <td>13</td>
      <td>9</td>
      <td>2.145842</td>
      <td>0.123967</td>
      <td>2</td>
      <td>6.500000</td>
      <td>0.500000</td>
      <td>3</td>
      <td>0.230769</td>
      <td>0.692308</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>86</th>
      <td>11</td>
      <td>7</td>
      <td>1.889159</td>
      <td>0.160494</td>
      <td>2</td>
      <td>5.500000</td>
      <td>0.500000</td>
      <td>4</td>
      <td>0.363636</td>
      <td>0.636364</td>
      <td>...</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>21</th>
      <td>16</td>
      <td>10</td>
      <td>2.302585</td>
      <td>0.100000</td>
      <td>10</td>
      <td>1.600000</td>
      <td>0.400000</td>
      <td>3</td>
      <td>0.187500</td>
      <td>0.625000</td>
      <td>...</td>
      <td>1</td>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>7</td>
      <td>2</td>
      <td>0.636514</td>
      <td>0.555556</td>
      <td>4</td>
      <td>1.750000</td>
      <td>0.250000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.285714</td>
      <td>...</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>91</th>
      <td>56</td>
      <td>51</td>
      <td>3.924584</td>
      <td>0.019970</td>
      <td>3</td>
      <td>18.666667</td>
      <td>340.666667</td>
      <td>10</td>
      <td>0.178571</td>
      <td>0.910714</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>15</td>
      <td>8</td>
      <td>2.043192</td>
      <td>0.135802</td>
      <td>9</td>
      <td>1.666667</td>
      <td>0.333333</td>
      <td>2</td>
      <td>0.133333</td>
      <td>0.533333</td>
      <td>...</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>50</th>
      <td>23</td>
      <td>18</td>
      <td>2.857103</td>
      <td>0.060000</td>
      <td>2</td>
      <td>11.500000</td>
      <td>84.500000</td>
      <td>1</td>
      <td>0.043478</td>
      <td>0.782609</td>
      <td>...</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>80</th>
      <td>29</td>
      <td>25</td>
      <td>3.204778</td>
      <td>0.041420</td>
      <td>3</td>
      <td>9.666667</td>
      <td>0.333333</td>
      <td>2</td>
      <td>0.068966</td>
      <td>0.862069</td>
      <td>...</td>
      <td>4</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>93</th>
      <td>13</td>
      <td>11</td>
      <td>2.397895</td>
      <td>0.090909</td>
      <td>2</td>
      <td>6.500000</td>
      <td>24.500000</td>
      <td>1</td>
      <td>0.076923</td>
      <td>0.846154</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>83</th>
      <td>24</td>
      <td>21</td>
      <td>3.028029</td>
      <td>0.049587</td>
      <td>2</td>
      <td>12.000000</td>
      <td>18.000000</td>
      <td>4</td>
      <td>0.166667</td>
      <td>0.875000</td>
      <td>...</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>71</th>
      <td>13</td>
      <td>11</td>
      <td>2.397895</td>
      <td>0.090909</td>
      <td>2</td>
      <td>6.500000</td>
      <td>0.500000</td>
      <td>2</td>
      <td>0.153846</td>
      <td>0.846154</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>48</th>
      <td>8</td>
      <td>4</td>
      <td>1.386294</td>
      <td>0.250000</td>
      <td>4</td>
      <td>2.000000</td>
      <td>2.000000</td>
      <td>4</td>
      <td>0.500000</td>
      <td>0.500000</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>33</td>
      <td>18</td>
      <td>2.846480</td>
      <td>0.061224</td>
      <td>21</td>
      <td>1.571429</td>
      <td>0.428571</td>
      <td>5</td>
      <td>0.151515</td>
      <td>0.545455</td>
      <td>...</td>
      <td>0</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>12</th>
      <td>11</td>
      <td>6</td>
      <td>1.732868</td>
      <td>0.187500</td>
      <td>8</td>
      <td>1.375000</td>
      <td>0.625000</td>
      <td>1</td>
      <td>0.090909</td>
      <td>0.545455</td>
      <td>...</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>15</th>
      <td>14</td>
      <td>10</td>
      <td>2.253858</td>
      <td>0.111111</td>
      <td>10</td>
      <td>1.400000</td>
      <td>4.400000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.714286</td>
      <td>...</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>29</th>
      <td>34</td>
      <td>23</td>
      <td>3.084652</td>
      <td>0.048469</td>
      <td>26</td>
      <td>1.307692</td>
      <td>0.692308</td>
      <td>4</td>
      <td>0.117647</td>
      <td>0.676471</td>
      <td>...</td>
      <td>1</td>
      <td>9</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>24</th>
      <td>14</td>
      <td>9</td>
      <td>2.197225</td>
      <td>0.111111</td>
      <td>9</td>
      <td>1.555556</td>
      <td>0.444444</td>
      <td>2</td>
      <td>0.142857</td>
      <td>0.642857</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>62</th>
      <td>26</td>
      <td>23</td>
      <td>3.135494</td>
      <td>0.043478</td>
      <td>2</td>
      <td>13.000000</td>
      <td>98.000000</td>
      <td>0</td>
      <td>0.000000</td>
      <td>0.884615</td>
      <td>...</td>
      <td>3</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>88</th>
      <td>14</td>
      <td>11</td>
      <td>2.369382</td>
      <td>0.097222</td>
      <td>2</td>
      <td>7.000000</td>
      <td>50.000000</td>
      <td>2</td>
      <td>0.142857</td>
      <td>0.785714</td>
      <td>...</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>37</th>
      <td>37</td>
      <td>19</td>
      <td>2.743635</td>
      <td>0.086420</td>
      <td>21</td>
      <td>1.761905</td>
      <td>3.269841</td>
      <td>7</td>
      <td>0.189189</td>
      <td>0.513514</td>
      <td>...</td>
      <td>3</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>31</th>
      <td>24</td>
      <td>10</td>
      <td>2.033000</td>
      <td>0.172840</td>
      <td>12</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>3</td>
      <td>0.125000</td>
      <td>0.416667</td>
      <td>...</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>72</th>
      <td>19</td>
      <td>17</td>
      <td>2.833213</td>
      <td>0.058824</td>
      <td>2</td>
      <td>9.500000</td>
      <td>112.500000</td>
      <td>2</td>
      <td>0.105263</td>
      <td>0.894737</td>
      <td>...</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>67 rows × 24 columns</p>
</div>



標準化 :為了避免偏向某個變數去做訓練


```python
from sklearn.preprocessing  import StandardScaler
sc=StandardScaler()

sc.fit(x_train)

x_train_nor=sc.transform(x_train)
x_test_nor=sc.transform(x_test)
```

    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/sklearn/preprocessing/data.py:645: DataConversionWarning: Data with input dtype int64, float64 were all converted to float64 by StandardScaler.
      return self.partial_fit(X, y)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/ipykernel_launcher.py:6: DataConversionWarning: Data with input dtype int64, float64 were all converted to float64 by StandardScaler.
      
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/ipykernel_launcher.py:7: DataConversionWarning: Data with input dtype int64, float64 were all converted to float64 by StandardScaler.
      import sys


訓練資料分類效果(3個參數)


```python
from sklearn.linear_model  import LogisticRegression
import math
lr=LogisticRegression()
lr.fit(x_train_nor,y_train)

# 印出係數
print(lr.coef_)
#印出24個檢定變數的顯著性，以 P-value 是否小於 0.05（信心水準 95%）來判定
print(f_regression(x_train_nor,y_train)[1])
# 印出截距
print(lr.intercept_ )

```

    [[ 0.05073646  0.16110099  0.5169015  -0.71144527 -1.88462048  1.16090357
       0.0333939   0.24978403  0.19895375  0.952695   -0.25788532  0.26413467
      -0.34617137 -0.36122929  0.57772752 -0.00945377 -0.10280697 -0.28001234
       0.         -0.52968175 -0.06851578 -0.21853065  0.22126113 -0.07297395]]
    [1.59650601e-01 6.90901540e-03 2.35938438e-05 9.17292701e-06
     4.23644597e-09 1.15729405e-08 7.59778174e-02 3.20619794e-02
     1.09218594e-01 3.39824140e-13 2.38475771e-01 1.16056518e-01
     8.96529128e-01 6.63765503e-01 7.02383648e-03 3.75252408e-01
     6.51157050e-02 6.93987446e-01            nan 3.33110705e-02
     2.40812687e-01 7.72496060e-01 8.17869677e-01 4.91588646e-01]
    [0.55797716]


    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/sklearn/linear_model/logistic.py:433: FutureWarning: Default solver will be changed to 'lbfgs' in 0.22. Specify a solver to silence this warning.
      FutureWarning)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/sklearn/utils/validation.py:761: DataConversionWarning: A column-vector y was passed when a 1d array was expected. Please change the shape of y to (n_samples, ), for example using ravel().
      y = column_or_1d(y, warn=True)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/sklearn/utils/validation.py:761: DataConversionWarning: A column-vector y was passed when a 1d array was expected. Please change the shape of y to (n_samples, ), for example using ravel().
      y = column_or_1d(y, warn=True)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/sklearn/feature_selection/univariate_selection.py:299: RuntimeWarning: invalid value encountered in true_divide
      corr /= X_norms
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/scipy/stats/_distn_infrastructure.py:877: RuntimeWarning: invalid value encountered in greater
      return (self.a < x) & (x < self.b)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/scipy/stats/_distn_infrastructure.py:877: RuntimeWarning: invalid value encountered in less
      return (self.a < x) & (x < self.b)
    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/scipy/stats/_distn_infrastructure.py:1831: RuntimeWarning: invalid value encountered in less_equal
      cond2 = cond0 & (x <= self.a)


分別計算是人機對話的機率、不是人機對話的機率


```python
np.round(lr.predict_proba(x_test_nor),3)
```




    array([[0.004, 0.996],
           [0.927, 0.073],
           [0.967, 0.033],
           [0.96 , 0.04 ],
           [0.021, 0.979],
           [0.   , 1.   ],
           [0.9  , 0.1  ],
           [0.858, 0.142],
           [0.82 , 0.18 ],
           [0.992, 0.008],
           [0.984, 0.016],
           [0.464, 0.536],
           [0.97 , 0.03 ],
           [0.988, 0.012],
           [0.473, 0.527],
           [0.113, 0.887],
           [0.933, 0.067],
           [0.991, 0.009],
           [0.812, 0.188],
           [0.869, 0.131],
           [0.996, 0.004],
           [0.903, 0.097],
           [0.002, 0.998],
           [0.133, 0.867],
           [0.957, 0.043],
           [0.45 , 0.55 ],
           [0.203, 0.797],
           [0.002, 0.998],
           [0.992, 0.008],
           [0.85 , 0.15 ]])



模型績效: 評估分類模型的好壞--用混淆矩陣

PS: 要使用視覺化混淆矩陣要先執行以下的code (官網提供的)



```python


def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
```


```python
from sklearn.metrics import confusion_matrix
cnf=confusion_matrix(y_test, lr.predict(x_test_nor))
print('混淆矩陣：', cnf)
```

    混淆矩陣： [[19  2]
     [ 0  9]]



```python
import itertools
target_name=['yes','no']
plot_confusion_matrix(cnf,classes=target_name,title='confusion matrix')
plt.show()
```

    Confusion matrix, without normalization
    [[19  2]
     [ 0  9]]


    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/matplotlib/font_manager.py:1241: UserWarning: findfont: Font family ['SimHei'] not found. Falling back to DejaVu Sans.
      (prop.get_family(), self.defaultFamily[fontext]))



![png](index_files/index_20_2.png)



```python
#準確（分類）率
Accuracy= (19+9)/(19+9+2+0)
print(Accuracy)
```

    0.9333333333333333



```python
#命中率
precision=9/11
print(precision)
```

    0.8181818181818182



```python
#覆蓋率或者靈敏度
recall=9/9
print(recall)
```

    1.0



```python
F1=2/2.22222222222
print(F1)
```

    0.9000000000009


Reference
* [Python機器學習(scikit-learn) --Logistic Regression](http://to52016.pixnet.net/blog/post/343519054-%5Bpython%5D-logistic-regression%28%E7%BE%85%E5%90%89%E6%96%AF%E8%BF%B4%E6%AD%B8%29)
* [如何辨別機器學習模型的好壞？秒懂Confusion Matrix](https://www.ycc.idv.tw/confusion-matrix.html)
* [第 22 天機器學習（2）複迴歸與 Logistic 迴歸](https://ithelp.ithome.com.tw/articles/10187047)
