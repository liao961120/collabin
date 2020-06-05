---
title: Git
subtitle: ''
tags: [lope]
date: '2020-03-27'
author: Jessy Chen
mysite: /jessy_chen/
comment: yes
---

# Git

在寫 code 的時候，學習 Git 大概是一件令人興奮又困惑的事情，一方面可以將不同版本的程式都保留下來，另一方面會覺得 Git 本身應該也算是另一種程式語言，擔心會不會用了 Git 什麼事都沒發生，檔案還不見 XDD

## Git 簡介
- Git 將不同版本（version）的內容以 commit 的方式紀錄，每個 commit 是專案（project）的快閃照（snapshot），而這些 commit 的集合就是專案的開發歷程紀錄。
- 即使再微小的更動，都可以藉由 commit 完成，同時開發專案與保持專案的上線。
- Git 的語法為`git <command> <—-flags> <arguments>`，開頭為`git`，接著帶出指令，並可能會加上`-`或`—-`來調整參數。

## 常用指令 
- `git status`：查看目前 Git 中每個檔案的狀態。是個強大的指令，因為每個步驟顯示的狀態訊息都不一樣，除了可以讓自己更清楚自己在幹嘛，有時候看這些訊息也滿有趣的（？），例如：新增檔案 `new file`、修改檔案 `modified`、刪除檔案 `deleted`、變更檔名 `renamed`等等，括號內的附加數字表示與原檔案的相似程度。
- `git add` 及 `git commit -m <commit_message>`：總是一起使用的感覺，前者讓 Git 知道哪些檔案要被託管，後者確認送出此次的檔案更動。`git add <file_name>/<folder_name>` 可選擇某些檔案或資料夾進行 commit，如果全部更動都要送出，可 `git add .`。在送出之前，檔案的狀態是 untracked，被 `git add` 後是 tracked/not yet committed，而 `git commit` 後才是 commited，且 `git status` 會回傳 `nothing to commit, working tree clean` 這個訊息，代表所有的更動都已處理。
- 因為無法 commit 空的資料夾，可新增一個`.keep`或`.gitkeep`來讓 Git 能夠感應到這個空的資料夾。完整的程式碼為`touch imgs/.keep`（其中的`imgs`代表資料夾名稱）。
- `git push`：將 `git commit` 後的資料送到遠端儲存庫。
- `git log`：查看 commit 的歷史紀錄，包括 commit message 和專屬的 commit ID/SHA 1。`git log —-graph —-oneline` 可將 commit 的歷史紀錄圖像化。
- `git clone`：首次下載遠端儲存庫。
- `git pull` 其實有兩個步驟，先是將資料從 remote repo 傳到 local repo，然後再進到 working directory。`git fetch` 只是將資料下載到 local repo 裡，並不會進到 working directory。

## 分支（branch）
- 分支（branch）其實可理解成 commit，只是多加了一個名稱或標籤。master 和 origin/master 其實就是兩個分支了，master 是 GitHub 的預設分支。
- `git branch`：查看目前有哪些分支，以及自己所在的分支為何。
- 如果在建立分支後，master 都沒有任何更動，就又和此分支合併，這樣的合併稱為 fast-forward（快轉）。
- `git branch —-set-upstream-to=origin/<branch_name> <branch_name>`：設定遠端分支，可以知道超前或落後遠端分支幾個 commit。
- `git revert <SHA1>`：以 commit 的方式回覆某個 SHA1 的 commit。
- `git checkout <SHA1> <file>`將某版本的檔案取出來，但 HEAD 仍會在當前的 commit 上。如果用`git status`查看的話，會發現有 `new file`。

### 參考資料
1. Git 軟體工程師必備的版本管理（Hahow 線上課程）
2.  [連猴子都能懂的Git入門指南](https://backlog.com/git-tutorial/tw/)
3.  [為你自己學Git](https://gitbook.tw/chapters/introduction/what-is-git.html)
