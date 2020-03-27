---
title: 使用多進程加速斷詞作業
subtitle: ''
tags: ["multiprocessing", "word segmentation", LOPE]
date: '2020-03-26'
author: Don
mysite: /don/
comment: yes
---


為了將PTT撈下來的語料大量進行斷詞，一開始寫了一個用迴圈一個檔案一個檔案慢慢斷詞的程式碼，後來發現實在是太慢了（當然放在server上慢慢跑還是可以跑完），後來發現其實可以用多進程的方式實現，剛剛好server有很多顆CPU，可以讓每個CPU同時運幫我斷詞。假如server上有16個CPU的話，等於說原本迴圈版的斷一篇文章的時間，用多進程的版本就可以斷16篇文章。粗略來說，省了16倍的時間。

使用多進程，需要用到`multiprocessing`這個原生套件。(請參考官方文檔：https://docs.python.org/zh-cn/3/library/multiprocessing.html)

# 匯入 `multiprocessing` 套件


```python
import multiprocessing as mp

# 先看總共有幾個 cpu 可以使用
cpu_count = mp.cpu_count()
print(cpu_count)
```

# 實例化 Pool 物件


```python
# 把你想使用的 cpu 數量作為參數
pool = mp.Pool(cpu_count)
```

# 接著準備一個要針對檔案進行處理的函數


```python
def function_for_every_file_to_run(json_path):
    """
    輸入是一個 .json 檔的路徑，也就是每一篇貼文的 .json 檔
    """
    
    # 讀進 json 檔
    with open(json_path, "r") as f:
        data = json.load(f)
        
    # 這裡可以開始進行斷詞任務
    # 這裡用 split() 來模擬斷詞
    list_of_word = data['post'].split()
    
    # 把斷好的詞寫進新的檔案
    # (略...)
```

# 最後調用 Pool 物件的`imap_unordered()`方法

Pool 物件其實有很多不同進行多進程的方法，有`apply()`, `apply_async()`, `map()`, `map_async()`, `imap()`, `imap_unordered()` ...等，每個方法有不同適用的場景，可以自行查閱網路上的介紹(https://docs.python.org/zh-cn/3/library/multiprocessing.html#module-multiprocessing.pool)。

這裡我使用的是 `imap_unordered()`，因為斷詞文章的順序並不重要。

這幾個方法的接收的參數都是差不多的，我們看一下 `imap_unordered()` 接收的參數：

```
pool.imap_unordered(func, iterable, chunksize=1)
```

第二個參數是 `iterable`，在這裡的例子可能是路徑中所有的 .json 檔，所以是一個 list of json path。

第一個參數是 `func`，也就是針對第二個參數中的每一個元素要進行的函數，也就是我上面所準備的 `function_for_every_file_to_run()`，這也是為什麼這個函數接收的參數是 `json_path`。

接下來就可以丟進去囉。


```python
pool.imap_unordered(function_for_every_file_to_run, Path("~/ptt_json_file").rglob("*.json"))
```

# 結論

我測試過沒有用多進程的版本，對幾十萬個.json檔大概要斷八個多小時，而使用server上32個CPU去進行多進程的斷詞，只需要幾十分鐘，真的是快得很有成就感。當然也要感謝我們有一個那麼多CPU資源的server啦。
