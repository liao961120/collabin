---
title: 南島語料搜尋小工具
subtitle: ''
tags: [lope]
date: '2019-05-10'
author: Don
mysite: /don/
comment: yes
---


# 南島語料搜尋小工具

這學期修了「語言田野調查」，請了汶水泰雅語的族語老師來給我們上課，並將每個禮拜採集的語料整理成一個.docx檔。

## 語料檔範例

```
1.
ma-tas=sami         su     tigami     ni     Payan    babay   i    Laway
AF-write=1PL.NOM    ACC    letter     BEN    Payan    for     NOM  Laway
主焦-寫=1PL.主格     受格    信         受益格   Payan    給      主格  Laway

#e I write the letter to Laway with Payan.  
#c 我跟Payan一起寫信給Laway。   
#n 比較 ki Payan 和 ni Payan: ki Payan的意思為「和 Payan」，ni Payan的意思為「 Payan的信」。

2.
si-pa-quwas=mu           i      yaya
CF-VBL-song=1SG.GEN      NOM    mother
參焦-動化-歌=1SG.屬格      名詞    媽媽
 
#e I sing for mom.
#c 我唱歌給媽媽聽。
#n i 可以省略。
```

## 語料編碼格式

```
[編號].
[族語轉寫]
[英文Glossing]
[中文Glossing]
[空行]
#e [英文翻譯]
#c [中文翻譯]
#n [註釋]
[空行]
```

但現在我遇到的麻煩是，我好奇的某個語言現象常常散佈在好多個`.docx`檔中，變成我要一個一個打開，然後用搜尋功能一個一個找出來。所以我就在想，是否可以寫個小程式，讓`python`爬完我資料夾中的`.docx`檔後，整理成單一的資料結構，這樣就可以直接下個搜尋，撈出所有相關的語料。

既然要處理word檔，我找到了一個叫做`docx`的套件，可以進去每個word檔撈出裡頭的文字。

## 程式碼


```python
import sys
import re
import os
from docx import Document
import pandas as pd
from IPython.display import display, HTML

class CorpusProcessor:
    def __init__(self, path):
        self.result = []
        self.path = path
        self._process_path(self.path)
        
    def search(self, query_word):
        """
        query_word: <Str>
            要搜索的字串，此搜索字串會先丟入re.compile()
            因此可以接收regex string
            例如此參數可以輸入"(LOC|INS)"
            則可以給出所有標有LOC或INS的語料。
        """

        pattern = re.compile(query_word)

        r = self._query_keyword(pattern)
        
        for k, v in r.items():
            print(f"<< {k} >>")
            if len(v) == 0:
                print("本週無相關資料")
            else:
                for item in v:
                    n = item['num']
                    c = item['content']
                    cc = c.split('\n')
                    cc = list(filter(lambda x: x!='', cc))
                    display(pd.DataFrame([cc[0].split(), cc[1].split(), cc[2].split()]).rename({0: "泰雅：", 1: "英文：", 2: "中文："}, axis='index')) 
                    print("[英文翻譯]")
                    print([ccc for ccc in cc if ccc.startswith("#e")][0])
                    print("[中文翻譯]")
                    print([ccc for ccc in cc if ccc.startswith("#c")][0])
                    print("[註釋]")
                    print([ccc for ccc in cc if ccc.startswith("#n")][0])
    
    def _process_path(self, p):
        for filename in os.listdir(p):
            if not filename.startswith("~") and (filename.endswith(".docx") or filename.endswith(".doc")):
                document = self._open_file(filename)
                self.result.append(self._process(document, filename))

    def _open_file(self, name):
        d = Document(name)
        return d
    
    
    def _process(self, doc, filename):
        result = {
            "file_name": filename,
            "data": []
        }
        all_p = doc.paragraphs
        num_re = re.compile("(\d{1,2})\.")

        num = 0
        current_index = -1
        # rrr = map(lambda x: re.match(num_re, x.text), all_p)
        start = False
        for p in all_p:
            num_re = re.compile("(\d{1,2})\.")
            match = re.match(num_re, p.text)

            if match:
                start = True
                num = match.group(1)
                result["data"].append({"num": num, "content": ""})
                current_index = len(result["data"]) - 1
            else:
                if not start:
                    pass
                else:
                    result["data"][current_index]["content"] += "\n" + p.text

        return result
    
    def _query_keyword(self, q):
        result = {}

        for file in self.result:
            result[file["file_name"]] = [sentence for sentence in file["data"] if re.search(q, sentence["content"])]

        return result
```

## 展示時間

要使用這個程式就必須要有以上述方式編碼的`.docx`語料檔。

這學期我的期末報告打算做Causative的句法議題，因此就來看一下目前收集到的汶水泰雅語中所有的使動結構：


```python
corpus = CorpusProcessor('.')
corpus.search('CAUS')
```

    << W10_20190507_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>si-pa-kasiyuk=mu</td>
      <td>ku</td>
      <td>pa-patas</td>
      <td>i</td>
      <td>rawin=mu</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CF-CAUS-borrow=1SG.GEN</td>
      <td>NOM</td>
      <td>NML-write</td>
      <td>NOM</td>
      <td>friend=1SG.GEN</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>參焦-使動-借=1SG.屬格</td>
      <td>主格</td>
      <td>名化-寫</td>
      <td>主格</td>
      <td>朋友=1SG.屬格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I lend pen to my classmate.
    [中文翻譯]
    #c 我借筆給我同學。
    [註釋]
    #n ku pa-patas 和 i rawin=mu可互換。這句「讓」的意思比較明顯。「我肯讓你向我借東西」，有點免搶。借的物品為主詞。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-kasiyuk-an=mu</td>
      <td>ku</td>
      <td>rawin=mu</td>
      <td>su</td>
      <td>pa-patas</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-borrow-LF=1SG.GEN</td>
      <td>NOM</td>
      <td>friend=1SG.GEN</td>
      <td>ACC</td>
      <td>pa-write</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-借-處焦=1SG.屬格</td>
      <td>主格</td>
      <td>朋友=1SG.屬格</td>
      <td>受格</td>
      <td>pa-寫</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I lend pen to my classmate.
    [中文翻譯]
    #c我借筆給我同學。
    [註釋]
    #n ditransitive 三論元句型。ku  rawin=mu 和su  pa-patas可互換。「我借給你」借的人為主詞。



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
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-kasiyuk-i=kuwing/kung</td>
      <td>tikai</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-barrow-PF=1SG.NOM</td>
      <td>a.while</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-借-受焦=1SG.主格</td>
      <td>一下</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Lend me.
    [中文翻譯]
    #c 借我一下。
    [註釋]
    #n 較有拜託之意。
    << W8_20190417_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-‘usa=mu</td>
      <td>i</td>
      <td>ba-biru-an</td>
      <td>i</td>
      <td>sasan</td>
      <td>ku</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-go=1SG.GEN</td>
      <td>LOC</td>
      <td>Ca-word-LOC</td>
      <td>LOC</td>
      <td>tomorrow</td>
      <td>NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-去=1SG.屬格</td>
      <td>處格</td>
      <td>Ca-字-處格</td>
      <td>處格</td>
      <td>明天</td>
      <td>主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I make my younger sister go to school tomorrow.
    [中文翻譯]
    #c 我要妹妹明天去學校。
    [註釋]
    #n pa-‘usa 可以說成 pa-‘usa-un。本句的i sasan可以省略。本句的 i babiruan 和 i sasan 順序可以調換。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-‘usa-un</td>
      <td>kuwing/kung</td>
      <td>i</td>
      <td>ba-biru-an</td>
      <td>ni</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-go-PF</td>
      <td>1SG.NOM</td>
      <td>LOC</td>
      <td>Ca-word-LOC</td>
      <td>GEN</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-去-受焦</td>
      <td>1SG.主格</td>
      <td>處格</td>
      <td>Ca-字-處格</td>
      <td>屬格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e My younger sister makes me go to school.
    [中文翻譯]
    #c 我的妹妹要我去學校。
    [註釋]
    #n本句和上一句動詞的兩個論元一個是普通名詞，一個是代名詞。主事者（上句的「我」和本句的「妹妹」）都用屬格，受事者（上句的「妹妹」和本句的「我」）都用主格。而且動詞不一樣了。語序也不一樣了。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-‘usa-un</td>
      <td>ni</td>
      <td>yaya</td>
      <td>i</td>
      <td>taipei</td>
      <td>i</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-go-PF</td>
      <td>GEN</td>
      <td>mother</td>
      <td>LOC</td>
      <td>Taipei</td>
      <td>NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-去-受焦</td>
      <td>屬格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>台北</td>
      <td>主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother lets my younger brother go to Taipei.
    [中文翻譯]
    #c 媽媽讓我的弟弟去台北。
    [註釋]
    #n



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>miki-pa-‘usa-un</td>
      <td>ni</td>
      <td>yaya</td>
      <td>i</td>
      <td>taipei</td>
      <td>i</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>want-CAUS-go-PF</td>
      <td>GEN</td>
      <td>mother</td>
      <td>LOC</td>
      <td>Taipei</td>
      <td>NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>想要-使動-去-受焦</td>
      <td>屬格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>台北</td>
      <td>主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother wants to let my younger brother go to Taipei.
    [中文翻譯]
    #c 媽媽想讓我的弟弟去台北。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>miki</td>
      <td>i</td>
      <td>pa-‘usa-un</td>
      <td>ni</td>
      <td>yaya</td>
      <td>i</td>
      <td>taipei</td>
      <td>i</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>want</td>
      <td>LNK</td>
      <td>CAUS-go-PF</td>
      <td>GEN</td>
      <td>mother</td>
      <td>LOC</td>
      <td>Taipei</td>
      <td>NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>想要</td>
      <td>聯繫詞</td>
      <td>使動-去-受焦</td>
      <td>屬格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>台北</td>
      <td>主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother wants to let my younger brother go to Taipei.
    [中文翻譯]
    #c 媽媽想讓我的弟弟去台北。
    [註釋]
    #n 意義與上句同
    << W4_20190313_HW.docx >>
    本週無相關資料
    << W9_20190424_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>sika-qanguqu=su</td>
      <td>ku</td>
      <td>iyu</td>
      <td>hani</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-sleep=2SG.GEN</td>
      <td>NOM</td>
      <td>medicine</td>
      <td>this</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-睡=2SG.屬格</td>
      <td>主格</td>
      <td>藥</td>
      <td>這</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e This medicine makes you fall asleep.
    [中文翻譯]
    #c 這個藥讓你睡著。
    [註釋]
    #n sika-nguqu 也可以。說sika-simui 或sika-kasimui  更嚴重。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>si-pa-qilaap</td>
      <td>ni</td>
      <td>yaya</td>
      <td>ku</td>
      <td>‘ulaqi</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>IF-CAUS-sleep</td>
      <td>GEN</td>
      <td>mother</td>
      <td>NOM</td>
      <td>child</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>工焦-使動-睡</td>
      <td>屬格</td>
      <td>媽媽</td>
      <td>主格</td>
      <td>小孩</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e The mother made the child sleep.
    [中文翻譯]
    #c 媽媽讓小孩睡覺。
    [註釋]
    #n
    << W6_20190327_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>kia</td>
      <td>qutux</td>
      <td>xuwil</td>
      <td>pin-tahuk</td>
      <td>sku</td>
      <td>ik</td>
      <td>na</td>
      <td>raralan</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>exist</td>
      <td>one</td>
      <td>dog</td>
      <td>CAUS-sit</td>
      <td>LOC</td>
      <td>under</td>
      <td>GEN</td>
      <td>table</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>存在</td>
      <td>一</td>
      <td>狗</td>
      <td>使動-坐</td>
      <td>處格</td>
      <td>下面</td>
      <td>屬格</td>
      <td>桌子</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e There is a dog made to sit under the table.
    [中文翻譯]
    #c 有一隻狗被某人讓他坐在那邊。
    [註釋]
    #n pin-tahuk 的意思是指某人讓某物坐在那邊。隱含迫使之意。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>kia</td>
      <td>qutux</td>
      <td>xuwil</td>
      <td>pin-tahuk=mu</td>
      <td>sku/i</td>
      <td>ik</td>
      <td>na</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>exist</td>
      <td>one</td>
      <td>dog</td>
      <td>CAUS-sit=1SG.NOM</td>
      <td>LOC</td>
      <td>under</td>
      <td>GEN</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>存在</td>
      <td>一</td>
      <td>狗</td>
      <td>使動-坐=1SG.主格</td>
      <td>處格</td>
      <td>下面</td>
      <td>屬格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e There is a dog which I make to sit under the table.
    [中文翻譯]
    #c 有一隻狗我讓他坐在桌子下。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ikwing</td>
      <td>ga</td>
      <td>kia</td>
      <td>qutux</td>
      <td>xuwil</td>
      <td>p-&lt;in&gt;tahuk(=mu)</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>1SG.NOM</td>
      <td>TOPIC</td>
      <td>exist</td>
      <td>one</td>
      <td>dog</td>
      <td>CAUS-&lt;PRF&gt;sit(=1SG.NOM)</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>1SG.主格</td>
      <td>主個</td>
      <td>存在</td>
      <td>一</td>
      <td>狗</td>
      <td>使動-&lt;完成&gt;坐(=1SG.主格)</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I made a dog sitting under the table.
    [中文翻譯]
    #c 我曾經讓一隻狗坐在桌子下。
    [註釋]
    #n mu省略也可以，但族語老師仍傾向加mu。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pin-tahuk=mu</td>
      <td>ku</td>
      <td>xuwil</td>
      <td>i</td>
      <td>ik</td>
      <td>na</td>
      <td>raralan</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-sit=1SG.NOM</td>
      <td>ACC</td>
      <td>dog</td>
      <td>LOC</td>
      <td>under</td>
      <td>GEN</td>
      <td>table</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-坐=1SG.主格</td>
      <td>受格</td>
      <td>狗</td>
      <td>處格</td>
      <td>下面</td>
      <td>屬格</td>
      <td>桌子</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I make the dog sitting under the table. 
    [中文翻譯]
    #c 我（現在）讓狗坐在桌子下。
    [註釋]
    #n
    << W11_20190508_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>p-&lt;in&gt;kasyuk=mu</td>
      <td>hiya</td>
      <td>ku</td>
      <td>pa-patas</td>
      <td>hani</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CAUS-&lt;PF&gt;borrow=1SG.GEN</td>
      <td>3SG.NOM</td>
      <td>NOM</td>
      <td>NML-write</td>
      <td>this</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>使動-&lt;受焦&gt;借=1SG.屬格</td>
      <td>3SG.主格</td>
      <td>主格</td>
      <td>名化-寫</td>
      <td>這</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I lent him him this pen last month.
    [中文翻譯]
    #c 這隻筆是我上個月借給他的。
    [註釋]
    #n maquwa ka watin : 下個月，要來的月。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>si-pi-kitaal=kung</td>
      <td>su</td>
      <td>singbung</td>
      <td>ni</td>
      <td>yaya</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CF-CAUS-taal=1SG.NOM</td>
      <td>ACC</td>
      <td>news</td>
      <td>GEN</td>
      <td>mother</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>參焦-使動-看=1Sg.主格</td>
      <td>受格</td>
      <td>新聞</td>
      <td>屬格</td>
      <td>媽媽</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother lets me see news.
    [中文翻譯]
    #c 媽媽讓我看新聞。
    [註釋]
    #n si-pa-kitaal = si-pi-kitaal=si-ka-kitaal。 su singbung 和 ni yaya 可以互換位址。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ini</td>
      <td>pa-kital-i</td>
      <td>su</td>
      <td>singbung</td>
      <td>ni</td>
      <td>yaya</td>
      <td>i</td>
      <td>yaba</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>NEG</td>
      <td>CAUS-see-CF</td>
      <td>ACC</td>
      <td>news</td>
      <td>GEN</td>
      <td>mother</td>
      <td>NOM</td>
      <td>father</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>否定</td>
      <td>使動-看-參焦</td>
      <td>受格</td>
      <td>新聞</td>
      <td>屬格</td>
      <td>媽媽</td>
      <td>主格</td>
      <td>爸爸</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother doen’t let father watch news.
    [中文翻譯]
    #c 媽媽不讓爸爸看新聞。
    [註釋]
    #n 這裡paki-tal-i 可說成 piki-tal-i
    << W5_20190320_HW.docx >>
    本週無相關資料
    << W7_20190327_HW.docx >>
    本週無相關資料


讓我們看一下泰雅語的「煮」：


```python
corpus.search('cook')
```

    << W10_20190507_HW.docx >>
    本週無相關資料
    << W8_20190417_HW.docx >>
    本週無相關資料
    << W4_20190313_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>uniyan=su</td>
      <td>t&lt;um&gt;ahuk</td>
      <td>su</td>
      <td>ayang</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>PROG=2SG.GEN</td>
      <td>&lt;AF&gt;cook</td>
      <td>ACC</td>
      <td>soup</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>正在=2SG.屬格</td>
      <td>煮</td>
      <td>受格</td>
      <td>湯</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e You are making soup. 
    [中文翻譯]
    #c 你正在煮湯。
    [註釋]
    #n tumahuk煮什麼湯都可以，有水的就可以。
    << W9_20190424_HW.docx >>
    本週無相關資料
    << W6_20190327_HW.docx >>
    本週無相關資料
    << W11_20190508_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>si-pa-hapuy=nia</td>
      <td>nanak</td>
      <td>i</td>
      <td>hiya</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CF-VBL-fire=3SG.GEN</td>
      <td>alone</td>
      <td>NOM</td>
      <td>3SG.NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>參焦-動化-火=3SG.屬格</td>
      <td>獨自</td>
      <td>主格</td>
      <td>3SG.主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e he cooks for himself.
    [中文翻譯]
    #c 他煮飯給自己吃。
    [註釋]
    #n i nia和nanak位置可以交換。
    << W5_20190320_HW.docx >>
    本週無相關資料
    << W7_20190327_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>kia</td>
      <td>i</td>
      <td>yaya</td>
      <td>i</td>
      <td>ha-hapuy-an</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>exist</td>
      <td>NOM</td>
      <td>mother</td>
      <td>LOC</td>
      <td>cook-LOC</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>存在</td>
      <td>主格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>煮-處格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e The mother is in the kitchen.
    [中文翻譯]
    #c 媽媽在廚房。
    [註釋]
    #n 本句的媽媽為說聽話者都知道的媽媽，可能就是你的或我的媽媽。請與下句將 i 替換成 a 做比較。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>kia</td>
      <td>a</td>
      <td>yaya</td>
      <td>i</td>
      <td>hahapuy-an</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>exist</td>
      <td>NOM</td>
      <td>mother</td>
      <td>LOC</td>
      <td>cook-LOC</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>存在</td>
      <td>主格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>煮-處格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e A mother is in the kitchen.
    [中文翻譯]
    #c 有個媽媽在廚房。
    [註釋]
    #n 本句的媽媽為某一個媽媽，但不知道是誰，只知道是有一個媽媽。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>maki</td>
      <td>kuwing</td>
      <td>i</td>
      <td>hahapuy-an</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>exist</td>
      <td>1SG.NOM</td>
      <td>LOC</td>
      <td>cook-LOC</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>存在</td>
      <td>1SG.主格</td>
      <td>處格</td>
      <td>煮-處格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I am in the kitchen.
    [中文翻譯]
    #c 我在廚房。
    [註釋]
    #n maki 也可以說成 makia。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>t&lt;um&gt;ahuk</td>
      <td>su</td>
      <td>ayang</td>
      <td>i</td>
      <td>yaya</td>
      <td>i</td>
      <td>hahapuy-an</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>&lt;AF&gt;cook</td>
      <td>ACC</td>
      <td>soup</td>
      <td>NOM</td>
      <td>mother</td>
      <td>LOC</td>
      <td>cook-LOC</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>&lt;主焦&gt;煮</td>
      <td>受格</td>
      <td>湯</td>
      <td>主格</td>
      <td>媽媽</td>
      <td>處格</td>
      <td>煮-處格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mom is making soup in the kitchen.
    [中文翻譯]
    #c 媽媽在廚房裡煮湯。
    [註釋]
    #n



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>t&lt;um&gt;ahuk</td>
      <td>su</td>
      <td>ayang</td>
      <td>i</td>
      <td>kuwing</td>
      <td>i</td>
      <td>hahapuy-an</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>&lt;AF&gt;cook</td>
      <td>ACC</td>
      <td>soup</td>
      <td>NOM</td>
      <td>1SG.NOM</td>
      <td>LOC</td>
      <td>cook-LOC</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>&lt;主焦&gt;煮</td>
      <td>受格</td>
      <td>湯</td>
      <td>主格</td>
      <td>1SG.主格</td>
      <td>處格</td>
      <td>煮-處格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I am boiling soup in the kitchen.
    [中文翻譯]
    #c 我在廚房裡煮湯。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>t&lt;um&gt;ahuk=su</td>
      <td>ayang</td>
      <td>i</td>
      <td>hahapuy-an</td>
      <td>qu</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>&lt;AF&gt;cook=2SG.NOM</td>
      <td>soup</td>
      <td>LOC</td>
      <td>cook-LOC</td>
      <td>Q</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>&lt;主焦&gt;煮=2SG.主格</td>
      <td>湯</td>
      <td>處格</td>
      <td>煮-處格</td>
      <td>疑問助詞</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Do you make soup in the kitchen?
    [中文翻譯]
    #c 你在廚房裡煮湯嗎？
    [註釋]
    #n 請與下句在句首加了uni’an做比較。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>uni’an=su</td>
      <td>t&lt;um&gt;ahuk</td>
      <td>su</td>
      <td>ayang</td>
      <td>i</td>
      <td>hahapuyan</td>
      <td>qu</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>PROG=2SG.NOM</td>
      <td>&lt;AF&gt;cook</td>
      <td>ACC</td>
      <td>soup</td>
      <td>LOC</td>
      <td>cook-LOC</td>
      <td>Q</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>進行=2SG.主格</td>
      <td>&lt;主焦&gt;煮湯</td>
      <td>受格</td>
      <td>湯</td>
      <td>處格</td>
      <td>煮-處格</td>
      <td>疑問助詞</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Are you making soup in the kitchen?
    [中文翻譯]
    #c 你在廚房裡煮湯嗎？
    [註釋]
    #n 本句中第一個su為第二人稱的clitic，第二個su為受格標記。


query string也可以接收regex string，假設我想叫出所有含有「工具格」(Instrumental case)和「共格」(Comitative case)的句子:


```python
corpus.search('共格|工具格')
```

    << W10_20190507_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ma-tas</td>
      <td>na</td>
      <td>pa-patas</td>
      <td>i</td>
      <td>hiya</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>AF-write</td>
      <td>INS</td>
      <td>NML-write</td>
      <td>NOM</td>
      <td>3SG.NOM</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>主焦-寫</td>
      <td>工具格</td>
      <td>名化-寫</td>
      <td>主格</td>
      <td>3SG.主格</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e He writes with pen.
    [中文翻譯]
    #c他用筆寫字。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>si-patas=mu</td>
      <td>na</td>
      <td>pa-patas</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>CF-write=1SG.GEN</td>
      <td>INS</td>
      <td>NML-write</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>參焦-寫=1SG.屬格</td>
      <td>工具格</td>
      <td>名化-寫</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I write with pen.
    [中文翻譯]
    #c 我用筆寫字。
    [註釋]
    #n AF的p/m型，原形為matas，但加了前綴會變成patas(e.g. si + matas -> sipatas)



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>tal-an=mu</td>
      <td>i</td>
      <td>hiya</td>
      <td>matas</td>
      <td>na</td>
      <td>pa-patas</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>see-LF=1SG.GEN</td>
      <td>NOM</td>
      <td>3SG.NOM</td>
      <td>write.AF</td>
      <td>INS</td>
      <td>名化-write</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>看-處焦=1SG.屬格</td>
      <td>主格</td>
      <td>3SG.NOM</td>
      <td>寫.主焦</td>
      <td>工具格</td>
      <td>名化-寫</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I see him writing with pen.
    [中文翻譯]
    #c 我看到他用筆寫字。
    [註釋]
    #n i hiya 可以移到句尾。
    << W8_20190417_HW.docx >>
    本週無相關資料
    << W4_20190313_HW.docx >>
    本週無相關資料
    << W9_20190424_HW.docx >>
    本週無相關資料
    << W6_20190327_HW.docx >>
    本週無相關資料
    << W11_20190508_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ma-tas=kung</td>
      <td>su</td>
      <td>tigami</td>
      <td>ki</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>AF-write=1SG.NOM</td>
      <td>ACC</td>
      <td>letter</td>
      <td>COM</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>主焦-寫=1SG.主格</td>
      <td>受格</td>
      <td>信</td>
      <td>共格</td>
      <td>Payan</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I write a letter to Payan.
    [中文翻譯]
    #c我寫一封信給Payan。 
    [註釋]
    #n ni (BEN) Payan => 幫Payan寫信。給老師：ki  pa-pasibaq



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ma-tas=kung</td>
      <td>su</td>
      <td>tigami</td>
      <td>ki</td>
      <td>pa-pasibaq</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>AF-write=1SG.NOM</td>
      <td>ACC</td>
      <td>letter</td>
      <td>COM</td>
      <td>teacher</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>主焦-寫=1SG.主格</td>
      <td>受格</td>
      <td>信</td>
      <td>共格</td>
      <td>老師</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I write a letter to the teacher.
    [中文翻譯]
    #c我寫一封信給老師。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>ma-tas=sami</td>
      <td>su</td>
      <td>tigami</td>
      <td>ki/ni</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>AF-write=1PL.NOM</td>
      <td>ACC</td>
      <td>letter</td>
      <td>COM/BEN</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>主焦-寫=1PL.主格</td>
      <td>受格</td>
      <td>信</td>
      <td>共格/受益格</td>
      <td>Payan</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I write the letter to Laway with Payan.
    [中文翻譯]
    #c 我跟Payan一起寫信給Laway。 
    [註釋]
    #n 比較 ki Payan 和 ni Payan: ki Payan的意思為「和 Payan」，ni Payan的意思為「 Payan的信」。



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>arua=mu</td>
      <td>si-bainai</td>
      <td>ki</td>
      <td>Payan</td>
      <td>ku</td>
      <td>pa-patas</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>already=1SG.GEN</td>
      <td>CF-buy</td>
      <td>COM</td>
      <td>Payan</td>
      <td>NOM</td>
      <td>NML-write</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>已經=1SG.GEN</td>
      <td>參焦-買</td>
      <td>共格</td>
      <td>Payan</td>
      <td>主格</td>
      <td>名化-寫</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I’ve already sold pen to Payan.
    [中文翻譯]
    #c 我把筆賣給Payan了。
    [註釋]
    #n 



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>pa-b&lt;in&gt;asun=mu</td>
      <td>ku</td>
      <td>pa-patas</td>
      <td>ki</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>IRR-&lt;PF&gt;buy=1SG.GEN</td>
      <td>NOM</td>
      <td>pa-write</td>
      <td>COM</td>
      <td>Payan</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>非實現-&lt;受焦&gt;買=1SG.屬格</td>
      <td>主格</td>
      <td>pa-寫</td>
      <td>共格</td>
      <td>Payan</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e I will sell pen to Payan. / I will buy pen from Payan.
    [中文翻譯]
    #c 我要把筆賣給Payan。/ 我要跟Payan買筆。
    [註釋]
    #n 
    << W5_20190320_HW.docx >>
    本週無相關資料
    << W7_20190327_HW.docx >>



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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>泰雅：</th>
      <td>uni’an</td>
      <td>i</td>
      <td>humibaw</td>
      <td>su/*ku</td>
      <td>paruxau</td>
      <td>i</td>
      <td>yaya</td>
    </tr>
    <tr>
      <th>英文：</th>
      <td>PROG</td>
      <td>LNK</td>
      <td>cut</td>
      <td>ACC</td>
      <td>vegetable</td>
      <td>NOM</td>
      <td>mother</td>
    </tr>
    <tr>
      <th>中文：</th>
      <td>進行</td>
      <td>連繫詞</td>
      <td>切</td>
      <td>受格</td>
      <td>菜</td>
      <td>主格</td>
      <td>媽媽</td>
    </tr>
  </tbody>
</table>
</div>


    [英文翻譯]
    #e Mother is cutting vegetable.
    [中文翻譯]
    #c媽媽正在切菜。
    [註釋]
    #n 若不用特別強調「正在」，可以省略句首的”uni’an i”。humibaw意義為「切」，而上句的hahibaw 的意義為「用來切」(工具格？)。


## 心得

這學期的語言田調課，感覺很像是上學期句法課學到的知識終於派上了用場，而且還是用在一個雖然從來不認識但其實離自己其實很近的活生生的南島語上。好像課本上那些抽象的術語都有了血肉之軀，但當然，實際採集到的語料（或者說實際的語言）絕對不會是像每本參考語法上寫的那樣那麼方正、那麼規矩，不是每個實際的句子都能無誤地由某幾條規則推導出那樣，而那些不規則性所反映的正是實際語言在演化/涵化/變化的痕跡以及人腦的複雜性。

後來覺得這樣的小程式好像就是一個小語料庫那樣，從採收來的一籃藍語料裡挑出想要的果實。至此我也才體會到上學期的語料庫語言學課上，老師不斷強調的，語料庫真正重要的是經過分析整理後的標記，如果沒有了這些用沒日沒夜的語料轉寫辛勞換來的標記，我根本不可能透過這個程式去抓出所有的屬格或者工具格，然後做進一步的語言學分析，更不用說不同人對同個語料可能會有不同的標記和詮釋。

突然想起這學期遇到的另一位老師，他總是對當今的機器/AI的能力持疑。現在的確是有很多自動標記詞性的演算法，無論是用統計方法或是機率模型，但對於像泰雅語這種電子化的語料非常少數的語言，常常連我在判斷某個詞到底要標什麼格位時都無法60%確定了，我又要如何寫演算法讓機器幫忙找出呢？或者是如果沒有語言學家先給定泰雅語裡面到底名詞有幾種格位，電腦真的能夠自己找出有幾種嗎？或者這真的是個有標準答案的問題嗎？常常聽到那位老師這類悲觀的論調（以及對人類族群抱以樂觀的論調）時，就會想說，那麼我們要做的應該不是從此封印電腦吧，而是要想辦法讓電腦在這些層面能「跟得上」人類。而要怎麼讓電腦「像人類一樣」，似乎又必須回到諸多計算模型的模擬，我們不一定要讓電腦給出最佳唯一解，但至少應該要讓電腦能像我們一樣能夠存疑和問問題才對。

這大概就是本週的微心得。

我有把這個微專案放到[Github](https://github.com/puerdon/corpus_processor)上，目前是由我和力行一起維護，目前也還在想可以加什麼功能，能讓期末報告寫得更順利。
