---
title: 協作部落格
subtitle: 三步驟發表文章
disable_mathjax: true
comment: true
---



## 兩種文章發表方式

### Google 表單

見 [三步驟發表文章](https://corbloggers.netlify.com/info/about/#三步驟發表)

### GitHub 使用者

**R部落客 • 協作** 託管於 GitHub 上。因此，若熟悉 GitHub，可直接以 Pull Request 的方式新增文章：

1. Fork [Rbloggers/coBlogger](https://github.com/Rbloggers/coBlogger)

1. 在 `content/` 下新增作者資料夾及文章資料夾，每篇文章是各自獨立的一個資料夾：

    ```yaml
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
    
    ```yaml
    ---
    title: <標題> # e.g., Yongfu's Blog
    subtitle: <副標題> #e.g.,  R · Learning · Life
    disable_mathjax: true
    disable_highlight: true
    ---
    ```

1. 至 [config.yaml](https://github.com/Rbloggers/coBlogger/blob/dd235acb6debd9d5bc29abd8f104dc3143769ad7/config.yaml#L32-L34) `menu > main` 之下新增連結資訊

1. 提出 Pull Request

## 問題協助

在提交的過程中，如遇到任何問題，歡迎在下方留言或是透過 [email](mailto:liao961120@gmail.com) 聯絡我們。