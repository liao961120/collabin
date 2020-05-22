---
title: '閩南語"有"字句'
subtitle: ''
tags: [lope]
date: '2020-05-22'
author: Mao-Chang Ku
mysite: /mao-chang/
comment: yes
output: md_document
isRmd: no
---

### MOE TSM sentences

    library(jiebaR)
    library(dplyr)
    library(readr)
    library(stringr)
    library(tidyverse)
    library(quanteda)
    library(tidytext)
    library(readxl)
    library(officer)
    library(flextable)

    lemma_tsm <- read_csv("詞目總檔.csv") %>% .$詞目
    writeLines(lemma_tsm, 'TSM_dict.txt')
    sentence_tsm <- read_csv("例句.csv") %>% 
      select(c(1, 5, 6, 7)) %>%
      rename(編號 = 例句編號, 標音 = 例句標音)

    sentence_tsm %>% head(10) %>% knitr::kable(align = 'c')

    sentence_tsm %>% nrow
    filter(sentence_tsm, str_detect(例句, '有')) %>% nrow

<table>
<thead>
<tr class="header">
<th style="text-align: center;">編號</th>
<th style="text-align: center;">例句</th>
<th style="text-align: center;">標音</th>
<th style="text-align: center;">華語翻譯</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">1</td>
<td style="text-align: center;">一蕊花</td>
<td style="text-align: center;">tsi̍t luí hue</td>
<td style="text-align: center;">一朵花</td>
</tr>
<tr class="even">
<td style="text-align: center;">2</td>
<td style="text-align: center;">紅嬰仔哭甲一身軀汗。</td>
<td style="text-align: center;">Âng-enn-á khàu kah tsi̍t sin-khu kuānn.</td>
<td style="text-align: center;">小嬰兒哭得滿身大汗。</td>
</tr>
<tr class="odd">
<td style="text-align: center;">3</td>
<td style="text-align: center;">一睏仔</td>
<td style="text-align: center;">tsi̍t-khùn-á</td>
<td style="text-align: center;">一下子</td>
</tr>
<tr class="even">
<td style="text-align: center;">4</td>
<td style="text-align: center;">一絲仔</td>
<td style="text-align: center;">tsi̍t-si-á</td>
<td style="text-align: center;">一點點</td>
</tr>
<tr class="odd">
<td style="text-align: center;">5</td>
<td style="text-align: center;">一流</td>
<td style="text-align: center;">it-liû</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">6</td>
<td style="text-align: center;">𪜶兩个生做一模一樣。</td>
<td style="text-align: center;">In nn̄g ê senn-tsò it-bôo-it-iūnn.</td>
<td style="text-align: center;">他們兩個長得一模一樣。</td>
</tr>
<tr class="odd">
<td style="text-align: center;">7</td>
<td style="text-align: center;">一生</td>
<td style="text-align: center;">it-sing</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">8</td>
<td style="text-align: center;">一向</td>
<td style="text-align: center;">it hiòng</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">9</td>
<td style="text-align: center;">𪜶兩个兄弟仔為著拚生理，就按呢一刀兩斷無來去。</td>
<td style="text-align: center;">In nn̄g ê hiann-tī-á uī-tio̍h piànn sing-lí, tō án-ne it-to-lióng-tuān bô lâi-khì.</td>
<td style="text-align: center;">他們兄弟倆為了拚生意，就這樣斷絕關係，不相往來。</td>
</tr>
<tr class="even">
<td style="text-align: center;">10</td>
<td style="text-align: center;">小等一下。</td>
<td style="text-align: center;">Sió-tán–tsi̍t-ē.</td>
<td style="text-align: center;">稍等一會兒。</td>
</tr>
</tbody>
</table>

    ## [1] 14980
    ## [1] 890

### TSM u

**+noun**  
(1) 厝內有人客。(existential)  
(2) 我有一本冊。(possessive)  
(3) 有人來矣。(presentational)

**+verb**  
(4) 我有食飯矣。(perfective) \[+telic, +bounded\]  
(5) 伊有食菸。(habitual) \[-telic, +bounded\]  
(6) 花有紅。(emphatic) \[-telic, -bounded\]

    # initilize `jiebar`
    tagger <- worker(type = "tag",
                     user = "TSM_dict.txt",
                     symbol = T,
                     bylines = F)

    segmenter <- worker(user = "TSM_dict.txt",
                        symbol = T,
                        bylines = F)

    # define own function
    tag_text <- function(x, jiebar){
      segment(x, jiebar) %>%
        paste(names(.), sep = "/", collapse = " ")
    }

    seg_text <- function(x, jiebar){
      segment(x, jiebar) %>%
        paste(collapse = " ")
    }

    sentence_tsm_tagged <- sentence_tsm %>%
      mutate(斷詞 = map_chr(例句, seg_text, segmenter),
               斷詞標記 = map_chr(例句, tag_text, tagger))

    tsm_u <- sentence_tsm_tagged %>%
      filter(str_detect(斷詞標記, '\\b有/')) 

    tsm_u %>% head(10) %>% knitr::kable(align = 'c')

    nrow(tsm_u)

<table>
<thead>
<tr class="header">
<th style="text-align: center;">編號</th>
<th style="text-align: center;">例句</th>
<th style="text-align: center;">標音</th>
<th style="text-align: center;">華語翻譯</th>
<th style="text-align: center;">斷詞</th>
<th style="text-align: center;">斷詞標記</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">135</td>
<td style="text-align: center;">對這件代誌伊閣有二步七仔！</td>
<td style="text-align: center;">Tuì tsit kiānn tāi-tsì i koh ū–jī-pōo-tshit-á!</td>
<td style="text-align: center;">對這件事情他還有點能耐！</td>
<td style="text-align: center;">對 這件 代誌 伊閣 有 二步 七仔 ！</td>
<td style="text-align: center;">對/p 這件/mq 代誌/x 伊閣/x 有/v 二步/m 七仔/x ！/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">182</td>
<td style="text-align: center;">伊真有人緣。</td>
<td style="text-align: center;">I tsin ū-lâng-iân.</td>
<td style="text-align: center;">他很有人緣。</td>
<td style="text-align: center;">伊真 有 人緣 。</td>
<td style="text-align: center;">伊真/x 有/v 人緣/n 。/x</td>
</tr>
<tr class="odd">
<td style="text-align: center;">186</td>
<td style="text-align: center;">這號物件都已經有矣，你閣欲買，加了錢的。</td>
<td style="text-align: center;">Tsit-lō mi̍h-kiānn to í-king ū–ah, lí koh beh bé, ke liáu-tsînn–ê.</td>
<td style="text-align: center;">這個東西已經有了，你還要買，多花錢而已。</td>
<td style="text-align: center;">這號 物件 都 已經 有 矣 ， 你 閣 欲 買 ， 加 了 錢 的 。</td>
<td style="text-align: center;">這號/x 物件/n 都/d 已經/d 有/v 矣/zg ，/x 你/r 閣/zg 欲/d 買/v ，/x 加/v 了/ul 錢/n 的/uj 。/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">222</td>
<td style="text-align: center;">這件代誌有也好，無也好，攏無要緊。</td>
<td style="text-align: center;">Tsit kiānn tāi-tsì ū iā hó, bô iā hó, lóng bô-iàu-kín.</td>
<td style="text-align: center;">這件事情可有可無，都沒關係。</td>
<td style="text-align: center;">這件 代誌 有 也好 ， 無 也好 ， 攏 無 要緊 。</td>
<td style="text-align: center;">這件/mq 代誌/x 有/v 也好/y ，/x 無/v 也好/y ，/x 攏/zg 無/v 要緊/v 。/x</td>
</tr>
<tr class="odd">
<td style="text-align: center;">246</td>
<td style="text-align: center;">伊的性地有影土。</td>
<td style="text-align: center;">I ê sìng-tē ū-iánn thóo.</td>
<td style="text-align: center;">他的個性非常土。</td>
<td style="text-align: center;">伊 的 性地 有 影土 。</td>
<td style="text-align: center;">伊/ns 的/uj 性地/n 有/v 影土/x 。/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">354</td>
<td style="text-align: center;">彼口井敢閣有咧上水？</td>
<td style="text-align: center;">Hit kháu tsénn kám koh ū teh tshiūnn-tsuí?</td>
<td style="text-align: center;">那口井還有人在取水嗎？</td>
<td style="text-align: center;">彼口 井敢 閣 有 咧 上水 ？</td>
<td style="text-align: center;">彼口/x 井敢/x 閣/zg 有/v 咧/v 上水/ns ？/x</td>
</tr>
<tr class="odd">
<td style="text-align: center;">365</td>
<td style="text-align: center;">這個月是小月，來阮店交關的人客有較少。</td>
<td style="text-align: center;">Tsit kò gue̍h sī sió-gue̍h, lâi guán tiàm kau-kuan ê lâng-kheh ū khah tsió.</td>
<td style="text-align: center;">這個月是生意淡季，來我們店裡捧場的人比較少。</td>
<td style="text-align: center;">這個 月 是 小 月 ， 來 阮店 交關 的 人客 有 較 少 。</td>
<td style="text-align: center;">這個/r 月/m 是/v 小/a 月/m ，/x 來/zg 阮店/x 交關/vn 的/uj 人客/x 有/v 較/zg 少/a 。/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">400</td>
<td style="text-align: center;">有也好，無也好。</td>
<td style="text-align: center;">Ū iā hó, bô iā hó.</td>
<td style="text-align: center;">有也好，沒有也好。</td>
<td style="text-align: center;">有 也好 ， 無 也好 。</td>
<td style="text-align: center;">有/v 也好/y ，/x 無/v 也好/y 。/x</td>
</tr>
<tr class="odd">
<td style="text-align: center;">401</td>
<td style="text-align: center;">生理人初二、十六攏有拜土地公。</td>
<td style="text-align: center;">Sing-lí-lâng tshe-jī, tsa̍p-la̍k lóng ū pài Thóo-tī-kong.</td>
<td style="text-align: center;">生意人初二、十六都拜土地公。</td>
<td style="text-align: center;">生理 人 初二 、 十六 攏 有 拜 土地公 。</td>
<td style="text-align: center;">生理/vn 人/n 初二/t 、/x 十六/m 攏/zg 有/v 拜/v 土地公/n 。/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">434</td>
<td style="text-align: center;">𪜶親情內底有一个大官虎，講話攏會硩死人。</td>
<td style="text-align: center;">In tshin-tsiânn lāi-té ū tsi̍t ê tuā-kuann-hóo, kóng-uē lóng ē teh-sí-lâng.</td>
<td style="text-align: center;">他的親戚裡頭有一個當大官的，說話都會將別人壓得死死的。</td>
<td style="text-align: center;">𪜶 親情 內底 有 一个 大官 虎 ， 講話 攏 會 硩 死 人 。</td>
<td style="text-align: center;">𪜶/x 親情/n 內底/x 有/v 一个/m 大官/n 虎/n ，/x 講話/n 攏/zg 會/v 硩/zg 死/v 人/n 。/x</td>
</tr>
</tbody>
</table>

    ## [1] 463

### contexts of TSM u

    corpus_tsm_u <- corpus(tsm_u,
                        docid_field = '編號',
                        text_field = '斷詞')

    kwic(corpus_tsm_u, '有') %>% 
      mutate(context = tsm_u$斷詞標記[match(docname, tsm_u$編號)]) %>%
      mutate(pinyin = tsm_u$標音[match(docname, tsm_u$編號)]) %>%
      select(-from, -to, -pattern) %>%
      head(50) %>% 
      knitr::kable(align = 'c')

<table>
<thead>
<tr class="header">
<th style="text-align: center;">docname</th>
<th style="text-align: center;">pre</th>
<th style="text-align: center;">keyword</th>
<th style="text-align: center;">post</th>
<th style="text-align: center;">context</th>
<th style="text-align: center;">pinyin</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">135</td>
<td style="text-align: center;">這件 代 誌 伊 閣</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">二步 七 仔 ！</td>
<td style="text-align: center;">對/p 這件/mq 代誌/x 伊閣/x 有/v 二步/m 七仔/x ！/x</td>
<td style="text-align: center;">Tuì tsit kiānn tāi-tsì i koh ū–jī-pōo-tshit-á!</td>
</tr>
<tr class="even">
<td style="text-align: center;">182</td>
<td style="text-align: center;">伊 真</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">人緣 。</td>
<td style="text-align: center;">伊真/x 有/v 人緣/n 。/x</td>
<td style="text-align: center;">I tsin ū-lâng-iân.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">186</td>
<td style="text-align: center;">這 號 物件 都 已經</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">矣 ， 你 閣 欲</td>
<td style="text-align: center;">這號/x 物件/n 都/d 已經/d 有/v 矣/zg ，/x 你/r 閣/zg 欲/d 買/v ，/x 加/v 了/ul 錢/n 的/uj 。/x</td>
<td style="text-align: center;">Tsit-lō mi̍h-kiānn to í-king ū–ah, lí koh beh bé, ke liáu-tsînn–ê.</td>
</tr>
<tr class="even">
<td style="text-align: center;">222</td>
<td style="text-align: center;">這件 代 誌</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">也好 ， 無 也好 ，</td>
<td style="text-align: center;">這件/mq 代誌/x 有/v 也好/y ，/x 無/v 也好/y ，/x 攏/zg 無/v 要緊/v 。/x</td>
<td style="text-align: center;">Tsit kiānn tāi-tsì ū iā hó, bô iā hó, lóng bô-iàu-kín.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">246</td>
<td style="text-align: center;">伊 的 性 地</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">影 土 。</td>
<td style="text-align: center;">伊/ns 的/uj 性地/n 有/v 影土/x 。/x</td>
<td style="text-align: center;">I ê sìng-tē ū-iánn thóo.</td>
</tr>
<tr class="even">
<td style="text-align: center;">354</td>
<td style="text-align: center;">彼 口 井 敢 閣</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">咧 上 水 ？</td>
<td style="text-align: center;">彼口/x 井敢/x 閣/zg 有/v 咧/v 上水/ns ？/x</td>
<td style="text-align: center;">Hit kháu tsénn kám koh ū teh tshiūnn-tsuí?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">365</td>
<td style="text-align: center;">交 關 的 人 客</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">較 少 。</td>
<td style="text-align: center;">這個/r 月/m 是/v 小/a 月/m ，/x 來/zg 阮店/x 交關/vn 的/uj 人客/x 有/v 較/zg 少/a 。/x</td>
<td style="text-align: center;">Tsit kò gue̍h sī sió-gue̍h, lâi guán tiàm kau-kuan ê lâng-kheh ū khah tsió.</td>
</tr>
<tr class="even">
<td style="text-align: center;">400</td>
<td style="text-align: center;"></td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">也好 ， 無 也好 。</td>
<td style="text-align: center;">有/v 也好/y ，/x 無/v 也好/y 。/x</td>
<td style="text-align: center;">Ū iā hó, bô iā hó.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">401</td>
<td style="text-align: center;">人 初二 、 十六 攏</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">拜 土地 公 。</td>
<td style="text-align: center;">生理/vn 人/n 初二/t 、/x 十六/m 攏/zg 有/v 拜/v 土地公/n 。/x</td>
<td style="text-align: center;">Sing-lí-lâng tshe-jī, tsa̍p-la̍k lóng ū pài Thóo-tī-kong.</td>
</tr>
<tr class="even">
<td style="text-align: center;">434</td>
<td style="text-align: center;">𪜶 親情 內 底</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一个 大 官 虎 ，</td>
<td style="text-align: center;">𪜶/x 親情/n 內底/x 有/v 一个/m 大官/n 虎/n ，/x 講話/n 攏/zg 會/v 硩/zg 死/v 人/n 。/x</td>
<td style="text-align: center;">In tshin-tsiânn lāi-té ū tsi̍t ê tuā-kuann-hóo, kóng-uē lóng ē teh-sí-lâng.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">436</td>
<td style="text-align: center;">拍 拚 ， 向 望</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一 工會 出頭天 。</td>
<td style="text-align: center;">伊下/x 性命/n 落去/v 拍/v 拚/zg ，/x 向望/x 有/v 一/m 工會/n 出頭天/i 。/x</td>
<td style="text-align: center;">I hē-sènn-miā lo̍h khì phah-piànn, ǹg-bāng ū tsi̍t kang ē tshut-thâu-thinn.</td>
</tr>
<tr class="even">
<td style="text-align: center;">443</td>
<td style="text-align: center;">你 若 是</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">啥 物 三長兩短 ， 欲</td>
<td style="text-align: center;">你/r 若/c 是/v 有/v 啥/r 物/zg 三長兩短/j ，/x 欲/d 叫/v 我/r 按/p 怎活/x 落去/v ？/x</td>
<td style="text-align: center;">Lí nā-sī ū siánn-mih sann-tn̂g-nn̄g-té, beh kiò guá án-tsuánn ua̍h–lo̍h-khì?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">461</td>
<td style="text-align: center;">伊 佇 彼 間 銀行</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一个 口座 。</td>
<td style="text-align: center;">伊/ns 佇彼間/x 銀行/n 有/v 一个/m 口座/x 。/x</td>
<td style="text-align: center;">I tī hit king gîn-hâng ū tsi̍t ê kháu-tsō.</td>
</tr>
<tr class="even">
<td style="text-align: center;">493</td>
<td style="text-align: center;">報告 講 今 仔 日</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">大 湧 ， 你 毋</td>
<td style="text-align: center;">氣象報告/n 講今/x 仔日/x 有/v 大湧/x ，/x 你/r 毋通/x 去/v 釣魚/n 。/x</td>
<td style="text-align: center;">Khì-siōng pò-kò kóng kin-á-ji̍t ū tuā-íng, lí m̄-thang khì tiò-hî.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">516</td>
<td style="text-align: center;">較 早</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">真 濟 山賊 佇 遮</td>
<td style="text-align: center;">較/zg 早/a 有/v 真濟/x 山賊/n 佇遮/x 出入/v 。/x</td>
<td style="text-align: center;">Khah-tsá ū tsin tsē suann-tsha̍t tī tsia tshut-ji̍p.</td>
</tr>
<tr class="even">
<td style="text-align: center;">519</td>
<td style="text-align: center;">我</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一雙 大 跤 胴 。</td>
<td style="text-align: center;">我/r 有/v 一雙/m 大跤/x 胴/n 。/x</td>
<td style="text-align: center;">Guá ū tsi̍t siang tuā-kha-tâng.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">521</td>
<td style="text-align: center;">你 真正</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">夠 低 路 ， 連</td>
<td style="text-align: center;">你/r 真正/d 有/v 夠低/a 路/n ，/x 連/nr 這款/r 工課/n 都袂曉做/x 。/x</td>
<td style="text-align: center;">Lí tsin-tsiànn ū-kàu kē-lōo, liân tsit khuán khang-khuè to bē-hiáu tsò.</td>
</tr>
<tr class="even">
<td style="text-align: center;">526</td>
<td style="text-align: center;">時 陣 ， 阮 兜</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">辦 桌 請 人 。</td>
<td style="text-align: center;">阮/nr 阿公/nr 七十歲/m 大壽/n 的/uj 時陣/x ，/x 阮兜/x 有/v 辦桌/x 請/zg 人/n 。/x</td>
<td style="text-align: center;">Guán a-kong tshit-tsa̍p huè tuā-siū ê sî-tsūn, guán tau ū pān-toh tshiánn–lâng.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">548</td>
<td style="text-align: center;"></td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">才 調 你 早就 考</td>
<td style="text-align: center;">有/v 才/d 調/v 你/r 早就/d 考牢矣/x ！/x</td>
<td style="text-align: center;">Ū tsâi-tiāu lí tsá tō khó-tiâu–ah!</td>
</tr>
<tr class="even">
<td style="text-align: center;">550</td>
<td style="text-align: center;">賣 的 價 數 是</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">較 貴 啦 。</td>
<td style="text-align: center;">小賣/x 的/uj 價數/x 是/v 有/v 較/zg 貴/a 啦/y 。/x</td>
<td style="text-align: center;">Sió-bē ê kè-siàu sī ū khah kuì–lah.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">677</td>
<td style="text-align: center;">伊 足</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">內 才 的 。</td>
<td style="text-align: center;">伊足/x 有/v 內/n 才/d 的/uj 。/x</td>
<td style="text-align: center;">I tsiok ū lāi-tsâi–ê.</td>
</tr>
<tr class="even">
<td style="text-align: center;">685</td>
<td style="text-align: center;">這 領 裙</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">幾 公 分 長 ？</td>
<td style="text-align: center;">這領/x 裙/n 有/v 幾公/x 分長/v ？/x</td>
<td style="text-align: center;">Tsit niá kûn ū kuí kong-hun tn̂g?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">736</td>
<td style="text-align: center;"></td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">穿 內 衫 加 較</td>
<td style="text-align: center;">有/v 穿/zg 內衫/x 加較/x 衛生/an 。/x</td>
<td style="text-align: center;">Ū tshīng lāi-sann ke khah uē-sing.</td>
</tr>
<tr class="even">
<td style="text-align: center;">740</td>
<td style="text-align: center;">囡 仔 人 嘛 看</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">。</td>
<td style="text-align: center;">這本/r 冊的/x 內容/n 真淺/x ，/x 囡/zg 仔人/x 嘛/y 看/v 有/v 。/x</td>
<td style="text-align: center;">Tsit pún tsheh ê luē-iông tsin tshián, gín-á-lâng mā khuànn-ū.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">747</td>
<td style="text-align: center;">門 邊 ， 我 攏</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">看 著 五彩 的 燈火</td>
<td style="text-align: center;">暗時/x 坐/v 佇窗/x 仔/zg 門邊/s ，/x 我攏/x 有/v 看/v 著/n 五彩/nz 的/uj 燈火/n 閃閃爍爍/z 。/x</td>
<td style="text-align: center;">Àm-sî tsē tī thang-á-mn̂g pinn, guá lóng ū khuànn-tio̍h ngóo-tshái ê ting-hué siám-siám-sih-sih.</td>
</tr>
<tr class="even">
<td style="text-align: center;">754</td>
<td style="text-align: center;">你 敢</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">食 中 晝 頓 ？</td>
<td style="text-align: center;">你/r 敢/v 有/v 食中/x 晝頓/x ？/x</td>
<td style="text-align: center;">Lí kám ū tsia̍h tiong-tàu-tǹg?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">780</td>
<td style="text-align: center;">你</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">啥 物 不滿 ， 做</td>
<td style="text-align: center;">你/r 有/v 啥/r 物/zg 不滿/a ，/x 做/v 你講/x 出來/v 。/x</td>
<td style="text-align: center;">Lí ū siánn-mih put-buán, tsò lí kóng–tshut-lâi.</td>
</tr>
<tr class="even">
<td style="text-align: center;">848</td>
<td style="text-align: center;"></td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">喙 無心</td>
<td style="text-align: center;">有/v 喙/zg 無心/v</td>
<td style="text-align: center;">ū-tshuì-bô-sim</td>
</tr>
<tr class="odd">
<td style="text-align: center;">858</td>
<td style="text-align: center;">咱 規 庄 頭 攏總</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">五百 戶 。</td>
<td style="text-align: center;">咱規/x 庄頭/x 攏總/v 有/v 五百戶/m 。/x</td>
<td style="text-align: center;">Lán kui tsng-thâu lóng-tsóng ū gōo-pah hōo.</td>
</tr>
<tr class="even">
<td style="text-align: center;">892</td>
<td style="text-align: center;">毋 是 佇 外 口</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">欠 人 錢 ？</td>
<td style="text-align: center;">你/r 是/v 毋/nr 是/v 佇外口/x 有/v 欠/v 人錢/x ？/x</td>
<td style="text-align: center;">Lí sī m̄ sī tī guā-kháu ū khiàm lâng tsînn?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">960</td>
<td style="text-align: center;">你</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">欠 用 就 來 共</td>
<td style="text-align: center;">你/r 有/v 欠/v 用/p 就/d 來/zg 共/d 我講/x ，/x 我會/n 當借/x 你/r 。/x</td>
<td style="text-align: center;">Lí ū khiàm-īng tō lâi kā guá kóng, guá ē-tàng tsioh–lí.</td>
</tr>
<tr class="even">
<td style="text-align: center;">961</td>
<td style="text-align: center;">遮 的 物件 你 若</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">欠 用 就 提 去</td>
<td style="text-align: center;">遮/v 的/uj 物件/n 你/r 若/c 有/v 欠/v 用/p 就/d 提去/v 。/x</td>
<td style="text-align: center;">Tsia ê mi̍h-kiānn lí nā ū khiàm-īng tō the̍h–khì.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">974</td>
<td style="text-align: center;">擺 戇 ， 路邊 哪有</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">應 公 。</td>
<td style="text-align: center;">少年/m 若無一/x 擺/v 戇/zg ，/x 路邊/s 哪有/x 有/v 應公/x 。/x</td>
<td style="text-align: center;">Siàu-liân nā bô tsi̍t pái gōng, lōo-pinn ná ū Iú-ìng-kong.</td>
</tr>
<tr class="even">
<td style="text-align: center;">1033</td>
<td style="text-align: center;">遐 敢 若</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一个 歹 物 ， 毋</td>
<td style="text-align: center;">遐敢/x 若/c 有/v 一个/m 歹物/x ，/x 毋/nr 通過/p 去/v 。/x</td>
<td style="text-align: center;">Hia kánn-ná ū tsi̍t ê pháinn-mi̍h, m̄-thang kuè–khì.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1044</td>
<td style="text-align: center;">拍 拚 ， 日後 才</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">出脫 。</td>
<td style="text-align: center;">你/r 著/n 好好/d 仔拍/x 拚/zg ，/x 日後/t 才/d 有/v 出脫/v 。/x</td>
<td style="text-align: center;">Lí tio̍h hó-hó-á phah-piànn, ji̍t-āu tsiah ū tshut-thuat.</td>
</tr>
<tr class="even">
<td style="text-align: center;">1060</td>
<td style="text-align: center;">漢文 這方面 的 學問 較</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">興趣 。</td>
<td style="text-align: center;">伊對/x 漢文/nz 這方面/mq 的/uj 學問/n 較/zg 有/v 興趣/n 。/x</td>
<td style="text-align: center;">I tuì hàn-bûn tsit hong-bīn ê ha̍k-būn khah ū hìng-tshù.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1077</td>
<td style="text-align: center;">伊 昨 昏 都</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">較 好 矣 ， 是</td>
<td style="text-align: center;">伊/ns 昨昏/x 都/d 有/v 較/zg 好/a 矣/zg ，/x 是/v 按/p 怎今/x 仔日閣/x 反症/x ？/x</td>
<td style="text-align: center;">I tsa-hng to ū khah hó–ah, sī-án-tsuánn kin-á-ji̍t koh huán-tsìng?</td>
</tr>
<tr class="even">
<td style="text-align: center;">1094</td>
<td style="text-align: center;">你 會</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">這 款 心理 ， 實在</td>
<td style="text-align: center;">你/r 會/v 有/v 這款/r 心理/n ，/x 實在/v 予人/x 想/v 袂/ng 到/v 。/x</td>
<td style="text-align: center;">Lí ē ū tsit khuán sim-lí, si̍t-tsāi hōo lâng siūnn bē kàu.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1122</td>
<td style="text-align: center;">各人</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">各人 的 心意 。</td>
<td style="text-align: center;">各人/r 有/v 各人/r 的/uj 心意/n 。/x</td>
<td style="text-align: center;">Kok-lâng ū kok-lâng ê sim-ì.</td>
</tr>
<tr class="even">
<td style="text-align: center;">1138</td>
<td style="text-align: center;">的 囡 仔 攏 真</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">出脫 。</td>
<td style="text-align: center;">雖然/c 𪜶/x 兜/v 真/d 散/v 赤/vg ，/x 毋過/x 𪜶/x 的/uj 囡/zg 仔/zg 攏/zg 真/d 有/v 出脫/v 。/x</td>
<td style="text-align: center;">Sui-jiân in tau tsin sàn-tshiah, m̄-koh in ê gín-á lóng tsin ū tshut-thuat.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1144</td>
<td style="text-align: center;">會 停電 ， 你 敢</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">攢 手 電 仔 ？</td>
<td style="text-align: center;">明仔/x 暗會/x 停電/v ，/x 你/r 敢/v 有/v 攢/zg 手電/n 仔/zg ？/x</td>
<td style="text-align: center;">Bîn-á-àm ē thîng-tiān, lí kám ū tshuân tshiú-tiān-á?</td>
</tr>
<tr class="even">
<td style="text-align: center;">1159</td>
<td style="text-align: center;"></td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">酒 矸 ， 通 賣</td>
<td style="text-align: center;">有/v 酒/n 矸/n ，/x 通賣/x 無/v ，/x 歹銅/x 舊錫簿/x 仔紙/x 通賣無/x ？/x</td>
<td style="text-align: center;">Ū tsiú-kan, thang bē–bô, pháinn-tâng-kū-siah phōo-á-tsuá thang bē–bô?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1163</td>
<td style="text-align: center;">今 仔 日</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一个 和尚 來 遮 化緣</td>
<td style="text-align: center;">今仔日/x 有/v 一个/m 和尚/nr 來/zg 遮/v 化緣/n 。/x</td>
<td style="text-align: center;">Kin-á-ji̍t ū tsi̍t ê huê-siūnn lâi tsia huà-iân.</td>
</tr>
<tr class="even">
<td style="text-align: center;">1174</td>
<td style="text-align: center;">个 醫生 的 手 頭</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">較 重 。</td>
<td style="text-align: center;">這个/x 醫生/n 的/uj 手頭/n 有/v 較/zg 重/a 。/x</td>
<td style="text-align: center;">Tsit ê i-sing ê tshiú-thâu ū khah tāng.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1233</td>
<td style="text-align: center;">个 牛 牢 內 底</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">幾隻 牛 犅 ？</td>
<td style="text-align: center;">這个/x 牛牢/x 內底/x 有/v 幾隻/m 牛/n 犅/x ？/x</td>
<td style="text-align: center;">Tsit ê gû-tiâu lāi-té ū kuí tsiah gû-káng?</td>
</tr>
<tr class="even">
<td style="text-align: center;">1315</td>
<td style="text-align: center;">今 仔 日 佇 西門町</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一陣 兄弟 咧 捙 拚</td>
<td style="text-align: center;">今仔日/x 佇/zg 西門町/ns 有/v 一陣/m 兄弟/n 咧/v 捙/x 拚/zg 。/x</td>
<td style="text-align: center;">Kin-á-ji̍t tī Se-mn̂g-ting ū tsi̍t tīn hiann-tī teh tshia-piànn.</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1333</td>
<td style="text-align: center;">你 對 這件 代 誌</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">啥 物 主張 ？</td>
<td style="text-align: center;">你/r 對/p 這件/mq 代誌/x 有/v 啥/r 物/zg 主張/n ？/x</td>
<td style="text-align: center;">Lí tuì tsit kiānn tāi-tsì ū siánn-mih tsú-tiunn?</td>
</tr>
<tr class="even">
<td style="text-align: center;">1342</td>
<td style="text-align: center;">你</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">啥 物 好 主意 無</td>
<td style="text-align: center;">你/r 有/v 啥/r 物好/x 主意/n 無/v ？/x</td>
<td style="text-align: center;">Lí ū siánn-mih hó tsú-ì–bô?</td>
</tr>
<tr class="odd">
<td style="text-align: center;">1353</td>
<td style="text-align: center;">彼 條 路 中央</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">一 凹 ， 你 著</td>
<td style="text-align: center;">彼條/x 路/n 中央/n 有/v 一/m 凹/a ，/x 你/r 著愛較/x 細膩/a 咧/v 。/x</td>
<td style="text-align: center;">Hit tiâu lōo tiong-ng ū tsi̍t nah, lí tio̍h ài khah sè-jī–leh.</td>
</tr>
<tr class="even">
<td style="text-align: center;">1454</td>
<td style="text-align: center;">所 講 的 佮 事實</td>
<td style="text-align: center;">有</td>
<td style="text-align: center;">真 大 的 出入 。</td>
<td style="text-align: center;">伊/ns 所講/c 的/uj 佮/zg 事實/n 有/v 真大/a 的/uj 出入/v 。/x</td>
<td style="text-align: center;">I sóo kóng–ê kah sū-si̍t ū tsin tuā ê tshut-ji̍p.</td>
</tr>
</tbody>
</table>

    # define chunk tokenization function
    tokenizer_chunks <- function(input){
      str_split(input, pattern = '(，/x)|(。/x)|(？/x)|(！/x)')
    }


    # convert text to pattern
    tsm_u %>%
      select(編號, 斷詞標記) %>%
      unnest_tokens(chunk, 斷詞標記,
                    token = tokenizer_chunks) %>% 
      filter(nzchar(chunk)) %>%
    # unnest_tokens(pattern, chunck,
    #                token = function(x) str_extract(x, '\\b有/v\\s(\\w+/[^n\\s]+\\s)*?\\w+/(a|v)')) %>%
      head(10) %>% 
      knitr::kable(align = 'c')

<table>
<thead>
<tr class="header">
<th style="text-align: center;">編號</th>
<th style="text-align: center;">chunk</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">135</td>
<td style="text-align: center;">對/p 這件/mq 代誌/x 伊閣/x 有/v 二步/m 七仔/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">182</td>
<td style="text-align: center;">伊真/x 有/v 人緣/n</td>
</tr>
<tr class="odd">
<td style="text-align: center;">186</td>
<td style="text-align: center;">這號/x 物件/n 都/d 已經/d 有/v 矣/zg</td>
</tr>
<tr class="even">
<td style="text-align: center;">186</td>
<td style="text-align: center;">你/r 閣/zg 欲/d 買/v</td>
</tr>
<tr class="odd">
<td style="text-align: center;">186</td>
<td style="text-align: center;">加/v 了/ul 錢/n 的/uj</td>
</tr>
<tr class="even">
<td style="text-align: center;">222</td>
<td style="text-align: center;">這件/mq 代誌/x 有/v 也好/y</td>
</tr>
<tr class="odd">
<td style="text-align: center;">222</td>
<td style="text-align: center;">無/v 也好/y</td>
</tr>
<tr class="even">
<td style="text-align: center;">222</td>
<td style="text-align: center;">攏/zg 無/v 要緊/v</td>
</tr>
<tr class="odd">
<td style="text-align: center;">246</td>
<td style="text-align: center;">伊/ns 的/uj 性地/n 有/v 影土/x</td>
</tr>
<tr class="even">
<td style="text-align: center;">354</td>
<td style="text-align: center;">彼口/x 井敢/x 閣/zg 有/v 咧/v 上水/ns</td>
</tr>
</tbody>
</table>

### write docx files

    doc <- read_docx()
    for (i in 1:nrow(tsm_u)) {
      doc %>%
        body_add_par(tsm_u[i,]$標音) %>%
        body_add_par(tsm_u[i,]$華語翻譯) %>%
        body_add_par('')
    }

    df <- qflextable(head(sentence_tsm))
    body_add_flextable(doc, df)

    print(doc, target = 'TSM_u.docx')

### References

鄭良偉. 1992. 台灣話和普通話的動相–時態系統. 中國境內語言暨語言學第一輯:
漢語方言, pp. 179–239.  
曹逢甫 & 鄭縈. 1995. 談閩南語 “有” 的五種用法及其間的關係. 中國語文研究,
11, 155-167.

Wu, J. S., & Zheng, Z. R. (2018, May). Toward a unified semantics for Ū
in Ū+ situation in Taiwan southern min: A modal-aspectual account. In
Workshop on Chinese Lexical Semantics (pp. 408-422). Springer, Cham.

<a href="https://davidgohel.github.io/officer/" class="uri">https://davidgohel.github.io/officer/</a>  
<a href="https://github.com/g0v/moedict-data-twblg" class="uri">https://github.com/g0v/moedict-data-twblg</a>
