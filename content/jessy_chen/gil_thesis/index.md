---
title: NTU GIL Thesis Analysis (1)
subtitle: ''
tags: [lope]
date: '2019-05-03'
author: Jessy Chen
mysite: /jessy_chen/
comment: yes
---



```python
import requests
from bs4 import BeautifulSoup
import re
import pandas as pd
import jieba
```


```python
soup_lst = []
pages = range(1, 7+1)
for page in pages:
    print(page)
    url = "http://www.airitilibrary.com/Search/alThesisbrowse?FirstID=U0001&ThirdID=D0001001010&type=Dissertations&SecondID=C0001001&publicationTypeID=publicationType_all&page=" + str(page)
    res = requests.get(url)
    soup = BeautifulSoup(res.text, "lxml")
    soup_lst.append(soup)
```

    1
    2
    3
    4
    5
    6
    7



```python
lst = []
num = 1
for soup in soup_lst:
    for d in soup.find("tbody").find_all("td"):
        ahref = d.find("span", class_="title_con1")
        if ahref:
            title = ahref.text.strip()
            link = ahref.select("a[href]")
            author, year = [n.text.strip() for n in d.find_all("span", class_="note_con1")]
            year = re.search("\\d{4}", year).group(0)
            keywords = [n.text for n in d.find("span", class_="note_conN").find_all("a")]
            lst.append({"title": title, "link": link, "author": author, "year": year, "keywords": keywords})
            print(num)
            num = num + 1
        else:
            pass
```

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45
    46
    47
    48
    49
    50
    51
    52
    53
    54
    55
    56
    57
    58
    59
    60
    61
    62
    63
    64
    65
    66
    67
    68
    69
    70
    71
    72
    73
    74
    75
    76
    77
    78
    79
    80
    81
    82
    83
    84
    85
    86
    87
    88
    89
    90
    91
    92
    93
    94
    95
    96
    97
    98
    99
    100
    101
    102
    103
    104
    105
    106
    107
    108
    109
    110
    111
    112
    113
    114
    115
    116
    117
    118
    119
    120
    121
    122
    123
    124
    125
    126



```python
lst
```




    [{'author': '曹景瑄',
      'keywords': ['一詞多義', '詞類歧義', '語境', '語意優勢性', '詞彙歧義解困', '個體差異', '事件相關電位'],
      'link': [<a href="/Publication/Index/U0001-2603201917354500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2603201917354500');});},this); return false;">
                     語義優勢性對語法語境中詞彙歧義解析之影響—中文歧義詞處理的事件相關電位研究
                   </a>],
      'title': '語義優勢性對語法語境中詞彙歧義解析之影響—中文歧義詞處理的事件相關電位研究',
      'year': '2019'},
     {'author': '顏瑄慧',
      'keywords': ['語言習得', '句法處理', '人工語法學習', '統計學習', '左右半腦差異', '個別差異', '事件相關電位'],
      'link': [<a href="/Publication/Index/U0001-0701201917122400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0701201917122400');});},this); return false;">
                     左右半腦差異與句法結構複雜度之學習——以事件相關腦電位分析人工語法處理狀況
                   </a>],
      'title': '左右半腦差異與句法結構複雜度之學習——以事件相關腦電位分析人工語法處理狀況',
      'year': '2019'},
     {'author': '湯苓',
      'keywords': ['統計學習',
       '非相鄰依存規律',
       '中文人造語言',
       '單耳交替聆聽實驗方法',
       '左右半腦差異',
       '語言腦側化現象',
       '事件相關電位'],
      'link': [<a href="/Publication/Index/U0001-2901201810091100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2901201810091100');});},this); return false;">
                     左右半腦非相鄰依存統計學習之初探
                   </a>],
      'title': '左右半腦非相鄰依存統計學習之初探',
      'year': '2018'},
     {'author': '葉遲',
      'keywords': ['半腦間抑制關係',
       '半腦間協作關係',
       '句法處理',
       '分視野實驗',
       '統計學習',
       'interhemispheric inhibition',
       'interhemispheric coordination'],
      'link': [<a href="/Publication/Index/U0001-2609201800590700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2609201800590700');});},this); return false;">
                     以事件相關電位看句法處理側化、半腦間互動關係以及語言能力的相互關係
                   </a>],
      'title': '以事件相關電位看句法處理側化、半腦間互動關係以及語言能力的相互關係',
      'year': '2018'},
     {'author': '鍾柔安',
      'keywords': ['動詞偏態（效果）',
       '關係子句',
       '語法處理',
       '漸進式處理',
       'verb bias (effect)',
       'relative clause processing',
       'syntactic processing'],
      'link': [<a href="/Publication/Index/U0001-0708201814502500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0708201814502500');});},this); return false;">
                     動詞偏態對處理中文關係子句的影響: 事件相關電位研究
                   </a>],
      'title': '動詞偏態對處理中文關係子句的影響: 事件相關電位研究',
      'year': '2018'},
     {'author': '李佳臻',
      'keywords': ['情感分析',
       '評價語言',
       '主題模型',
       '模式文法',
       '意見偵測',
       '意見擷取',
       'aspect-based sentiment analysis'],
      'link': [<a href="/Publication/Index/U0001-1405201811353600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1405201811353600');});},this); return false;">
                     評價語言分析與主題擷取-網路旅遊部落格情感分析之應用
                   </a>],
      'title': '評價語言分析與主題擷取-網路旅遊部落格情感分析之應用',
      'year': '2018'},
     {'author': '張智傑',
      'keywords': ['臺灣南島語', '布農語', '郡群', '空間認知', '動作事件', '時間認知', '隱喻'],
      'link': [<a href="/Publication/Index/U0001-1908201823204000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201823204000');});},this); return false;">
                     郡群布農語的空間與時間表達研究
                   </a>],
      'title': '郡群布農語的空間與時間表達研究',
      'year': '2018'},
     {'author': '吳小涵',
      'keywords': ['性別自然語言處理',
       '薰衣草語言學',
       '同性戀文本',
       '卷積神經網路',
       '支持向量機器',
       'GenderNLP',
       'Lavender Linguistic'],
      'link': [<a href="/Publication/Index/U0001-2509201810293500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2509201810293500');});},this); return false;">
                     以性別自然語言處理觀點分析與預測同志語言
                   </a>],
      'title': '以性別自然語言處理觀點分析與預測同志語言',
      'year': '2018'},
     {'author': '劉郁文',
      'keywords': ['憂鬱症', '言談分析', '計算語言學', '主題模型', '線上諮詢', '醫病溝通', '同儕支持'],
      'link': [<a href="/Publication/Index/U0001-0103201709244300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0103201709244300');});},this); return false;">
                     憂鬱症線上討論言談之主題分析
                   </a>],
      'title': '憂鬱症線上討論言談之主題分析',
      'year': '2017'},
     {'author': '鄭愛琳',
      'keywords': ['語態系統',
       '中間語態',
       '中間語態標記',
       '類型比較',
       '上莫利語',
       '西部馬來-玻里尼西亞語',
       'voice system'],
      'link': [<a href="/Publication/Index/U0001-1807201723214200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1807201723214200');});},this); return false;">
                     上莫利語的語態系統: 以中間語態為主
                   </a>],
      'title': '上莫利語的語態系統: 以中間語態為主',
      'year': '2017'},
     {'author': '李智堯',
      'keywords': ['中文詞彙網路',
       '語意網',
       '詞彙知識本體',
       '鏈結資料',
       '普林斯頓詞彙網路',
       '數位辭典學',
       'Chinese Wordnet'],
      'link': [<a href="/Publication/Index/U0001-1412201618043200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1412201618043200');});},this); return false;">
                     中文詞彙網鏈結資料化：從桌面資料庫至適用於語意網的詞彙知識本體
                   </a>],
      'title': '中文詞彙網鏈結資料化：從桌面資料庫至適用於語意網的詞彙知識本體',
      'year': '2017'},
     {'author': '黃資勻',
      'keywords': ['語言學標記',
       '中文',
       '自然語言處理',
       '群眾募集',
       '遊戲化',
       'Linguistics Annotation',
       'Chinese'],
      'link': [<a href="/Publication/Index/U0001-2408201713544600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2408201713544600');});},this); return false;">
                     ESemiCrowd - 中文自然語言處理的群眾外包架構
                   </a>],
      'title': 'ESemiCrowd - 中文自然語言處理的群眾外包架構',
      'year': '2017'},
     {'author': '許學旻',
      'keywords': ['醫病言談',
       '醫病溝通',
       '醫師病人陪同者溝通',
       '醫病三方溝通',
       '禮貌',
       'medical discourse',
       'doctor-patient communication'],
      'link': [<a href="/Publication/Index/U0001-2308201719590100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2308201719590100');});},this); return false;">
                     醫病溝通中之協商：以北台灣之眼科醫師為例
                   </a>],
      'title': '醫病溝通中之協商：以北台灣之眼科醫師為例',
      'year': '2017'},
     {'author': '莊育穎',
      'keywords': ['語音變異',
       '詞彙辨識',
       '變異頻率',
       '社會意涵',
       '說話者信息',
       '台灣華語',
       'phonetic variation'],
      'link': [<a href="/Publication/Index/U0001-1508201713183400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201713183400');});},this); return false;">
                     台灣華語語音變異對詞彙辨識之影響
                   </a>],
      'title': '台灣華語語音變異對詞彙辨識之影響',
      'year': '2017'},
     {'author': '吳怡安',
      'keywords': ['中文詞彙網路',
       '詞義消歧',
       '詞義標記',
       '監都式學習',
       '文字嵌入',
       'Chinese Wordnet',
       'Word Sense Disambiguation'],
      'link': [<a href="/Publication/Index/U0001-1808201616221600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1808201616221600');});},this); return false;">
                     中文詞彙網路的詞義消歧
                   </a>],
      'title': '中文詞彙網路的詞義消歧',
      'year': '2016'},
     {'author': '李婉如',
      'keywords': ['疼痛',
       '疼痛表達',
       '認知語言學',
       '認知隱喻',
       '自我',
       'pain',
       'pain expressions'],
      'link': [<a href="/Publication/Index/U0001-0302201622003700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0302201622003700');});},this); return false;">
                     從認知語言學看中文的疼痛表達
                   </a>],
      'title': '從認知語言學看中文的疼痛表達',
      'year': '2016'},
     {'author': '蔡宜庭',
      'keywords': ['老化', '隱喻理解歷程', '熟悉的隱喻', '非熟悉的隱喻', '個別差異', '語言流暢度測驗', 'aging'],
      'link': [<a href="/Publication/Index/U0001-0302201611041000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0302201611041000');});},this); return false;">
                     老化對處理非熟悉隱喻的影響
                   </a>],
      'title': '老化對處理非熟悉隱喻的影響',
      'year': '2016'},
     {'author': '陳馨妍',
      'keywords': ['多模態',
       '肖似性',
       '文法隱喻',
       '認知語言學',
       '現代西洋繪畫',
       '非再現性藝術',
       'Multimodality'],
      'link': [<a href="/Publication/Index/U0001-1308201621251200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1308201621251200');});},this); return false;">
                     現代繪畫中文本性之認知多模態探討
                   </a>],
      'title': '現代繪畫中文本性之認知多模態探討',
      'year': '2016'},
     {'author': '許靖瑋',
      'keywords': ['語前助詞', '語用功能', '社會互動', '文類', '多功能性', '言談分析', '談話分析'],
      'link': [<a href="/Publication/Index/U0001-1207201615394100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1207201615394100');});},this); return false;">
                     中文語前助詞的語用功能：以Eh2和Oh為例
                   </a>],
      'title': '中文語前助詞的語用功能：以Eh2和Oh為例',
      'year': '2016'},
     {'author': '林怡馨',
      'keywords': ['詞表',
       '基本詞彙',
       '英文詞網',
       '覆蓋率',
       '語意階層',
       'wordlists',
       'basic words'],
      'link': [<a href="/Publication/Index/U0001-0102201614494700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0102201614494700');});},this); return false;">
                     詞表告訴了我們什麼？—以詞義及難度分級檢驗現存英文詞表
                   </a>],
      'title': '詞表告訴了我們什麼？—以詞義及難度分級檢驗現存英文詞表',
      'year': '2016'},
     {'author': '莊茹涵',
      'keywords': ['批踢踢',
       '立場分類',
       '語用學',
       '語料庫語言學',
       '線上回文',
       'PTT',
       'stance classification'],
      'link': [<a href="/Publication/Index/U0001-2302201623470800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2302201623470800');});},this); return false;">
                     中文短回文立場分類
                   </a>],
      'title': '中文短回文立場分類',
      'year': '2016'},
     {'author': '廖于萱',
      'keywords': ['反霸凌', '海報研究', '視覺語法', '跨文化比較', '集體主義和個人主義', '關注受害者', '關注霸凌者'],
      'link': [<a href="/Publication/Index/U0001-1708201612325400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708201612325400');});},this); return false;">
                     很棒的想法？很霸的想法？：從反霸凌海報比較霸凌的概念
                   </a>],
      'title': '很棒的想法？很霸的想法？：從反霸凌海報比較霸凌的概念',
      'year': '2016'},
     {'author': '周伶蓁',
      'keywords': ['情緒預測',
       '語言',
       '事件相關電位',
       '同理心',
       '晚期正波',
       'emotional expectation',
       'language'],
      'link': [<a href="/Publication/Index/U0001-0302201617473900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0302201617473900');});},this); return false;">
                     以事件相關電位研究情緒預測在句子處理中的影響
                   </a>],
      'title': '以事件相關電位研究情緒預測在句子處理中的影響',
      'year': '2016'},
     {'author': '詹君陽',
      'keywords': ['國語', '配音', '成對變異指數', 'Guoyu', 'dubbing', 'PVI'],
      'link': [<a href="/Publication/Index/U0001-3107201700373400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-3107201700373400');});},this); return false;">
                     標準國語的想像？台灣配音表演的語音與社會意涵分析
                   </a>],
      'title': '標準國語的想像？台灣配音表演的語音與社會意涵分析',
      'year': '2016'},
     {'author': '許展嘉',
      'keywords': ['篇章組織詞串', '頻率', '人際溝通詞串', '常用詞串', '指涉詞串', '語體', '使用基礎模型'],
      'link': [<a href="/Publication/Index/U0001-1006201610081500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1006201610081500');});},this); return false;">
                     中文的常用詞串
                   </a>],
      'title': '中文的常用詞串',
      'year': '2016'},
     {'author': '黃文怡',
      'keywords': ['多模態隱喻',
       '轉喻',
       '都市意象',
       '繪本',
       '視覺－文字多模態隱喻辨識程序',
       '魔幻超現實',
       '多模態隱喻場景連鎖反應'],
      'link': [<a href="/Publication/Index/U0001-1508201605534500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201605534500');});},this); return false;">
                     小城故事：繪本中的都市意象之多模態隱喻研究
                   </a>],
      'title': '小城故事：繪本中的都市意象之多模態隱喻研究',
      'year': '2016'},
     {'author': '李柏緯',
      'keywords': ['異性戀常規性', '性/別', '語言與身分認同', '批判話語分析', '語料庫語言學', '交友網站', '男同志'],
      'link': [<a href="/Publication/Index/U0001-2306201619430000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2306201619430000');});},this); return false;">
                     性向、偏好、與身分認同論述：以台灣交友網站的異性戀常規性為例
                   </a>],
      'title': '性向、偏好、與身分認同論述：以台灣交友網站的異性戀常規性為例',
      'year': '2016'},
     {'author': '雷翔宇',
      'keywords': ['鼻韻尾合流',
       '語料庫研究',
       '自然語料',
       '方言差異',
       '韻律顯著',
       '韻律邊界',
       'syllable-final nasal merger'],
      'link': [<a href="/Publication/Index/U0001-1808201616404800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1808201616404800');});},this); return false;">
                     臺灣華語自然語料中鼻韻尾合流之韻律與方言影響
                   </a>],
      'title': '臺灣華語自然語料中鼻韻尾合流之韻律與方言影響',
      'year': '2016'},
     {'author': '陳旻昕',
      'keywords': ['句法處理',
       '中文詞類訊息',
       '分視野實驗',
       '語言腦側化現象',
       '兩腦間抑制關係',
       '兩腦間合作關係',
       'syntactic processing'],
      'link': [<a href="/Publication/Index/U0001-1708201610391500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708201610391500');});},this); return false;">
                     中文詞類訊息處理的腦側化現象：事件相關電位研究
                   </a>],
      'title': '中文詞類訊息處理的腦側化現象：事件相關電位研究',
      'year': '2016'},
     {'author': '張貽涵',
      'keywords': ['概念隱喻',
       '月經',
       '衛生棉',
       '衛生棉條',
       '女性身體',
       'Conceptual metaphor',
       'menstruation'],
      'link': [<a href="/Publication/Index/U0001-1907201613063700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1907201613063700');});},this); return false;">
                     月經意象在女性衛生用品中的概念隱喻：以網路經驗分享文和廣告為例
                   </a>],
      'title': '月經意象在女性衛生用品中的概念隱喻：以網路經驗分享文和廣告為例',
      'year': '2016'},
     {'author': '江妍',
      'keywords': ['戀愛言談', '告白', '戀愛說服', '說服策略', '拒絕策略', '接受策略', '會話分析'],
      'link': [<a href="/Publication/Index/U0001-1408201620064600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1408201620064600');});},this); return false;">
                     戀愛言談:告白中的說服、拒絕、與接受之策略研究
                   </a>],
      'title': '戀愛言談:告白中的說服、拒絕、與接受之策略研究',
      'year': '2016'},
     {'author': '葉宇喬',
      'keywords': ['鼻韻尾合流',
       '語句重音',
       '韻律邊界',
       '自然語料',
       '臺灣華語',
       'syllable-final nasal mergers',
       'prosodic promenince'],
      'link': [<a href="/Publication/Index/U0001-1308201511594600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1308201511594600');});},this); return false;">
                     年齡與韻律對臺灣華語自然語料庫中鼻音韻尾合流之影響
                   </a>],
      'title': '年齡與韻律對臺灣華語自然語料庫中鼻音韻尾合流之影響',
      'year': '2015'},
     {'author': '李乃欣',
      'keywords': ['非詞覆誦',
       '接受性詞彙',
       '表達性詞彙',
       '音韻口語輸出能力',
       'nonword repetition',
       'receptive vocabulary',
       'expressive vocabulary'],
      'link': [<a href="/Publication/Index/U0001-1308201511153400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1308201511153400');});},this); return false;">
                     中文學齡前幼童的非詞覆誦、詞彙量及音韻能力在發展過程中之動態互動：跨序列研究
                   </a>],
      'title': '中文學齡前幼童的非詞覆誦、詞彙量及音韻能力在發展過程中之動態互動：跨序列研究',
      'year': '2015'},
     {'author': '楊靜琛',
      'keywords': ['詞彙習得',
       '名詞偏向',
       '基本層次範疇',
       '華語習得',
       '詞彙多樣性',
       '語料庫',
       'vocabulary acquisition'],
      'link': [<a href="/Publication/Index/U0001-1908201522133300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201522133300');});},this); return false;">
                     測量華語兒童早期詞彙成長:以語料庫為本之研究
                   </a>],
      'title': '測量華語兒童早期詞彙成長:以語料庫為本之研究',
      'year': '2015'},
     {'author': '王伯雅',
      'keywords': ['詞彙穩定', '詞彙生命', '新詞', '詞彙擴散', '網路語言', '語言改變', '量化語言學'],
      'link': [<a href="/Publication/Index/U0001-1908201520284000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201520284000');});},this); return false;">
                     詞彙穩定的秘密—對各語言學面向的質性與量化分析
                   </a>],
      'title': '詞彙穩定的秘密—對各語言學面向的質性與量化分析',
      'year': '2015'},
     {'author': '呂珮瑜',
      'keywords': ['情緒指稱詞',
       '情緒示意詞',
       '情緒詞',
       '語意韻律',
       '詞組塊',
       'emotion denoting words',
       'emotion signaling words'],
      'link': [<a href="/Publication/Index/U0001-1608201619544600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1608201619544600');});},this); return false;">
                     中文情緒詞庫的建造與標記
                   </a>],
      'title': '中文情緒詞庫的建造與標記',
      'year': '2015'},
     {'author': '林盈妤',
      'keywords': ['多模態融合聚變理論',
       '多模態隱喻/轉喻',
       '閱聽者反應',
       '多模態提示',
       '多模態體裁',
       'Multimodal Fusion Model',
       'multimodal metaphor/metonymy'],
      'link': [<a href="/Publication/Index/U0001-1808201500105200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1808201500105200');});},this); return false;">
                     多模態，隱喻，與詮釋的交會：以政治漫畫與藝術歌曲為佐證
                   </a>],
      'title': '多模態，隱喻，與詮釋的交會：以政治漫畫與藝術歌曲為佐證',
      'year': '2015'},
     {'author': '楊佳縈',
      'keywords': ['卡那卡那富語', '蒙受關係', '受害概念', '受益概念', '致使句構', '轉移動詞', 'Kanakanavu'],
      'link': [<a href="/Publication/Index/U0001-2901201615070100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2901201615070100');});},this); return false;">
                     卡那卡那富語受益與受害概念的語言表徵
                   </a>],
      'title': '卡那卡那富語受益與受害概念的語言表徵',
      'year': '2015'},
     {'author': '呂慈紘',
      'keywords': ['隱喻理解歷程',
       '二語習得',
       '二語語義理解',
       '二語譬喻性字詞',
       'Metaphor processing',
       'second language learning',
       'second language semantic processing'],
      'link': [<a href="/Publication/Index/U0001-0202201617170000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0202201617170000');});},this); return false;">
                     英文為外語學習者理解英文隱喻的神經認知機制
                   </a>],
      'title': '英文為外語學習者理解英文隱喻的神經認知機制',
      'year': '2015'},
     {'author': '劉星辰',
      'keywords': ['卡那卡那富語',
       '焦點系統',
       '構詞句法',
       '語意角色',
       '語用功能',
       'Kanakanavu',
       'voice'],
      'link': [<a href="/Publication/Index/U0001-1808201412265300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1808201412265300');});},this); return false;">
                     卡那卡那富語焦點系統之語意及言談功能
                   </a>],
      'title': '卡那卡那富語焦點系統之語意及言談功能',
      'year': '2014'},
     {'author': '陳佳音',
      'keywords': ['動態事件',
       '語言習得',
       '空間語言',
       'motion event',
       'language acquisition',
       'spatial language'],
      'link': [<a href="/Publication/Index/U0001-2701201412141200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2701201412141200');});},this); return false;">
                     西班牙文動態事件樣貌與路徑表達方式之研究：以中文母語者為例
                   </a>],
      'title': '西班牙文動態事件樣貌與路徑表達方式之研究：以中文母語者為例',
      'year': '2014'},
     {'author': '段人鳯',
      'keywords': ['體現',
       '生成詞彙',
       '隱喻',
       '身體部位',
       '政治話語',
       'embodiment',
       'generative lexicon'],
      'link': [<a href="/Publication/Index/U0001-2008201523402500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2008201523402500');});},this); return false;">
                     體現與生成詞彙之交會：以台灣總統演講中的身體隱喻為例
                   </a>],
      'title': '體現與生成詞彙之交會：以台灣總統演講中的身體隱喻為例',
      'year': '2014'},
     {'author': '劉純睿',
      'keywords': ['批踢踢',
       '動態語料庫',
       '臺灣華語',
       'PTT',
       'dynamic corpus',
       'Taiwan Mandarin'],
      'link': [<a href="/Publication/Index/U0001-2110201409484500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2110201409484500');});},this); return false;">
                     批踢踢語料庫之建置與應用
                   </a>],
      'title': '批踢踢語料庫之建置與應用',
      'year': '2014'},
     {'author': '鄧安婷',
      'keywords': ['疑問詞',
       '疑問句構',
       '卡那卡那富語',
       '語言類型學',
       '副詞性動詞結構',
       'Interrogative words',
       'Interrogative constructions'],
      'link': [<a href="/Publication/Index/U0001-2008201414340300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2008201414340300');});},this); return false;">
                     卡那卡那富語疑問句探究
                   </a>],
      'title': '卡那卡那富語疑問句探究',
      'year': '2014'},
     {'author': '沈姿妤',
      'keywords': ['隱喻理解歷程',
       '字面意的激發',
       '熟悉度高的隱喻',
       '熟悉度低的隱喻',
       '動作感覺的模擬(sensory-motor simulation)',
       '心像形成能力',
       '圖像效果'],
      'link': [<a href="/Publication/Index/U0001-1908201410563600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201410563600');});},this); return false;">
                     隱喻熟悉度以及個人心像認知能力對於理解動作隱喻之影響:事件相關電位研究
                   </a>],
      'title': '隱喻熟悉度以及個人心像認知能力對於理解動作隱喻之影響:事件相關電位研究',
      'year': '2014'},
     {'author': '王聖富',
      'keywords': ['台灣閩南語',
       '台語',
       '段落訊號',
       '韻律疆界',
       '自然語料',
       'Taiwan Southern Min',
       'Taiwanese'],
      'link': [<a href="/Publication/Index/U0001-0508201313461700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0508201313461700');});},this); return false;">
                     台灣閩南語自然語料中言談單位交界之音長訊號
                   </a>],
      'title': '台灣閩南語自然語料中言談單位交界之音長訊號',
      'year': '2013'},
     {'author': '王駿杰',
      'keywords': ['言談語用功能',
       '「結果」',
       '「反預期」標記',
       '互動功能',
       '會話結構組織功能',
       '預期故事情節結尾',
       '標誌故事情節結尾'],
      'link': [<a href="/Publication/Index/U0001-1708201314464900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708201314464900');});},this); return false;">
                     漢語「結果」的言談語用功能
                   </a>],
      'title': '漢語「結果」的言談語用功能',
      'year': '2013'},
     {'author': '吳姿瑩',
      'keywords': ['繼承語學習',
       '泰雅習得詞彙',
       '衍生詞綴習得',
       '語言經驗',
       'heritage language learning',
       'Atayal acquired lexicon',
       'acquisition of derivational morphology'],
      'link': [<a href="/Publication/Index/U0001-2801201314420500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2801201314420500');});},this); return false;">
                     泰雅語衍生詞綴習得：以新竹某國小為例
                   </a>],
      'title': '泰雅語衍生詞綴習得：以新竹某國小為例',
      'year': '2013'},
     {'author': '陳炯皓',
      'keywords': ['情緒', '情緒動詞', '構式', '事件結構', '使役', 'emotion', 'emotion verbs'],
      'link': [<a href="/Publication/Index/U0001-3011201316135800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-3011201316135800');});},this); return false;">
                     台灣閩南語情緒動詞及其構式:從認知觀點分析
                   </a>],
      'title': '台灣閩南語情緒動詞及其構式:從認知觀點分析',
      'year': '2013'},
     {'author': '林玥彤',
      'keywords': ['時間詞', '近義詞', '時間距離差異', '之前', '以前', '之後', '以後'],
      'link': [<a href="/Publication/Index/U0001-1908201318165200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201318165200');});},this); return false;">
                     中文近義詞「之前/以前」及「之後/以後」之時間距離差異研究
                   </a>],
      'title': '中文近義詞「之前/以前」及「之後/以後」之時間距離差異研究',
      'year': '2013'},
     {'author': '林昱志',
      'keywords': ['汶水泰雅語',
       '致使構式',
       '致使概念',
       '構詞�句法',
       '形式�語意關聯',
       '語態',
       'Mayrinax Atayal'],
      'link': [<a href="/Publication/Index/U0001-1508201321421200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201321421200');});},this); return false;">
                     汶水泰雅語中致使概念的語言表現：致使連續體的觀點
                   </a>],
      'title': '汶水泰雅語中致使概念的語言表現：致使連續體的觀點',
      'year': '2013'},
     {'author': '何尉賢',
      'keywords': ['語言學',
       '馬來語',
       '認知語法',
       '副詞',
       '形容詞',
       'linguistics',
       'Malay language'],
      'link': [<a href="/Publication/Index/U0001-1408201317004700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1408201317004700');});},this); return false;">
                     從認知觀點看馬來語-nya的副詞功能
                   </a>],
      'title': '從認知觀點看馬來語-nya的副詞功能',
      'year': '2013'},
     {'author': '黃宗榮',
      'keywords': ['介係詞',
       '進行態助動詞',
       '汶水泰雅語',
       '結構重整',
       '語法化',
       'adposition',
       'progressive auxiliary'],
      'link': [<a href="/Publication/Index/U0001-1508201313053100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201313053100');});},this); return false;">
                     汶水泰雅語中的kiya 與haniyan：其介詞用法及助動詞用法
                   </a>],
      'title': '汶水泰雅語中的kiya 與haniyan：其介詞用法及助動詞用法',
      'year': '2013'},
     {'author': '葉郁婷',
      'keywords': ['底', '圖', '圖示', '動詞類別', '內在承受者', '承受形式之假定值', 'default UV form'],
      'link': [<a href="/Publication/Index/U0001-1508201306364200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201306364200');});},this); return false;">
                     泰雅語之事件概念化與動詞分類
                   </a>],
      'title': '泰雅語之事件概念化與動詞分類',
      'year': '2013'},
     {'author': '新留修一',
      'keywords': ['情緒', '顏色', '部位', '生理學', '前後搭配詞', '身體體現', 'emotion'],
      'link': [<a href="/Publication/Index/U0001-1609201200442700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1609201200442700');});},this); return false;">
                     四種情緒與顏色的變化 : 認知語言學和生理學的解釋
                   </a>],
      'title': '四種情緒與顏色的變化 : 認知語言學和生理學的解釋',
      'year': '2012'},
     {'author': '徐寧',
      'keywords': ['敘事分析',
       '精神分裂症',
       '思想障礙',
       '敘事評定量表(Narrative Assessment Profile)',
       '人物描述',
       'narratives',
       'schizophrenia'],
      'link': [<a href="/Publication/Index/U0001-0702201219245100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0702201219245100');});},this); return false;">
                     中文精神分裂症病患敘事能力之研究
                   </a>],
      'title': '中文精神分裂症病患敘事能力之研究',
      'year': '2012'},
     {'author': '粘雅婷',
      'keywords': ['隱喻', '互動言談', '動態系統', '社會認知', '言談主題', '系統性隱喻', '慣用性'],
      'link': [<a href="/Publication/Index/U0001-1508201201105000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201201105000');});},this); return false;">
                     從語料庫看中文互動言談中隱喻的動態表現
                   </a>],
      'title': '從語料庫看中文互動言談中隱喻的動態表現',
      'year': '2012'},
     {'author': '謝承諭',
      'keywords': ['空殼名詞', '語言作為社會行動', '會話分析', '互動語言學', '語輪組織', '立場採取', '互為主觀性'],
      'link': [<a href="/Publication/Index/U0001-2008201210383800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2008201210383800');});},this); return false;">
                     中文空殼名詞之互動功能: 以問題是、事實上、這樣(子)和什麼意思為例
                   </a>],
      'title': '中文空殼名詞之互動功能: 以問題是、事實上、這樣(子)和什麼意思為例',
      'year': '2012'},
     {'author': '史家麟',
      'keywords': ['霧台魯凱語',
       '格位標記',
       '言談分析',
       '功能語法',
       '句法學',
       'Budai Rukai',
       'Case Marker'],
      'link': [<a href="/Publication/Index/U0001-0808201214355100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0808201214355100');});},this); return false;">
                     霧台魯凱語格位標記有無探討
                   </a>],
      'title': '霧台魯凱語格位標記有無探討',
      'year': '2012'},
     {'author': '李珮琪',
      'keywords': ['性別隱喻',
       '語言與性別',
       '性別社會建構',
       '概念隱喻',
       'gender metaphor',
       'language and gender',
       'social construction of gender'],
      'link': [<a href="/Publication/Index/U0001-1908201215263300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201215263300');});},this); return false;">
                     水漾女人、動物男人、與隱喻：性別與年齡交互影響之性別隱喻研究
                   </a>],
      'title': '水漾女人、動物男人、與隱喻：性別與年齡交互影響之性別隱喻研究',
      'year': '2012'},
     {'author': '史家麟',
      'keywords': ['霧台魯凱語',
       '格位標記',
       '言談分析',
       '功能語法',
       '句法學',
       'Budai Rukai',
       'Case Marker'],
      'link': [<a href="/Publication/Index/U0001-0808201214355100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0808201214355100');});},this); return false;">
                     霧台魯凱語格位標記有無探討
                   </a>],
      'title': '霧台魯凱語格位標記有無探討',
      'year': '2012'},
     {'author': '謝雯雯',
      'keywords': ['概念隱喻',
       '教育',
       '文化',
       '成語及諺語',
       'conceptual metaphor',
       'education',
       'culture'],
      'link': [<a href="/Publication/Index/U0001-2905201212350300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2905201212350300');});},this); return false;">
                     教育概念隱喻研究：以華語及英文成語與諺語為例
                   </a>],
      'title': '教育概念隱喻研究：以華語及英文成語與諺語為例',
      'year': '2012'},
     {'author': '邱盛秀',
      'keywords': ['對抗隱喻', '批判論述分析', '意識', '框架理論', '法律語言', '台灣', 'FIGHT metaphor'],
      'link': [<a href="/Publication/Index/U0001-3107201219421900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-3107201219421900');});},this); return false;">
                     法律語言中之對抗隱喻:認知語言學觀點
                   </a>],
      'title': '法律語言中之對抗隱喻:認知語言學觀點',
      'year': '2012'},
     {'author': '鄭綉蓉',
      'keywords': ['動態事件',
       '族語學習',
       '原住民語言',
       '語言經驗',
       '敘事',
       'motion event',
       'heritage language learning'],
      'link': [<a href="/Publication/Index/U0001-2504201216194700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2504201216194700');});},this); return false;">
                     學習泰雅語動態事件編碼:以新竹某國小族語學習為例
                   </a>],
      'title': '學習泰雅語動態事件編碼:以新竹某國小族語學習為例',
      'year': '2012'},
     {'author': '陳正賢',
      'keywords': ['韻律段落', '聲學參數', '音韻單位', '自然語言處理', '口語處理', '子句切分', '計算模型'],
      'link': [<a href="/Publication/Index/U0001-2809201111373500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2809201111373500');});},this); return false;">
                     以計算統計方法及聲學參數研究中文自然語流之韻律短語切分
                   </a>],
      'title': '以計算統計方法及聲學參數研究中文自然語流之韻律短語切分',
      'year': '2012'},
     {'author': '許家齊',
      'keywords': ['形式功能對應',
       '中文',
       '情態助動詞',
       '認知發展',
       'form and function mapping',
       'Mandarin',
       'modals'],
      'link': [<a href="/Publication/Index/U0001-1307201121575600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1307201121575600');});},this); return false;">
                     早期語言發展中的「要」
                   </a>],
      'title': '早期語言發展中的「要」',
      'year': '2011'},
     {'author': '程涂媛',
      'keywords': ['言談訊息',
       '關係子句',
       '漢語關係子句',
       '言談中關係子句',
       '兒童漢語',
       'information flow',
       'relative clause'],
      'link': [<a href="/Publication/Index/U0001-1908201109453700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201109453700');});},this); return false;">
                     從言談訊息談漢語兒童「的」語句之使用
                   </a>],
      'title': '從言談訊息談漢語兒童「的」語句之使用',
      'year': '2011'},
     {'author': '李立基',
      'keywords': ['反身代名詞所有格',
       '語料庫語言學',
       '視角',
       '主觀性',
       'reflexive possessive',
       'corpus linguistics',
       'viewpoint'],
      'link': [<a href="/Publication/Index/U0001-1908201110140000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1908201110140000');});},this); return false;">
                     漢語反身代名詞所有格的研究
                   </a>],
      'title': '漢語反身代名詞所有格的研究',
      'year': '2011'},
     {'author': '李家宏',
      'keywords': ['學術寫作',
       '名物化',
       '文步分析',
       '語法隱喻',
       '凝結性',
       '非個人化',
       'academic writing'],
      'link': [<a href="/Publication/Index/U0001-1412201117551700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1412201117551700');});},this); return false;">
                     名物化在醫學期刊「摘要」與「背景」的語用分析
                   </a>],
      'title': '名物化在醫學期刊「摘要」與「背景」的語用分析',
      'year': '2011'},
     {'author': '呂維倫',
      'keywords': ['多義詞', '主觀化', '概念原型', '影像基模', '語境（上下文）', '隱喻', '動詞片語'],
      'link': [<a href="/Publication/Index/U0001-1708201122120200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708201122120200');});},this); return false;">
                     對一詞多義現象的概念探索︰[V] – [UP] 與 [V] – [上] 的研究
                   </a>],
      'title': '對一詞多義現象的概念探索︰[V] – [UP] 與 [V] – [上] 的研究',
      'year': '2011'},
     {'author': '鄒佳蓉',
      'keywords': ['賽德克太魯閣',
       '格位標記',
       '時態時貌系統',
       '衍生構詞',
       'Truku Seediq',
       'case marker',
       'tense/aspect/modality system'],
      'link': [<a href="/Publication/Index/U0001-2107201110084900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2107201110084900');});},this); return false;">
                     賽德克太魯閣語句法探究
                   </a>],
      'title': '賽德克太魯閣語句法探究',
      'year': '2011'},
     {'author': '洪嘉馡',
      'keywords': ['詞彙歧異',
       '詞義預測',
       '語料庫為主的方法',
       '詞形相似成群的方法',
       '概念相似成群的方法',
       '實驗性的評估',
       'Lexical ambiguity'],
      'link': [<a href="/Publication/Index/U0001-2306201010550300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2306201010550300');});},this); return false;">
                     詞義預測研究：以語料庫驅動的語言學研究方法
                   </a>],
      'title': '詞義預測研究：以語料庫驅動的語言學研究方法',
      'year': '2010'},
     {'author': '劉雅玲',
      'keywords': ['旅程隱喻',
       '原住民流行音樂',
       '流行歌詞',
       '概念隱喻',
       '事件結構隱喻',
       'JOURNEY metaphor',
       'indigenous pop lyrics'],
      'link': [<a href="/Publication/Index/U0001-1507201010463800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1507201010463800');});},this); return false;">
                     台灣原住民國語流行歌詞之旅程隱喻研究
                   </a>],
      'title': '台灣原住民國語流行歌詞之旅程隱喻研究',
      'year': '2010'},
     {'author': '林國喬',
      'keywords': ['內在動貌',
       '事件結構',
       '布農語',
       '臺灣南島語',
       '事件特徵',
       'inner aspect',
       'event structure'],
      'link': [<a href="/Publication/Index/U0001-2906201018340800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2906201018340800');});},this); return false;">
                     卓群布農語內在動貌之句法研究
                   </a>],
      'title': '卓群布農語內在動貌之句法研究',
      'year': '2010'},
     {'author': '王國樹',
      'keywords': ['概念隱喻模型',
       '概念隱喻',
       '融合理論',
       '合成隱喻',
       '流行音樂',
       '愛情',
       'Metaphor Network Model'],
      'link': [<a href="/Publication/Index/U0001-1508201020541500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508201020541500');});},this); return false;">
                     概念隱喻網絡研究：以國語流行歌曲之愛情主題為例
                   </a>],
      'title': '概念隱喻網絡研究：以國語流行歌曲之愛情主題為例',
      'year': '2010'},
     {'author': '張晉寧',
      'keywords': ['雙關語', '廣告', '混和理論', '多型式輸入', '中文特性', 'pun', 'advertisemen'],
      'link': [<a href="/Publication/Index/U0001-1402201022020800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1402201022020800');});},this); return false;">
                     從認知語用觀點看中文雙關語廣告的理解：以台北捷運站內廣告為例
                   </a>],
      'title': '從認知語用觀點看中文雙關語廣告的理解：以台北捷運站內廣告為例',
      'year': '2010'},
     {'author': '吳得心',
      'keywords': ['工具延伸性',
       '詞彙發展',
       '動詞延伸',
       'instrument extensibility',
       'lexical development',
       'verb extension'],
      'link': [<a href="/Publication/Index/U0001-2007201015240000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2007201015240000');});},this); return false;">
                     兒童的動詞運用:工具的延伸性
                   </a>],
      'title': '兒童的動詞運用:工具的延伸性',
      'year': '2010'},
     {'author': '黃惠如',
      'keywords': ['鄒語', '台灣南島語', '句法', '語用', '詞組序', 'voice /焦點', '名詞指涉形'],
      'link': [<a href="/Publication/Index/U0001-1308201017160200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1308201017160200');});},this); return false;">
                     鄒語言談語句詞組之語法與語用分析
                   </a>],
      'title': '鄒語言談語句詞組之語法與語用分析',
      'year': '2010'},
     {'author': '洪媽益',
      'keywords': ['Cebuano語',
       '菲律賓語',
       '南島語',
       '語法',
       '篇章',
       'Cebuano',
       'Austronesian'],
      'link': [<a href="/Publication/Index/U0001-1901200917112700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1901200917112700');});},this); return false;">
                     Cebuano功能參考語法
                   </a>],
      'title': 'Cebuano功能參考語法',
      'year': '2009'},
     {'author': '張有鈞',
      'keywords': ['層次顯著性假說',
       '詞義顯著性',
       '語料庫詞義頻率',
       '隱喻多義詞',
       '詞彙隱喻',
       '語境效應',
       '約定俗成隱喻'],
      'link': [<a href="/Publication/Index/U0001-1508200910545400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1508200910545400');});},this); return false;">
                     隱喻多義詞之心理處理歷程：語境、詞義頻率與詞義顯著性
                   </a>],
      'title': '隱喻多義詞之心理處理歷程：語境、詞義頻率與詞義顯著性',
      'year': '2009'},
     {'author': '王炳勻',
      'keywords': ['認知語言學', '構式語法', '認知固化', '事件融合', '語意延伸', '原則性多義', '結果動詞'],
      'link': [<a href="/Publication/Index/U0001-1108200910014000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1108200910014000');});},this); return false;">
                     從語言使用到構式固化：漢語多義結果動詞「V-開」的認知語言學研究
                   </a>],
      'title': '從語言使用到構式固化：漢語多義結果動詞「V-開」的認知語言學研究',
      'year': '2009'},
     {'author': '陳素玫',
      'keywords': ['語意特指性',
       '語意分類',
       '詞彙習得',
       '詞彙發展',
       '動詞習得',
       '快速對應',
       'semantic specificity'],
      'link': [<a href="/Publication/Index/U0001-2207200920501300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2207200920501300');});},this); return false;">
                     詞彙特指性與詞彙習得之探討
                   </a>],
      'title': '詞彙特指性與詞彙習得之探討',
      'year': '2009'},
     {'author': '落合泉',
      'keywords': ['賽德克語',
       '附著代名詞',
       '自由型代名詞',
       '主詞與動詞一致性',
       'portmanteau 型',
       'Seediq',
       'clitic'],
      'link': [<a href="/Publication/Index/U0001-2207200917092100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2207200917092100');});},this); return false;">
                     賽德克語代名詞研究
                   </a>],
      'title': '賽德克語代名詞研究',
      'year': '2009'},
     {'author': '莊育穎',
      'keywords': ['捲舌音', '齒音', '重音', '詞類', '自然語料', '台灣華語', 'retroflex sibilant'],
      'link': [<a href="/Publication/Index/U0001-1708200916104100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708200916104100');});},this); return false;">
                     台灣華語自然語料中無聲捲舌音及齒音之聲學研究
                   </a>],
      'title': '台灣華語自然語料中無聲捲舌音及齒音之聲學研究',
      'year': '2009'},
     {'author': '林盈妤',
      'keywords': ['王建民',
       '台灣',
       '棒球',
       '批判隱喻模式分析 (CMM)',
       '報紙論述',
       'Chien-Ming Wang',
       'Taiwan'],
      'link': [<a href="/Publication/Index/U0001-1708200913544700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1708200913544700');});},this); return false;">
                     台灣報紙論述中的王建民現象:批判隱喻模式分析
                   </a>],
      'title': '台灣報紙論述中的王建民現象:批判隱喻模式分析',
      'year': '2009'},
     {'author': '龔書萍',
      'keywords': ['概念映照模型',
       '華語隱喻',
       '隱喻釋義',
       '語境',
       '句子處理',
       'Conceptual Mapping Model',
       'metaphors in Mandarin Chinese'],
      'link': [<a href="/Publication/Index/U0001-0501200916585400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0501200916585400');});},this); return false;">
                     概念隱喻的映照規則
                   </a>],
      'title': '概念隱喻的映照規則',
      'year': '2009'},
     {'author': '劉業馨',
      'keywords': ['賽德克語', '韻律', '詞彙重音', '語調', '聲學', '類型學', 'ToBI'],
      'link': [<a href="/Publication/Index/U0001-2007200910493200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2007200910493200');});},this); return false;">
                     賽德克語韻律研究
                   </a>],
      'title': '賽德克語韻律研究',
      'year': '2009'},
     {'author': '許立昭',
      'keywords': ['複合詞重音',
       '片語重音',
       '聲學特色',
       '第二語言韻律',
       '台灣學生',
       'compound stress',
       'phrasal stress'],
      'link': [<a href="/Publication/Index/U0001-2101200907312200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2101200907312200');});},this); return false;">
                     英語複合詞及片語重音研究：比較台灣高等英語學習者與以英語為母語的外國人
                   </a>],
      'title': '英語複合詞及片語重音研究：比較台灣高等英語學習者與以英語為母語的外國人',
      'year': '2009'},
     {'author': '左如平',
      'keywords': ['分類',
       '分類詞',
       '度量詞',
       '語料庫語言學',
       '知識本體',
       'categorization',
       'measure word'],
      'link': [<a href="/Publication/Index/U0001-0508200913293700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0508200913293700');});},this); return false;">
                     由分類看認知: 以英語量詞為例
                   </a>],
      'title': '由分類看認知: 以英語量詞為例',
      'year': '2009'},
     {'author': '黃妙茹',
      'keywords': ['詞彙習得',
       '斷詞',
       '中文',
       '副詞',
       'lexical acquisition',
       'word segmentation',
       'Mandarin'],
      'link': [<a href="/Publication/Index/U0001-2307200922522100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2307200922522100');});},this); return false;">
                     早期語言發展中的「還」
                   </a>],
      'title': '早期語言發展中的「還」',
      'year': '2009'},
     {'author': '姚郁芬',
      'keywords': ['位置結構', '時貌', '動詞習得', '學習機制', '同音字', 'IPL理解作業', '語言習得'],
      'link': [<a href="/Publication/Index/U0001-2907200914042600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2907200914042600');});},this); return false;">
                     「在」的語言發展歷程研究
                   </a>],
      'title': '「在」的語言發展歷程研究',
      'year': '2009'},
     {'author': '吳怡臻',
      'keywords': ['台灣華語',
       '台灣閩語',
       '聲調',
       '焦點',
       '同步習得雙語者',
       '語言流利度',
       'Taiwan Mandarin'],
      'link': [<a href="/Publication/Index/U0001-1808200919401900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1808200919401900');});},this); return false;">
                     閩語流利度對台灣華閩雙語者聲調與焦點呈現之影響
                   </a>],
      'title': '閩語流利度對台灣華閩雙語者聲調與焦點呈現之影響',
      'year': '2009'},
     {'author': '吳佳霖',
      'keywords': ['動態事件',
       '空間語言',
       '雙語習得',
       '語言處理',
       'motion event',
       'spatial language',
       'bilingual language acquisition'],
      'link': [<a href="/Publication/Index/U0001-1907200813550100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1907200813550100');});},this); return false;">
                     中英雙語者之中文動態事件組裝探討：英語經驗的影響
                   </a>],
      'title': '中英雙語者之中文動態事件組裝探討：英語經驗的影響',
      'year': '2008'},
     {'author': '何佳容',
      'keywords': ['撒奇萊雅', '音素', '母音', '重音', '語調', '音韻學', '語音學'],
      'link': [<a href="/Publication/Index/U0001-2307200820242400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2307200820242400');});},this); return false;">
                     撒奇萊雅語音韻與語音交流研究—母音、重音節、句子語調
                   </a>],
      'title': '撒奇萊雅語音韻與語音交流研究—母音、重音節、句子語調',
      'year': '2008'},
     {'author': '宋立心',
      'keywords': ['賽夏語',
       '比較句結構',
       '語言類型學',
       '超越型比較句',
       '形容詞',
       'Saisiyat',
       'comparative constructions'],
      'link': [<a href="/Publication/Index/U0001-3007200814131400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-3007200814131400');});},this); return false;">
                     賽夏語比較句結構
                   </a>],
      'title': '賽夏語比較句結構',
      'year': '2008'},
     {'author': '黃舒屏',
      'keywords': ['多義詞', '比較語言學', '分類', '原型', '語料標記', '觀點化', 'polysemy'],
      'link': [<a href="/Publication/Index/U0001-2507200816035800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2507200816035800');});},this); return false;">
                     多義詞的分析及其在語料庫標記的應用: 以賽夏語為例
                   </a>],
      'title': '多義詞的分析及其在語料庫標記的應用: 以賽夏語為例',
      'year': '2008'},
     {'author': '黃宜萱',
      'keywords': ['台灣華語', '語言變異', '高聲調標的', '一聲', '四聲', '焦點', 'Taiwan Mandarin'],
      'link': [<a href="/Publication/Index/U0001-2507200816594400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2507200816594400');});},this); return false;">
                     台灣華語高聲調標的呈現之語言變異研究
                   </a>],
      'title': '台灣華語高聲調標的呈現之語言變異研究',
      'year': '2008'},
     {'author': '林佑旻',
      'keywords': ['語言分類',
       '文化',
       '隱喻',
       '轉喻',
       '語境',
       'linguistic categorization',
       'culture'],
      'link': [<a href="/Publication/Index/U0001-2907200823192800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2907200823192800');});},this); return false;">
                     「心」的語意分析：從語言分類和文化認知談起
                   </a>],
      'title': '「心」的語意分析：從語言分類和文化認知談起',
      'year': '2008'},
     {'author': '賴美璇',
      'keywords': ['中文「比」字比較句',
       '程度副詞',
       '規則建立',
       '類比過程',
       '語言習得',
       'Mandarin BI comparative structure',
       'degree adverbs'],
      'link': [<a href="/Publication/Index/U0001-1407200815230100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1407200815230100');});},this); return false;">
                     兒童早期「比」字比較句之副詞使用
                   </a>],
      'title': '兒童早期「比」字比較句之副詞使用',
      'year': '2008'},
     {'author': '郭政淳',
      'keywords': ['比較句結構',
       '類型學',
       '「超越」型(比較句)',
       '去動詞化',
       '詞類系統',
       'comparative construction',
       'typology'],
      'link': [<a href="/Publication/Index/U0001-0107200814143100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0107200814143100');});},this); return false;">
                     阿美語的比較句結構
                   </a>],
      'title': '阿美語的比較句結構',
      'year': '2008'},
     {'author': '王玨珵',
      'keywords': ['意義', '語意學', '句構', '譬喻', '轉喻', 'meaning', 'semantics'],
      'link': [<a href="/Publication/Index/U0001-1107200814220500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1107200814220500');});},this); return false;">
                     檢視「詞彙概念及認知模型」理論：以漢語「走」為基礎的研究
                   </a>],
      'title': '檢視「詞彙概念及認知模型」理論：以漢語「走」為基礎的研究',
      'year': '2008'},
     {'author': '陳依婷',
      'keywords': ['規避詞', '主觀性', '互動主觀性', '禮貌', '面子', '禮貌策略', 'hedges'],
      'link': [<a href="/Publication/Index/U0001-2807200816214800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2807200816214800');});},this); return false;">
                     中文口語言談中規避詞的使用
                   </a>],
      'title': '中文口語言談中規避詞的使用',
      'year': '2008'},
     {'author': '沈文琦',
      'keywords': ['撒奇萊雅', '句法', '否定', '疑問', '使役', '阿美語', 'Sakizaya'],
      'link': [<a href="/Publication/Index/U0001-1907200801500500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1907200801500500');});},this); return false;">
                     撒奇萊雅語句法結構初探
                   </a>],
      'title': '撒奇萊雅語句法結構初探',
      'year': '2008'},
     {'author': '林智凱',
      'keywords': ['東亞漢字音',
       '優選理論',
       '歷史音韻',
       '晦澀性',
       '音節結構',
       'Sino-Xenic Languages',
       'Optimality Theory'],
      'link': [<a href="/Publication/Index/U0001-1407200818541300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1407200818541300');});},this); return false;">
                     東亞漢字音之入聲韻變化: 以優選理論探討
                   </a>],
      'title': '東亞漢字音之入聲韻變化: 以優選理論探討',
      'year': '2008'},
     {'author': '董鴻鈞',
      'keywords': ['台語',
       '音調擾動',
       '韻律',
       '音質',
       'Taiwanese',
       'tonal perturbation',
       'prosody'],
      'link': [<a href="/Publication/Index/U0001-0502200811473600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0502200811473600');});},this); return false;">
                     臺語韻律對語音調擾動及音質的影響
                   </a>],
      'title': '臺語韻律對語音調擾動及音質的影響',
      'year': '2008'},
     {'author': '蕭季樺',
      'keywords': ['情緒, 句構, 事件結構, 隱喻, 誇飾',
       'emotion, construction, event structure, metaphor, hyperbole'],
      'link': [<a href="/Publication/Index/U0001-2707200709400600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2707200709400600');});},this); return false;">
                     漢語口語之情緒語言
                   </a>],
      'title': '漢語口語之情緒語言',
      'year': '2007'},
     {'author': '謝富惠',
      'keywords': ['情緒語言',
       '思想語言',
       '語法模式',
       '情感系統',
       '人觀的民族文化理論',
       'language of emotion',
       'talk of thinking'],
      'link': [<a href="/Publication/Index/U0001-0802200710093700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0802200710093700');});},this); return false;">
                     噶瑪蘭語及賽夏語情緒及思想語言之研究
                   </a>],
      'title': '噶瑪蘭語及賽夏語情緒及思想語言之研究',
      'year': '2007'},
     {'author': '鍾曉芳',
      'keywords': ['源域',
       '概念隱喻',
       '由上而下的方式',
       '由下而上的方式',
       '知識本體',
       '搭配詞組',
       'source domains'],
      'link': [<a href="/Publication/Index/U0001-2408200709484700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2408200709484700');});},this); return false;">
                     以語料庫驅動之隱喻源域界定研究
                   </a>],
      'title': '以語料庫驅動之隱喻源域界定研究',
      'year': '2007'},
     {'author': '李乃欣',
      'keywords': ['非詞覆誦',
       '音韻發展',
       '音韻記憶',
       '音韻處理能力',
       '發音訓練',
       'nonword repetition',
       'phonological development'],
      'link': [<a href="/Publication/Index/U0001-1008200716373800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1008200716373800');});},this); return false;">
                     非詞覆誦作業與音韻發展之探討
                   </a>],
      'title': '非詞覆誦作業與音韻發展之探討',
      'year': '2007'},
     {'author': '周向南',
      'keywords': ['語言習得',
       '代名詞指涉',
       '代名詞理解',
       '代名詞使用',
       '理解與使用',
       'Language Acquisition',
       'Referential Expressions'],
      'link': [<a href="/Publication/Index/U0001-2108200709413000" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2108200709413000');});},this); return false;">
                     中文兒童對代名詞指涉的理解與運用
                   </a>],
      'title': '中文兒童對代名詞指涉的理解與運用',
      'year': '2007'},
     {'author': '劉季蓉',
      'keywords': ['客家話', '大埔客語', '聲調系統', '聲調連發', '聲調環境', '音韻學與語音學的分界', 'Hakka'],
      'link': [<a href="/Publication/Index/U0001-2507200713054500" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2507200713054500');});},this); return false;">
                     客家話大埔音聲調之聲學研究
                   </a>],
      'title': '客家話大埔音聲調之聲學研究',
      'year': '2007'},
     {'author': '吳芷誼',
      'keywords': ['指涉性轉喻',
       '語言行為轉喻',
       '觀點化',
       '禮貌',
       '關聯理論',
       '語境',
       'referential metonymy'],
      'link': [<a href="/Publication/Index/U0001-2707200713455300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2707200713455300');});},this); return false;">
                     中文口語言談中的轉喻呈現
                   </a>],
      'title': '中文口語言談中的轉喻呈現',
      'year': '2007'},
     {'author': '林珊如',
      'keywords': ['動態事件',
       '空間語言',
       '語言習得',
       'motion events',
       'spatial language',
       'language acquisition'],
      'link': [<a href="/Publication/Index/U0001-0709200618194900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0709200618194900');});},this); return false;">
                     動態事件編碼:中文兒童之研究
                   </a>],
      'title': '動態事件編碼:中文兒童之研究',
      'year': '2006'},
     {'author': '陳正賢',
      'keywords': ['及物性',
       '論元結構',
       '範疇',
       '詞類',
       '句構語法',
       'Transitivity',
       'argument structure'],
      'link': [<a href="/Publication/Index/U0001-1007200600074400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1007200600074400');});},this); return false;">
                     漢語中的及物性：從語用觀點看論元結構
                   </a>],
      'title': '漢語中的及物性：從語用觀點看論元結構',
      'year': '2006'},
     {'author': '林欣誼',
      'keywords': ['情境', '觀點', '量詞', '字彙學習', '語言習得', 'context', 'perspective'],
      'link': [<a href="/Publication/Index/U0001-0409200613155100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0409200613155100');});},this); return false;">
                     情境、觀點與兒童量詞使用
                   </a>],
      'title': '情境、觀點與兒童量詞使用',
      'year': '2006'},
     {'author': '江豪文',
      'keywords': ['空間認知',
       '動作事件',
       '台灣南島語',
       'spatial conceptualizations',
       'Motion events',
       'Formosan languages'],
      'link': [<a href="/Publication/Index/U0001-0507200614575100" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0507200614575100');});},this); return false;">
                     噶瑪蘭語空間認知之研究
                   </a>],
      'title': '噶瑪蘭語空間認知之研究',
      'year': '2006'},
     {'author': '陳紀昕',
      'keywords': ['同音詞',
       '複合詞',
       '詞彙分類',
       '語言發展',
       'homophone',
       'compound',
       'lexical organization'],
      'link': [<a href="/Publication/Index/U0001-0409200620290800" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0409200620290800');});},this); return false;">
                     同音詞素在詞彙分類的作用
                   </a>],
      'title': '同音詞素在詞彙分類的作用',
      'year': '2006'},
     {'author': '林東毅',
      'keywords': ['情緒', '感嘆詞', '語尾助詞', '隱喻', '轉喻', '力量動態', 'emotion'],
      'link': [<a href="/Publication/Index/U0001-2906200608295300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2906200608295300');});},this); return false;">
                     噶瑪蘭語之情緒語言
                   </a>],
      'title': '噶瑪蘭語之情緒語言',
      'year': '2006'},
     {'author': '張廖宜',
      'keywords': ['國語聲調',
       '聲學研究',
       '聲調行為表現',
       '情緒',
       'Mandarin tones',
       'acoustic studies',
       'tonal behavior'],
      'link': [<a href="/Publication/Index/U0001-0208200518355900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0208200518355900');});},this); return false;">
                     情緒對中文聲調影響之研究
                   </a>],
      'title': '情緒對中文聲調影響之研究',
      'year': '2005'},
     {'author': '江芳梅',
      'keywords': ['賽夏語', '重音', '韻律', '聲學', 'Saisiyat', 'accent', 'prosody'],
      'link': [<a href="/Publication/Index/U0001-2707200506344200" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2707200506344200');});},this); return false;">
                     賽夏語韻律研究
                   </a>],
      'title': '賽夏語韻律研究',
      'year': '2005'},
     {'author': '蔡佩舒',
      'keywords': ['詞彙語意學',
       '詞彙提取',
       '詞義數目效應',
       '義面數目效應',
       '詞類數目效應',
       '詞類',
       'lexical semantics'],
      'link': [<a href="/Publication/Index/U0001-1707200517423700" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-1707200517423700');});},this); return false;">
                     中文多義詞的心理語言學處理
                   </a>],
      'title': '中文多義詞的心理語言學處理',
      'year': '2005'},
     {'author': '李蓁',
      'keywords': ['非詞覆誦',
       '音韻處理能力',
       '詞彙學習',
       '語言發展',
       'nonword repetition',
       'phonological processing',
       'vocabulary learning'],
      'link': [<a href="/Publication/Index/U0001-2807200510295300" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2807200510295300');});},this); return false;">
                     中文學齡前兒童非詞覆誦測驗與音韻處理能力之探討
                   </a>],
      'title': '中文學齡前兒童非詞覆誦測驗與音韻處理能力之探討',
      'year': '2005'},
     {'author': '張廖宜',
      'keywords': ['國語聲調',
       '聲學研究',
       '聲調行為表現',
       '情緒',
       'Mandarin tones',
       'acoustic studies',
       'tonal behavior'],
      'link': [<a href="/Publication/Index/U0001-0208200518355900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0208200518355900');});},this); return false;">
                     情緒對中文聲調影響之研究
                   </a>],
      'title': '情緒對中文聲調影響之研究',
      'year': '2005'},
     {'author': '葉俞廷',
      'keywords': ['否定', '詞類', '助動詞', '動詞', '質詞', '句法結構', 'NegP'],
      'link': [<a href="/Publication/Index/U0001-0107200518572600" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0107200518572600');});},this); return false;">
                     噶瑪蘭語否定詞之句法研究
                   </a>],
      'title': '噶瑪蘭語否定詞之句法研究',
      'year': '2005'},
     {'author': '林哲民',
      'keywords': ['台灣南島語',
       '基於轉換的錯誤驅動學習',
       '標記集',
       '線上語料庫',
       '田調文本處理',
       '維特根斯坦',
       'Formosan Austronesian languages'],
      'link': [<a href="/Publication/Index/U0001-2206200512415900" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-2206200512415900');});},this); return false;">
                     微型語料庫的自動處理：賽夏語詞性標記、部份剖析及其應用
                   </a>],
      'title': '微型語料庫的自動處理：賽夏語詞性標記、部份剖析及其應用',
      'year': '2005'},
     {'author': '沈嘉琪',
      'keywords': ['反身詞', '交互句型', '約束理論', '代詞', '南島語', '噶瑪蘭', 'reflexive'],
      'link': [<a href="/Publication/Index/U0001-0807200514435400" onclick="Share_ShowMouseButton(function(){_Layout_BlockUICustomSetting(function(){_Layout_PjaxToOtherPageTypeFirstIDSecondID('/Publication/Index','','U0001-0807200514435400');});},this); return false;">
                     噶瑪蘭語反身詞與交互句型之研究
                   </a>],
      'title': '噶瑪蘭語反身詞與交互句型之研究',
      'year': '2005'}]




```python
df = pd.DataFrame(lst, index=range(1, len(lst)+1))
df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>author</th>
      <th>keywords</th>
      <th>link</th>
      <th>title</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>曹景瑄</td>
      <td>[一詞多義, 詞類歧義, 語境, 語意優勢性, 詞彙歧義解困, 個體差異, 事件相關電位]</td>
      <td>[&lt;a href="/Publication/Index/U0001-26032019173...</td>
      <td>語義優勢性對語法語境中詞彙歧義解析之影響—中文歧義詞處理的事件相關電位研究</td>
      <td>2019</td>
    </tr>
    <tr>
      <th>2</th>
      <td>顏瑄慧</td>
      <td>[語言習得, 句法處理, 人工語法學習, 統計學習, 左右半腦差異, 個別差異, 事件相關電位]</td>
      <td>[&lt;a href="/Publication/Index/U0001-07012019171...</td>
      <td>左右半腦差異與句法結構複雜度之學習——以事件相關腦電位分析人工語法處理狀況</td>
      <td>2019</td>
    </tr>
    <tr>
      <th>3</th>
      <td>湯苓</td>
      <td>[統計學習, 非相鄰依存規律, 中文人造語言, 單耳交替聆聽實驗方法, 左右半腦差異, 語言...</td>
      <td>[&lt;a href="/Publication/Index/U0001-29012018100...</td>
      <td>左右半腦非相鄰依存統計學習之初探</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>4</th>
      <td>葉遲</td>
      <td>[半腦間抑制關係, 半腦間協作關係, 句法處理, 分視野實驗, 統計學習, interhem...</td>
      <td>[&lt;a href="/Publication/Index/U0001-26092018005...</td>
      <td>以事件相關電位看句法處理側化、半腦間互動關係以及語言能力的相互關係</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>5</th>
      <td>鍾柔安</td>
      <td>[動詞偏態（效果）, 關係子句, 語法處理, 漸進式處理, verb bias (effec...</td>
      <td>[&lt;a href="/Publication/Index/U0001-07082018145...</td>
      <td>動詞偏態對處理中文關係子句的影響: 事件相關電位研究</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>6</th>
      <td>李佳臻</td>
      <td>[情感分析, 評價語言, 主題模型, 模式文法, 意見偵測, 意見擷取, aspect-ba...</td>
      <td>[&lt;a href="/Publication/Index/U0001-14052018113...</td>
      <td>評價語言分析與主題擷取-網路旅遊部落格情感分析之應用</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>7</th>
      <td>張智傑</td>
      <td>[臺灣南島語, 布農語, 郡群, 空間認知, 動作事件, 時間認知, 隱喻]</td>
      <td>[&lt;a href="/Publication/Index/U0001-19082018232...</td>
      <td>郡群布農語的空間與時間表達研究</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>8</th>
      <td>吳小涵</td>
      <td>[性別自然語言處理, 薰衣草語言學, 同性戀文本, 卷積神經網路, 支持向量機器, Gend...</td>
      <td>[&lt;a href="/Publication/Index/U0001-25092018102...</td>
      <td>以性別自然語言處理觀點分析與預測同志語言</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>9</th>
      <td>劉郁文</td>
      <td>[憂鬱症, 言談分析, 計算語言學, 主題模型, 線上諮詢, 醫病溝通, 同儕支持]</td>
      <td>[&lt;a href="/Publication/Index/U0001-01032017092...</td>
      <td>憂鬱症線上討論言談之主題分析</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>10</th>
      <td>鄭愛琳</td>
      <td>[語態系統, 中間語態, 中間語態標記, 類型比較, 上莫利語, 西部馬來-玻里尼西亞語, ...</td>
      <td>[&lt;a href="/Publication/Index/U0001-18072017232...</td>
      <td>上莫利語的語態系統: 以中間語態為主</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>11</th>
      <td>李智堯</td>
      <td>[中文詞彙網路, 語意網, 詞彙知識本體, 鏈結資料, 普林斯頓詞彙網路, 數位辭典學, C...</td>
      <td>[&lt;a href="/Publication/Index/U0001-14122016180...</td>
      <td>中文詞彙網鏈結資料化：從桌面資料庫至適用於語意網的詞彙知識本體</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>12</th>
      <td>黃資勻</td>
      <td>[語言學標記, 中文, 自然語言處理, 群眾募集, 遊戲化, Linguistics Ann...</td>
      <td>[&lt;a href="/Publication/Index/U0001-24082017135...</td>
      <td>ESemiCrowd - 中文自然語言處理的群眾外包架構</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>13</th>
      <td>許學旻</td>
      <td>[醫病言談, 醫病溝通, 醫師病人陪同者溝通, 醫病三方溝通, 禮貌, medical di...</td>
      <td>[&lt;a href="/Publication/Index/U0001-23082017195...</td>
      <td>醫病溝通中之協商：以北台灣之眼科醫師為例</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>14</th>
      <td>莊育穎</td>
      <td>[語音變異, 詞彙辨識, 變異頻率, 社會意涵, 說話者信息, 台灣華語, phonetic...</td>
      <td>[&lt;a href="/Publication/Index/U0001-15082017131...</td>
      <td>台灣華語語音變異對詞彙辨識之影響</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>15</th>
      <td>吳怡安</td>
      <td>[中文詞彙網路, 詞義消歧, 詞義標記, 監都式學習, 文字嵌入, Chinese Word...</td>
      <td>[&lt;a href="/Publication/Index/U0001-18082016162...</td>
      <td>中文詞彙網路的詞義消歧</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>16</th>
      <td>李婉如</td>
      <td>[疼痛, 疼痛表達, 認知語言學, 認知隱喻, 自我, pain, pain express...</td>
      <td>[&lt;a href="/Publication/Index/U0001-03022016220...</td>
      <td>從認知語言學看中文的疼痛表達</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>17</th>
      <td>蔡宜庭</td>
      <td>[老化, 隱喻理解歷程, 熟悉的隱喻, 非熟悉的隱喻, 個別差異, 語言流暢度測驗, aging]</td>
      <td>[&lt;a href="/Publication/Index/U0001-03022016110...</td>
      <td>老化對處理非熟悉隱喻的影響</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>18</th>
      <td>陳馨妍</td>
      <td>[多模態, 肖似性, 文法隱喻, 認知語言學, 現代西洋繪畫, 非再現性藝術, Multim...</td>
      <td>[&lt;a href="/Publication/Index/U0001-13082016212...</td>
      <td>現代繪畫中文本性之認知多模態探討</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>19</th>
      <td>許靖瑋</td>
      <td>[語前助詞, 語用功能, 社會互動, 文類, 多功能性, 言談分析, 談話分析]</td>
      <td>[&lt;a href="/Publication/Index/U0001-12072016153...</td>
      <td>中文語前助詞的語用功能：以Eh2和Oh為例</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>20</th>
      <td>林怡馨</td>
      <td>[詞表, 基本詞彙, 英文詞網, 覆蓋率, 語意階層, wordlists, basic w...</td>
      <td>[&lt;a href="/Publication/Index/U0001-01022016144...</td>
      <td>詞表告訴了我們什麼？—以詞義及難度分級檢驗現存英文詞表</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>21</th>
      <td>莊茹涵</td>
      <td>[批踢踢, 立場分類, 語用學, 語料庫語言學, 線上回文, PTT, stance cla...</td>
      <td>[&lt;a href="/Publication/Index/U0001-23022016234...</td>
      <td>中文短回文立場分類</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>22</th>
      <td>廖于萱</td>
      <td>[反霸凌, 海報研究, 視覺語法, 跨文化比較, 集體主義和個人主義, 關注受害者, 關注霸凌者]</td>
      <td>[&lt;a href="/Publication/Index/U0001-17082016123...</td>
      <td>很棒的想法？很霸的想法？：從反霸凌海報比較霸凌的概念</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>23</th>
      <td>周伶蓁</td>
      <td>[情緒預測, 語言, 事件相關電位, 同理心, 晚期正波, emotional expect...</td>
      <td>[&lt;a href="/Publication/Index/U0001-03022016174...</td>
      <td>以事件相關電位研究情緒預測在句子處理中的影響</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>24</th>
      <td>詹君陽</td>
      <td>[國語, 配音, 成對變異指數, Guoyu, dubbing, PVI]</td>
      <td>[&lt;a href="/Publication/Index/U0001-31072017003...</td>
      <td>標準國語的想像？台灣配音表演的語音與社會意涵分析</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>25</th>
      <td>許展嘉</td>
      <td>[篇章組織詞串, 頻率, 人際溝通詞串, 常用詞串, 指涉詞串, 語體, 使用基礎模型]</td>
      <td>[&lt;a href="/Publication/Index/U0001-10062016100...</td>
      <td>中文的常用詞串</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>26</th>
      <td>黃文怡</td>
      <td>[多模態隱喻, 轉喻, 都市意象, 繪本, 視覺－文字多模態隱喻辨識程序, 魔幻超現實, 多...</td>
      <td>[&lt;a href="/Publication/Index/U0001-15082016055...</td>
      <td>小城故事：繪本中的都市意象之多模態隱喻研究</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>27</th>
      <td>李柏緯</td>
      <td>[異性戀常規性, 性/別, 語言與身分認同, 批判話語分析, 語料庫語言學, 交友網站, 男同志]</td>
      <td>[&lt;a href="/Publication/Index/U0001-23062016194...</td>
      <td>性向、偏好、與身分認同論述：以台灣交友網站的異性戀常規性為例</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>28</th>
      <td>雷翔宇</td>
      <td>[鼻韻尾合流, 語料庫研究, 自然語料, 方言差異, 韻律顯著, 韻律邊界, syllabl...</td>
      <td>[&lt;a href="/Publication/Index/U0001-18082016164...</td>
      <td>臺灣華語自然語料中鼻韻尾合流之韻律與方言影響</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>29</th>
      <td>陳旻昕</td>
      <td>[句法處理, 中文詞類訊息, 分視野實驗, 語言腦側化現象, 兩腦間抑制關係, 兩腦間合作關...</td>
      <td>[&lt;a href="/Publication/Index/U0001-17082016103...</td>
      <td>中文詞類訊息處理的腦側化現象：事件相關電位研究</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>30</th>
      <td>張貽涵</td>
      <td>[概念隱喻, 月經, 衛生棉, 衛生棉條, 女性身體, Conceptual metapho...</td>
      <td>[&lt;a href="/Publication/Index/U0001-19072016130...</td>
      <td>月經意象在女性衛生用品中的概念隱喻：以網路經驗分享文和廣告為例</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>97</th>
      <td>黃宜萱</td>
      <td>[台灣華語, 語言變異, 高聲調標的, 一聲, 四聲, 焦點, Taiwan Mandarin]</td>
      <td>[&lt;a href="/Publication/Index/U0001-25072008165...</td>
      <td>台灣華語高聲調標的呈現之語言變異研究</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>98</th>
      <td>林佑旻</td>
      <td>[語言分類, 文化, 隱喻, 轉喻, 語境, linguistic categorizati...</td>
      <td>[&lt;a href="/Publication/Index/U0001-29072008231...</td>
      <td>「心」的語意分析：從語言分類和文化認知談起</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>99</th>
      <td>賴美璇</td>
      <td>[中文「比」字比較句, 程度副詞, 規則建立, 類比過程, 語言習得, Mandarin B...</td>
      <td>[&lt;a href="/Publication/Index/U0001-14072008152...</td>
      <td>兒童早期「比」字比較句之副詞使用</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>100</th>
      <td>郭政淳</td>
      <td>[比較句結構, 類型學, 「超越」型(比較句), 去動詞化, 詞類系統, comparati...</td>
      <td>[&lt;a href="/Publication/Index/U0001-01072008141...</td>
      <td>阿美語的比較句結構</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>101</th>
      <td>王玨珵</td>
      <td>[意義, 語意學, 句構, 譬喻, 轉喻, meaning, semantics]</td>
      <td>[&lt;a href="/Publication/Index/U0001-11072008142...</td>
      <td>檢視「詞彙概念及認知模型」理論：以漢語「走」為基礎的研究</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>102</th>
      <td>陳依婷</td>
      <td>[規避詞, 主觀性, 互動主觀性, 禮貌, 面子, 禮貌策略, hedges]</td>
      <td>[&lt;a href="/Publication/Index/U0001-28072008162...</td>
      <td>中文口語言談中規避詞的使用</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>103</th>
      <td>沈文琦</td>
      <td>[撒奇萊雅, 句法, 否定, 疑問, 使役, 阿美語, Sakizaya]</td>
      <td>[&lt;a href="/Publication/Index/U0001-19072008015...</td>
      <td>撒奇萊雅語句法結構初探</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>104</th>
      <td>林智凱</td>
      <td>[東亞漢字音, 優選理論, 歷史音韻, 晦澀性, 音節結構, Sino-Xenic Lang...</td>
      <td>[&lt;a href="/Publication/Index/U0001-14072008185...</td>
      <td>東亞漢字音之入聲韻變化: 以優選理論探討</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>105</th>
      <td>董鴻鈞</td>
      <td>[台語, 音調擾動, 韻律, 音質, Taiwanese, tonal perturbati...</td>
      <td>[&lt;a href="/Publication/Index/U0001-05022008114...</td>
      <td>臺語韻律對語音調擾動及音質的影響</td>
      <td>2008</td>
    </tr>
    <tr>
      <th>106</th>
      <td>蕭季樺</td>
      <td>[情緒, 句構, 事件結構, 隱喻, 誇飾, emotion, construction, ...</td>
      <td>[&lt;a href="/Publication/Index/U0001-27072007094...</td>
      <td>漢語口語之情緒語言</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>107</th>
      <td>謝富惠</td>
      <td>[情緒語言, 思想語言, 語法模式, 情感系統, 人觀的民族文化理論, language o...</td>
      <td>[&lt;a href="/Publication/Index/U0001-08022007100...</td>
      <td>噶瑪蘭語及賽夏語情緒及思想語言之研究</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>108</th>
      <td>鍾曉芳</td>
      <td>[源域, 概念隱喻, 由上而下的方式, 由下而上的方式, 知識本體, 搭配詞組, sourc...</td>
      <td>[&lt;a href="/Publication/Index/U0001-24082007094...</td>
      <td>以語料庫驅動之隱喻源域界定研究</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>109</th>
      <td>李乃欣</td>
      <td>[非詞覆誦, 音韻發展, 音韻記憶, 音韻處理能力, 發音訓練, nonword repet...</td>
      <td>[&lt;a href="/Publication/Index/U0001-10082007163...</td>
      <td>非詞覆誦作業與音韻發展之探討</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>110</th>
      <td>周向南</td>
      <td>[語言習得, 代名詞指涉, 代名詞理解, 代名詞使用, 理解與使用, Language Ac...</td>
      <td>[&lt;a href="/Publication/Index/U0001-21082007094...</td>
      <td>中文兒童對代名詞指涉的理解與運用</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>111</th>
      <td>劉季蓉</td>
      <td>[客家話, 大埔客語, 聲調系統, 聲調連發, 聲調環境, 音韻學與語音學的分界, Hakka]</td>
      <td>[&lt;a href="/Publication/Index/U0001-25072007130...</td>
      <td>客家話大埔音聲調之聲學研究</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>112</th>
      <td>吳芷誼</td>
      <td>[指涉性轉喻, 語言行為轉喻, 觀點化, 禮貌, 關聯理論, 語境, referential...</td>
      <td>[&lt;a href="/Publication/Index/U0001-27072007134...</td>
      <td>中文口語言談中的轉喻呈現</td>
      <td>2007</td>
    </tr>
    <tr>
      <th>113</th>
      <td>林珊如</td>
      <td>[動態事件, 空間語言, 語言習得, motion events, spatial lang...</td>
      <td>[&lt;a href="/Publication/Index/U0001-07092006181...</td>
      <td>動態事件編碼:中文兒童之研究</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>114</th>
      <td>陳正賢</td>
      <td>[及物性, 論元結構, 範疇, 詞類, 句構語法, Transitivity, argume...</td>
      <td>[&lt;a href="/Publication/Index/U0001-10072006000...</td>
      <td>漢語中的及物性：從語用觀點看論元結構</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>115</th>
      <td>林欣誼</td>
      <td>[情境, 觀點, 量詞, 字彙學習, 語言習得, context, perspective]</td>
      <td>[&lt;a href="/Publication/Index/U0001-04092006131...</td>
      <td>情境、觀點與兒童量詞使用</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>116</th>
      <td>江豪文</td>
      <td>[空間認知, 動作事件, 台灣南島語, spatial conceptualizations...</td>
      <td>[&lt;a href="/Publication/Index/U0001-05072006145...</td>
      <td>噶瑪蘭語空間認知之研究</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>117</th>
      <td>陳紀昕</td>
      <td>[同音詞, 複合詞, 詞彙分類, 語言發展, homophone, compound, le...</td>
      <td>[&lt;a href="/Publication/Index/U0001-04092006202...</td>
      <td>同音詞素在詞彙分類的作用</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>118</th>
      <td>林東毅</td>
      <td>[情緒, 感嘆詞, 語尾助詞, 隱喻, 轉喻, 力量動態, emotion]</td>
      <td>[&lt;a href="/Publication/Index/U0001-29062006082...</td>
      <td>噶瑪蘭語之情緒語言</td>
      <td>2006</td>
    </tr>
    <tr>
      <th>119</th>
      <td>張廖宜</td>
      <td>[國語聲調, 聲學研究, 聲調行為表現, 情緒, Mandarin tones, acous...</td>
      <td>[&lt;a href="/Publication/Index/U0001-02082005183...</td>
      <td>情緒對中文聲調影響之研究</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>120</th>
      <td>江芳梅</td>
      <td>[賽夏語, 重音, 韻律, 聲學, Saisiyat, accent, prosody]</td>
      <td>[&lt;a href="/Publication/Index/U0001-27072005063...</td>
      <td>賽夏語韻律研究</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>121</th>
      <td>蔡佩舒</td>
      <td>[詞彙語意學, 詞彙提取, 詞義數目效應, 義面數目效應, 詞類數目效應, 詞類, lexi...</td>
      <td>[&lt;a href="/Publication/Index/U0001-17072005174...</td>
      <td>中文多義詞的心理語言學處理</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>122</th>
      <td>李蓁</td>
      <td>[非詞覆誦, 音韻處理能力, 詞彙學習, 語言發展, nonword repetition,...</td>
      <td>[&lt;a href="/Publication/Index/U0001-28072005102...</td>
      <td>中文學齡前兒童非詞覆誦測驗與音韻處理能力之探討</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>123</th>
      <td>張廖宜</td>
      <td>[國語聲調, 聲學研究, 聲調行為表現, 情緒, Mandarin tones, acous...</td>
      <td>[&lt;a href="/Publication/Index/U0001-02082005183...</td>
      <td>情緒對中文聲調影響之研究</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>124</th>
      <td>葉俞廷</td>
      <td>[否定, 詞類, 助動詞, 動詞, 質詞, 句法結構, NegP]</td>
      <td>[&lt;a href="/Publication/Index/U0001-01072005185...</td>
      <td>噶瑪蘭語否定詞之句法研究</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>125</th>
      <td>林哲民</td>
      <td>[台灣南島語, 基於轉換的錯誤驅動學習, 標記集, 線上語料庫, 田調文本處理, 維特根斯坦...</td>
      <td>[&lt;a href="/Publication/Index/U0001-22062005124...</td>
      <td>微型語料庫的自動處理：賽夏語詞性標記、部份剖析及其應用</td>
      <td>2005</td>
    </tr>
    <tr>
      <th>126</th>
      <td>沈嘉琪</td>
      <td>[反身詞, 交互句型, 約束理論, 代詞, 南島語, 噶瑪蘭, reflexive]</td>
      <td>[&lt;a href="/Publication/Index/U0001-08072005144...</td>
      <td>噶瑪蘭語反身詞與交互句型之研究</td>
      <td>2005</td>
    </tr>
  </tbody>
</table>
<p>126 rows × 5 columns</p>
</div>




```python
"""
word_lst = []
for title in df["title"]:
    words = jieba.cut(title, cut_all=False)
    words = [word for word in words]
    word_lst.append(words)
    
word_lst
"""
```




    '\nword_lst = []\nfor title in df["title"]:\n    words = jieba.cut(title, cut_all=False)\n    words = [word for word in words]\n    word_lst.append(words)\n    \nword_lst\n'




```python
word_lst = []
for title in df["title"]:
    words = jieba.cut(title, cut_all=False)
    for word in words:
        word_lst.append(word)
    
word_lst
```




    ['語義優',
     '勢性',
     '對',
     '語法',
     '語境',
     '中詞',
     '彙',
     '歧義',
     '解析',
     '之影響',
     '—',
     '中文',
     '歧義詞',
     '處理',
     '的',
     '事件',
     '相關',
     '電位',
     '研究',
     '左右',
     '半腦',
     '差異',
     '與',
     '句法',
     '結構',
     '複',
     '雜度',
     '之學習',
     '—',
     '—',
     '以',
     '事件',
     '相關',
     '腦電位',
     '分析',
     '人工',
     '語法',
     '處理',
     '狀況',
     '左右',
     '半腦',
     '非',
     '相鄰',
     '依存',
     '統計',
     '學習',
     '之',
     '初探',
     '以',
     '事件',
     '相關',
     '電位',
     '看',
     '句法',
     '處理',
     '側化',
     '、',
     '半腦間',
     '互動關',
     '係',
     '以及',
     '語言',
     '能力',
     '的',
     '相互',
     '關',
     '係',
     '動詞',
     '偏態',
     '對',
     '處理',
     '中文',
     '關',
     '係',
     '子句',
     '的',
     '影響',
     ':',
     ' ',
     '事件',
     '相關',
     '電位',
     '研究',
     '評價',
     '語言',
     '分析',
     '與',
     '主題',
     '擷取',
     '-',
     '網路',
     '旅遊',
     '部落',
     '格',
     '情感',
     '分析',
     '之應用',
     '郡',
     '群布',
     '農語',
     '的',
     '空間',
     '與',
     '時間',
     '表達',
     '研究',
     '以性',
     '別',
     '自然',
     '語言',
     '處理',
     '觀點',
     '分析',
     '與',
     '預測',
     '同志',
     '語言',
     '憂鬱',
     '症線',
     '上',
     '討論言談',
     '之主題',
     '分析',
     '上',
     '莫利',
     '語的',
     '語態',
     '系統',
     ':',
     ' ',
     '以中間',
     '語態',
     '為',
     '主',
     '中文',
     '詞',
     '彙',
     '網鏈',
     '結資料化',
     '：',
     '從',
     '桌面',
     '資料',
     '庫至',
     '適用',
     '於',
     '語意網',
     '的',
     '詞',
     '彙',
     '知識',
     '本體',
     'ESemiCrowd',
     ' ',
     '-',
     ' ',
     '中文',
     '自然',
     '語言',
     '處理',
     '的',
     '群眾外',
     '包架構',
     '醫病',
     '溝通',
     '中',
     '之',
     '協商',
     '：',
     '以北',
     '台灣',
     '之',
     '眼科',
     '醫師',
     '為例',
     '台灣華語',
     '語音',
     '變異',
     '對',
     '詞',
     '彙',
     '辨識',
     '之',
     '影響',
     '中文',
     '詞',
     '彙',
     '網路',
     '的',
     '詞義消歧',
     '從',
     '認知',
     '語言學',
     '看',
     '中文',
     '的',
     '疼痛',
     '表達',
     '老化',
     '對',
     '處理',
     '非',
     '熟悉',
     '隱喻',
     '的',
     '影響',
     '現代繪畫',
     '中文',
     '本性',
     '之',
     '認知',
     '多模',
     '態探',
     '討',
     '中文',
     '語前',
     '助詞',
     '的',
     '語用',
     '功能',
     '：',
     '以',
     'Eh2',
     '和',
     'Oh',
     '為例',
     '詞表告訴',
     '了',
     '我們',
     '什麼',
     '？',
     '—',
     '以',
     '詞義及',
     '難度',
     '分級',
     '檢驗',
     '現存',
     '英文',
     '詞表',
     '中文',
     '短',
     '回文',
     '立場',
     '分類',
     '很棒',
     '的',
     '想法',
     '？',
     '很霸',
     '的',
     '想法',
     '？',
     '：',
     '從',
     '反霸',
     '凌海',
     '報比較',
     '霸凌',
     '的',
     '概念',
     '以',
     '事件',
     '相關',
     '電位',
     '研究',
     '情緒',
     '預測',
     '在',
     '句子',
     '處理',
     '中',
     '的',
     '影響',
     '標準',
     '國語',
     '的',
     '想像',
     '？',
     '台灣',
     '配音',
     '表演',
     '的',
     '語音',
     '與',
     '社會',
     '意涵',
     '分析',
     '中文',
     '的',
     '常用',
     '詞串',
     '小城',
     '故事',
     '：',
     '繪本',
     '中',
     '的',
     '都市',
     '意象',
     '之',
     '多模',
     '態隱喻',
     '研究',
     '性',
     '向',
     '、',
     '偏好',
     '、',
     '與',
     '身分',
     '認同',
     '論述',
     '：',
     '以台灣',
     '交友',
     '網站',
     '的',
     '異性',
     '戀常',
     '規性',
     '為例',
     '臺',
     '灣華語',
     '自然',
     '語料',
     '中',
     '鼻韻尾',
     '合流',
     '之韻律',
     '與',
     '方言',
     '影響',
     '中文',
     '詞類',
     '訊息',
     '處理',
     '的',
     '腦側',
     '化現',
     '象',
     '：',
     '事件',
     '相關',
     '電位',
     '研究',
     '月經',
     '意象',
     '在',
     '女性',
     '衛生',
     '用品',
     '中',
     '的',
     '概念',
     '隱喻',
     '：',
     '以',
     '網路',
     '經驗',
     '分享',
     '文和廣告',
     '為例',
     '戀愛言談',
     ':',
     '告白',
     '中',
     '的',
     '說服',
     '、',
     '拒絕',
     '、',
     '與',
     '接受',
     '之',
     '策略',
     '研究',
     '年齡',
     '與',
     '韻律',
     '對',
     '臺',
     '灣華語',
     '自然',
     '語料',
     '庫中',
     '鼻音',
     '韻尾',
     '合流',
     '之影響',
     '中文',
     '學齡',
     '前',
     '幼童',
     '的',
     '非詞',
     '覆誦',
     '、',
     '詞',
     '彙',
     '量',
     '及',
     '音韻',
     '能力',
     '在',
     '發展',
     '過程',
     '中',
     '之動態',
     '互動',
     '：',
     '跨',
     '序列',
     '研究',
     '測量',
     '華語',
     '兒童',
     '早期',
     '詞',
     '彙',
     '成長',
     ':',
     '以語',
     '料庫',
     '為',
     '本',
     '之',
     '研究',
     '詞',
     '彙',
     '穩定',
     '的',
     '秘密',
     '—',
     '對',
     '各',
     '語言學',
     '面向',
     '的',
     '質性',
     '與',
     '量化',
     '分析',
     '中文',
     '情緒',
     '詞庫',
     '的',
     '建造',
     '與',
     '標記',
     '多模',
     '態',
     '，',
     '隱喻',
     '，',
     '與',
     '詮釋',
     '的',
     '交會',
     '：',
     '以',
     '政治',
     '漫畫',
     '與',
     '藝術',
     '歌曲',
     '為佐證',
     '卡',
     '那卡',
     '那富語',
     '受益',
     '與',
     '受害',
     '概念',
     '的語',
     '言表',
     '徵',
     '英文',
     '為',
     '外語',
     '學習者',
     '理解',
     '英文',
     '隱喻',
     '的',
     '神經',
     '認知',
     '機制',
     '卡',
     '那卡',
     '那富語',
     '焦點',
     '系統',
     '之',
     '語意',
     '及言談',
     '功能',
     '西班牙文',
     '動態',
     '事件',
     '樣貌',
     '與',
     '路',
     '徑表達',
     '方式',
     '之',
     '研究',
     '：',
     '以',
     '中文',
     '母語者',
     '為例',
     '體現',
     '與',
     '生成',
     '詞',
     '彙',
     '之',
     '交會',
     '：',
     '以台灣',
     '總統',
     '演講',
     '中',
     '的',
     '身體',
     '隱喻',
     '為例',
     '批',
     '踢踢',
     '語料',
     '庫',
     '之',
     '建置',
     '與',
     '應用',
     '卡',
     '那卡',
     '那富',
     '語疑',
     '問句',
     '探究',
     '隱喻',
     '熟悉',
     '度',
     '以及',
     '個',
     '人心',
     '像',
     '認知',
     '能力',
     '對',
     '於',
     '理解',
     '動作',
     '隱喻',
     '之',
     '影響',
     ':',
     '事件',
     '相關',
     '電位',
     '研究',
     '台灣',
     '閩南語',
     '自然',
     '語料',
     '中言談',
     '單位',
     '交界',
     '之音長',
     '訊號',
     '漢語',
     '「',
     '結果',
     '」',
     '的',
     '言',
     '談語',
     '用',
     '功能',
     '泰雅',
     '語',
     '衍生',
     '詞綴',
     '習得',
     '：',
     '以',
     '新竹',
     '某國',
     '小為例',
     '台灣',
     '閩南語',
     '情緒動',
     '詞',
     '及其',
     '構式',
     ':',
     '從',
     '認知',
     '觀點',
     '分析',
     '中文',
     '近義詞',
     '「',
     '之前',
     '/',
     '以前',
     '」',
     '及',
     '「',
     '之',
     '後',
     '/',
     '以',
     '後',
     '」',
     '之時間',
     '距離',
     '差異',
     '研究',
     '汶水',
     '泰雅',
     '語中',
     '致使',
     '概念',
     '的語',
     '言表',
     '現',
     '：',
     '致使',
     '連續體',
     '的',
     '觀點',
     '從',
     '認知',
     '觀點',
     '看馬來語',
     '-',
     'nya',
     '的',
     '副',
     '詞',
     '功能',
     '汶水',
     '泰雅',
     '語中',
     '的',
     'kiya',
     ' ',
     '與',
     'haniyan',
     '：',
     '其介詞',
     '用法',
     '及助動',
     '詞',
     '用法',
     '泰雅',
     '語之',
     '事件',
     '概念化',
     '與',
     '動詞',
     '分類',
     '四種',
     '情緒',
     '與',
     '顏色',
     '的',
     '變化',
     ' ',
     ':',
     ' ',
     '認知',
     '語言學',
     '和',
     '生理',
     '學',
     '的',
     '解釋',
     '中文',
     '精神分裂症',
     '病患',
     '敘事',
     '能力',
     '之',
     '研究',
     '從',
     '語料',
     '庫',
     '看',
     '中文',
     '互動言談',
     '中',
     '隱喻',
     '的',
     '動態',
     '表現',
     '中文',
     '空殼',
     '名詞',
     '之',
     '互動',
     '功能',
     ':',
     ' ',
     '以',
     '問題',
     '是',
     '、',
     '事實',
     '上',
     '、',
     '這樣',
     '(',
     '子',
     ')',
     '和',
     '什麼',
     '意思',
     '為例',
     '霧',
     '台魯凱語',
     '格位',
     '標記',
     '有',
     '無',
     '探討',
     '水漾',
     '女人',
     '、',
     '動物',
     '男人',
     '、',
     '與',
     '隱喻',
     '：',
     '性別',
     '與',
     '年齡',
     '交互',
     '影響',
     '之',
     '性別',
     '隱喻',
     '研究',
     '霧',
     '台魯凱語',
     '格位',
     '標記',
     '有',
     '無',
     '探討',
     '教育',
     '概念',
     '隱喻',
     '研究',
     '：',
     '以華語',
     '及',
     '英文',
     '成語',
     '與',
     '諺語',
     '為例',
     '法律',
     '語',
     '言中',
     '之',
     '對',
     '抗隱喻',
     ':',
     '認知',
     '語言學',
     '觀點',
     '學習',
     '泰雅',
     '語動態',
     '事件',
     '編碼',
     ':',
     '以',
     '新竹',
     '某國小族',
     '語學習',
     '為例',
     '以計算',
     '統計',
     '方法',
     '及',
     '聲學',
     '參數',
     '研究',
     '中文',
     '自然',
     '語流',
     '之韻律',
     '短語',
     '切分',
     '早期',
     '語言',
     '發展',
     '中',
     '的',
     '「',
     '要',
     '」',
     '從言',
     '談訊息',
     '談漢語',
     '兒童',
     '「',
     '的',
     '」',
     '語句',
     '之',
     '使用',
     '漢語',
     '反身',
     '代名',
     '詞',
     '所有格',
     '的',
     '研究',
     '名',
     '物化',
     '在',
     '醫學',
     '期刊',
     '「',
     '摘要',
     '」',
     '與',
     '「',
     '背景',
     '」',
     '的',
     '語用',
     '分析',
     '對',
     '一詞',
     '多義現',
     '象',
     '的',
     '概念',
     '探索',
     '︰',
     '[',
     'V',
     ']',
     ' ',
     '–',
     ' ',
     '[',
     'UP',
     ']',
     ' ',
     '與',
     ' ',
     '[',
     'V',
     ']',
     ' ',
     '–',
     ' ',
     '[',
     '上',
     ']',
     ' ',
     '的',
     '研究',
     '賽',
     '德克',
     '太魯閣語',
     '句法',
     '探究',
     '詞義預測',
     '研究',
     '：',
     '以語',
     '料庫',
     '驅動',
     '的',
     '語言學',
     '研究',
     '方法',
     '台灣',
     '原住民',
     '國語',
     '流行歌',
     '詞',
     '之',
     '旅程',
     '隱喻',
     '研究',
     '卓群布',
     '農語',
     '內',
     '在',
     '動貌',
     '之',
     '句法',
     '研究',
     '概念',
     '隱喻',
     '網絡',
     '研究',
     '：',
     '以國語',
     '流行歌曲',
     '之愛情',
     '主題',
     '為例',
     '從',
     '認知',
     '語用',
     '觀點',
     '看',
     '中文',
     '雙關',
     '語廣告',
     '的',
     '理解',
     '：',
     '以',
     '台北',
     '捷運站',
     '內廣告',
     '為例',
     '兒童',
     '的',
     '動詞',
     '運用',
     ':',
     '工具',
     '的',
     '延伸性',
     '鄒語言談',
     '語句',
     '詞組',
     '之',
     '語法',
     '與',
     '語用',
     '分析',
     'Cebuano',
     '功能',
     '參考',
     '語法',
     '隱喻',
     '多義詞',
     '之',
     '心理',
     '處理',
     '歷程',
     '：',
     '語境',
     '、',
     '詞義頻',
     '率',
     '與',
     '詞義顯',
     '著性',
     '從',
     '語言',
     '使用',
     '到',
     '構式',
     '固化',
     '：',
     '漢語',
     '多義結果',
     '動詞',
     '「',
     'V',
     '-',
     '開',
     '」',
     '的',
     '認知',
     '語言學',
     '研究',
     '詞',
     '彙',
     '特指',
     '性',
     '與',
     '詞',
     '彙',
     '習得',
     '之',
     '探討',
     '賽',
     '德克',
     '語',
     '代名',
     '詞',
     '研究',
     '台灣華語',
     ...]




```python
word_dic = {}
for word in word_lst:
    if word in word_dic:
        word_dic[word] = word_dic[word] + 1
    else:
        word_dic[word] = 1
        
word_dic
```




    {' ': 18,
     '(': 1,
     ')': 1,
     '-': 4,
     '/': 2,
     ':': 16,
     'Cebuano': 1,
     'ESemiCrowd': 1,
     'Eh2': 1,
     'Oh': 1,
     'UP': 1,
     'V': 3,
     '[': 4,
     ']': 4,
     'haniyan': 1,
     'kiya': 1,
     'nya': 1,
     '–': 2,
     '—': 6,
     '、': 15,
     '「': 14,
     '」': 14,
     '一詞': 1,
     '上': 4,
     '中': 15,
     '中文': 29,
     '中無聲': 1,
     '中英': 1,
     '中言談': 1,
     '中詞': 1,
     '主': 1,
     '主題': 2,
     '之': 40,
     '之主題': 1,
     '之入': 1,
     '之前': 1,
     '之動態': 1,
     '之學習': 1,
     '之影響': 2,
     '之愛情': 1,
     '之應用': 1,
     '之時間': 1,
     '之音長': 1,
     '之韻律': 2,
     '了': 1,
     '事件': 12,
     '事實': 1,
     '互動': 2,
     '互動言談': 1,
     '互動關': 1,
     '交互': 2,
     '交友': 1,
     '交會': 2,
     '交流': 1,
     '交界': 1,
     '人工': 1,
     '人心': 1,
     '什麼': 2,
     '代名': 3,
     '以': 15,
     '以中間': 1,
     '以前': 1,
     '以北': 1,
     '以及': 2,
     '以台灣': 2,
     '以國語': 1,
     '以性': 1,
     '以漢語': 1,
     '以英': 1,
     '以華語': 1,
     '以計算': 1,
     '以語': 3,
     '以賽': 1,
     '作業': 1,
     '作用': 1,
     '使用': 5,
     '依存': 1,
     '係': 3,
     '個': 1,
     '偏好': 1,
     '偏態': 1,
     '側化': 1,
     '像': 1,
     '優選理論': 1,
     '元': 1,
     '兒': 1,
     '兒童': 6,
     '內': 1,
     '內廣告': 1,
     '其介詞': 1,
     '凌海': 1,
     '分享': 1,
     '分析': 12,
     '分級': 1,
     '分類': 5,
     '切分': 1,
     '初探': 2,
     '別': 1,
     '到': 1,
     '前': 1,
     '前兒': 1,
     '剖析': 1,
     '副': 2,
     '功能': 6,
     '助詞': 1,
     '動作': 1,
     '動及': 1,
     '動態': 4,
     '動物': 1,
     '動詞': 4,
     '動貌': 1,
     '勢性': 1,
     '包架構': 1,
     '化現': 1,
     '半腦': 2,
     '半腦間': 1,
     '卓群布': 1,
     '協商': 1,
     '卡': 3,
     '原住民': 1,
     '參數': 1,
     '參考': 1,
     '及': 8,
     '及其': 3,
     '及助動': 1,
     '及言談': 1,
     '及賽': 1,
     '及齒音': 1,
     '反身': 2,
     '反霸': 1,
     '受害': 1,
     '受益': 1,
     '口': 2,
     '口語': 1,
     '句': 3,
     '句型': 1,
     '句子': 2,
     '句法': 6,
     '台北': 1,
     '台灣': 7,
     '台灣華': 1,
     '台灣華語': 3,
     '台魯凱語': 2,
     '各': 1,
     '合流': 2,
     '合詞': 1,
     '同志': 1,
     '同音': 1,
     '名': 1,
     '名詞': 1,
     '向': 1,
     '否定': 1,
     '呈': 1,
     '呈現': 2,
     '告白': 1,
     '和': 4,
     '問句': 1,
     '問題': 1,
     '單位': 1,
     '噶瑪蘭語': 5,
     '四種': 1,
     '回文': 1,
     '固化': 1,
     '國語': 2,
     '在': 8,
     '基礎': 1,
     '報比較': 1,
     '報紙': 1,
     '夏語': 2,
     '外國人': 1,
     '外語': 1,
     '多模': 3,
     '多義現': 1,
     '多義結果': 1,
     '多義詞': 3,
     '大埔': 1,
     '太魯閣語': 1,
     '女人': 1,
     '女性': 1,
     '子': 1,
     '子句': 1,
     '字': 1,
     '字音': 1,
     '學': 1,
     '學習': 2,
     '學習者': 2,
     '學齡': 2,
     '客家': 1,
     '對': 14,
     '小城': 1,
     '小為例': 1,
     '工具': 1,
     '左右': 2,
     '差異': 2,
     '常用': 1,
     '年齡': 2,
     '幼童': 1,
     '序列': 1,
     '度': 2,
     '庫': 4,
     '庫中': 1,
     '庫至': 1,
     '延伸性': 1,
     '建置': 1,
     '建造': 1,
     '彙': 13,
     '影響': 12,
     '很棒': 1,
     '很霸': 1,
     '後': 2,
     '徑表達': 1,
     '從': 10,
     '從言': 1,
     '微型': 1,
     '徵': 1,
     '德克': 3,
     '心': 1,
     '心理': 2,
     '思想': 1,
     '性': 2,
     '性別': 2,
     '情境': 1,
     '情感': 1,
     '情緒': 8,
     '情緒動': 1,
     '想像': 1,
     '想法': 2,
     '意思': 1,
     '意涵': 1,
     '意象': 2,
     '態': 1,
     '態探': 1,
     '態隱喻': 1,
     '憂鬱': 1,
     '應用': 3,
     '戀常': 1,
     '戀愛言談': 1,
     '成語': 1,
     '成長': 1,
     '我們': 1,
     '所有格': 1,
     '批': 1,
     '批判': 1,
     '抗隱喻': 1,
     '拒絕': 1,
     '指涉': 1,
     '捲': 1,
     '捷運站': 1,
     '探究': 2,
     '探索': 1,
     '探討': 7,
     '接受': 1,
     '摘要': 1,
     '撒奇萊雅語': 2,
     '擷取': 1,
     '政治': 1,
     '故事': 1,
     '敘事': 1,
     '教育': 1,
     '文化': 1,
     '文和廣告': 1,
     '料庫': 3,
     '新竹': 2,
     '方式': 1,
     '方法': 2,
     '方言': 1,
     '於': 2,
     '旅程': 1,
     '旅遊': 1,
     '早期': 4,
     '映照': 1,
     '是': 1,
     '時間': 1,
     '月經': 1,
     '有': 2,
     '期刊': 1,
     '本': 1,
     '本性': 1,
     '本體': 1,
     '東亞漢': 1,
     '某國': 1,
     '某國小族': 1,
     '格': 1,
     '格位': 2,
     '桌面': 1,
     '概念': 9,
     '概念化': 1,
     '構式': 2,
     '標準': 1,
     '標記': 5,
     '模型': 1,
     '模式分析': 1,
     '樣貌': 1,
     '機制': 1,
     '檢視': 1,
     '檢驗': 1,
     '歌曲': 1,
     '歧義': 1,
     '歧義詞': 1,
     '歷程': 2,
     '母語': 1,
     '母語者': 1,
     '母音': 1,
     '比': 4,
     '比較': 1,
     '水漾': 1,
     '汶水': 2,
     '法律': 1,
     '泰雅': 5,
     '流利': 1,
     '流行歌': 1,
     '流行歌曲': 1,
     '測量': 1,
     '測驗': 1,
     '溝通': 1,
     '演講': 1,
     '漢語': 5,
     '漫畫': 1,
     '灣華語': 2,
     '為': 5,
     '為佐證': 1,
     '為例': 12,
     '無': 2,
     '焦點': 2,
     '熟悉': 2,
     '片語': 1,
     '物化': 1,
     '物性': 1,
     '特指': 1,
     '狀況': 1,
     '率': 1,
     '王建民': 1,
     '現': 1,
     '現之語': 1,
     '現代繪畫': 1,
     '現存': 1,
     '現象': 1,
     '理解': 4,
     '理論': 1,
     '生成': 1,
     '生理': 1,
     '用': 1,
     '用品': 1,
     '用法': 2,
     '由': 1,
     '男人': 1,
     '界定': 1,
     '異性': 1,
     '疼痛': 1,
     '病患': 1,
     '症線': 1,
     '發展': 5,
     '的': 66,
     '的語': 2,
     '相互': 1,
     '相鄰': 1,
     '相關': 7,
     '看': 5,
     '看論': 1,
     '看馬來語': 1,
     '眼科': 1,
     '知識': 1,
     '短': 1,
     '短語': 1,
     '研究': 42,
     '社會': 1,
     '神經': 1,
     '秘密': 1,
     '穩定': 1,
     '空殼': 1,
     '空間': 2,
     '立場': 1,
     '童量': 1,
     '童非': 1,
     '策略': 1,
     '節': 1,
     '精神分裂症': 1,
     '系統': 2,
     '組裝': 1,
     '結果': 1,
     '結構': 5,
     '結資料化': 1,
     '統計': 2,
     '經驗': 2,
     '網站': 1,
     '網絡': 1,
     '網路': 3,
     '網鏈': 1,
     '編碼': 2,
     '總統': 1,
     '繪本': 1,
     '群布': 1,
     '群眾外': 1,
     '習得': 2,
     '老化': 1,
     '聲學': 2,
     '聲調': 3,
     '聲韻': 1,
     '背景': 1,
     '能力': 5,
     '腦側': 1,
     '腦電位': 1,
     '自動': 1,
     '自然': 7,
     '致使': 2,
     '臺': 3,
     '與': 36,
     '舌音': 1,
     '英文': 4,
     '英語': 4,
     '莫利': 1,
     '華語': 1,
     '著性': 1,
     '藝術': 1,
     '處理': 13,
     '衍生': 1,
     '衛生': 1,
     '表演': 1,
     '表現': 1,
     '表達': 2,
     '複': 2,
     '西班牙文': 1,
     '要': 1,
     '覆誦': 2,
     '規則': 1,
     '規性': 1,
     '規避詞': 1,
     '觀點': 8,
     '解析': 1,
     '解釋': 1,
     '言': 2,
     '言中': 1,
     '言表': 2,
     '訊息': 1,
     '訊號': 1,
     '討': 1,
     '討論言談': 1,
     '評價': 1,
     '詞': 23,
     '詞串': 1,
     '詞庫': 1,
     '詞性': 1,
     '詞為例': 1,
     '詞素': 1,
     '詞組': 1,
     '詞綴': 1,
     '詞義及': 1,
     '詞義消歧': 1,
     '詞義預測': 1,
     '詞義頻': 1,
     '詞義顯': 1,
     '詞表': 1,
     '詞表告訴': 1,
     '詞覆誦': 1,
     '詞類': 1,
     '詮釋': 1,
     '話': 1,
     '認同': 1,
     '認知': 14,
     '語': 3,
     '語中': 2,
     '語之': 1,
     '語前': 1,
     '語動態': 1,
     '語句': 2,
     '語境': 2,
     '語學習': 1,
     '語廣告': 1,
     '語意': 2,
     '語意網': 1,
     '語態': 2,
     '語料': 8,
     '語法': 4,
     '語流': 1,
     '語用': 5,
     '語疑': 1,
     '語的': 2,
     '語義優': 1,
     '語言': 13,
     '語言學': 7,
     '語言談': 2,
     '語調': 1,
     '語量': 1,
     '語音': 4,
     '語韻律': 2,
     '說服': 1,
     '調之聲學': 1,
     '調擾': 1,
     '調標': 1,
     '談漢語': 1,
     '談訊息': 1,
     '談語': 1,
     '談起': 1,
     '論述': 2,
     '諺語': 1,
     '變化': 2,
     '變異': 2,
     '象': 2,
     '資料': 1,
     '質性': 1,
     '賽': 3,
     '賽夏語': 3,
     '走': 1,
     '距離': 1,
     '跨': 1,
     '路': 1,
     '踢踢': 1,
     '身分': 1,
     '身體': 1,
     '較': 3,
     '轉喻': 1,
     '辨識': 1,
     '農語': 2,
     '近義詞': 1,
     '這樣': 1,
     '連續體': 1,
     '運用': 2,
     '過程': 1,
     '適用': 1,
     '還': 1,
     '那卡': 3,
     '那富': 1,
     '那富語': 2,
     '郡': 1,
     '部份': 1,
     '部落': 1,
     '都市': 1,
     '鄒語言談': 1,
     '配音': 1,
     '醫學': 1,
     '醫師': 1,
     '醫病': 1,
     '重音': 2,
     '量': 1,
     '量化': 1,
     '開': 1,
     '閩': 1,
     '閩南語': 2,
     '閩語': 1,
     '關': 2,
     '阿美': 1,
     '隱喻': 16,
     '隱喻源域': 1,
     '雙語者': 2,
     '雙關': 1,
     '雜度': 1,
     '難度': 1,
     '電位': 6,
     '霧': 2,
     '霸凌': 1,
     '非': 2,
     '非詞': 2,
     '面向': 1,
     '音聲': 1,
     '音質': 1,
     '音韻': 4,
     '韻尾': 1,
     '韻律': 2,
     '預測': 2,
     '顏色': 1,
     '驅動': 2,
     '體現': 1,
     '高等': 1,
     '高聲': 1,
     '鼻音': 1,
     '鼻韻尾': 1,
     '︰': 1,
     '，': 2,
     '：': 28,
     '？': 4}




```python
word_df = pd.DataFrame(list(word_dic.items()), columns=["word", "count"]).sort_values("count", ascending=False)
word_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>word</th>
      <th>count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>14</th>
      <td>的</td>
      <td>66</td>
    </tr>
    <tr>
      <th>18</th>
      <td>研究</td>
      <td>42</td>
    </tr>
    <tr>
      <th>38</th>
      <td>之</td>
      <td>40</td>
    </tr>
    <tr>
      <th>22</th>
      <td>與</td>
      <td>36</td>
    </tr>
    <tr>
      <th>11</th>
      <td>中文</td>
      <td>29</td>
    </tr>
    <tr>
      <th>94</th>
      <td>：</td>
      <td>28</td>
    </tr>
    <tr>
      <th>91</th>
      <td>詞</td>
      <td>23</td>
    </tr>
    <tr>
      <th>56</th>
      <td></td>
      <td>18</td>
    </tr>
    <tr>
      <th>126</th>
      <td>隱喻</td>
      <td>16</td>
    </tr>
    <tr>
      <th>55</th>
      <td>:</td>
      <td>16</td>
    </tr>
    <tr>
      <th>28</th>
      <td>以</td>
      <td>15</td>
    </tr>
    <tr>
      <th>42</th>
      <td>、</td>
      <td>15</td>
    </tr>
    <tr>
      <th>109</th>
      <td>中</td>
      <td>15</td>
    </tr>
    <tr>
      <th>121</th>
      <td>認知</td>
      <td>14</td>
    </tr>
    <tr>
      <th>312</th>
      <td>「</td>
      <td>14</td>
    </tr>
    <tr>
      <th>314</th>
      <td>」</td>
      <td>14</td>
    </tr>
    <tr>
      <th>2</th>
      <td>對</td>
      <td>14</td>
    </tr>
    <tr>
      <th>13</th>
      <td>處理</td>
      <td>13</td>
    </tr>
    <tr>
      <th>6</th>
      <td>彙</td>
      <td>13</td>
    </tr>
    <tr>
      <th>47</th>
      <td>語言</td>
      <td>13</td>
    </tr>
    <tr>
      <th>115</th>
      <td>為例</td>
      <td>12</td>
    </tr>
    <tr>
      <th>15</th>
      <td>事件</td>
      <td>12</td>
    </tr>
    <tr>
      <th>54</th>
      <td>影響</td>
      <td>12</td>
    </tr>
    <tr>
      <th>30</th>
      <td>分析</td>
      <td>12</td>
    </tr>
    <tr>
      <th>95</th>
      <td>從</td>
      <td>10</td>
    </tr>
    <tr>
      <th>162</th>
      <td>概念</td>
      <td>9</td>
    </tr>
    <tr>
      <th>164</th>
      <td>在</td>
      <td>8</td>
    </tr>
    <tr>
      <th>163</th>
      <td>情緒</td>
      <td>8</td>
    </tr>
    <tr>
      <th>76</th>
      <td>觀點</td>
      <td>8</td>
    </tr>
    <tr>
      <th>195</th>
      <td>語料</td>
      <td>8</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>201</th>
      <td>訊息</td>
      <td>1</td>
    </tr>
    <tr>
      <th>200</th>
      <td>詞類</td>
      <td>1</td>
    </tr>
    <tr>
      <th>199</th>
      <td>方言</td>
      <td>1</td>
    </tr>
    <tr>
      <th>232</th>
      <td>過程</td>
      <td>1</td>
    </tr>
    <tr>
      <th>233</th>
      <td>之動態</td>
      <td>1</td>
    </tr>
    <tr>
      <th>235</th>
      <td>跨</td>
      <td>1</td>
    </tr>
    <tr>
      <th>252</th>
      <td>建造</td>
      <td>1</td>
    </tr>
    <tr>
      <th>270</th>
      <td>徵</td>
      <td>1</td>
    </tr>
    <tr>
      <th>267</th>
      <td>受害</td>
      <td>1</td>
    </tr>
    <tr>
      <th>266</th>
      <td>受益</td>
      <td>1</td>
    </tr>
    <tr>
      <th>262</th>
      <td>為佐證</td>
      <td>1</td>
    </tr>
    <tr>
      <th>261</th>
      <td>歌曲</td>
      <td>1</td>
    </tr>
    <tr>
      <th>260</th>
      <td>藝術</td>
      <td>1</td>
    </tr>
    <tr>
      <th>259</th>
      <td>漫畫</td>
      <td>1</td>
    </tr>
    <tr>
      <th>258</th>
      <td>政治</td>
      <td>1</td>
    </tr>
    <tr>
      <th>256</th>
      <td>詮釋</td>
      <td>1</td>
    </tr>
    <tr>
      <th>254</th>
      <td>態</td>
      <td>1</td>
    </tr>
    <tr>
      <th>251</th>
      <td>詞庫</td>
      <td>1</td>
    </tr>
    <tr>
      <th>236</th>
      <td>序列</td>
      <td>1</td>
    </tr>
    <tr>
      <th>250</th>
      <td>量化</td>
      <td>1</td>
    </tr>
    <tr>
      <th>249</th>
      <td>質性</td>
      <td>1</td>
    </tr>
    <tr>
      <th>248</th>
      <td>面向</td>
      <td>1</td>
    </tr>
    <tr>
      <th>247</th>
      <td>各</td>
      <td>1</td>
    </tr>
    <tr>
      <th>246</th>
      <td>秘密</td>
      <td>1</td>
    </tr>
    <tr>
      <th>245</th>
      <td>穩定</td>
      <td>1</td>
    </tr>
    <tr>
      <th>244</th>
      <td>本</td>
      <td>1</td>
    </tr>
    <tr>
      <th>241</th>
      <td>成長</td>
      <td>1</td>
    </tr>
    <tr>
      <th>238</th>
      <td>華語</td>
      <td>1</td>
    </tr>
    <tr>
      <th>237</th>
      <td>測量</td>
      <td>1</td>
    </tr>
    <tr>
      <th>569</th>
      <td>句型</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>570 rows × 2 columns</p>
</div>


