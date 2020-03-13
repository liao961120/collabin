---
title: CWB解讀：位置屬性編碼 (positional attribute encoding)
subtitle: ''
tags: [CWB, LOPE]
date: '2020-03-13'
author: Don
mysite: /don/
comment: yes
---

CWB (Corpus Workbench)是很多語料庫背後的後端系統，一個純文字的語料檔要經過下面幾個步驟之後，才有辦法使用 CQP 查詢。

- Step 1. 將語料整理成`.vrt`檔
- Step 2. Encoding (進行編碼): 使用`cwb-encode`指令將語料的`.vrt`檔編碼
- Step 3. Indexing (進行索引): 使用`cwb-make`指令將編碼好的語料進行Indexing
- Step 4. Compressing (進行壓縮): (非必要)
- Step 5. 語料庫建好了，可以開始用CQP查詢
  
平常只有當一個使用者來使用CWB。因為我很好奇CWB到底如何儲存這些語料檔，以及為什麼可以讓查詢結果那麼快，所以想試著去讀CWB的原始碼，看可不可以找出一些線索，順便練習讀code的能力。

# 我準備的實驗語料檔

我準備了一個簡單的語料檔如下 (取名為`corpus.vrt`)：

```
<s>
I   Np
go  Va
</s>
<s>
We  Np
go  Va
</s>
```

`.vrt`檔是CWB所規範的語料庫文字檔，他外圍的tag很像是XML檔，`.vrt`的特色在於，每一個word token一定要單獨放在一行。像上面這個檔案，包含了兩個句子(以`<s>...</s>`包起來，<>裡的文字可以自己定義)：

- I go.
- We go.

然後呢，每個word token放在屬於自己的一行。每一行呢，第一個column是word token，第二個column我放的是詞性標記，當然，如果你有其他屬於這個word token的標記，你可以繼續加第三個column。column和column之間請用`<TAB>`區隔。

在CWB的世界裡，像是`<s>...</s>`這樣的XML標記稱為 `structure attribute` (簡稱`s-attribute`)，而像是word token 和這個token的詞性標記這種屬性則稱為 `position attribute` (簡稱 `p-attribute`)。所以呢，在上面的語料中，我總共有一個`s-attribute`和兩個`p-attribute`(word和詞性標記)。

> - 詳細內容請參考CWB的官方說明文件：[CQP Query Language Tutorial](http://cwb.sourceforge.net/files/CQP_Tutorial.pdf) 當中的 1.2 The CWB corpus data model
> - 另一份文件 [Corpus Encoding Tutorial](http://cwb.sourceforge.net/files/CWB_Encoding_Tutorial.pdf) 中的 2. First step: encoding and indexing 也有很好的說明。

然後執行 `cwb-encode` 指令：
```bash
$ cwb-encode 
    -d <要放置編碼後的語料庫檔案位置>
    -f corpus.vrt (我上面的語料庫檔)    
    -R <要放置編碼後的語料庫檔案位置>
    -P pos    (指定除了.vrt第二個column，也就是第二個p-attribute叫做pos)
    -S s      (指定.vrt的 s-attribute 叫做 s)
    -c utf8   (指定編碼為 utf8)
    -DvxSB
```

執行成功後，會發現在我指定的資料夾中(剛剛用`-d`指定的資料夾)，新增了以下幾個檔案：

- [關於POS的]
    - `pos.corpus`
    - `pos.lexicon.idx`
    - `pos.lexicon`
- [關於WORD的]
    - `word.corpus`
    - `word.lexicon.idx`
    - `word.lexicon`
- [關於S的]
    - `s.rng`

至少在知道所謂的encoding到底做了什麼之前，我們可以知道這些檔案應該就是encoding的結果吧。我的目的是想知道，到底CWB把哪些訊息寫進這些檔案裡。


# 指令`cwb-encode`的原始碼就在 `utils/cwb-encode.c` 當中

> `utils/cwb-encode.c`請見http://svn.code.sf.net/p/cwb/code/cwb/trunk/utils/cwb-encode.c

在這個檔案的最前面，看起來初始化了很多全域變數。其中我看到一行註解：

> cwb-encode encodes S-attributes and P-attributes, so there is an object-type and global array representing each.

好，意思是`cwb-encode`指令是用來encode**Structure-屬性**和**Position-屬性**的，然後每種屬性都會以一個**object-type**和**global array**來表徵，但還是不知道要幹嘛。

但下面我們看到了`s_att_builder `objecct和`p_att_builder` object：

```c
/**
 * p_att_builder object: represents a P-attribute being encoded.
 */
typedef struct {
  char *name;                   /**< CWB name of the attribute */
  cl_lexhash lh;                /**< String hash object containing the lexicon for the encoded P attrbute */
  int position;                 /**< Byte index of the lexicon file in progress; contains total number of bytes
                                     written so far (== the beginning of the -next- string that is written) */
  int feature_set;              /**< Boolean: is this a feature set attribute? => validate and normalise format */
  FILE *lex_fd;                 /**< file handle of lexicon component */
  FILE *lexidx_fd;              /**< file handle of lexicon index component */
  FILE *corpus_fd;              /**< file handle of corpus component */
} p_att_builder;

/**
 * s_att_builder object: represents an S-attribute being encoded, and holds some
 * information about the currently-being-processed instance of that S-attribute.
 */
typedef struct s_att_builder {
  ...
} s_att_builder;
```

因為`s_att_builder`很長，所以先看比較單純的`p_att_builder`。扣掉三個`FILE`之外（也就是用來產生`[P].lexicon`, `[P].lexicon.idx`和`[P].corpus`檔的），就剩下:

- `char *name`: 這個P屬性的名稱
- `cl_lexhash lh`: 包含著編碼後的P屬性的lexicon的String hash object (我還不知道什麼是string hash object，目前我的猜測是給lexicon裡的每個成員一個hash值，用來快速存取？) (以POS這個P屬性來說，POS的lexicon就是所有的詞性的集合。)
- `int position`: 不斷紀錄lexicon file現在寫到了第幾個位元數的標記。
- `int feature_set`: 是否為feature set (`1` or `0`) 

## 進入主程式 `main()`
- 初始化變數 (這部分稍微掃過就好)
- parse命令列變數
- 初始化debug訊息 (不重要，可略過)
- 初始化 loop 變數
- MAIN LOOP: 開始一行一行處理輸入的`.vrt`語料檔 (重頭戲!)
  - 開始去輸入的檔案裡頭逐行檢查
  - 前半部：努力parse出XML tag的部分 -> 抓到後在丟入 s_attr_builder
  - 後半部：確定非XML tag的部分，即是p-attribute要處理的
    - 每行p-attribute的字串會丟進 `encode_add_p_attr_line()`

## 關鍵是`cwb-encode.c`中的函式`encode_add_p_attr_line()` 

這個函式對.vrt檔中每一行**非XML**的資料進行處理，也就是對每一行含有word token和POS標記的字串進行處理：

```C
/**
 * Processes a token data line.
 *
 * That is, it processes a line that is *not* an XML line.
 *
 * Note that this is destructive - the argument character
 * string will be changed *in situ* via an strtok-like mechanim.
 *
 * @param str  A string containing the line to process.
 */
void
encode_add_p_attr_line(char *str)
{
  /* (略) */
  
  id = cl_lexhash_id(p_encoder[fc].lh, token);
  if (id < 0) {
    /* new entry -> write LEXIDX & LEXICON files */
    NwriteInt(p_encoder[fc].position, p_encoder[fc].lexidx_fd);
    p_encoder[fc].position += strlen(token) + 1;
    if (p_encoder[fc].position < 0)
      encode_error("Maximum size of .lexicon file exceeded for %s attribute (> %d bytes)", p_encoder[fc].name, INT_MAX);
    if (EOF == fputs(token, p_encoder[fc].lex_fd)) {
      perror("fputs() write error");
      encode_error("Error writing .lexicon file for %s attribute.", p_encoder[fc].name);
    }
    if (EOF == putc('\0', p_encoder[fc].lex_fd)) {
      perror("putc() write error");
      encode_error("Error writing .lexicon file for %s attribute.", p_encoder[fc].name);
    }
    entry = cl_lexhash_add(p_encoder[fc].lh, token);
    id = entry->id;
    }

    /* (略) */
        
  /* 將 id 寫進 .corpus 檔 */
  NwriteInt(id, p_encoder[fc].corpus_fd);
}
```

因為我的目的是想知道，到底在encoding的過程中，CWB到底把哪些訊息寫進上面那幾個新生成的檔案(*.corpus, *.lexicon 和 *.lexicon.idx)中，因此我只要從上面這段程式碼找到「把某些東西寫進檔案」的function就好了。主要是這幾個：

- `NwriteInt(p_encoder[fc].position, p_encoder[fc].lexidx_fd);`
- `fputs(token, p_encoder[fc].lex_fd`
- `putc('\0', p_encoder[fc].lex_fd)`
- `NwriteInt(id, p_encoder[fc].corpus_fd)`

`lex_fd`指的是`*.lexicon檔`，`lexidx_fd`指的是`*.lexicon.idx`檔，`corpus_fd`指的是`*.corpus_fd`檔。所以目前可以看到的是，CWB寫進`*.lexicon.idx`和`*.corpus`的是整數型別的資料(`NwriteInt`)，而寫進`*.lexicon`檔的是字串型別(`fputs()`和`putc()`)的。

根據以下這一段：

```c
id = cl_lexhash_id(p_encoder[fc].lh, token);
if (id < 0) {
    /* new entry -> write LEXIDX & LEXICON files */
    /* 如果 id < 0 才要寫入 .lexicon 和 .lexicon.idx */
}
```

如果`id < 0`，則代表目前掃描到的token之前還沒有出現過，只有在這樣的情況下，才要把這個token寫進`*.lexicon`和`*.lexicon.idx`，所以說這兩個檔案紀錄的是所有不重複的token。

`*.lexicon`紀錄的是每個token（以byte表示），而token和token之間以`00`分隔。讓我們看一下用我上面`.vrt`跑出來的`word.lexicon`裡頭長什麼樣子：

```
4900 676f 0057 6500 
```

就短短一行8個bytes，如果先不看裡頭的`00`的話，`49` (這是位元的16進位表示法) 代表的是十進位的 73 (16 * 4 + 9)，而如果用python執行`chr(73)`的話，結果就是`I`這個詞。

我把上面幾個位元都用`chr()`跑一次，


```python
print(chr(int.from_bytes(b'\x49', byteorder='big')))
print("00")
print(chr(int.from_bytes(b'\x67', byteorder='big')))
print(chr(int.from_bytes(b'\x6f', byteorder='big')))
print("00")
print(chr(int.from_bytes(b'\x57', byteorder='big')))
print(chr(int.from_bytes(b'\x65', byteorder='big')))
```

    I
    00
    g
    o
    00
    W
    e


很明顯的`word.lexicon`紀錄的就是所有不重複的word token，是token經過utf-8編碼過後的位元檔，而且token之間以`00`分隔。

那麼`word.lexicon.idx`呢？我先把CWB產生給我的`word.lexicon.idx`檔打開給大家看：

```
0000 0000 0000 0002 0000 0005
```
按照上面的程式碼，有n個token，就會寫入`*.lexicon.idx`n次，既然剛剛的`*.lexicon`裡只有3個token，那麼我就可以也把`word.lexicon.idx`分成三個東西：`0000 0000`, `0000 0002`, `0000 0005`。從程式碼也已經知道寫進`*.lexicon.idx`的是position，但是是什麼東西的position呢？

答案就是：`0000 0000`代表的就是說第一個word token是從`word.lexicon`這個檔案第0個byte開始的（這是一定的吧？）。然後`0000 0002`紀錄的就是第二個word token是從`word.lexicon`這個檔案的第2個byte開始算起的，也就是`word.lexicon`檔案中`67`開始的地方(也就是字母g的位置)。

現在我們只剩下 `*.corpus` 檔案還沒解答。CWB產生給我的`*.corpus`內容長這樣：

```
0000 0000 0000 0001 0000 0002 0000 0001
```

也是一大堆位元，根據上面的程式碼，我們可以看到，每掃過一次token，無論與之前的重複與否，都會寫進`*.corpus`一次，所以我的語料檔有四個token(I, go, we, go)，所以照理說`*.corpus`也會有四個東西。那目前看起來就是`0000 0000`, `0000 0001`, `0000 0002`和`0000 0001`。程式碼說寫進`*.corpus`的是`id`，但是是什麼東西的id呢？我猜測應該就是說，語料庫裡第一個出現的word token是id為`0`的（也就是"I"）、第二個出現的word token是id為`1`的(也就是"go")...以此類推，因此語料庫裡最後一個出現的word token又是id為`1`的（又是"go"）。

呼，看了那麼久，結果encode出的東西也不過是這樣而已。上面說的是以word這個p-attribute來示範，pos的話應該也是一樣的道理。這篇只有講到`p-attribute`的encoding。從`word.corpus`可以看出，這邊的encoding並沒有把兩個語句分開，因為檔案看起來這兩個句子是連在一起的。所以我猜測區分句子的encoding應該是在這一篇沒有講到的`s-attribute` encoding當中，也就是CWB生成的`s.rng`檔案中。

那就下回待續啦。
