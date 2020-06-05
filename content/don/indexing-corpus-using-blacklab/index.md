---
title: 使用BlackLab建立語料庫
subtitle: ''
tags: ["語料庫", LOPE]
date: '2020-04-17'
author: Don
mysite: /don/
comment: yes
---


在尋找適合查詢PTT語料庫的系統時，查到了由[Dutch Language Institute (INT)](https://ivdnt.org/)所開發的[BlackLab](https://inl.github.io/BlackLab/)。這個語料庫系統由Java寫成，並建在Apache Lucene的基礎之上。Apache Lucene同時也是現在很多人在用的全文搜尋系統Elasticsearch的底層架構。

之前阿吉學長曾經把PTT建在Elasticsearch裡頭，但那個時候一直不知道怎麼讓Elasticsearch也能做類似CQL (Corpus Query Language)的搜尋。而BlackLab的一大賣點就是他可以做到這一點。

從BlackLab的GitHub可以看到，最早一版的V.1.0.0 release是在2014年，而我現在所使用的V.2.0.0則是今年一月才發布的。於是想要來玩玩看試試看。但過程中遇到了一些困難，因為自己沒寫過什麼Java，所以在按照BlackLab網站的說明流程時卡關了很久，後來終於解決了，想把這個過程記錄下來當作備忘。

以下Step 1 - Step 6 是按照官方網站的[Getting start](https://inl.github.io/BlackLab/getting-started.html)的操作流程，再加上我自己在過程中的註解。

# Step 1: 確認自己的電腦上有Java的JDK和JRE

## JVM, JRE, JDK

Java是一個很大的生態系，光是在安裝Java的過程中，就被一大堆專有名詞給纏住。Java的生態系大致有以下這三種不可或缺的東西：
- JVM (Java Virtual Machine)
- JRE (Java Runtime Environment)
- JDK (Java Developer Kit)

詳細內容請分別參考這個部落格：
- [為什麼需要JVM?](https://openhome.cc/Gossip/JavaEssence/WhyJVM.html)
- [什麼是JRE?](https://openhome.cc/Gossip/JavaEssence/WhatJRE.html)
- [來安裝JDK](https://openhome.cc/Gossip/JavaEssence/InstallJDK.html)

或者:
- [GeeksforGeeks: Differences between JDK, JRE and JVM](https://www.geeksforgeeks.org/differences-jdk-jre-jvm/)

## JAR, WAR
JAR和WAR是用來將Java寫好的code打包在一起的東西。



# Step 2: 下載 BlackLab

到[官方的Github release頁面](https://github.com/INL/BlackLab/releases/)下載`blacklab-server-2.0.0.war`

然後解開.war檔：
```
$ java -xvf blacklab-server-2.0.0.war
```

應該會出現 `WEB-INF` 和 `META-INF` 這兩個資料夾。

接著進去 `WEB-INF` 這個資料夾：
```bash
$ cd WEB-INF
```

然後執行以下指令，正確的話應該會跳出這個指令要求的一些參數：

```bash
$ java -cp "lib/*" nl.inl.blacklab.tools.IndexTool
```

會顯示：
```bash
Usage:
  IndexTool {add|create} [options] <indexdir> <inputdir> <format>
  IndexTool delete <indexdir> <filterQuery>

Options:
  --maxdocs <n>          Stop after indexing <n> documents
  --linked-file-dir <d>  Look in directory <d> for linked (e.g. metadata) files
  --nothreads            Disable multithreaded indexing (enabled by default)

Deprecated options (not needed anymore with .yaml format configs):
  --indexparam <file>    Read properties file with parameters for DocIndexer
                         (NOTE: even without this option, if the current
                         directory, the input or index directory (or its parent)
                         contain a file named indexer.properties, these are passed
                         to the indexer)
  ---<name> <value>      Pass parameter to DocIndexer class
  ---meta-<name> <value> Add an extra metadata field to documents indexed.
                         You can also add a property named meta-<name> to your
                         indexer.properties file. This field is stored untokenized.
```

所以要進行Indexing最主要要執行的就是：
```
IndexTool create [options] <indexdir> <inputdir> <format>
```

需要給的參數：
- `indexdir`: indexing後的檔案要存放在哪個資料夾
- `inputdir`: 準備要進行indexing的語料原始檔在哪個資料夾
- `format`: 你的語料原始檔是什麼格式

關於format的參數，Blacklab支援很多種語料格式：(取自 [官網文件](https://inl.github.io/BlackLab/indexing-with-blacklab.html) 中的 Supported formats 一節)
- `tei` (Text Encoding Initiative, a popular XML format for linguistic resources, including corpora. indexes content inside the ‘body’ element; assumes part of speech is found in an attribute called ‘type’)
- `sketch-wpl` (the TSV/XML hybrid input format the Sketch Engine/CWB use)
- `chat` (Codes for the Human Analysis of Transcripts, the format used by the CHILDES project)
- `folia` (a corpus XML format popular in the Netherlands)
- `tsv-frog` (tab-separated file as produced by the Frog annotation tool)
- `csv`
- `tsv`
- `txt`
- `pagexml` (OCR XML format)
- `alto` (an OCR XML format)
- `whitelab2` (FoLiA format, but specifically tailored for the WhiteLab2 search frontend)
- `sketchxml` (files converted from the Sketch Engine’s tab-separated format to be “true XML”, so each token corresponds to a ‘w’ tag)
- `di-tei-element-text` (a variant of TEI where content inside the ‘text’ element is indexed)
- `di-tei-pos-function` (a variant of TEI where part of speech is in an attribute called ‘function’)

因為每個人手上的語料需要的標記不同，所以Blacklab也提供了可以自定義欄位的方式，讓indexing的方式更能符合自己的需求。（請參考[官網的How to configure indexing](https://inl.github.io/BlackLab/how-to-configure-indexing.html)）


# Step 3: 準備好語料

以下是官方提供的荷蘭文範例語料，為TEI格式。
把這個存成文字檔，並放在一個資料夾裡面（假設是 `~/data/corpus` ），這個資料夾的路徑待會會用到。

```xml
<TEI.2>
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>Content of file grpea_0190 (converted to TEI P4
                    format)</title>
            </titleStmt>
            <publicationStmt>
                <p />
            </publicationStmt>
            <sourceDesc>
                <p>grpea 0190</p>
                <listBibl id="inlMetadata">
                    <bibl>
                        <interpGrp type="date.publication">
                            <interp value="1990-01" />
                        </interpGrp>
                        <interpGrp type="idno">
                            <interp value="5mwc.grpea_0190" />
                        </interpGrp>
                        <interpGrp type="article.class">
                            <interp
                                value="default-corpuscomponent.milieu" />
                        </interpGrp>
                        <interpGrp type="corpus.provenance">
                            <interp
                                value="INL-vijfmiljoenwoordencorpus" />
                        </interpGrp>
                        <interpGrp type="properties">
                            <interp value="medium=tijdschrift" />
                        </interpGrp>
                    </bibl>
                </listBibl>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
            <ab>
                <lb />
                <s>
                    <w lemma="het"
                        type="VNW(pers,pron,stan,red,3,ev,onz)"
                        xml:id="w.4502">Het</w>
                    <w lemma="zien" type="WW(pv,tgw,met-t)"
                        xml:id="w.4503">ziet</w>
                    <w lemma="ernaar" type="BW()" xml:id="w.4504">ernaar</w>
                    <w lemma="uit" type="VZ(fin)" xml:id="w.4505">uit</w>
                    <w lemma="dat" type="VG(onder)" xml:id="w.4506">dat</w>
                    <w lemma="Frankrijk"
                        type="N(eigen,ev,basis,onz,stan)"
                        xml:id="w.4507">Frankrijk</w>
                    <pc type="SPEC(afgebr)" xml:id="pc.000607">,</pc>
                    <w lemma="België"
                        type="N(eigen,ev,basis,onz,stan)"
                        xml:id="w.4508">België</w>
                    <w lemma="en" type="VG(neven)" xml:id="w.4509">en</w>
                    <w lemma="Nederland"
                        type="N(eigen,ev,basis,onz,stan)"
                        xml:id="w.4510">Nederland</w>
                    <w lemma="niet" type="BW()" xml:id="w.4511">niet</w>
                    <w lemma="in" type="VZ(init)" xml:id="w.4512">in</w>
                    <lb />
                    <w lemma="staat"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4513">staat</w>
                    <w lemma="zijn" type="WW(pv,tgw,mv)"
                        xml:id="w.4514">zijn</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4515">de</w>
                    <w lemma="enorm"
                        type="ADJ(prenom,basis,met-e,stan)"
                        xml:id="w.4516">enorme</w>
                    <w lemma="milieuprobleem" type="N(soort,mv,basis)"
                        xml:id="w.4517">milieuproblemen</w>
                    <w lemma="van" type="VZ(init)" xml:id="w.4518">van</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4519">de</w>
                    <w lemma="Schelde"
                        type="N(eigen,ev,basis,zijd,stan)"
                        xml:id="w.4520">Schelde</w>
                    <w lemma="op" type="VZ(fin)" xml:id="w.4521">op</w>
                    <w lemma="te" type="VZ(init)" xml:id="w.4522">te</w>
                    <w lemma="lossen" type="WW(inf,vrij,zonder)"
                        xml:id="w.4523">lossen</w>
                    <pc type="SPEC(afgebr)" xml:id="pc.000608">,</pc>
                    <w lemma="en" type="VG(neven)" xml:id="w.4524">en</w>
                    <w lemma="dat"
                        type="VNW(aanw,pron,stan,vol,3o,ev)"
                        xml:id="w.4525">dat</w>
                    <w lemma="brengen" type="WW(pv,tgw,met-t)"
                        xml:id="w.4526">brengt</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4527">de</w>
                    <w lemma="uitvoering"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4528">uitvoering</w>
                    <lb />
                    <w lemma="van" type="VZ(init)" xml:id="w.4529">van</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4530">de</w>
                    <w lemma="afspraak"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4531">afspraak</w>
                    <w lemma="voor" type="VZ(init)" xml:id="w.4532">voor</w>
                    <w lemma="deze"
                        type="VNW(aanw,det,stan,prenom,met-e,rest)"
                        xml:id="w.4533">deze</w>
                    <w lemma="rivier"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4534">rivier</w>
                    <w lemma="in" type="VZ(init)" xml:id="w.4535">in</w>
                    <w lemma="gevaar"
                        type="N(soort,ev,basis,onz,stan)"
                        xml:id="w.4536">gevaar</w>
                    <pc type="LET()" xml:id="pc.000609">.</pc>
                </s>
                <s>
                    <w lemma="uit" type="VZ(init)" xml:id="w.4537">Uit</w>
                    <w lemma="een" type="LID(onbep,stan,agr)"
                        xml:id="w.4538">een</w>
                    <w lemma="in" type="VZ(init)" xml:id="w.4539">in</w>
                    <w lemma="opdracht"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4540">opdracht</w>
                    <w lemma="van" type="VZ(init)" xml:id="w.4541">van</w>
                    <w lemma="Greenpeace"
                        type="N(eigen,ev,basis,onz,stan)"
                        xml:id="w.4542">Greenpeace</w>
                    <w lemma="opstellen" type="WW(vd,vrij,zonder)"
                        xml:id="w.4543">opgesteld</w>
                    <w lemma="rapport"
                        type="N(soort,ev,basis,onz,stan)"
                        xml:id="w.4544">rapport</w>
                    <lb />
                    <w lemma="blijken" type="WW(pv,tgw,met-t)"
                        xml:id="w.4545">blijkt</w>
                    <w lemma="dat" type="VG(onder)" xml:id="w.4546">dat</w>
                    <w lemma="van" type="VZ(init)" xml:id="w.4547">van</w>
                    <w lemma="een" type="LID(onbep,stan,agr)"
                        xml:id="w.4548">een</w>
                    <w lemma="vermindering"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4549">vermindering</w>
                    <w lemma="van" type="VZ(init)" xml:id="w.4550">van</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4551">de</w>
                    <w lemma="vervuiling"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4552">vervuiling</w>
                    <w lemma="van" type="VZ(init)" xml:id="w.4553">van</w>
                    <w lemma="de" type="LID(bep,stan,rest)"
                        xml:id="w.4554">de</w>
                    <w lemma="Schelde"
                        type="N(eigen,ev,basis,zijd,stan)"
                        xml:id="w.4555">Schelde</w>
                    <w lemma="geen"
                        type="VNW(onbep,det,stan,prenom,zonder,agr)"
                        xml:id="w.4556">geen</w>
                    <w lemma="spraak"
                        type="N(soort,ev,basis,zijd,stan)"
                        xml:id="w.4557">sprake</w>
                    <w lemma="zijn" type="WW(pv,tgw,ev)"
                        xml:id="w.4558">is</w>
                    <pc type="LET()" xml:id="pc.000610">.</pc>
                </s>
                <lb />
            </ab>
        </body>
    </text>
</TEI.2>
```

# Step 4: 進行Indexing

現在萬事俱備只欠東風，我們從一開始有裝了Java，下載了blacklab，準備好語料原始檔，也確定語料的格式是TEI之後，就可以開始準備進行Indexing:

還記得剛剛的指令嗎？
```bash
$ java -cp "lib/*" nl.inl.blacklab.tools.IndexTool
```

現在我們要把其他參數也填進去：
```bash
$ $ java -cp "lib/*" nl.inl.blacklab.tools.IndexTool create ~/data/indexed_file ~/data/corpus tei-p4
```

成功的話你應該會看到：
```bash
1 docs (8 kB, 57 tokens); avg. 0.2k tok/s (0.0 MB/s); currently 0.2k tok/s (0.0 MB/s); 378 ms elapsed
Done. Elapsed time: 0 seconds
```

也就是1個document已經成功被index了。然後你就會在你剛剛所指定的index存放資料夾(以我的例子是：`~/data/indexed_file`)看到裡面多了很多檔案。

# Step 5: 實際進行Query

既然成功Indexing後，就代表我們可以對這個indexed corpus進行Query了。

blacklab提供兩種query方式，第一種是command line，第二種是透過架一個 blacklab-server 的 HTTP API。

這裡介紹第一種：
```bash
$ $ java -cp "lib/*" nl.inl.blacklab.tools.QueryTool <index所在的資料夾>
```

這個指令只要求一個參數，也就是你index後的檔案所存放的資料夾，所以我就要輸入：
```bash
$ $ java -cp "lib/*" nl.inl.blacklab.tools.QueryTool~/data/indexed_file
```

成功輸入後你會看到指令列跳出一個類似互動式的程式，會跳出`CorpusQL`的prompt，你就可以按照他跳出的說明來query，當然也可以使用CQL，例如：

```
CorpusQL> [][word="de"]
```

就會看到結果：

```
   1. [0000]           en Nederland niet in staat [zijn de] enorme milieuproblemen van de Schelde
   2. [0000] staat zijn de enorme milieuproblemen [van de] Schelde op te lossen , en
   3. [0000]                op te lossen , en dat [brengt de] uitvoering van de afspraak voor
   4. [0000]          en dat brengt de uitvoering [van de] afspraak voor deze rivier in
   5. [0000]      blijkt dat van een vermindering [van de] vervuiling van de Schelde geen
   6. [0000]   een vermindering van de vervuiling [van de] Schelde geen sprake is
6 hits in 1 documents
33 ms elapsed
```

當然command line並沒有那麼方便，使用第二種方法，也就是用HTTP API的方式會比較好用，這個可以下次再寫一下如何使用，要搭配Java的Tomcat server一起使用。

以下的連結是我自己練習用的，把PTT婚姻版(marriage)所有的語料經過上面的Indexing流程後，再使用blacklab的前後端所架設的一個搜尋頁面，大家可以玩看看：
http://140.112.147.125:8887/corpus-frontend/ptt_marriage_index/search

之後應該會試著把所有PTT的語料都搬到這上面，測試看看那麼大量的資料是否也可以快速檢索。

