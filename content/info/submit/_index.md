---
title: 發表文章
subtitle: Ideas Worth Spreading
disable_mathjax: true
comment: true
---

## LOPE

若您是 [LOPE](http://lope.linguistics.ntu.edu.tw/) 成員，請先閱讀 [協作閣 for LOPE](https://bit.ly/LOPE0221) 再填寫[這份表單](https://goo.gl/forms/t76C5JNDjMx8DxX42)。其他使用者，詳見下方說明。


## 兩種文章發表方式

### 三步驟發表

1. 用 R Markdown 寫文章 ([模板](https://collabin.netlify.com/post-template.zip)、[輸出文章](/yongfu/write-in-rmd/))
1. 將 `.Rmd` 檔與相關外部檔案（Rmd 所在之資料夾）壓縮成 `.zip` 檔
1. 填寫**文章上傳表單**：<https://goo.gl/forms/p2COrcydN4EYoqWG3>

如果可以的話，我們希望使用者能註冊 [GitHub](https://github.com) 帳號，嘗試學習直接透過 Pull Request 新增文章 (見下)。如此，GitHub 能記錄您發表文章的歷史，而您未來也能學會使用 GitHub 託管網站。


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

## 同步發表至 R部落客

若您想讓發表在 **協作閣** 的文章出現在 [R部落客粉專](https://www.facebook.com/twRblogger) ，僅需在文章 `.Rmd` yaml head 的 `tags:` 加入 `rblog`：

```yaml
---
title: "文章標題"
subtitle: "文章副標題"
author: "作者姓名"
...
comment: true             # 文章是否開放留言
tags: ['rblog', 'tag2']   # 文章 tag
```

加入標籤前，請您務必先閱讀 [R部落客 文章提交規定](https://rbloggers.github.io/join.html#必要規定)。


## 問題協助

在提交的過程中，如遇到任何問題，歡迎在下方留言或是透過 [email](mailto:liao961120@gmail.com) 聯絡我們。

