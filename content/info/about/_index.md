---
title: 關於
subtitle: A Blog for Anyone
disable_mathjax: true
disable_highlight: true
---


**R部落客 • 協作** 旨在提供 R 語言愛好者，特別是 *沒有經營部落格* 者，一個發表文章的平台。

## 社群共營的部落格


## 簡單的文章發表機制

文章發表步驟 **R部落客 • 協作**：

1. 使用 R Markdown 撰寫文章
1. 將 `.Rmd` 檔與相關外部檔案（Rmd 所在之資料夾）壓縮成 `.zip` 檔
1. 填寫文章上傳表單：<http://bit.ly/coRbloggersForm>

### GitHub 使用者

**R部落客 • 協作** 託管於 GitHub 上。因此，若熟悉 GitHub，可直接以 Pull Request 的方式新增文章：

1. Fork [Rbloggers/coBlogger](https://github.com/Rbloggers/coBlogger)

1. 在 `content/` 下新增作者資料夾及文章資料夾，每篇文章是各自獨立的一個資料夾：

    ```yml
    /
    ├── content/
        ├── <作者資料夾>/
            ├── _index.md        # 作者個人頁面（文章列表）
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
    
    ```yml
    ---
    title: <標題> # e.g., Yongfu's Blog
    subtitle: <副標題> #e.g.,  R · Learning · Life
    disable_mathjax: true
    disable_highlight: true
    ---
    ```

1. 至 [config.yaml](https://github.com/Rbloggers/coBlogger/blob/dd235acb6debd9d5bc29abd8f104dc3143769ad7/config.yaml#L32-L34) `menu > main` 之下新增連結資訊

1. 提出 Pull Request



## 為作者保存所有文章

如果有一天作者決定獨立經營一個部落格，保存在 **R部落客 • 協作** 上的文章能輕鬆地轉移至新部落格，因為所有的文章都是獨立、可重新產生網頁的 `.Rmd` 檔。事實上，這正是 **R部落客 • 協作** 最希望看見的未來。