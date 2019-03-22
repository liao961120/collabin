---
title: 字裡牌間——禁止された言葉①
subtitle: ''
tags: ["yugioh", "python", LOPE]
date: '2019-03-22'
author: Bénjī
mysite: /ka-sîng/
comment: yes
---


《遊戲王》這部作品已經存在了超過20年，從此延伸出的集換式紙牌遊戲在全世界各地傳播著，隨著每一季推出新的卡牌，這個遊戲至少依然保有許多熱愛它的玩家。做為一款競爭型的紙牌遊戲，玩家可以搭配各個時期所發行的遊戲王卡片，組合出千變萬化的戰術來贏得決鬥。
然而，世間萬物皆不盡完美，無論是玩家或是遊戲公司。有的玩家會利用規則、規則以外或卡牌敘述上的漏洞贏得所謂不風光的勝利；遊戲公司也可能做出強度超出平衡、使得決鬥變得可能不需要戰術、靠猜拳的運氣就能贏得決鬥的卡牌。玩家的不完美，或許可以依靠比賽中執法的裁判從中監督，來得到比賽的公平性，而遊戲公司的疏忽，正是本次分析的主角——禁止/制限卡表(卡表)所要負責的事。
1999年，第一個版本的卡表出現了。早期規範及配套措施尚未完善，經過頻繁地更改，在2004年之後，以半年一次的頻率更新一次卡表。2013年9月，分屬於亞洲地區的「遊☆戱☆王オフィシャルカードゲーム デュエルモンスターズ」(OCG)，以及歐美地區的「YU-GI-OH! TRADING CARD GAME」(TCG)兩個系統，因為玩家使用習慣、卡片發行不同步等因素，開始各自發布不同的卡表，造成玩家大致上依照所在地區不同，遵循著不同的卡表來交流或比賽。之後，遊戲王進入了決鬥步調更加快速的時期，為了因應更快的賽場環境變化，卡表改以大致每三個月更新一次的頻率。
這次的分析，主要是希望能藉由卡片中效果文的敘述，試圖找到OCG與TCG的卡表中的差異，討論這樣的差異和兩方玩家的習慣之間的關係。

## 材料收集：

這次分析的卡表，將採用OCG在2019年1月1日生效的卡表，以及TCG同期在2019年1月28日生效的卡表，卡表中每一張卡片的效果文文本進行比對。從Yugioh Fandom中的OCG以及TCG卡表的網頁原始碼中，取得每一張卡片所對應到的連結，並做簡單的分類。


```python
import csv

# set lists
list_OCG_nomi = []
list_TCG_nomi = []
list_onaji = []

# read .csv file
with open('banlist1901.csv', newline='') as csvfile:
    rows = csv.reader(csvfile)
    for row in rows:
        if row[0] == 'OCG':
            list_OCG_nomi.append([row[3],row[2],row[1],row[4]])
        elif row[0] == 'TCG':
            list_TCG_nomi.append([row[3],row[2],row[1],row[4]])

# classify
for card in list_OCG_nomi:
    if card in list_TCG_nomi:
        list_onaji.append(card)
for card in list_onaji:
    list_OCG_nomi.remove(card)
    list_TCG_nomi.remove(card)
```

在遊戲王的世界中，各個語言下的效果文，在功用上是一樣的，為了分析上的便利性，在此全部以英文版的效果文來分析。
接著，利用request取得每一張卡的效果文文本。


```python
import requests
from bs4 import BeautifulSoup as bs

link_front = "https://yugioh.fandom.com"

def get_card_text(url):
    request = requests.get(url)
    html = request.text
    soup = bs(html)
    # get the card text
    card_text = soup.select('table.collapsible.expanded.navbox-inner td:nth-of-type(2)')[0].text
    card_text = card_text.strip()
    return card_text

for j in range(len(list_OCG_nomi)):
    list_OCG_nomi[j].append(get_card_text(link_front + list_OCG_nomi[j][3]))
for j in range(len(list_TCG_nomi)):
    list_TCG_nomi[j].append(get_card_text(link_front + list_TCG_nomi[j][3]))

```


```python
# fix data manually
list_TCG_nomi[8][0] = 'Maxx "C"'
```

## 材料分析：

首先，我們先觀察，屬於「禁止卡」(不可以該卡片來構築牌組)的項目中，兩種卡表的差異：


```python
import pandas
forb_cmp = [] #matrix
forb_cmp_num = [] #y-axis
for card in list_OCG_nomi:
    if card[2] == 'Forbidden':
        status_cmp = 'Unlimited'
        for card_cmp in list_TCG_nomi:
            if card_cmp[0] == card[0]:
                status_cmp = card_cmp[2]
        forb_cmp.append(card[0:3]+[status_cmp])
        forb_cmp_num.append('')
for card in list_TCG_nomi:
    if card[2] == 'Forbidden':
        status_cmp = 'Unlimited'
        for card_cmp in list_OCG_nomi:
            if card_cmp[0] == card[0]:
                status_cmp = card_cmp[2]
        forb_cmp.append(card[0:2]+[status_cmp]+[card[2]])
        forb_cmp_num.append('')
#make table
x_axis = ['Card name', 'Type', 'Status in OCG', 'Status in TCG']
pandas.DataFrame(forb_cmp, forb_cmp_num, x_axis)
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
      <th>Card name</th>
      <th>Type</th>
      <th>Status in OCG</th>
      <th>Status in TCG</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th></th>
      <td>Amazoness Archer</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Blackwing - Steam the Cloak</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Cannon Soldier</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Cannon Soldier MK-2</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Glow-Up Bulb</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Number 95: Galaxy-Eyes Dark Matter Dragon</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Summon Sorceress</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Toon Cannon Soldier</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Wind-Up Hunter</td>
      <td>Monster</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Divine Sword - Phoenix Blade</td>
      <td>Spell</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Dragonic Diagram</td>
      <td>Spell</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Raigeki</td>
      <td>Spell</td>
      <td>Forbidden</td>
      <td>Limited</td>
    </tr>
    <tr>
      <th></th>
      <td>Zoodiac Barrage</td>
      <td>Spell</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Life Equalizer</td>
      <td>Trap</td>
      <td>Forbidden</td>
      <td>Unlimited</td>
    </tr>
    <tr>
      <th></th>
      <td>Magical Explosion</td>
      <td>Trap</td>
      <td>Forbidden</td>
      <td>Limited</td>
    </tr>
    <tr>
      <th></th>
      <td>Astrograph Sorcerer</td>
      <td>Monster</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Blaster, Dragon Ruler of Infernos</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Daigusto Emeral</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Denglong, First of the Yang Zing</td>
      <td>Monster</td>
      <td>Semi-Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Djinn Releaser of Rituals</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Double Iris Magician</td>
      <td>Monster</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Fairy Tail - Snow</td>
      <td>Monster</td>
      <td>Semi-Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Grinder Golem</td>
      <td>Monster</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Maxx "C"</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Morphing Jar 2</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Number 42: Galaxy Tomahawk</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Number 86: Heroic Champion - Rhongomyniad</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Performapal Skullcrobat Joker</td>
      <td>Monster</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Samsara Lotus</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Supreme King Dragon Starving Venom</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Tempest, Dragon Ruler of Storms</td>
      <td>Monster</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Topologic Gumblar Dragon</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Tribe-Infecting Virus</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>True King Lithosagym, the Disaster</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Wind-Up Carrier Zenmaity</td>
      <td>Monster</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Chicken Game</td>
      <td>Spell</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Harpie's Feather Duster</td>
      <td>Spell</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Kaiser Colosseum</td>
      <td>Spell</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Pot of Avarice</td>
      <td>Spell</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Rank-Up-Magic Argent Chaos Force</td>
      <td>Spell</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Soul Charge</td>
      <td>Spell</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Super Rejuvenation</td>
      <td>Spell</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>That Grass Looks Greener</td>
      <td>Spell</td>
      <td>Semi-Limited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Self-Destruct Button</td>
      <td>Trap</td>
      <td>Unlimited</td>
      <td>Forbidden</td>
    </tr>
    <tr>
      <th></th>
      <td>Vanity's Emptiness</td>
      <td>Trap</td>
      <td>Limited</td>
      <td>Forbidden</td>
    </tr>
  </tbody>
</table>
</div>


