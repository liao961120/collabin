---
title: 'Crawling Instagram posts: using IG scrapper'
subtitle: ''
tags: [crawler, instagram, ig scrapper, LOPE]
date: '2020-03-20'
author: Yolanda Chen
mysite: /yolanda_chen/
comment: yes
---


# IG Scraper


```python
## Install IG scraper
```


```python
$ pip install instagram-scraper
```


```python
$ pip install instagram-scraper --upgrade
```

## Usage


```python
# To scrape a users media <yolayyc> (login in if private account)
```


```python
!instagram-scraper yolayyc
```

    Searching yolayyc for profile pic: 100% 1/1 [00:00<00:00, 1605.17 images/s]
    Searching yolayyc for posts: 282 media [00:28,  9.86 media/s]
    Downloading: 100%|##########| 283/283 [00:00<00:00, 59080.58it/s]



```python
# Specify media types to scrape. Enter as space separated values. 
# Valid values are image, video, story (story-image & story-video), or none. Stories require a --login-user and --login-pass to be defined.
```


```python
!instagram-scraper iakuhs -t image
```

    Searching iakuhs for profile pic: 100% 1/1 [00:00<00:00, 1503.33 images/s]
    Searching iakuhs for posts: 47 media [00:04, 10.46 media/s]
    Downloading: 100%|##########| 48/48 [00:06<00:00,  7.42it/s]



```python
# Saves the media metadata associated with the user's posts to <destination>/<username>.json.  
# Can be combined with --media-types none to only fetch the metadata without downloading the media.
```


```python
!instagram-scraper yolayyc --media-metadata
```

    Searching yolayyc for profile pic: 100% 1/1 [00:00<00:00, 1760.83 images/s]
    Searching yolayyc for posts: 282 media [00:30,  9.36 media/s]
    Downloading: 100%|##########| 283/283 [00:00<00:00, 78050.24it/s]



```python
# Saves the comment metadata associated with the posts to <destination>/<username>.json. 
# Can be combined with --media-types noneto only fetch the metadata without downloading the media.
```


```python
# !instagram-scraper jet___official --comments I
```


```python
# Saves the user profile metadata to  <destination>/<username>.json.
```


```python
!instagram-scraper yolayyc --profile-metadata
```

    Searching yolayyc for profile pic: 100% 1/1 [00:00<00:00, 1795.51 images/s]
    Searching yolayyc for posts: 282 media [00:27, 10.32 media/s]
    Downloading: 100%|##########| 283/283 [00:00<00:00, 76982.17it/s]



```python
# To scrape a hashtag for media with a maximum of 50 posts
```


```python
!Instagram-scraper love -m 50
```

    Searching love for profile pic: 100% 1/1 [00:00<00:00, 1360.46 images/s]
    Searching love for posts: 1 media [00:01,  1.31s/ media]
    Downloading: 100%|##########| 51/51 [00:00<00:00, 20407.32it/s]




```python
# Reference: IG Scrapper (https://github.com/rarcega/instagram-scraper)
```
