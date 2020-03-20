[![Build Status](https://travis-ci.org/liao961120/collabin.svg?branch=master)](https://travis-ci.org/liao961120/collabin)


# 協作閣

開源協作部落格


## 表單上傳後

1. If 新作者
    - 新增作者資料夾
        - 新增 [`_index.md`](https://github.com/liao961120/collabin/blob/master/content/yongfu/_index.md)
    - `config.yaml`: 新增作者 ID
    - `content/author_info/<author>.yml`
1. 處理文章格式 (for LOPE)：
    1. 打開 `load_submission.R`
    1. 檢視總共有多少新文章
    1. 一次處理一篇
