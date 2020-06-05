---
title: 發表文章
subtitle: Ideas Worth Spreading
disable_mathjax: true
comment: true
---

## LOPE

若您是 [LOPE](http://lope.linguistics.ntu.edu.tw/) 成員，請先閱讀 [協作閣 for LOPE](https://bit.ly/LOPE0221) 再填寫[這份表單](https://goo.gl/forms/t76C5JNDjMx8DxX42)。其他使用者，詳見下方說明。

## 加入協作閣

為建構您的個人頁面，第一次上傳文章前，請先填寫 [加入申請](https://forms.gle/anT5Jak8227S8io48)。表單送出後，請先耐心等候 ( 1 ~ 7 天) 回信，再填寫文章上傳表單。

## 三步驟發表

1. Markdown / R Markdown / Jupyter Notebook 撰寫文章
  - 文章中的外部檔案連結，請使用**相對路徑**
  
1. 準備上傳檔案：
  - Markdown 撰寫：將 `.md` 檔與相關外部檔案（`.md` 所在之資料夾）壓縮成 `.zip` 檔。請確保壓縮檔內**只有一個 `.md` 檔**。
  - R Markdown 撰寫：將 `.Rmd` 檔與相關外部檔案（Rmd 所在之資料夾）壓縮成 `.zip` 檔。請確保壓縮檔內**只有一個 `.Rmd` 檔**。
  - Jupyter Notebook：確定已先執行過整個 Notebook，直接提交 `.ipynb` 檔。

1. 填寫**文章上傳表單**：<https://forms.gle/rJpKs9TxQ9Dmqqc2A>


## 修改文章

修改文章必須擁有 [GitHub](https://github.com) 帳號。要修改文章，可在該篇文章的頁面中點擊 <img style="display:inline;height:1em;margin-bottom:0" src="https://bit.ly/2RRirG7">：

<img src='/images/edit.png' style='width:40%'>

這將會開啟 GitHub 上的編輯頁面。第一次編輯時，GitHub 會請您 fork repo，請點擊確定。編輯的過程可完全透過網頁進行，別擔心會因為按錯什麼而毀損檔案。

### Jupyter Notebook

如果使用 Jupyter Notebook 撰寫文章，點擊 <img style="display:inline;height:1em;margin-bottom:0" src="https://bit.ly/2RRirG7"> 所修改的會是已轉換成 `.md` 的文件。換言之，原始的 `.ipynb` 並未被修改。若想保持兩者的一致，請在進入 <img style="display:inline;height:1em;margin-bottom:0" src="https://bit.ly/2RRirG7"> 進行修改之後，再
透過 pull request 複寫原本的 `.ipynb` (與 `.md` 在同一個資料夾，並且檔名皆為 `index` 開頭)


## 文章撰寫、上傳、發表

關於上述更詳細的說明，請閱讀此[投影片](http://bit.ly/collabinDocs)。

<!--

### GitHub 使用者

**協作閣** 託管於 GitHub 上。因此，若熟悉 GitHub，可直接提出 Pull Request 新增文章(不需填表單)：

1. 用 R Markdown 寫文章 ([模板](https://collabin.netlify.com/post-template.zip)、[輸出文章](/yongfu/write-in-rmd/))

1. Fork [Rbloggers/collabin](https://github.com/Rbloggers/collabin)

1. 在 `content/` 下新增作者資料夾及[文章資料夾](https://github.com/Rbloggers/collabin/tree/master/content/yongfu/write-in-rmd)，每篇文章是各自獨立的一個資料夾：

    ```yaml
    /
    ├── content/
        ├── <作者資料夾>/  # 只有第一次發文要新增, 之後文章皆在此新增
            ├── _index.md   # 作者個人頁面（文章列表）
            ├── <文章資料夾1>/   # 文章1
            │   ├── index.Rmd    # 文章1 內文
            │   ├── ref.bib
            │   ├── img1.gif
            │   ├── ... 
            │   └── img2.png
            │
            └── <文章資料夾2>/   # 文章2
                ├── index.Rmd    # 文章2 內文
                ├── ... 
                └── img2.png
    ```

1. 在 `content/<作者資料夾>/_index.md` 第一行開始新增下列內容：
    
    ```yaml
    ---
    title: <標題>       # e.g., Yongfu's Blog
    subtitle: <副標題>  # e.g.,  R · Learning · Life
    disable_mathjax: true
    disable_highlight: true
    ---
    ```

1. 至 [config.yaml](https://github.com/Rbloggers/collabin/blob/a214ef35099220aa01956489abbce3fca15ecaf3/config.yaml#L32-L34) `menu > main` 之下新增連結資訊：
    
    ```yaml
    menu:
      main:
        ...
        - name: Yongfu Liao
          url: /yongfu/
          weight: 100        # author weights are always 100
        - name: <Your Name>
          url: /<文章資料夾>/
          weight: 100        # author weights are always 100
    ```

1. 提出 Pull Request

-->

## 問題協助

在提交的過程中，如遇到任何問題，歡迎在下方留言或是透過 [email](mailto:liao961120@gmail.com) 聯絡我們。

