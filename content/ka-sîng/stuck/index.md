---
title: 失敗しちゃった
subtitle: ''
tags: ["yugioh", "python", "request", LOPE]
date: '2019-03-29'
author: Bénjī
mysite: /ka-sîng/
comment: yes
---


卡...卡住了\_(:з」∠)\_

原本循著上禮拜的腳步，我應該要接著分析兩張卡表中卡片的效果文的。由於我並沒有把抓下來的資料匯出，於是我把上次的code重新跑一遍。

結果跑到一半的時候，發生了意外：


```python
import requests
from bs4 import BeautifulSoup as bs

link_front = "https://yugioh.fandom.com"

def get_card_text(url):
    request = requests.get(url)
    html = request.text
    soup = bs(html)
    # get the card text
    card_text = soup.select('table.collapsible.expanded.navbox-inner td:nth-of-type(1)')[1].text
    card_text = card_text.strip()
    return card_text

list_OCG_nomi = list_OCG.copy()
list_TCG_nomi = list_TCG.copy()
for j in range(len(list_OCG_nomi)):
    list_OCG_nomi[j].append(get_card_text(link_front + list_OCG_nomi[j][3]))
for j in range(len(list_TCG_nomi)):
    list_TCG_nomi[j].append(get_card_text(link_front + list_TCG_nomi[j][3]))
```


    ---------------------------------------------------------------------------

    IndexError                                Traceback (most recent call last)

    <ipython-input-26-a3ad12f7c44e> in <module>()
         16 list_TCG_nomi = list_TCG.copy()
         17 for j in range(len(list_OCG_nomi)):
    ---> 18     list_OCG_nomi[j].append(get_card_text(link_front + list_OCG_nomi[j][3]))
         19 for j in range(len(list_TCG_nomi)):
         20     list_TCG_nomi[j].append(get_card_text(link_front + list_TCG_nomi[j][3]))


    <ipython-input-26-a3ad12f7c44e> in get_card_text(url)
          9     soup = bs(html)
         10     # get the card text
    ---> 11     card_text = soup.select('table.collapsible.expanded.navbox-inner td:nth-of-type(1)')[1].text
         12     card_text = card_text.strip()
         13     return card_text


    IndexError: list index out of range


#### ？？？？？

List index out of range是怎麼發生的？

於是檢查了一下list_OCG_nomi的情況：


```python
list_OCG_nomi
```




    [['Amazoness Archer',
      'Monster',
      'Forbidden',
      '/wiki/Amazoness_Archer',
      'You can Tribute 2 monsters; inflict 1200 damage to your opponent.'],
     ['Blackwing - Steam the Cloak',
      'Monster',
      'Forbidden',
      '/wiki/Blackwing_-_Steam_the_Cloak',
      'If this face-up card leaves the field: Special Summon 1 "Steam Token" (Aqua-Type/WIND/Level 1/ATK 100/DEF 100). If this card is in your Graveyard: You can Tribute 1 monster; Special Summon this card from the Graveyard. You can only use this effect of "Blackwing - Steam the Cloak" once per Duel. If this card Summoned this way is used as a Synchro Material Monster, all other Synchro Material Monsters must be "Blackwing" monsters.'],
     ['Cannon Soldier', 'Monster', 'Forbidden', '/wiki/Cannon_Soldier'],
     ['Cannon Soldier MK-2', 'Monster', 'Forbidden', '/wiki/Cannon_Soldier_MK-2'],
     ['Glow-Up Bulb', 'Monster', 'Forbidden', '/wiki/Glow-Up_Bulb'],
     ...
     ...
     ...




不知道為何到第三個就卡住了，於是把第三張牌的網址單獨抽出來看：


```python
url = 'https://yugioh.fandom.com/wiki/Cannon_Soldier'
request = requests.get(url)
html = request.text
soup = bs(html)
soup.select('table.collapsible.expanded.navbox-inner td:nth-of-type(1)')
soup.select('table')
```




    []



還真的是空的，連table的label都選不到。

但是那個網站還是有內容的，甚至可以找得到table的label。


```python
soup
```




    <!DOCTYPE html>
    <html class="" dir="ltr" lang="en">
    <head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
    <meta content="width=device-width, user-scalable=yes" name="viewport"/>
    <meta content="MediaWiki 1.19.24" name="generator"/>
    <meta content="Yu-Gi-Oh!,yugioh,Cannon Soldier,Cannon Soldier,Cannon Soldier,Cannon Soldier,Card type,Monster Card,Attribute,DARK,Type,Machine,Effect Monster" name="keywords"/>
    <meta content="The Arabic, Chinese, Croatian, Greek, Polish andThai names given are not official. (card names) The Chinese lore given is not official." name="description"/>
    <meta content="summary" name="twitter:card"/>
    <meta content="@getfandom" name="twitter:site"/>
    ...
    ...
    ...
    <div class="dablink">The <b>Chinese              </b> lore given is not official. </div>
    <table class="cardtable">
    <tr>
    <th class="cardtable-header" colspan="3" style="background-color: #F93; color: #000;">Cannon Soldier<br /><span class="cardtable-subheader"><span lang="ja">キャノン ・ ソルジャー</span></span></th>
    ...
    ...
    ...




在其他頁面卻可以正常選到：


```python
url2 = 'https://yugioh.fandom.com/wiki/Amazoness_Archer'
request2 = requests.get(url2)
html2 = request2.text
soup2 = bs(html2)
soup2.select('table.collapsible.expanded.navbox-inner td:nth-of-type(1)')[1].text

```




    '\nYou can Tribute 2 monsters; inflict 1200 damage to your opponent.'



暫時不知道該怎麼辦了\_(:з」∠)\_
