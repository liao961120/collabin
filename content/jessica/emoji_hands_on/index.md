---
title: Emoji Hands-on
subtitle: W4 Microblog
tags: [lope]
date: '2019-03-26'
author: Jessica
mysite: /jessica/
comment: yes
---


# 💡W4 Microblog
# 📍 Emoji Hands-on

上週老師在meeting上提到emoji，讓我注意到emoji在我們日常生活的溝通中真是無所不在啊～～它既增添了語言的樂趣，也可以輔助表達出文字中沒透露出的情緒。
比如說，當你要請別人幫你填一份問卷時，如果說：「拜託🥺 」就比單純得只說「拜託」感覺語氣再和緩(誠懇?)一點，也感覺沒那麼兇，對方答應的機會比較高。
於是我上網找了一些emoji的資料，發現Emoji背後都是unicode編碼。關於emoji最權威的資料是[Emoji Charts](https://unicode.org/emoji/charts/emoji-list.html)，
可以看到每個表情符號的unicode編碼、圖示、關鍵字、跟CLDR Short Name(簡釋的概念)。 
首先，第一個讓我最好奇的是如何在python裡顯示emoji呢？

### 在Python裡顯示emoji

輸入CLDR Short Name，
輸出圖示


```python
import emoji
print(emoji.emojize('Python is :raised_hand:', use_aliases=True))
```

    Python is ✋


如果＋s(複數)上去會變成......?


```python
print(emoji.emojize('Python is :raised_hands:', use_aliases=True))

```

    Python is 🙌


兩隻手！！

也可以反過來，貼上表情符號，輸出CLDR Short Name


```python
print(emoji.demojize('Python is 👍'))
```

    Python is :thumbs_up:


### 進階版的emoji顯示，可以改膚色！！

man_list 分别是: 男孩  女孩  男人  女人


```python
man_list = [u'\U0001F466', u'\U0001F467', u'\U0001F468', u'\U0001F469']
# skin_color_list 分别是: 空字串,表示默認白種人 -->(不斷加深膚色) 黑種人
skin_color_list = ['', u'\U0001F3FB', u'\U0001F3FC', u'\U0001F3FD', u'\U0001F3FE', u'\U0001F3FF', ]
for man in man_list:
    for color in skin_color_list:
        print (man + color),
    
    print ('-' * 20)

#把人加在一起，變成一家人！！
print (u'\U0001F468' + u'\u200D' + u'\U0001F469' + u'\u200D' + u'\U0001F467')

```

    👦
    👦🏻
    👦🏼
    👦🏽
    👦🏾
    👦🏿
    --------------------
    👧
    👧🏻
    👧🏼
    👧🏽
    👧🏾
    👧🏿
    --------------------
    👨
    👨🏻
    👨🏼
    👨🏽
    👨🏾
    👨🏿
    --------------------
    👩
    👩🏻
    👩🏼
    👩🏽
    👩🏾
    👩🏿
    --------------------
    👨‍👩‍👧


### 找出字串中的Emoji：使用REGEX


```python
import re
try:
    
    myre = re.compile(u'['
        u'\U0001F300-\U0001F64F'
        u'\U0001F680-\U0001F6FF'
        u'\u2600-\u2B55]+',
        re.UNICODE)
except re.error:
    
    myre = re.compile(u'('
        u'\ud83c[\udf00-\udfff]|'
        u'\ud83d[\udc00-\ude4f\ude80-\udeff]|'
        u'[\u2600-\u2B55])+',
        re.UNICODE)

sss = u'I have a dog \U0001f436 . You have a cat \U0001f431 ! I smile \U0001f601 to you!'
print (myre.sub('[Emoji]', sss) ) # 顯示字串中Emoji的位置
print (myre.findall(sss))         # 找出字串中的Emoji
```

    I have a dog [Emoji] . You have a cat [Emoji] ! I smile [Emoji] to you!
    ['🐶', '🐱', '😁']


### 蝦米！？有EmojiNet? 

在找資料的過程中，我發現居然有人做過[EmojiNet](http://emojinet.knoesis.org/home.php)!!大致上就是把表情符號弄當成是文字一樣，做成像是CWN，把每個表情符號的sense做embedding~好厲害啊啊啊～～
我看了一下他們的[論文](http://knoesis.org/people/sanjayaw/papers/2017/Wijeratne_WebIntelligence_2017_Emoji_Similarity.pdf)，背後運作的方法似乎是將下面圖裡顯示的資料做成representation，然後再訓練成embedding~當然，這只是我能理解的部分，其他的我就真的看不懂惹～～
不過！！雖然我不是完全理解背後的邏輯，但是它有API!!所以直接來實做看看吧！

![Emoji embedding](https://i.screenshot.net/pne9gcp?b70bcdb4eeca5527bdda56e479eeec56)

### Emoji NET API 實作 


```python
#Get emoji inf.
# 傳回description, keywords, related emoji, shortcode(應該就是上面的CLDR Short Name)
import requests
response = requests.get("http://emojinet.knoesis.org/api/emoji/U0001F64C")  #在emoji/後面加上表情符號的unicode long
response_text = response.text
print(response_text)
```

    [
      {
        "category": "Emoticons -> Gesture symbols", 
        "description": "Two hands raised in the air, celebrating success or another joyous event. Raising Hands was approved as part of Unicode 6.0 in 2010 under the name 'Person Raising Both Hands in Celebration' and added to Emoji 1.0 in 2015.", 
        "keywords": [
          "gesture", 
          "hand", 
          "celebration", 
          "hooray", 
          "raised"
        ], 
        "related": [
          "\\U0001F305", 
          "\\U0001F37B", 
          "\\U0001F389", 
          "\\U0001F38A", 
          "\\U0001F38F", 
          "\\U0001F44D", 
          "\\U0001F44F", 
          "\\U0001F481_\\U0000200D_\\U00002642_\\U0000FE0F", 
          "\\U0001F603", 
          "\\U0001F64B_\\U0000200D_\\U00002640_\\U0000FE0F", 
          "\\U0001F64B_\\U0000200D_\\U00002642_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FB_\\U0000200D_\\U00002640_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FB_\\U0000200D_\\U00002642_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FD_\\U0000200D_\\U00002640_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FD_\\U0000200D_\\U00002642_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FE_\\U0000200D_\\U00002640_\\U0000FE0F", 
          "\\U0001F64B_\\U0001F3FE_\\U0000200D_\\U00002642_\\U0000FE0F", 
          "\\U000026EA", 
          "\\U0000270A", 
          "\\U0001F1EE_\\U0001F1F9", 
          "\\U0001F64F", 
          "\\U0001F91A"
        ], 
        "shortcode": ":raised_hands:", 
        "title": "raising hands", 
        "unicode": "U+1F64C"
      }
    ]
    



```python
#Get Noun Meanings for Emoji
response = requests.get("http://emojinet.knoesis.org/api/emoji/noun/U0001F64C")
response_text = response.text
print(response_text)
```

    [
      {
        "babelnet_senseID": "bn:00042759n", 
        "term": "hand"
      }, 
      {
        "babelnet_senseID": "bn:00009676n", 
        "term": "god"
      }, 
      {
        "babelnet_senseID": "bn:00042759n", 
        "term": "hands"
      }, 
      {
        "babelnet_senseID": "bn:01193643n", 
        "term": "praise"
      }, 
      {
        "babelnet_senseID": "bn:00040336n", 
        "term": "gesture"
      }, 
      {
        "babelnet_senseID": "bn:00044716n", 
        "term": "hooray"
      }
    ]
    



```python
#Get Verb Meanings for Emoji
response = requests.get("http://emojinet.knoesis.org/api/emoji/verb/U0001F64C")
response_text = response.text
print(response_text)
```

    {
      "data": [
        {
          "babelnet_senseID": "bn:00091913v", 
          "term": "praise"
        }, 
        {
          "babelnet_senseID": "bn:13629680v", 
          "term": "hooray"
        }
      ]
    }
    


實作完API之後，我只有一個感想：真是狂人啊😵連這種東西都想得出來～～真令人甘拜下風！
