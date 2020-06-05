---
title: Memes(I)
subtitle: ''
tags: [lope]
date: '2020-03-19'
author: Jessica
mysite: /jessica/
comment: yes
---


## Instagram Scraper

instagram-scraper 是用python 寫的command line 程式，可以用來抓取instagram用戶的照片或是影片。直接在terminal上執行下列指令即可下載照片或影片。

### 安裝 instagram-scraper:
$ pip install instagram-scraper

> 下面是我有試過的用法，更多用法可以參考它的[github](https://github.com/rarcega/instagram-scraper)

## 1. 基本用法：

### 爬某個用戶的所有圖片/影片：
- 有登入的方式，私人/公開用戶都可以爬
   




    $ instagram-scraper <username> -u <your username> -p <your password>

- 不想登入的方式，但只能爬公開用戶
   

    $ instagram-scraper <username>

- 爬多個公開用戶

    $ instagram-scraper username1,username2,username3

### 爬某個hashtag下的所有圖片/影片：
    $ instagram-scraper <hashtag without #> --tag

## 2. 特別用法：

### 限制爬的篇數
    --maximum     -m
- 範例：＃迷因梗圖這個hashtag下的其中500個
    

    $ instagram-scraper 迷因梗圖 --tag  -m  500

### 限制爬的媒體種類（image, video, story)
    --media-types -t
- 範例：jc0615meme這個用戶下的所有圖片
    

    $ instagram-scraper jc0615meme -t image

*****

## 3. 下載檔案

爬好的檔案最後會出現在你工作路徑下，便大功告成！

    <current working directory>/<username>
