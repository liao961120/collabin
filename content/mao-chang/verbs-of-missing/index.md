---
title: 思念、想念、懷念、掛念的語意比較
subtitle: ''
tags: ["lexical semantics", "PTT", LOPE]
date: '2020-04-10'
author: Mao-Chang Ku
mysite: /mao-chang/
comment: yes
isRmd: no
---

Mining articles from PTT HatePolitics and Boy-Girl Boards
---------------------------------------------------------

    library(jiebaR)
    library(stringr)
    library(future.apply)
    library(PTTmineR)
    library(tidytext)
    library(quanteda)
    library(dplyr)
    library(future)
    library(readr)

    seg <- worker()
    plan(multiprocess(workers = 8, gc = TRUE))

    HP_miner <- PTTmineR$new(task.name = 'Hate_Politics')
    HP_miner %>% 
      mine_ptt(board = "HatePolitics", last.n.page = 200)

    HP_miner %>% 
      export_ptt(export.type = 'tbl', obj.name = 'HP_tbl_result')
    HP_post <- HP_tbl_result$post_info_tbl

    posts_HP <- vector()
    for (i in 1:nrow(HP_post)) {
      p <- HP_post$post_content[i]
      segged_p <- segment(p, seg)
      posts_HP[i] <- paste0(segged_p, collapse = ' ')
    }

    HP_df <- tibble::tibble(看板 = '政黑',
                              編號 = 1:nrow(HP_post),
                              作者 = HP_post$post_author, 
                              標題 = HP_post$post_title, 
                              內容 = posts_HP)

    write_csv(HP_df, path = 'PTT_HP.csv')

    BG_miner <- PTTmineR$new(task.name = 'Boy-Girl')
    BG_miner %>% 
      mine_ptt(board = "Boy-Girl", last.n.page = 200)

    BG_miner %>% 
      export_ptt(export.type = 'tbl', obj.name = 'BG_tbl_result')
    BG_post <- BG_tbl_result$post_info_tbl

    posts_BG <- vector()
    for (i in 1:nrow(BG_post)) {
      q <- BG_post$post_content[i]
      segged_q <- segment(q, seg)
      posts_BG[i] <- paste0(segged_q, collapse = ' ')
    }

    BG_df <- tibble::tibble(看板 = '男女', 
                              編號 = 1:nrow(BG_post),
                              作者 = BG_post$post_author, 
                              標題 = BG_post$post_title, 
                              內容 = posts_BG)

    write_csv(BG_df, path = 'PTT_BG.csv')

    head(HP_df)

    ## # A tibble: 6 x 5
    ##   看板   編號 作者     標題                 內容                           
    ##   <chr> <int> <chr>    <chr>                <chr>                          
    ## 1 政黑      1 yuxds    Re: 館長自爆：北市官員說為了讓我開… 引述 sunyeah 湯元 嗎 之 銘 言 打電話 給 幕僚…
    ## 2 政黑      2 GV13     回應譚德塞 要鬥志不鬥氣… 1. 轉錄 標題 ︰ 回 應 譚 德塞 要 鬥志 不 鬥氣 …
    ## 3 政黑      3 platinu… 覺青請小心 你擁護的可能是五毛！！… https reurl cc kdEgqd 抓到了 攻擊 彈…
    ## 4 政黑      4 huanglo… 韓國瑜談外商投資高雄 可望今年底定案… 日商 台灣 三井 不動產 集團 拜訪 高雄 市長 韓國 瑜 …
    ## 5 政黑      5 wiwi0526 韓導該怎麼下台才漂亮 看見 2 階段 還有 10 幾萬 份 沒 送 但 審議 就 …
    ## 6 政黑      6 sunyeah  Re: 館長自爆：北市官員說為了讓我開… 打電話 給 幕僚 抱怨 嗆 聲 幹 拎 娘 2022 以後 …

    head(BG_df)

    ## # A tibble: 6 x 5
    ##   看板   編號 作者     標題                內容                            
    ##   <chr> <int> <chr>    <chr>               <chr>                           
    ## 1 男女      1 bb255052 Re: 為什麼男生都喜歡看起來笨的女… 我 很 認真 的 回 你 然後 也 說 一下 天然 呆 是 真…
    ## 2 男女      2 asususer 如何與飲料店妹子閒聊 超級新手… 本人 是 超級 少話 的 男生 句點 王 很多 時候 不 知道…
    ## 3 男女      3 sumade   Re: 我與iouuoi小姐爭執，請… 引述 NSDC 隨風而逝 之 銘 言 我 相信 公道 自在 人…
    ## 4 男女      4 coolrr   Re: 澳洲台勞女能碰嗎！？… 引述 alexhsu0909 之 銘 言 本魯 朋友 碰到 了…
    ## 5 男女      5 stan766… Re: 我與iouuoi小姐爭執，請… 先說 結論 老子 付錢 怎能不 愛上 我 想 吃 沒 吃 到 …
    ## 6 男女      6 puretru… 天秤座露股溝道歉具有法律效力嗎？… 試管嬰兒 小孩 比較 有 實驗 精神 情緒 勒索 妹 哭腔 走…

Statistics
----------

    boards <- c('政黑', '男女')

    HP_npost <- nrow(HP_df)
    BG_npost <- nrow(BG_df)

    HP_nchar <- HP_df$內容 %>% nchar %>% sum
    BG_nchar <- BG_df$內容 %>% nchar %>% sum

    tidy_HP <- HP_df %>% unnest_tokens('word', '內容', token = 'words')
    tidy_BG <- BG_df %>% unnest_tokens('word', '內容', token = 'words')

    HP_ntok <- tidy_HP %>% nrow()
    BG_ntok <- tidy_BG %>% nrow()

    HP_nword <- tidy_HP %>% count(word) %>% nrow()
    BG_nword <- tidy_BG %>% count(word) %>% nrow()

    tibble::tibble(看板 = boards,
                     篇數 = c(HP_npost, BG_npost),
                     字數 = c(HP_nchar, BG_nchar),
                     tokens = c(HP_ntok, BG_ntok),
                     words = c(HP_nword, BG_nword))

    ## # A tibble: 2 x 5
    ##   看板   篇數    字數  tokens words
    ##   <chr> <int>   <int>   <int> <int>
    ## 1 政黑   3894 2250498  858224 33493
    ## 2 男女   3919 3577966 1431892 28448


‘Missing’ Verbs
---------------

    corpus_HP <- corpus(HP_df,
                        docid_field = '編號',
                        text_field = '內容')

    kwic(corpus_HP, '[思想懷掛]念', valuetype = 'regex') %>% head(10) %>% knitr::kable(align = 'c')

<table>
<thead>
<tr class="header">
<th style="text-align: center;">docname</th>
<th style="text-align: center;">from</th>
<th style="text-align: center;">to</th>
<th style="text-align: center;">pre</th>
<th style="text-align: center;">keyword</th>
<th style="text-align: center;">post</th>
<th style="text-align: center;">pattern</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">229</td>
<td style="text-align: center;">213</td>
<td style="text-align: center;">213</td>
<td style="text-align: center;">來源 是 台灣 而 令人</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">的 是 網路 上 頗</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">245</td>
<td style="text-align: center;">155</td>
<td style="text-align: center;">155</td>
<td style="text-align: center;">來源 是 台灣 而 令人</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">的 是 網路 上 頗</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">529</td>
<td style="text-align: center;">375</td>
<td style="text-align: center;">375</td>
<td style="text-align: center;">對於 以前 經濟 起飛 的</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">認為 KMT 保護 了 台灣</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">1376</td>
<td style="text-align: center;">94</td>
<td style="text-align: center;">94</td>
<td style="text-align: center;">壓 著 打 我 真</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">那個 用 卡車 撞 法院</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1398</td>
<td style="text-align: center;">18</td>
<td style="text-align: center;">18</td>
<td style="text-align: center;">政治 瞬間 無聊 許多 有夠</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">選 前 跟 韓 總</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">1609</td>
<td style="text-align: center;">34</td>
<td style="text-align: center;">34</td>
<td style="text-align: center;">沉寂 至今 實在 是 有點</td>
<td style="text-align: center;">想念</td>
<td style="text-align: center;">韓 導 的 妙語如珠</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1722</td>
<td style="text-align: center;">494</td>
<td style="text-align: center;">494</td>
<td style="text-align: center;">柯 粉 們 你們 會</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">2019 年 八月 以前 那個</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">1772</td>
<td style="text-align: center;">259</td>
<td style="text-align: center;">259</td>
<td style="text-align: center;">柯 粉 們 你們 會</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">2019 年 八月 以前 那個</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">2189</td>
<td style="text-align: center;">54</td>
<td style="text-align: center;">54</td>
<td style="text-align: center;">老 實說 還 真是 有點</td>
<td style="text-align: center;">想念</td>
<td style="text-align: center;">他 曾經 帶來 的 歡笑</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">2212</td>
<td style="text-align: center;">140</td>
<td style="text-align: center;">140</td>
<td style="text-align: center;">當時 很難 預測 到 我</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">以前 跟 我 筆戰 的</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
</tbody>
</table>

    corpus_BG <- corpus(BG_df,
                        docid_field = '編號',
                        text_field = '內容')

    kwic(corpus_BG, '[思想懷掛]念', valuetype = 'regex') %>% head(10) %>% knitr::kable(align = 'c') 

<table>
<thead>
<tr class="header">
<th style="text-align: center;">docname</th>
<th style="text-align: center;">from</th>
<th style="text-align: center;">to</th>
<th style="text-align: center;">pre</th>
<th style="text-align: center;">keyword</th>
<th style="text-align: center;">post</th>
<th style="text-align: center;">pattern</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">92</td>
<td style="text-align: center;">705</td>
<td style="text-align: center;">705</td>
<td style="text-align: center;">都 不 符合 引述 freshguy</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">不如 相 見 之 銘</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">108</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">引述 freshguy</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">不如 相 見 之 銘</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">117</td>
<td style="text-align: center;">33</td>
<td style="text-align: center;">33</td>
<td style="text-align: center;">的 通訊 方式 想要 表達</td>
<td style="text-align: center;">思念</td>
<td style="text-align: center;">要 馬 約 出來 要</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">122</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">引述 freshguy</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">不如 相 見 之 銘</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">140</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">引述 freshguy</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">不如 相 見 之 銘</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">148</td>
<td style="text-align: center;">477</td>
<td style="text-align: center;">477</td>
<td style="text-align: center;">巴 朋友 多麼 讓 人</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">的 字眼 阿 已經 好久</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">186</td>
<td style="text-align: center;">236</td>
<td style="text-align: center;">236</td>
<td style="text-align: center;">已 五年 五年 來 仍</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">過去 夫妻 相處 時光 幾天</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">279</td>
<td style="text-align: center;">35</td>
<td style="text-align: center;">35</td>
<td style="text-align: center;">著 你 認識 花 時間</td>
<td style="text-align: center;">懷念</td>
<td style="text-align: center;">過去 是 最大 的 錯誤</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="odd">
<td style="text-align: center;">303</td>
<td style="text-align: center;">103</td>
<td style="text-align: center;">103</td>
<td style="text-align: center;">的 ig 帳號 發 一下</td>
<td style="text-align: center;">思念</td>
<td style="text-align: center;">她 的 話 也 因</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
<tr class="even">
<td style="text-align: center;">303</td>
<td style="text-align: center;">388</td>
<td style="text-align: center;">388</td>
<td style="text-align: center;">愛 嗎 還是 只是 再</td>
<td style="text-align: center;">思念</td>
<td style="text-align: center;">過去 的 人 最後 我</td>
<td style="text-align: center;">[思想懷掛]念</td>
</tr>
</tbody>
</table>

    HP_freq <- tidy_HP %>% count(word)
    BG_freq <- tidy_BG %>% count(word)

    count_freq <- function (x, y) {
      if (y %in% x$word) {
        number <- filter(x, word == y)$n
      }
      else {number <- 0}
    }
      

    tibble::tibble(看板 = boards,
                     思念 = c(count_freq(HP_freq, '思念'), count_freq(BG_freq, '思念')),
                     想念 = c(count_freq(HP_freq, '想念'), count_freq(BG_freq, '想念')),
                     懷念 = c(count_freq(HP_freq, '懷念'), count_freq(BG_freq, '懷念')),
                     掛念 = c(count_freq(HP_freq, '掛念'), count_freq(BG_freq, '掛念')))

    ## # A tibble: 2 x 5
    ##   看板   思念  想念  懷念  掛念
    ##   <chr> <dbl> <int> <int> <dbl>
    ## 1 政黑      0     3    21     0
    ## 2 男女     18    28    26     3
