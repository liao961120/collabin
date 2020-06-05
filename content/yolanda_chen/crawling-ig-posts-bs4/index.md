---
title: 'Crawling Instagram posts content & image: using python beautiful soup'
subtitle: ''
tags: [Crawler, instagram, beautifulsoup, LOPE]
date: '2020-03-27'
author: Yolanda Chen
mysite: /yolanda_chen/
comment: yes
---


# 方法：用美麗湯直接抓取所有用戶訊息


```python
from random import choice
import json
 
import requests
from bs4 import BeautifulSoup
 
_user_agents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36'
]
 
 
class InstagramScraper:
 
    def __init__(self, user_agents=None, proxy=None):
        self.user_agents = user_agents
        self.proxy = proxy
 
    def __random_agent(self):
        if self.user_agents and isinstance(self.user_agents, list):
            return choice(self.user_agents)
        return choice(_user_agents)
 
    def __request_url(self, url):
        try:
            response = requests.get(url, headers={'User-Agent': self.__random_agent()}, proxies={'http': self.proxy,
                                                                                                 'https': self.proxy})
            response.raise_for_status()
        except requests.HTTPError:
            raise requests.HTTPError('Received non 200 status code from Instagram')
        except requests.RequestException:
            raise requests.RequestException
        else:
            return response.text
 
    @staticmethod
    def extract_json_data(html):
        soup = BeautifulSoup(html, 'html.parser')
        body = soup.find('body')
        script_tag = body.find('script')
        raw_string = script_tag.text.strip().replace('window._sharedData =', '').replace(';', '')
        return json.loads(raw_string)
 
    def profile_page_metrics(self, profile_url):
        results = {}
        try:
            response = self.__request_url(profile_url)
            json_data = self.extract_json_data(response)
            metrics = json_data['entry_data']['ProfilePage'][0]['graphql']['user']
        except Exception as e:
            raise e
        else:
            for key, value in metrics.items():
                if key != 'edge_owner_to_timeline_media':
                    if value and isinstance(value, dict):
                        value = value['count']
                        results[key] = value
                    elif value:
                        results[key] = value
        return results
 
    def profile_page_recent_posts(self, profile_url):
        results = []
        try:
            response = self.__request_url(profile_url)
            json_data = self.extract_json_data(response)
            metrics = json_data['entry_data']['ProfilePage'][0]['graphql']['user']['edge_owner_to_timeline_media']["edges"]
        except Exception as e:
            raise e
        else:
            for node in metrics:
                node = node.get('node')
                if node and isinstance(node, dict):
                    results.append(node)
        return results
```


```python
from pprint import pprint
 
k = InstagramScraper()
results = k.profile_page_recent_posts('https://www.instagram.com/yolayyc/?hl=en') #hl=en/zh makes no difference.
pprint(results)
```

    [{'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: 1 person, tree, sky and outdoor',
      'comments_disabled': False,
      'dimensions': {'height': 809, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=ced8cbeda41bca550e955fa9c4da8084&oe=5EA85C26',
      'edge_liked_by': {'count': 66},
      'edge_media_preview_like': {'count': 66},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\n'
                                                            '過不去的、過得去的，都會過去的。\n'
                                                            '\n'
                                                            '希望這個多事的2020明朗化，一切雨過天晴。🌸'}}]},
      'edge_media_to_comment': {'count': 3},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2271180991376429248',
      'is_video': False,
      'location': {'has_public_page': True,
                   'id': '207823876223493',
                   'name': '大湖公園落羽松下',
                   'slug': ''},
      'media_preview': 'ACofoFwpGPzodgcc8e3vTDCAcn1/T8KcYmQc/Uf5/DpVOTZMYpKw4Pjg/pTWAyO/8xTQNvI78+v69Of1p5HAYYH059/wqb7X6FW3F+lKF4pY4WfhRz1Oan8hfQ1fN2uSo33t8xvl4yRznnFLhTyD7VUkYZAB69M5PtUKuBknkDrx/iazNNDVES7TJ1K/wgdeM8+nNV5ozFIS/wAokUHHoeMj8KiMvluB0PbAFX711lRZRkEdPY1PVfMfRldZVZy27A7e/qan3qefm/I1V8vA255XPGPfGc1D9oI45/M1ehF2f//Z',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B-E2xQTnJDA',
      'taken_at_timestamp': 1584965894,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1079.1079a/s150x150/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=3a002685b117e081431f916d62b241e3&oe=5EA827CE'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1079.1079a/s240x240/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=ecb512b2c5d67524c27d04837549d7c1&oe=5EA5CB88'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1079.1079a/s320x320/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=1271d7bdd6cda03ce210f80b5b2140df&oe=5EA6003E'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1079.1079a/s480x480/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=20353156f6a142c0414098f3bc99b227&oe=5EA776E8'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1079.1079a/s640x640/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=ef7ac27dd6abf5a5247187b338e16e4d&oe=5EA84207'}],
      'thumbnail_src': 'https://instagram.ftpe8-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1079.1079a/s640x640/90332869_266937764299464_2341524270997098682_n.jpg?_nc_ht=instagram.ftpe8-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=Id8EGwmTTxMAX8oF9qg&oh=ef7ac27dd6abf5a5247187b338e16e4d&oe=5EA84207'},
     {'__typename': 'GraphVideo',
      'accessibility_caption': None,
      'comments_disabled': False,
      'dimensions': {'height': 1138, 'width': 640},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=1e5d9944fdab423316a237234a5d29d9&oe=5E80440F',
      'edge_liked_by': {'count': 33},
      'edge_media_preview_like': {'count': 33},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '2019.12🌟\n'
                                                            '\n'
                                                            '動盪的生活裡，音樂依舊撫慰人心。\n'
                                                            '\n'
                                                            '世界越快，心則慢😌😌\n'
                                                            '\u200b \u200b\n'
                                                            '-\u200b 樂團成員👇👇\n'
                                                            '主唱：Yola, Jet\u200b \n'
                                                            '和聲：Jet\n'
                                                            '吉他：Jayson\u200b\n'
                                                            '貝斯：Bonnie\u200b\n'
                                                            '鋼琴：Don\u200b\n'
                                                            '鼓：阿哲\u200b\n'
                                                            '—\n'
                                                            '\u200b\n'
                                                            '#shallow #ladygaga '
                                                            '#bradleycooper #翻唱 '
                                                            '#cover #coversong '
                                                            '#singer #sing '
                                                            '#likeforlike'}}]},
      'edge_media_to_comment': {'count': 0},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'felix_profile_grid_crop': None,
      'gating_info': None,
      'id': '2269701106229491205',
      'is_video': True,
      'location': None,
      'media_preview': 'ABcqwijeh/WpDCNud3OOhDfl0xTRzUijBzVARNGUOD6A8HPXnH19aK0re3+1SAMTlicn1wM9KKm4yiODxSo+0k/xdvbnr9aWNC3Qbh7f5NO8xYEbuXAGPTnJ/wAKuztewizHMQRIrYfHPHP1oqGKIltgIZ/7oP8AXp+tFQUUoZChOOM0w5PJ5ptPbpSEIjENletFOh++PxopN2Gj/9k=',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B9_mSF3HrYF',
      'taken_at_timestamp': 1584790046,
      'thumbnail_resources': [{'config_height': 266,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p150x150/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=4db01799a811191511c01918b9c113a4&oe=5E7FD76A'},
                              {'config_height': 427,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p240x240/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=45f52e53b0e26b93e36bccc1daeaea5c&oe=5E80415D'},
                              {'config_height': 569,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p320x320/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=6a1e353698c70eb8b4d373c81f5b27d9&oe=5E802F25'},
                              {'config_height': 854,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p480x480/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=138b0ef4039f61973275fe147083c482&oe=5E7FBFF9'},
                              {'config_height': 1138,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=1e5d9944fdab423316a237234a5d29d9&oe=5E80440F'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.236.607.607a/90889416_303015017341542_355608617732477976_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=Ekk4wuNdHfoAX9PoC3p&oh=e8b72acb0450d370e08525634818e682&oe=5E7FA4CA',
      'video_view_count': 216},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: 1 person, smiling, closeup and '
                               'indoor',
      'comments_disabled': False,
      'dimensions': {'height': 1350, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=21231502a8436eb81ffac811c359533c&oe=5EA8849D',
      'edge_liked_by': {'count': 84},
      'edge_media_preview_like': {'count': 84},
      'edge_media_to_caption': {'edges': [{'node': {'text': '- Be a voice, not an '
                                                            'echo.\n'
                                                            '\n'
                                                            '#greyme'}}]},
      'edge_media_to_comment': {'count': 24},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2266868221701026370',
      'is_video': False,
      'location': {'has_public_page': True,
                   'id': '1980122735646305',
                   'name': '瑰秘',
                   'slug': ''},
      'media_preview': 'ACEqpPdPcHYOFzk0t2SuAOFXoRx15zVW2kCnmrbIXPHTvn+lZPR+RulzK/UkivSybQMyevbHr9angfIIJyRz+dZUi+Q4PY1dhcKwGeW4oaVroFe9n0L3FFJiisyjnUby3ye3WtETA4K8+n/16rXsQifaDk98etV4gQcg4rZrmVyItxfKWbxixA9KuWcqFPmwrDqT3/OoDBuHrVm3uWtkMYQMxOQfw9B1qN1ZFNNPmLe9fUfmKKrfbpv7q/8AfNFTYLlK8O9sMMN6+2elNt7dnG8AlQas6mPue+f51p2Y/cL9Kpu0VYEryZCYHjxuGAam8pYYmlf0+X1yen+fTNaE3MJz6Cs/VD+6Qe/9Km2tgcm18yj9tb+6KKzcmitORE8zP//Z',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B91iKMjHHJC',
      'taken_at_timestamp': 1584451771,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s150x150/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=fc66c05444e7bcb61bdb290c4741dda4&oe=5EA69FC5'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s240x240/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=6f19239ba07f87c79d14a4cb08019be1&oe=5EA6528F'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s320x320/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=16ca0dc40830584ddd695d3eaecd9972&oe=5EA6D035'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s480x480/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=8d097bc12fed53795afb07bcb9adbf5b&oe=5EA7646F'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=a2eeab8a3fb1f5532037f4b671143ed1&oe=5EA73F10'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/90332868_345648366367542_1683744821250353587_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=VNtxmPSJhCMAX9JEyD2&oh=a2eeab8a3fb1f5532037f4b671143ed1&oe=5EA73F10'},
     {'__typename': 'GraphVideo',
      'accessibility_caption': None,
      'comments_disabled': False,
      'dimensions': {'height': 1138, 'width': 640},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=c315b6b6534ed535e5e01ae970165f45&oe=5E7FDD0D',
      'edge_liked_by': {'count': 25},
      'edge_media_preview_like': {'count': 25},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '2019.12.27\u200b 🎄\n'
                                                            '\u200b\n'
                                                            '🔥🔥🔥🔥\u200b\n'
                                                            '2019聖誕節炸翻台大豪爽🤤🤤\n'
                                                            '謝謝所有來看的朋友們💋💋\n'
                                                            '\u200b\n'
                                                            '唱一首芭樂歌 #愛不需要裝乖\u200b\n'
                                                            '🔥🔥🔥🔥\u200b\n'
                                                            '\u200b\n'
                                                            '-\u200b 樂團成員👇👇\n'
                                                            '主唱：Yola, Jet\u200b \n'
                                                            '和聲：Bonnie, '
                                                            'Benjamin\u200b, Don\n'
                                                            '吉他：Jayson\u200b\n'
                                                            '貝斯：Bonnie\u200b\n'
                                                            '鋼琴：Don\u200b\n'
                                                            '鼓：阿哲\u200b\n'
                                                            '—\n'
                                                            '\u200b\n'
                                                            '#愛不需要裝乖 #王詩安 #謝和弦 #翻唱 '
                                                            '#翻唱系列 #唱歌 #cover '
                                                            '#coversong #singer '
                                                            '#sing '
                                                            '#likeforlike'}}]},
      'edge_media_to_comment': {'count': 3},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'felix_profile_grid_crop': None,
      'gating_info': None,
      'id': '2247277537495328374',
      'is_video': True,
      'location': None,
      'media_preview': 'ABcqyEqWdJG+dl4wBkLgenamqcnoPyqUEZBIyB26ZpDKhUj5SMHvkcj/AAorQjga5kwuNzZJz/jzmimBFFEWGQMj16c/XpSsADjIz7c/r/hQkmVKsSR2HUA8+nvimzIYsMejdPX8uo/GgCxbzeS3mKVLDgA5/PsPwz70VVjO5jgZ+nX/AD1ooEJFcFPmBAP5/pnA/Kq7uzksxzk5pr9aD0pFCxStCcr3oph7UUCP/9k=',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B8v7wOGH6Z2',
      'taken_at_timestamp': 1582116669,
      'thumbnail_resources': [{'config_height': 266,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p150x150/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=5571876f63fa3b2f5a11495c1c2066c6&oe=5E7FF65E'},
                              {'config_height': 427,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p240x240/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=f1ebb79c1ab56d2af5b67fcace08edde&oe=5E7FBB98'},
                              {'config_height': 569,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p320x320/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=da410502011962bbc8552e7bbf56e3de&oe=5E7FE06E'},
                              {'config_height': 854,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p480x480/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=24366a56fd779b4dfd7b406cfbe7962f&oe=5E802678'},
                              {'config_height': 1138,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=c315b6b6534ed535e5e01ae970165f45&oe=5E7FDD0D'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.236.607.607a/84876529_127595218620187_7734643664131168522_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=107&_nc_ohc=25mjyhwwkrkAX98D2Dm&oh=f119b5aad54bb2596826f6c9bf953754&oe=5E800873',
      'video_view_count': 345},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: 1 person, outdoor',
      'comments_disabled': False,
      'dimensions': {'height': 1349, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=6a82ef69f245b24959db11486aeb2617&oe=5EA82741',
      'edge_liked_by': {'count': 81},
      'edge_media_preview_like': {'count': 81},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\n'
                                                            '情人節花束💕\n'
                                                            '✨\n'
                                                            '每個人擁有不同魔法，屬性相剋卻可以深愛，這就是人矛盾卻美麗的地方。'}}]},
      'edge_media_to_comment': {'count': 6},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2246546873279984778',
      'is_video': False,
      'location': None,
      'media_preview': 'ACEqqBcYPrSMMA49af8AToKglYrkf5zSGJyRmlx/9emE5wCCOO4xmlyPcUAN49KKfu9h+VFICc+uKgmjdVVyPvt8vqcdcVfKcfhWxIqRxpuAJG1Rnrzxwe3PU0wRi3MDzbGPy84JY9CRwDgcAn9SKpvG0bFX4I4P+f5VsJJISY5E4HBznDfQjjj+fQiotQUebkdCoOe/cc0WtoN73MvFFWdgopCLbYx+FaU6NPAAvB+Uqfw7+3b9aynq9AxFuME9TQBUt1fzish4XBIGcHnvn9abdTebKT2Hyj04/wDr1ZhOWUnk81lDrine4PclzRRgUUgP/9k=',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B8tVnqBHjSK',
      'taken_at_timestamp': 1582029278,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.173.1385.1385a/s150x150/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=8504aef2a3d2258bc191026729b9bd74&oe=5EA8A3F2'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.173.1385.1385a/s240x240/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=8c9e60676b4876edf95f2345d88bbb68&oe=5EA84045'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.173.1385.1385a/s320x320/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=8f93e36be3c59826300785a31d54777f&oe=5EA634FD'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.173.1385.1385a/s480x480/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=f83ddde009231213a7d23c7ff7b4b5d3&oe=5EA5D821'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.173.1385.1385a/s640x640/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=9a04fc883609e17a64907360d408bb3b&oe=5EA5B196'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.173.1385.1385a/s640x640/85068770_142525286892990_786288558299970019_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=tHrAxwspie4AX9aMN2l&oh=9a04fc883609e17a64907360d408bb3b&oe=5EA5B196'},
     {'__typename': 'GraphVideo',
      'accessibility_caption': None,
      'comments_disabled': False,
      'dimensions': {'height': 1138, 'width': 640},
      'display_url': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=0717daf6a50a2e1f16b436c335572161&oe=5E7FDA87',
      'edge_liked_by': {'count': 29},
      'edge_media_preview_like': {'count': 29},
      'edge_media_to_caption': {'edges': [{'node': {'text': '- \u200b\n'
                                                            '2019.12👻\u200b\n'
                                                            '\u200b\n'
                                                            '睽違好幾年，這次勇敢地在舞台上演出我偶像GEM的歌《來自天堂的魔鬼》。\u200b\n'
                                                            '\u200b\n'
                                                            '我喜歡唱歌、喜歡這個舞台；\u200b\n'
                                                            '喜歡每次與樂手們融合，用自己的方式詮釋喜歡的音樂🎵\u200b\n'
                                                            '\u200b\n'
                                                            '這次不是唱給誰聽了，純粹喜歡，留下最後一年在台大的足跡👣\u200b\n'
                                                            '\u200b\n'
                                                            '\u200b - '
                                                            '樂團成員👇👇\u200b\n'
                                                            '主唱：Yola\n'
                                                            '和聲：Jet\n'
                                                            '吉他：Jayson\u200b\n'
                                                            '貝斯：Bonnie\u200b\n'
                                                            '鋼琴：Don\u200b\n'
                                                            '鼓：阿哲\u200b\n'
                                                            '—\u200b\n'
                                                            '\u200b\n'
                                                            '#cover #coversong '
                                                            '#coversongs #igcover '
                                                            '#song #songs '
                                                            '#songlyrics #sing '
                                                            '#singing #music '
                                                            '#musica #musica '
                                                            '#musicvideo '
                                                            '#musically #musician '
                                                            '#musicproducer '
                                                            '#musicvideos '
                                                            '#musicians #musical '
                                                            '#musicfestival '
                                                            '#musiccover '
                                                            '#coversong #coversong '
                                                            '#songcover #like4like '
                                                            '#likeforfollow '
                                                            '#likeforlike #gem'}}]},
      'edge_media_to_comment': {'count': 1},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'felix_profile_grid_crop': {'crop_bottom': 0.7839366516,
                                  'crop_left': 0.0,
                                  'crop_right': 1.0,
                                  'crop_top': 0.221719457},
      'gating_info': None,
      'id': '2242346499065103349',
      'is_video': True,
      'location': None,
      'media_preview': 'ABcqxDz6VKqu6bFTIBzkLz+fXHtVzUMfaHGB1H16CqoOOnH0psCtt7kUVefDgAdEGACSc88n2+lFFxkt3+8laT7oY9/ToDjr0xUC7SDnr2/P/CldgxB68DJ96mihBR5G5C5APpwT0/L86QDIsbskbgOo6Zz05HT+tFRZ3429GopDViqx3nrz+lWZ5mkHPJxgkcDjuQOM1RozQA5XKkHrjpRTKKdxH//Z',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B8eakKsHcP1',
      'taken_at_timestamp': 1581528858,
      'thumbnail_resources': [{'config_height': 266,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/p150x150/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=ff20000917ed9787e2e7cd80cce2b1d9&oe=5E801A58'},
                              {'config_height': 427,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/p240x240/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=1d0e48b6433e628d02cc58ecc64a4b4a&oe=5E7FB75E'},
                              {'config_height': 569,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/p320x320/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=7cc61f6c66b692e3891c6b08d5c6b541&oe=5E7FD528'},
                              {'config_height': 854,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/p480x480/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=06b71c0f781d52df5af7013388e17b7a&oe=5E7FF8BE'},
                              {'config_height': 1138,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=0717daf6a50a2e1f16b436c335572161&oe=5E7FDA87'}],
      'thumbnail_src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c0.236.607.607a/83999681_118931602893392_8693692523286490668_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=89wa5sxmh7oAX9MvxzG&oh=0c9bd0f031eac6d66d7b88ffa721e555&oe=5E7FE879',
      'video_view_count': 294},
     {'__typename': 'GraphSidecar',
      'accessibility_caption': 'Image may contain: 2 people, closeup',
      'comments_disabled': False,
      'dimensions': {'height': 1350, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=1f1e62699360b6b797fc2f430dfc3ae4&oe=5EA81C3E',
      'edge_liked_by': {'count': 87},
      'edge_media_preview_like': {'count': 87},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '「我很需要喝一杯，\u200b\n'
                                                            '或是大吃，\u200b\n'
                                                            '如果你有事也沒關係。」 \u200b\n'
                                                            '\u200b\n'
                                                            '總在我最低潮的時候出現，\u200b\n'
                                                            '在我最幸福時比誰都開心。 \u200b\n'
                                                            '\u200b\n'
                                                            '\u200b\n'
                                                            '「希望我們都幸福，我會陪著你。」🥰🥰'}}]},
      'edge_media_to_comment': {'count': 8},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2241648697859308343',
      'is_video': False,
      'location': None,
      'media_preview': None,
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B8b750rHvs3',
      'taken_at_timestamp': 1581445370,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s150x150/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=b595ab78f3cfd5f4a985a711c68f8834&oe=5EA855AA'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s240x240/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=31e21cea1352fa51f3caf946cb0c524a&oe=5EA7DCB0'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s320x320/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=729fffb83a1c8f2e181df6bd96355403&oe=5EA84A52'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c0.180.1440.1440a/s480x480/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=d1eb9999c2e4384bbdbc6369442b2761&oe=5EA7D397'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=2639fb033572bdcbafeca3b394e91a9f&oe=5EA6AD9A'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/84471939_2661185013951018_2703026499983408231_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=RQjLvCNCd7EAX_mWJn-&oh=2639fb033572bdcbafeca3b394e91a9f&oe=5EA6AD9A'},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: one or more people, people '
                               'standing and outdoor',
      'comments_disabled': False,
      'dimensions': {'height': 810, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=001917250924ce36aaecd920bd5e13d4&oe=5EA7F9EF',
      'edge_liked_by': {'count': 78},
      'edge_media_preview_like': {'count': 78},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\n'
                                                            '大年初二，跟各位拜個晚年🤪 🧧\n'
                                                            '🐭年行大運\n'
                                                            '🐭錢🐭不完\n'
                                                            '🐭不盡的幸福與快樂💕\n'
                                                            '#2020'}}]},
      'edge_media_to_comment': {'count': 5},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2229354029159227298',
      'is_video': False,
      'location': None,
      'media_preview': 'ACofwcZp7xNHjcCM8jPcVeNmY325DY54PUe3v7VK1pLIA3CKOBvYDHoP8jmp/IoyKfn5cHr2/OtuHRi3MjL9Aev4/wD66qrZy8qI88HAI/i3DjPHbk8+9F0Bk9a2StUjYTjkoQB1Pbjrz07Gr/nJUye1iolYudwYdR3p11KZAo447fT27/4VLcRFSOPlQAZ9+/v1qs2G+orXmu35haxIFLLu9evtQ7lkKdM4x25B/wAP51IGMJBPIP8A+vB9ev8Ak09QsoI4BOe3T6f/AK/wrSVrJNWYrdir8wXHUbs4z/SrHlR+p/Oq0qGI4b8CO/8An3qkZCTn19zUSilv+ALQ/9k=',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B7wQa2Knx-i',
      'taken_at_timestamp': 1579979731,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s150x150/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=721ad83cd20c8d54472bd39c91bd0364&oe=5EA7AD7F'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s240x240/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=d6f1de6406c5aab74fa77693218e8b8a&oe=5EA61679'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s320x320/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=790014666a7b55abe55b1d8cff16b568&oe=5EA5E207'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s480x480/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=863e61e8c5a4078fab5a6fd2b1d6fcbd&oe=5EA91B42'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1080.1080a/s640x640/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=c699c51110a156e1a187253e7119e568&oe=5EA5E64F'}],
      'thumbnail_src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1080.1080a/s640x640/82555082_1354032601450157_5578443281707496610_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=SMwlGJcwnpsAX_45I-Q&oh=c699c51110a156e1a187253e7119e568&oe=5EA5E64F'},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: one or more people and people '
                               'standing',
      'comments_disabled': False,
      'dimensions': {'height': 1278, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=38349dd4ec3dea33ee8ecf1a0279df0f&oe=5EA643A7',
      'edge_liked_by': {'count': 82},
      'edge_media_preview_like': {'count': 82},
      'edge_media_to_caption': {'edges': [{'node': {'text': '有一天，遇到艱鉅的難，你會從這樣的日子裡醒來，你會懂得什麼是無條件的愛，你會開始回頭細數這些磨耗，認知到日子的意義不在於看起來多精彩，有多少人簇擁。\n'
                                                            '而是什麼才是你想要的模樣。'}}]},
      'edge_media_to_comment': {'count': 0},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2222726204171990821',
      'is_video': False,
      'location': None,
      'media_preview': 'ACQq1JbwKOMKfqP/ANVNe6fGQcA9Dwffnt+mKxRbqckbTjpyfzHT+ta1/GPsw28Yx09xWdy7FRrp/wCKQ/hx/LFNW4U8ZyTxnv8A5FUo7cshdgQB3wcY789M57UsflbhsySDzn0PT8aVykjWkS4LsI1GwHA/Kir3zYB3MMgHhcj+R60VVjO5zjWc2RhTx19ua353VYA7YwgBx7gcD88fhXOGeRsGRmPfr09vStKXAsyQMFiCfxpFlo3CyRbGASPaAwHbPp9Dz9AaxPLZGOQBtOD+f6gjnNWWk3W5YZyzDd+QH6kfrVDcT9/JIGAfQD/PFNiX6nYQsTGpHoKKzbe7YRgDHHHOP8RRTRL3MZYmYgE5HbrjB/l/Q9a0Sn7vy35X8qsooGcAD8KR+hrFs6FFFPAELBQcFlH+fSofLzwef5/n/jQzEPtBwCMkdifXHr71ZFNvYaitfUbsIACMAMchhk5+oHSihjzRRzC9mj//2Q==',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B7YtbTIn7cl',
      'taken_at_timestamp': 1579189633,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c0.132.1440.1440a/s150x150/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=d5da1c9ca0700c91624030f0ae739a31&oe=5EA7BFB1'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c0.132.1440.1440a/s240x240/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=ca13178babfe987aa8369093c3396565&oe=5EA67A7B'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c0.132.1440.1440a/s320x320/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=7f85a62f248eec48ea15372d27b93d5c&oe=5EA8C5C1'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/c0.132.1440.1440a/s480x480/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=5b74a2f2ca29c78df9fcf672380cb2af&oe=5EA6021B'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.132.1440.1440a/s640x640/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=9865e8eb7e53ed71055b22c48be74bc9&oe=5EA7AAFC'}],
      'thumbnail_src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.132.1440.1440a/s640x640/81659425_135816754554056_6831034347854319043_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=108&_nc_ohc=Zk3QKoP3o90AX-GRAYn&oh=9865e8eb7e53ed71055b22c48be74bc9&oe=5EA7AAFC'},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: indoor',
      'comments_disabled': False,
      'dimensions': {'height': 1080, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=3a34f3974d47434a0e269814bf0463ed&oe=5EA70E45',
      'edge_liked_by': {'count': 85},
      'edge_media_preview_like': {'count': 85},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '當對一件事情有比別人更大的情緒時，不妨問問自己問什麼？\u200b\n'
                                                            '為什麼要處在「1或0」的價值觀？\u200b\n'
                                                            '為什麼要對這件事比別人更敏感？\u200b\n'
                                                            '-\u200b\n'
                                                            '\u200b\n'
                                                            '「小時候家是我的全部。\u200b\n'
                                                            '我沒有爸爸。\u200b\n'
                                                            '十幾年的生活裡，不曾存在男性角色，我沒有機會習得如何與男性相處。\u200b\n'
                                                            '加上所有的時間都與媽媽單獨相處，媽媽是我的所有。\u200b\n'
                                                            '\u200b\n'
                                                            '還小不懂事，常常假日早上起床時，媽媽突然消失、沒留下隻字片語，\u200b\n'
                                                            '我只能著急地一直哭，好像我的世界崩塌、一點不剩。\u200b\n'
                                                            '因為家裡空空蕩蕩的只有我一個人，也只會有我一個人。\u200b\n'
                                                            '\u200b\n'
                                                            '對於這種『全有全無的無能感』，一直延續到長大。\u200b\n'
                                                            '當發生爭執或不滿，非常在意的人突然消失，那種無能感又再次湧現，\u200b\n'
                                                            '感覺無能為力、什麼都不能做，\u200b\n'
                                                            '感覺心裡的鑰匙總是放在別人身上，解答在別人那，自己是被操控的那一個。\u200b\n'
                                                            '\u200b\n'
                                                            '長大後慢慢開始感知這個問題，於是我告訴自己，\u200b\n'
                                                            '不管發生什麼事，就算我氣頭上，也絕對不會在那個當下逕自離開。\u200b\n'
                                                            '要嘛直球對決，要嘛說好各自冷靜。\u200b\n'
                                                            '我絕不要以這種無預警的姿態消失！」\u200b\n'
                                                            '-\u200b\n'
                                                            '\u200b\n'
                                                            '可惜的是，別人不是你，面對這樣的狀況你有多恐慌，他們不明白。\u200b\n'
                                                            '本來因事件破掉的那個洞，不但無法被修補，更每況愈下。\u200b\n'
                                                            '\u200b\n'
                                                            '在成長期所經歷的一切，深深遠地影響了往後的思維和情感意識，\u200b\n'
                                                            '當愛人消失時感到的失落和不安全感再次飆高，像滾雪球一樣，越滾越大。\u200b\n'
                                                            '\u200b\n'
                                                            '這樣源自於家庭創傷帶來的敏感和焦慮，在外人看來也許愚蠢至極。\u200b\n'
                                                            '我們都聽過這些話：\u200b\n'
                                                            '「這有什麼好生氣？」\u200b\n'
                                                            '「這樣也要難過？太誇張了吧！」\u200b\n'
                                                            '「各自冷靜一下也不行？」\u200b\n'
                                                            '\u200b\n'
                                                            '在不知情的狀況下，真的不好去評斷別人的是非對錯。\u200b\n'
                                                            '你又不是他們，怎麼了解他們的過去經歷過什麼？又憑什麼說東說西？\u200b\n'
                                                            '\u200b\n'
                                                            '最好的方式是，當事關係中的一方好好了解他們另一半過去經歷的一切，\u200b\n'
                                                            '從「感知」到「理解（可能帶有情緒）」，慢慢去「同理」，最後可能「治癒」。\u200b\n'
                                                            '\u200b\n'
                                                            '每一步都漫長且艱辛，每一分的成長都得來不易，\u200b\n'
                                                            '得來不易的東西不容易失去，也讓人不願失去。\u200b\n'
                                                            '\u200b\n'
                                                            '“We tend to forget '
                                                            'that baby steps still '
                                                            'move you '
                                                            'forward.”'}}]},
      'edge_media_to_comment': {'count': 6},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2215381111265935969',
      'is_video': False,
      'location': None,
      'media_preview': 'ACoqq8+vPuBVYDLZ9hTzMx/hqEzMv8IrBRZvdFxT5Yz19Pc9hTy8ijJAYDqBnIqgLlyQcD5f8+tTfaX9Bz/n1pcrDmJnAYbl4zVchvU/kKj+0Og2gDH+feo/tL+35U1FofMupo/2Yf8AIH+NRS6eUUseAoyeB2/GtD+2of7jfmKqXuppPEY0UrkjJJHQc1epGhHbWEjRmQjIZTtHbI9fT2FNt7Rpy275SpGQAO496kttTEUQjIbK9MYwfY55HpkU2z1HypHklBbzOw9R0/TijUehMdKz3P5D/Gm/2T/tH8h/jVs61F2jb8xSf2zF/wA82/Mf4UtRXRztGaSlqyQxTuvI4NNNJQMfQMUyigD/2Q==',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B6-nWITHcJh',
      'taken_at_timestamp': 1578314030,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s150x150/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=4b7a6a7c8ccab08ab501aa4f4ef9db5a&oe=5EA91255'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s240x240/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=7fac5ac9c59d32845de65a13f3cc72ba&oe=5EA79C9F'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s320x320/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=862a11d6cad754c5c1f33b4f30712e19&oe=5EA549A5'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/e35/s480x480/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=9a4658047dbdd27d73c32e5ceee49327&oe=5EA61BFF'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=8db6118cdec64c0c95a992e534b459a1&oe=5EA70A74'}],
      'thumbnail_src': 'https://instagram.ftpe8-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/80710866_102601657885197_8235038684071749225_n.jpg?_nc_ht=instagram.ftpe8-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=J2o4NbMdokoAX8vsidJ&oh=8db6118cdec64c0c95a992e534b459a1&oe=5EA70A74'},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: one or more people, people on '
                               'stage, people playing musical instruments, concert '
                               'and night',
      'comments_disabled': False,
      'dimensions': {'height': 719, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=2bb252f4da9795820bc0446dc944ce22&oe=5EA8D1ED',
      'edge_liked_by': {'count': 89},
      'edge_media_preview_like': {'count': 89},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '「教書」依然是我很喜歡的事！\u200b\n'
                                                            '摒除追求知識的過程，把實用的知識分享出去是我更想做的。\u200b\n'
                                                            '\u200b\n'
                                                            '上台教學者隨時保持比台下興奮的狀態，比誰都清楚內容、比誰都要清楚掌控時間和流程；\u200b\n'
                                                            '還要應變「一打多」突發狀況，\u200b\n'
                                                            '這種興奮和刺激，對我來說跟主持/表演其實很相像。\u200b\n'
                                                            '\u200b\n'
                                                            '看到台下發亮的眼睛、投入的神情，\u200b\n'
                                                            '看到原本不想學、排斥英文的人因為我而有了所謂「動機」，是最大的幸福🥺\u200b\n'
                                                            '\u200b\n'
                                                            '謝謝進入台大巧妙的機緣、\u200b\n'
                                                            '謝謝讓我有機會在台大教學的老師和學長姐、\u200b\n'
                                                            '謝謝我可愛又頑皮的學生們這麼愛我，\u200b\n'
                                                            '2020還會好好操你們的☺️'}}]},
      'edge_media_to_comment': {'count': 7},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2210392485025214119',
      'is_video': False,
      'location': {'has_public_page': True,
                   'id': '5377607',
                   'name': '台灣大學',
                   'slug': ''},
      'media_preview': 'ACobaEFVL5cRfiK0cVR1AZiAHdh/I1u9irGMEJGQOKbV1UjMRXnevOR0P/6h3qoetYCYlFLRQI6QvgZrPvnLIAf739KsueBVK77fX+ldD2ZRXAG04PzHjA6AdTn1z/jUR+6B7mnR9/wph6f8CrAkbn0pM0tNoA//2Q==',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B6s5EEEHu6n',
      'taken_at_timestamp': 1577719339,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c222.0.888.888a/s150x150/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=3c55d1824b58ded3855dde802fd1b224&oe=5EA7CDA5'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c222.0.888.888a/s240x240/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=0e89b7a107916d27a676a10500ab9ff6&oe=5EA8996F'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c222.0.888.888a/s320x320/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=d5df1f1026b4432107725e8f9065eb85&oe=5EA5A255'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/e35/c222.0.888.888a/s480x480/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=d06f2ae2a4852377c334886a24459d68&oe=5EA6938F'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c222.0.888.888a/s640x640/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=7c5867702c6a69e31afee64c646b6c5c&oe=5EA66E4D'}],
      'thumbnail_src': 'https://instagram.ftpe8-3.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c222.0.888.888a/s640x640/79626793_488547568470047_1117799678695899794_n.jpg?_nc_ht=instagram.ftpe8-3.fna.fbcdn.net&_nc_cat=111&_nc_ohc=yWBCMhP41G8AX8GaAlD&oh=7c5867702c6a69e31afee64c646b6c5c&oe=5EA66E4D'},
     {'__typename': 'GraphImage',
      'accessibility_caption': 'Image may contain: one or more people and people '
                               'standing',
      'comments_disabled': False,
      'dimensions': {'height': 810, 'width': 1080},
      'display_url': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=da62b324ad2a05d3a209670c7c0bf923&oe=5EA84928',
      'edge_liked_by': {'count': 68},
      'edge_media_preview_like': {'count': 68},
      'edge_media_to_caption': {'edges': [{'node': {'text': '-\u200b\n'
                                                            '🥳今晚Lopop live '
                                                            'band炸翻台大啦！！🥳 \u200b\n'
                                                            '\u200b\n'
                                                            '一年前我提出瘋狂的想法：\u200b\n'
                                                            '既然我們都是lope實驗室的成員，不如組個loper專屬的樂團-lopop？\u200b\n'
                                                            '\u200b\n'
                                                            '感謝 '
                                                            'Don和Ben的加入、經紀人Jessica辛苦陪練，\u200b\n'
                                                            '還有蟹老闆的強力支持，組成最初的lopop!🌹 '
                                                            '\u200b\n'
                                                            '\u200b\n'
                                                            '也謝謝一年後的今天，Bonnie找來超強樂手Jayson, '
                                                            '皓庭和阿哲跟我們一起表演、練團🥰\u200b\n'
                                                            '每次都帶著滿滿的收穫回家，只有超爽，沒有之一！\u200b\n'
                                                            '\u200b\n'
                                                            '謝謝代打槍手Jet，以及今天所有來看我們的朋友Kim, '
                                                            'Albert, Scott, Terry, '
                                                            'Jeff，還有默默支持lopop的朋友們，謝謝你們🥺🥰 '
                                                            '\u200b\n'
                                                            '\u200b\n'
                                                            '\u200b\n'
                                                            '表演順利成功😎\u200b\n'
                                                            'Lopop明年見～❤️'}}]},
      'edge_media_to_comment': {'count': 6},
      'fact_check_information': None,
      'fact_check_overall_rating': None,
      'gating_info': None,
      'id': '2208310745523750325',
      'is_video': False,
      'location': {'has_public_page': True,
                   'id': '512297235625524',
                   'name': '後台Backstage Café',
                   'slug': 'backstage-cafe'},
      'media_preview': 'ACof0ZrWKQ/Mg/If0rlJYgsjKOAGIA9ga7KO4huCREwZsc4/nXPmEJK4IBVG3Envj+HPpzk89anYrcywoqRIi5wOT7VYzHGR/F157H8/bp17GpLa48hshRg9s/h1/GgCD7M46qab5LehrRW9ZlwVHy8ZHGaZ559B+f8A9alqPQj09ikjH/ZH/oQqOAtM7O5O1ic892Of8Afwp6bF79aRyFA8rJ9R6dMf59qAK8yrsRh95hyOw6dB24pI93y5GQCe3Y+v+eKso39/KkYIII7fShdg5JY9cgZH69aYK3Xt+I8Mnl4UES46YOPoew71UME55wf8/jV0TRD1Ufif59ajMooEf//Z',
      'owner': {'id': '604431755', 'username': 'yolayyc'},
      'shortcode': 'B6lfuxEnwW1',
      'taken_at_timestamp': 1577471176,
      'thumbnail_resources': [{'config_height': 150,
                               'config_width': 150,
                               'src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s150x150/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=7a8fb2f93bcd6ad91424cf6efda498e2&oe=5EA8E713'},
                              {'config_height': 240,
                               'config_width': 240,
                               'src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s240x240/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=be97906f935717403d4f50699218c299&oe=5EA5ABA8'},
                              {'config_height': 320,
                               'config_width': 320,
                               'src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s320x320/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=c104f4f4e8a755d338b5ec6c2e4a64b9&oe=5EA541A0'},
                              {'config_height': 480,
                               'config_width': 480,
                               'src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/e35/c180.0.1080.1080a/s480x480/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=58eaa683cac6f9ecc01d1b73ad5adb50&oe=5EA6A844'},
                              {'config_height': 640,
                               'config_width': 640,
                               'src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1080.1080a/s640x640/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=a06ea91eff25b921dd5b3e58243953c7&oe=5EA8F377'}],
      'thumbnail_src': 'https://instagram.ftpe8-4.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c180.0.1080.1080a/s640x640/76895531_165835134514600_802991950918923281_n.jpg?_nc_ht=instagram.ftpe8-4.fna.fbcdn.net&_nc_cat=104&_nc_ohc=PzcvsJYqYpcAX-ZQOMy&oh=a06ea91eff25b921dd5b3e58243953c7&oe=5EA8F377'}]



```python
# Goal: 我的論文資料目標為抓取IG公開帳戶的貼文文案以及圖片，做符號學分類。

# Murmur: 因為今年三月二十之前（沒錯，就是幾天前），IG API被關閉了（IG API可以抓取貼文文案），改成Graph API（只能抓到貼文圖片）。
# 因此，原先我打算硬來，用selenium模擬器抓文案，之後順便可以做instaBOT（有時間的話）。
# 但是使用selenium一直不成功，最後才用python美麗湯試成功了！資料形式也算漂亮整齊。

# 驚喜之處在於，ig竟自動加上一條metadata——accessibility_caption：針對圖片的自動辨識；
# 如第一張圖的caption是"Image may contain: 1 person, tree, sky and outdoor"，也許可以為之後做圖文intergration的研究者鋪路。
# 歡迎有興趣者，直接run這個code，很簡單喔:p
```
