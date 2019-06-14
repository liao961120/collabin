---
title: Crawling TED Talks
subtitle: ''
tags: [nlp, crawling, python, ted, talks, LOPE]
date: '2019-05-31'
author: Richard Lian
mysite: /richl/
comment: yes
---


After gathering subtitles from the OpenSubtitles parallel corpora, I've set my sights on the translations that are available for most TED talks. According to the [official website](https://ted.com), TED is a nonprofit organization devoted to spreading ideas.

The transcriptions are ideal for a parallel corpus because the translation process is supervised and quality is ensured through the use of a style guide and reviewers who are experienced and check on the quality of a translation. 

Instead of crawling directly from the official website, I will use the [TCSE: Ted Corpus Search Engine](https://yohasebe.com/tcse/) because the transcriptions are already organized with helpful metadata, such as timestamps. Furthermore, the website provides a helpful option to combine subtitles into sentences, which is based on the English timestamps. If lines in an English transcription are combined, then the corresponding timestamps in another language will be used to combine transcriptions. I think.

Below is my code for crawling the transcriptions.


```python
from time import sleep

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import UnexpectedAlertPresentException
```

The code below is used to find videos that have either traditional or simplified Chinese subtitles.


```python
opts = Options()
opts.add_argument("user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36")

driver = webdriver.Chrome('./chromedriver', chrome_options=opts)
driver.get('https://yohasebe.com/tcse/')

# Select language (4 for simplified, 5 for traditional)
driver.find_element_by_xpath('''//*[@id="trans_selector"]/option[4]''').click()

# Use Expanded Segments (combines subtitles into a complete sentence)
driver.find_element_by_xpath('''//*[@id="expanded"]''').click()

# List all available talks
driver.find_element_by_xpath('''//*[@id="list_all"]''').click()
sleep(2)

talk_ids = []
# These 'tbuttons' are to go to the next page of results.
tbuttons = [f"tbutton-{i}" for i in range(1, 13)]

for tbutton in tbuttons:
    driver.find_element_by_css_selector(f"#{tbutton}").click()
    sleep(2)
    talk_id_spans = driver.find_elements_by_css_selector(".talk_id")
    for talk in talk_id_spans:
        _id = talk.get_attribute("talk_id")
        talk_ids.append(_id)
```

This next block is to get the actual transcriptions for a TED talk. Traditional and simplified will each have their own folders containing transcriptions. Each file name is the ID that a video is assigned. These will eventually be combined into corresponding traditional-simplified pairs.


```python
def get_ted_trans(lang, vid_ids):
    
    if lang == 'tm':
        BASE_URL = "https://yohasebe.com/tcse/v/medium/{}/sentence/1/4/1.00/f/f/14/100/yt"
        translation_selector = "td.sec_tr.lcode_zh-tw > span"
        output_path = Path("./ted_tm_trans")
    elif lang == 'mm':
        BASE_URL = "https://yohasebe.com/tcse/v/medium/{}/sentence/1/3/1.00/f/f/14/100/yt"
        translation_selector = "td.sec_tr.lcode_zh-cn > span"
        output_path = Path("./ted_mm_trans")
    else:
        raise ValueError("No such choice.")
    
    opts = Options()
    opts.add_argument("user-agent=mozilla/5.0 (x11; linux x86_64) applewebkit/537.36 (khtml, like gecko) chrome/74.0.3729.169 safari/537.36")
    transcriptions = []
    driver = webdriver.Chrome('./chromedriver', chrome_options=opts)
    
    for idx, vid_id in enumerate(vid_ids, 1):
        output_file = output_path.joinpath(f"{vid_id}.pkl")
        if output_file.exists():
            continue
        driver.get(BASE_URL.format(vid_id))
        sleep(3)
        
        while True:
            try:
                segline = driver.find_elements_by_css_selector(".segline")
            except UnexpectedAlertPresentException:
                driver.switch_to.alert.accept()
                sleep(3)
            else:
                break
                
        for line in segline:
            order = line.find_element_by_css_selector(".seq").text
            timestamp = line.find_element_by_css_selector(".time").text
            milliseconds = line.find_element_by_css_selector(".sec").get_attribute("millisec")
            english = line.find_element_by_css_selector(".sec span.en strong").text
            translation = line.find_element_by_css_selector(translation_selector).text
            transcriptions.append({
                'vid_id': vid_id,
                'order': order,
                'timestamp': timestamp,
                'milliseconds': milliseconds,
                'english': english,
                'translation': translation
            })
            
        with output_file.open('wb') as f:
            pickle.dump(transcriptions, f)
            
        if idx % 100 == 0:
            print(f"Completed {idx} of {len(vid_ids)}")
            
    driver.close()
```
