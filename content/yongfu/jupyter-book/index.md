---
title: "將 Jupyter Notebook 整理成一本書"
subtitle: "Jupyter Book 簡介"
author: "Yongfu Liao"
mysite: /yongfu/
date: "2019-05-11 00:00:00 +0800"
description: "Create a book from multiple Jupyter notebooks with Jupyter Book"
tags: ['notetaking', 'Jupyter Notebook']
comment: yes
---

從學期初修 Python[^credits] 就一直在吃老本，直到最近學到物件導向[^oop]才開始認真思索寫筆記這件事。就寫筆記而言，我最熟悉的工具[^tool]當然是 R Markdown，而 RStudio 目前[對 Python 也有不錯的支援](https://rstudio.github.io/reticulate)。但我平常把 [JupyterLab](https://github.com/jupyterlab/jupyterlab) 當成 Python 的 IDE 在使用，自然比較習慣這個環境，因此就決定使用 Jupyter Notebook 來寫筆記。我第一個想到的問題就是：R Markdown 的世界裡有 [bookdown](https://bookdown.org/yihui/bookdown) 將多個 `.Rmd` 變成一本書 (網頁)，但 Jupyter Notebook 似乎沒有這麼方便的工具[^nbconvert]。**我錯了**。好概念傳播的很快，受到 bookdown 的啟發，Jupyter 的世界裡也出現了一套類似的工具 --- [Jupyter Book](https://jupyter.org/jupyter-book/intro.html)。


## What is Jupyter Book?

其實 Jupyter Book 的概念非常簡單：

1. 將 Jupyter Notebook (`.ipynb`) 轉換成 markdown (`.md`)
2. 使用 Jekyll (靜態網頁產生器) 生成網頁


但它真正厲害的地方在於它的靜態網頁模板 ([範例](https://jupyter.org/jupyter-book/features/hiding.html))：

1. 版面風格與 Jupyter Notebook 類似
1. 網頁模板添加許多功能
    - `.ipynb` 下載連結
    - [binder](https://mybinder.org) 連結
    - 直接執行程式碼 (by [Thebe Lab](https://minrk.github.io/thebelab))


## Jupyter Book 的 Jekyll 模板

Jupyter Book 提供了相當清楚易懂的[說明文件](https://jupyter.org/jupyter-book/intro.html)。唯一需要注意的是，Jupyter Book 必須使用 Jekyll 才能在個人電腦上預覽網頁，而安裝 Jekyll 是非常麻煩的事 (尤其在 Windows 上)。為解決這麻煩，Jupyter Book 很細心的提供了[以 docker 使用 Jekyll 的方式](https://jupyter.org/jupyter-book/guide/03_build.html#build-the-books-site-html-locally)，減少安裝 Jekyll 的麻煩 (但學習使用 docker 又是另一個麻煩事)。如果對於 Jekyll 運作了然於心，其實可以不用在個人電腦上安裝 Jekyll 預覽網頁，直接將生成的檔案丟到 GitHub 上讓 GitHub Pages 生成網頁。

但對多數人最頭痛的應該是 Jekyll 模板的結構，這邊提供快速上手的說明 (換言之，在不懂 Jekyll 下使用 Jupyter Book 的模板)。


## 使用 Jupter Book

1. 安裝  
```bash
pip install jupyter-book
```

2. 匯入模板  
```bash
jupyter-book create mybookname
```
    
    這個指令會匯入 Jupyter Book 的 Jekyll 模板 (簡化)：  
    ```
    mybookname/
    ├── _config.yml
    ├── content
    │   ├── images
    │   │   └── logo
    │   │       └── favicon.ico
    │   └── notebook.ipynb
    └── _data
        └── toc.yml
    ```

    在這模板裡面，
    
    - **`content/`**
    
      存放 Jupyter Notebook 的地方，可依照自己喜好使用任意檔案結構 (e.g. `content/01/` 裡面放多個 notebook，如 `content/01/intro.ipynb`, `content/01/hello-world.ipynb`；或是直接將 notebook 丟在 `content/` 之下)。
    
    - **`_data/toc.yml`**
    
      `content/` 中的檔案結構可有很大彈性，因為網頁的目錄 (左欄) 連結是在 `_data/toc.yml` 中**手動設定**的。例如，要將 `content/01/intro.ipynb` 生成之網頁的連結放在目錄上 ，得在 `_data/toc.yml` 設定：

      ```yaml
      - title: Introduction
        url: /01/intro
        not_numbered: false
        expand_sections: false
      ```

    - **`_config.yml`**
    
      這裡是設定 Jekyll 網頁的一些資訊，例如網站名稱和作者等。特別需要注意的是 `baseurl` 和 `url` 這兩個項目。如果你的網頁是透過 GitHub Pages 產生的 (假設這份 Jekyll 模板上傳到 GitHub 的 `mybookname` repo)，那 baseurl 就會是 `/mybookname`：  
```yaml
baseurl: /mybookname
url: https://<user>.github.io
```

3. 輸出 (不需 Jekyll)：將 Working directory 設成 `mybookname/`，執行下方指令  
```bash
python scripts/clean.py  # 清理之前產生的檔案
jupyter-book build ./    # 從 `contents/` 產生 Jekyll 能處理的檔案
```

4. 上傳至 GitHub (記得到 Repo 的 Settings 裡設定，讓 GitHub Pages 使用 master branch 生成網頁)

這樣就大功告成了！

### My Python Note

[liao961120/pynote](https://github.com/liao961120/pynote) 是我透過 Jupyter Book 設置的 [Python 筆記](https://github.com/liao961120/pynote)，與上面介紹不同的是，我使用的是 [netlify](https://www.netlify.com) 而非 GitHub Pages；另外，我也透過 Travis-CI [幫我執行 `python scripts/clean.py` 與 `jupyter-book build ./`](https://github.com/liao961120/pynote/blob/master/.travis.yml)，所以就不用在每次修改筆記後，還得在電腦上跑這些指令。



[^credits]: 本來沒預計要修，沒想到選上了又加上學分不足，想趁這個機會逼自己熟悉一下 Python。

[^oop]: 去年七月的時候，開始栽入 R 套件開發的世界。這讓我比較深入的接觸 R 語言，同時也讓我更深刻體驗到「(一段時間後) 看不懂自己程式碼」的感覺。一方面，我覺得 R 向量式的思維習慣，讓我在學 Python (不使用 numpy, pandas 等套件) 的過程中有點卡；另一方面，我過去一直不太能掌握的物件導向的概念，但最近[聽完課](https://www.coursera.org/learn/pbc3/home/week/1)後竟然有頓悟的感覺。我猜原因不是因為老師講得特別好，單純是因為**自己寫過太多 buggy 的程式**，所以現在開始比較能體會 OOP 的思維方式如何減輕程式開發時的認知負擔。以前程式還寫得不夠多的時候，OOP 對我而言只是一堆生澀的術語和概念，反而造成學習上的困難。

[^tool]: 我認為一個**好的筆記**需要具備這些特徵：

    1. 能長存 (i.e. 不會被資源回收掉、不小心殺掉或遺忘在電腦與雲端硬碟的某個資料夾裡)
    2. 方便瀏覽，包含能快速找到筆記的位置 (我放在哪裡) 以及特定內容 (OO 概念寫在哪裡？)
    
    換言之，好的筆記意味著**好的檔案管理與搜尋方式**。在這個時代下，(靜態) 網頁正是管理筆記的好工具：它能長存且方便瀏覽 (i.e. 能輕易的在頁面間切換、在頁面內搜尋文字，找到所需資訊)。


[^nbconvert]: 當下的直覺想法是使用 [nbconvert](https://github.com/jupyter/nbconvert) 將 `.ipynb` 轉換成 `.md`，把這些 `.md` 丟到一個網頁模板，再用靜態網頁產生器 (Jekyll 或 Hugo) 生成網頁。於是我開始這樣做，但試了一陣子之後就發現這些**網頁模板都太複雜了**，光是要研究它們就要花上不少時間。另外，使用這些模板還有一個缺點 --- 人們喜歡熟悉的東西，換言之，常用 Jupyter Notebook 的人會習慣它的界面 (白、橘色)，但使用網頁模板會破壞這個習慣，讓使用者產生不適感。

