---
title: 也是一種才能
subtitle: ''
tags: [lope]
date: '2019-05-17'
author: Don
mysite: /don/
comment: yes
---


# 也是一種才能

這次的內容是關於我言談分析課程的期末報告主題，「也是」在語篇中表達同意/不同意的功能，以PTT為主要語料來源。


```python
import requests
import json
import time
import random
import nltk

from IPython.display import display

import pandas as pd


%matplotlib inline
pd.set_option('display.max_rows', 2000)


query = {
    'word': '也&&是',
    'size': 100,
    'post_type': 0,
    'boards': 'Gossiping',
    'sort': 'published',
    'order': 'asc',
    'start': '2019-04-28',
    'end': '2019-05-14'
}

API_ENDPOINT = 'http://140.112.147.121:9000/query'

res = requests.get('http://140.112.147.121:9000/query', query)
# print(res.text)
data = json.loads(res.text)['data']
# print(len(data))

def query_api(query_word='', post_type=0, size=100):
    result = []
    query = {
        'word': query_word,
        'size': size,
        'post_type': post_type,
        'boards': 'Gossiping',
        'sort': 'published',
        'order': 'asc',
        'start': '2019-04-28',
        'end': '2019-05-14'
    }
    
    res = requests.get(API_ENDPOINT, query)
    res_json = json.loads(res.text)
    result += res_json['data']
    
    total = res_json['total']
    
    time.sleep(0.5)
    
    for i in range(1, (total // size) + 1):
        query.update({'page': i})
        res = requests.get(API_ENDPOINT, query)
        result += json.loads(res.text)['data']
        time.sleep(0.5)
        
    return result
```

開始從API撈資料：


```python
comment = query_api('也&&是', 1, 100)
```

將撈到的資料存成json檔


```python
with open('data.json', 'w') as f:
    json.dump({'post': post, 'comment': comment}, f, ensure_ascii=False)
```


```python
print(f'含有「也是」字串的回文數：{len(comment)}')
```

    含有「也是」字串的回文數：4370


#### 4月28日~5月15日期間，於八卦版中所有包含「也是」的貼文：
- Po文：1809 篇
- 回文：4370 則


```python
def sampling_and_display(list_of_sentences, k=50):
    sample = [p['content'].replace('也 是', '也是') for p in random.sample(list_of_sentences, k)]
    df = pd.DataFrame({
        "left_context": [line.split('也是')[0] for line in sample],
        "query": '也是',
        "right_context": [line.split('也是')[1] for line in sample],
    })
    return df
```

### 隨機抽取100則含有「也是」的回文


```python
sampling_and_display(comment, k=100)
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
      <th>left_context</th>
      <th>query</th>
      <th>right_context</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>原本 我 還 以為 是 台灣人 跟 客家人 的 意思 ? 但是 客家人</td>
      <td>也是</td>
      <td>台灣人 啊 所以 這 說法 不 成立 那 到底 台客 是 甚麼 意思 呢 ? 有 八卦 嗎 ?</td>
    </tr>
    <tr>
      <th>1</th>
      <td>快 跟 你 爸 學學 怎麼 弄到 那 兩 種 密藥 阿 = = 你 副業 就 繼承 你爸 的...</td>
      <td>也是</td>
      <td>效果 很好 不 知道 是 我爸 還 我 媽去 哪 買來 的</td>
    </tr>
    <tr>
      <th>2</th>
      <td></td>
      <td>也是</td>
      <td>很多 男生 的 目標 阿</td>
    </tr>
    <tr>
      <th>3</th>
      <td>中國 是 一 個 國家 ， 不 是 一 種 血統 ， 87 而 所謂 的 「 漢 」 「 華 」</td>
      <td>也是</td>
      <td>文化 上 的 ， 跟 「 穆斯林 」 有 87 分像</td>
    </tr>
    <tr>
      <th>4</th>
      <td>退休金 沒 砍 之前</td>
      <td>也是</td>
      <td>這樣 處理 阿</td>
    </tr>
    <tr>
      <th>5</th>
      <td>砍 你 退休金 大概</td>
      <td>也是</td>
      <td>小 瑕疵 吧 沒 影響 沒 影響</td>
    </tr>
    <tr>
      <th>6</th>
      <td>日本 治台</td>
      <td>也是</td>
      <td>開頭 十年 大 殺 後來 . . . 就 皇民 養 出來 了</td>
    </tr>
    <tr>
      <th>7</th>
      <td>老婆</td>
      <td>也是</td>
      <td>， 一直 說 那 黃光 芹 那書 的 版稅 要 捐 ， 結果 也 還</td>
    </tr>
    <tr>
      <th>8</th>
      <td>自由</td>
      <td>也是</td>
      <td>可 撥仔 放任 風向 吹了 一 整天 才 生出 這 篇 可 撥文</td>
    </tr>
    <tr>
      <th>9</th>
      <td>至少 排便 順暢 食物 不 是 藥品 頂多 改善 一點 不能 治病 身體 好 的</td>
      <td>也是</td>
      <td>本來 就 身體 好 不是 光靠 食物 也 不能 每 天 只 吃 那 幾 種</td>
    </tr>
    <tr>
      <th>10</th>
      <td>政經 我</td>
      <td>也是</td>
      <td>世大運 那 左右 就 沒 看 了</td>
    </tr>
    <tr>
      <th>11</th>
      <td></td>
      <td>也是</td>
      <td>有開 電子 發票 格式 的 發票 卻 不能 用 載具 的 店 啊</td>
    </tr>
    <tr>
      <th>12</th>
      <td>還好 喜韓兒 大部分 只會 上網 洗臉 書 不然</td>
      <td>也是</td>
      <td>麻煩</td>
    </tr>
    <tr>
      <th>13</th>
      <td>中國 廚藝 訓練 學院</td>
      <td>也是</td>
      <td>少林寺 的 廚房 阿</td>
    </tr>
    <tr>
      <th>14</th>
      <td>2 萬 2 千多 人硬要 捐 1 億多 給 我 ， 我</td>
      <td>也是</td>
      <td>千百 個 不 願意 啊 ~</td>
    </tr>
    <tr>
      <th>15</th>
      <td>日本</td>
      <td>也是</td>
      <td>有 這 種 貼布 補法 , 重點 是 要 弄實 弄平</td>
    </tr>
    <tr>
      <th>16</th>
      <td>革命 日常 被 統後 的 台灣 大概</td>
      <td>也是</td>
      <td>這樣 吧</td>
    </tr>
    <tr>
      <th>17</th>
      <td>照 你 標準 : 大躍進</td>
      <td>也是</td>
      <td>世界 潮流 吧 精神 上 想 大 進步 啊</td>
    </tr>
    <tr>
      <th>18</th>
      <td>所以 吳淑珍 收 人家 幾十萬 的 百貨 禮券</td>
      <td>也是</td>
      <td>因為 選舉 ？</td>
    </tr>
    <tr>
      <th>19</th>
      <td>說 的</td>
      <td>也是</td>
      <td>， 吱吱 都 欠債 3000 億 了 ， 怎麼 不去 賣 屁股 還錢 ?</td>
    </tr>
    <tr>
      <th>20</th>
      <td>七彩 愛河 ，</td>
      <td>也是</td>
      <td>景點 啊 ～</td>
    </tr>
    <tr>
      <th>21</th>
      <td>結果 中國人 的 漢語 拼音 ,</td>
      <td>也是</td>
      <td>用 羅馬 字母 , 那 中國人</td>
    </tr>
    <tr>
      <th>22</th>
      <td>桃園 往 北橫 那邊 走 很多 可以 玩 簡單 說 就是 你 說 的 貢丸 米粉</td>
      <td>也是</td>
      <td>老人 的 名產 有沒有 也 不 重要</td>
    </tr>
    <tr>
      <th>23</th>
      <td>兩 超多強 格局 差不多 成形 了 ， 中美 拉開 跟 後面 梯隊 的 差距 中國 不 是 ...</td>
      <td>也是</td>
      <td>相當 可觀 的 ， 而且 還 沒 進入 暴兵 模式</td>
    </tr>
    <tr>
      <th>24</th>
      <td>其實 台灣 名校 能 出去 世界 舞台 的 也 不少 ， 有些 按 科系 的 排名 ， 更能...</td>
      <td>也是</td>
      <td></td>
    </tr>
    <tr>
      <th>25</th>
      <td>明明 也 有 擁核舉 科學 例證 被 無視 的 別 自助餐 了 地震 我 也 寫過 你</td>
      <td>也是</td>
      <td>拿 地震帶 說嘴 啊 . . . 噢 對 我住 台北 松山 夠格 吧 ? 你們 這 種 非...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>今年 好多 補助 案 ， 選前 狂 撒錢 ， 彰化 敗家子 魏明谷</td>
      <td>也是</td>
      <td>降</td>
    </tr>
    <tr>
      <th>27</th>
      <td>這 一定</td>
      <td>也是</td>
      <td>假 新聞 高雄人 明明 都 很 喜歡 韓神 去選 總統</td>
    </tr>
    <tr>
      <th>28</th>
      <td>這樣 的 死法 大概</td>
      <td>也是</td>
      <td>得償 所願 吧</td>
    </tr>
    <tr>
      <th>29</th>
      <td>可憐 ， 我 鄰居</td>
      <td>也是</td>
      <td>娶到 普妹 賤 婊 ， 被 吸血 吸到 背債</td>
    </tr>
    <tr>
      <th>30</th>
      <td>醬料 三類</td>
      <td>也是</td>
      <td>文組</td>
    </tr>
    <tr>
      <th>31</th>
      <td>出血</td>
      <td>也是</td>
      <td>隔 2 天 就 好了</td>
    </tr>
    <tr>
      <th>32</th>
      <td>賴清德</td>
      <td>也是</td>
      <td>韓粉 喔 還 誇他 百年 難得 一見</td>
    </tr>
    <tr>
      <th>33</th>
      <td>不過 其邁 的 那 個 政治 獻金</td>
      <td>也是</td>
      <td>明顯 低報 了 還是 柯 文哲 誠實</td>
    </tr>
    <tr>
      <th>34</th>
      <td>照某樓 邏輯 ， DPP</td>
      <td>也是</td>
      <td>壓榨 公務員 收割 阿</td>
    </tr>
    <tr>
      <th>35</th>
      <td>這篇爆 這麼 快 … 八成</td>
      <td>也是</td>
      <td>…</td>
    </tr>
    <tr>
      <th>36</th>
      <td>巴菲特 沒 他 爸媽 大概</td>
      <td>也是</td>
      <td>肥宅 而已 ㄅ</td>
    </tr>
    <tr>
      <th>37</th>
      <td>票 ? 不過 想想</td>
      <td>也是</td>
      <td>， 智障 這麼多 會信 的 不少</td>
    </tr>
    <tr>
      <th>38</th>
      <td>現在 在 那 雞 歪三小 ， 你們</td>
      <td>也是</td>
      <td>亂源 之 一 喇幹</td>
    </tr>
    <tr>
      <th>39</th>
      <td>每 個 女生 都 母豬 ？ 你媽</td>
      <td>也是</td>
      <td>母豬 ？</td>
    </tr>
    <tr>
      <th>40</th>
      <td>柯 出來</td>
      <td>也是</td>
      <td>炮灰 一 枚 估計 這 投機 仔應 沒膽 出來 啦</td>
    </tr>
    <tr>
      <th>41</th>
      <td>讚讚讚 ! 自住</td>
      <td>也是</td>
      <td>有 差 喔 ， 等於 多 花 好多 錢 去 買 一樣 的 東西 其實 就 跟 8 + 9 ...</td>
    </tr>
    <tr>
      <th>42</th>
      <td>警察 人員</td>
      <td>也是</td>
      <td>軍人 不 清楚</td>
    </tr>
    <tr>
      <th>43</th>
      <td>以前 老人 有錢 ，</td>
      <td>也是</td>
      <td>這樣 撒 ， 老人 教 的</td>
    </tr>
    <tr>
      <th>44</th>
      <td>我</td>
      <td>也是</td>
      <td>啊 ， 為什麼 沒有 我</td>
    </tr>
    <tr>
      <th>45</th>
      <td>你 不 幫 牠 一 把 牠 很 快</td>
      <td>也是</td>
      <td>死</td>
    </tr>
    <tr>
      <th>46</th>
      <td>整天 母豬 噁甲 的 ~ 自己 小孩 去 學校</td>
      <td>也是</td>
      <td>這樣 稱呼 同學 嗎 ?</td>
    </tr>
    <tr>
      <th>47</th>
      <td>羞辱 光秀 ， 遲早</td>
      <td>也是</td>
      <td>死</td>
    </tr>
    <tr>
      <th>48</th>
      <td>萬一 盤好 久 了 去年 好像</td>
      <td>也是</td>
      <td>萬一 左右 盤盤 盤 . . . 然後 崩跌</td>
    </tr>
    <tr>
      <th>49</th>
      <td>真韓粉 ， 我</td>
      <td>也是</td>
      <td></td>
    </tr>
    <tr>
      <th>50</th>
      <td>是 補足 功能</td>
      <td>也是</td>
      <td>修正 bug 但 修正 bug 與 原 po 說法 相似 但 與 上帝 起初 創造 完美 ...</td>
    </tr>
    <tr>
      <th>51</th>
      <td>家長 。 轉去 其他 班級</td>
      <td>也是</td>
      <td>去 欺負 其他 人 而已 ， 問題 根本 一樣</td>
    </tr>
    <tr>
      <th>52</th>
      <td>跟 美國 總統 見 個面 就 會 高潮 我</td>
      <td>也是</td>
      <td>罪 了</td>
    </tr>
    <tr>
      <th>53</th>
      <td>山上 一 堆 亂葬 岡 ， 但 山腳 一 堆 人</td>
      <td>也是</td>
      <td>排隊 接 山泉水</td>
    </tr>
    <tr>
      <th>54</th>
      <td>ㄏㄏ 意思 是 英九</td>
      <td>也是</td>
      <td>？</td>
    </tr>
    <tr>
      <th>55</th>
      <td>幫 高調 ， 要 中立</td>
      <td>也是</td>
      <td>武裝 夠 強</td>
    </tr>
    <tr>
      <th>56</th>
      <td>那 無 薪假</td>
      <td>也是</td>
      <td>政府 體恤 民情 囉</td>
    </tr>
    <tr>
      <th>57</th>
      <td>台灣 沒 健保 收費</td>
      <td>也是</td>
      <td>比米國 便宜 阿 ~</td>
    </tr>
    <tr>
      <th>58</th>
      <td>心理 輔導 我 覺得 根本 都 騙人 的 走得 出來</td>
      <td>也是</td>
      <td>靠 自己 嚴重 的 就是 要 靠 吃藥</td>
    </tr>
    <tr>
      <th>59</th>
      <td>用意 不錯 像 我 懶叫 今天</td>
      <td>也是</td>
      <td>關一天 剛剛 才開</td>
    </tr>
    <tr>
      <th>60</th>
      <td>耶 風向 不 對 就 說 是 反串 這 護航 真棒 那 這 篇</td>
      <td>也是</td>
      <td>反串 摟</td>
    </tr>
    <tr>
      <th>61</th>
      <td>歐美</td>
      <td>也是</td>
      <td>祖先 殖民 老本 加上 自己 左派 政黨 努力 達成 的</td>
    </tr>
    <tr>
      <th>62</th>
      <td>南勢角 這邊</td>
      <td>也是</td>
      <td></td>
    </tr>
    <tr>
      <th>63</th>
      <td>統一</td>
      <td>也是</td>
      <td>目標 沒有 時間表 啊 現在 咧 ?</td>
    </tr>
    <tr>
      <th>64</th>
      <td>不用 腦 給 你 聯考</td>
      <td>也是</td>
      <td>廢物</td>
    </tr>
    <tr>
      <th>65</th>
      <td>死了 就 閉嘴 鋼鐵 人</td>
      <td>也是</td>
      <td></td>
    </tr>
    <tr>
      <th>66</th>
      <td>裡面 怨氣 重 啊 ， 韓國 的 與 神 同行</td>
      <td>也是</td>
      <td>這樣 演</td>
    </tr>
    <tr>
      <th>67</th>
      <td>老鼠</td>
      <td>也是</td>
      <td>小 動物 啊 。 怎麼 殺 老鼠 就 沒事 還要 鼓勵 ?</td>
    </tr>
    <tr>
      <th>68</th>
      <td>想 看看 原 po 大哥 的 報告 家中</td>
      <td>也是</td>
      <td>有 挺韓 …</td>
    </tr>
    <tr>
      <th>69</th>
      <td>如實 申報 就 無罪 ， 那 殺人 在 自首</td>
      <td>也是</td>
      <td>囉 ? 87 ? ? ?</td>
    </tr>
    <tr>
      <th>70</th>
      <td>他吸 大麻</td>
      <td>也是</td>
      <td>在 合法 國家 好 嗎 ？ 起碼 到 現在 為止 都 是</td>
    </tr>
    <tr>
      <th>71</th>
      <td>政大 東亞所 就 一 坨 垃圾 地政系</td>
      <td>也是</td>
      <td>出 盧秀燕 這 坨 自經區 是 至少 從 2014 就 浮上 台面 的 議題</td>
    </tr>
    <tr>
      <th>72</th>
      <td>定調 所以 呢 ？ 管不動</td>
      <td>也是</td>
      <td>黨主席 責任 啊 ， 你 敢 說 英能 撇 乾淨 ？</td>
    </tr>
    <tr>
      <th>73</th>
      <td>男 的 裸 上身</td>
      <td>也是</td>
      <td>爭取來 的</td>
    </tr>
    <tr>
      <th>74</th>
      <td>不然 靠 摸奶救 經濟 嗎 ?</td>
      <td>也是</td>
      <td>性 特區 拍 AV 有 賺 嗎</td>
    </tr>
    <tr>
      <th>75</th>
      <td>何謂 網軍 ？ 不 領錢 的 算 嗎 ？ 算 的話 我</td>
      <td>也是</td>
      <td>網軍 沒錯 啦</td>
    </tr>
    <tr>
      <th>76</th>
      <td>嚴格 來說 ， 您們</td>
      <td>也是</td>
      <td>只 針對 陳 欸 。</td>
    </tr>
    <tr>
      <th>77</th>
      <td>而且 外勞 的 工作 很多</td>
      <td>也是</td>
      <td>本勞 不 願意 做 的 。 工地 也 一 堆 外勞 呀</td>
    </tr>
    <tr>
      <th>78</th>
      <td>原 PO 才 是 對 的 此 題出 單選 有 謬論 「 最 」 正確</td>
      <td>也是</td>
      <td>很 好笑 xd</td>
    </tr>
    <tr>
      <th>79</th>
      <td>什麼 叫 台灣人 欺負 中國人 ？ 台灣人 不</td>
      <td>也是</td>
      <td>中國人 嗎 ？ 涉嫌</td>
    </tr>
    <tr>
      <th>80</th>
      <td>幹 ！ 原來 白宮 發言人</td>
      <td>也是</td>
      <td>廠公 ， 抓到 了 ！</td>
    </tr>
    <tr>
      <th>81</th>
      <td>某些 老綠男</td>
      <td>也是</td>
      <td>整天 抹英阿 扯後腿 老 獨派 最會 啦</td>
    </tr>
    <tr>
      <th>82</th>
      <td>我</td>
      <td>也是</td>
      <td>網軍</td>
    </tr>
    <tr>
      <th>83</th>
      <td>一般 的 片子 不</td>
      <td>也是</td>
      <td>這樣</td>
    </tr>
    <tr>
      <th>84</th>
      <td>會 因為 被 罵 改投 藍 ， 表示 藍本 來 就是 他們 可以 接受 的 選項 那藍 得利...</td>
      <td>也是</td>
      <td>眾望所歸 ， 有 什麼 好 抱怨 的</td>
    </tr>
    <tr>
      <th>85</th>
      <td>噗哧 ， 所以 你 是 館長 啊 。 選前</td>
      <td>也是</td>
      <td>這樣 說</td>
    </tr>
    <tr>
      <th>86</th>
      <td>大家 看到 了 嗎 她 就是 愛上 我 惹 但 又 不 想 承認 所以 拿到 標籤 說 原來...</td>
      <td>也是</td>
      <td>可以 接受 啦 不過 打太痛 不會 爽 啦</td>
    </tr>
    <tr>
      <th>87</th>
      <td>爸爸</td>
      <td>也是</td>
      <td>韓粉 嗎 ？</td>
    </tr>
    <tr>
      <th>88</th>
      <td>背刺 ！</td>
      <td>也是</td>
      <td>一 種 做 功德 的 方式</td>
    </tr>
    <tr>
      <th>89</th>
      <td>發大 財是 一切 的 因</td>
      <td>也是</td>
      <td>一切 的果 ， 掌握 發大財 就 掌握 宇宙</td>
    </tr>
    <tr>
      <th>90</th>
      <td>2020 年 統一 以後 台灣</td>
      <td>也是</td>
      <td>這樣 啊</td>
    </tr>
    <tr>
      <th>91</th>
      <td>還有 ， 這 靠 腰 這</td>
      <td>也是</td>
      <td>擔心 大陸 的 健身房 進來 競爭 吧 ！</td>
    </tr>
    <tr>
      <th>92</th>
      <td>批評 DPP 勞權 ， 結果 去投 KMT 的</td>
      <td>也是</td>
      <td>賤種 蠢渣</td>
    </tr>
    <tr>
      <th>93</th>
      <td>所以 你</td>
      <td>也是</td>
      <td>既得利益 者 阿 , 出來 嘴 甚麼</td>
    </tr>
    <tr>
      <th>94</th>
      <td>但是 年紀 一到</td>
      <td>也是</td>
      <td>會 被 火掉 啊 工廠 包 什麼 時候 倒 都 不 知道</td>
    </tr>
    <tr>
      <th>95</th>
      <td>高雄市 議會 在野黨</td>
      <td>也是</td>
      <td>混吃 等死 ， 都 不 知道 在 幹嘛</td>
    </tr>
    <tr>
      <th>96</th>
      <td>上 禮拜 韓國 瑜 批評 別人 密室 結果 今天 吳韓 會談</td>
      <td>也是</td>
      <td>密室</td>
    </tr>
    <tr>
      <th>97</th>
      <td>你 幹嘛 惹 工讀生 生氣 呢 ? ? 人家 要領 500</td>
      <td>也是</td>
      <td>很 拼命 的</td>
    </tr>
    <tr>
      <th>98</th>
      <td>像 財務 工程</td>
      <td>也是</td>
      <td>一 種 工程 哦</td>
    </tr>
    <tr>
      <th>99</th>
      <td>這</td>
      <td>也是</td>
      <td>到 現在 老百姓 只 知道 很 好聽 名詞 。 卻 一直 不 知道 是 什麼</td>
    </tr>
  </tbody>
</table>
</div>



## 「也是」的多重功能

在PTT的文章中，我們可以看到「也是」一詞的多種用法，到底是在「也是」什麼？如果把PTT視為一個類對話的平台，有人發文開啟了討論串後(對話分析中所謂的Initiator)，那麼就會引來底下的留言，底下的留言被稱為「樓」，留言可以和樓主互動，也可以是底下留言者之間的互動（像是一樓的人說：「五樓韓粉」），而PTT的推文/噓文/箭頭回文的功能為回文者制定了回文情緒的分類，底下推文和噓文的統計量也同時會反映在文章總覽頁面的標題之前。

在這樣將PTT視作類對話的互動場域後，就可以開始回到「也是」一詞扮演的功能。「也是」使用的場景常常是目前的語篇(discourse)可能正在談論某個話題、事件或人物，說話者可能想到了一個與現在的話題相關的東西，但這個東西目前還沒有出現在目前的語篇當中，因此說話者透過「也是」將新事物搬上話題的舞台，可以說「也是」在言談中扮演的功能是同時回指原先的訊息、同時提供新的訊息。因此可以將「也是」視作達成言談融貫性的一個工具之一。

舉個（人造的）例子：
A說：「我期末真的累到想休學。」
B說：「我也是準備鞠躬盡瘁了。」

在這個對話中，A先表達自己的近期的感受，而B透過「也是」一方面關聯了A剛剛所說的話，一方面也引入了自己的感受。在這個例子中，可以看到「也是」的使用達成了對話的融貫性，並讓B表達了自己的感受在某方面與A的感受相同。

但像是「跟美國總統見個面就會高潮我也是罪了」這樣的回文內容呢？這篇的Po文原文講的是郭台銘與美國總統見面的新聞，在這則報導下方出現「跟美國總統見個面就會高潮我也是罪了」這樣的貼文，那麼這裡的「也是」回指了新聞內容的哪個部分呢？這裡「也是」的使用似乎就不像上面AB之間的對話那樣在表達同感，因為新聞本身的文體是在傳達資訊，而不是在徵詢觀者的同意。而且在這個回文中，符合了中文常見的TOPIC-COMMENT的結構：

```    
[跟美國總統見個面就會高潮][我也是醉了 ]
[     TOPIC          ][ COMMENT ]
```

先點出一個主題，再對該主題進行評論、發揮，這是中文裡必須要區分主題（跟美國總通見個面就會高潮）和主語（我）的一個特色。但我目前好奇的是，這裡的「也是」究竟是在「也是」什麼？是否是在表達「針對『跟美國總統見個面就會高潮』這個事件，其他很多人醉了，而我『也是』醉了」？這是我目前還不知道該如何去思考的一個問題。有些學者傾向將「也是醉了」視作一個construction，因為這個詞在在2014年中國流行語票選當中擠進前10名。但我覺得這個構式應該還可以再去分割下去，因為PTT裡有很多用來表達不同意和諷刺的「也是」，例如：「也是笑笑」、「也是不EY」、「也是很神奇」、「也是一種才能」等等。

我現在也還在慢慢看過這些語料，看看能不能找出什麼模式的階段，或者我能夠進行什麼樣的分類和分析。
