---
title: 'Spotify: Most Common Words for Each Genre'
subtitle: ''
tags: [nlp, python, LOPE]
date: '2019-03-22'
author: Richard Lian
mysite: /richl/
comment: yes
---



```python
from collections import Counter
import json
import pickle
import random
import re
import time

import lyricsgenius
import lyricwikia
from matplotlib import pyplot as plt
import matplotlib
from musixmatch import Musixmatch
from nltk.corpus import stopwords

%matplotlib inline
```


```python
# Combined meta and basic song info from last time into file
with open('./spotify_top_200_with_meta_20170101-20180101.json') as f:
    stats = json.load(f)
```


```python
stats.keys()
```




    dict_keys(['2017-01-01', '2017-01-02', '2017-01-03', '2017-01-04', '2017-01-05', '2017-01-06', '2017-01-07', '2017-01-08', '2017-01-09', '2017-01-10', '2017-01-11', '2017-01-12', '2017-01-13', '2017-01-14', '2017-01-15', '2017-01-16', '2017-01-17', '2017-01-18', '2017-01-19', '2017-01-20', '2017-01-21', '2017-01-22', '2017-01-23', '2017-01-24', '2017-01-25', '2017-01-26', '2017-01-27', '2017-01-28', '2017-01-29', '2017-01-30', '2017-01-31', '2017-02-01', '2017-02-02', '2017-02-03', '2017-02-04', '2017-02-05', '2017-02-06', '2017-02-07', '2017-02-08', '2017-02-09', '2017-02-10', '2017-02-11', '2017-02-12', '2017-02-13', '2017-02-14', '2017-02-15', '2017-02-16', '2017-02-17', '2017-02-18', '2017-02-19', '2017-02-20', '2017-02-21', '2017-02-22', '2017-02-23', '2017-02-24', '2017-02-25', '2017-02-26', '2017-02-27', '2017-02-28', '2017-03-01', '2017-03-02', '2017-03-03', '2017-03-04', '2017-03-05', '2017-03-06', '2017-03-07', '2017-03-08', '2017-03-09', '2017-03-10', '2017-03-11', '2017-03-12', '2017-03-13', '2017-03-14', '2017-03-15', '2017-03-16', '2017-03-17', '2017-03-18', '2017-03-19', '2017-03-20', '2017-03-21', '2017-03-22', '2017-03-23', '2017-03-24', '2017-03-25', '2017-03-26', '2017-03-27', '2017-03-28', '2017-03-29', '2017-03-30', '2017-03-31', '2017-04-01', '2017-04-02', '2017-04-03', '2017-04-04', '2017-04-05', '2017-04-06', '2017-04-07', '2017-04-08', '2017-04-09', '2017-04-10', '2017-04-11', '2017-04-12', '2017-04-13', '2017-04-14', '2017-04-15', '2017-04-16', '2017-04-17', '2017-04-18', '2017-04-19', '2017-04-20', '2017-04-21', '2017-04-22', '2017-04-23', '2017-04-24', '2017-04-25', '2017-04-26', '2017-04-27', '2017-04-28', '2017-04-29', '2017-04-30', '2017-05-01', '2017-05-02', '2017-05-03', '2017-05-04', '2017-05-05', '2017-05-06', '2017-05-07', '2017-05-08', '2017-05-09', '2017-05-10', '2017-05-11', '2017-05-12', '2017-05-13', '2017-05-14', '2017-05-15', '2017-05-16', '2017-05-17', '2017-05-18', '2017-05-19', '2017-05-20', '2017-05-21', '2017-05-22', '2017-05-23', '2017-05-24', '2017-05-25', '2017-05-26', '2017-05-27', '2017-05-28', '2017-05-29', '2017-06-01', '2017-06-03', '2017-06-04', '2017-06-05', '2017-06-06', '2017-06-07', '2017-06-08', '2017-06-09', '2017-06-10', '2017-06-11', '2017-06-12', '2017-06-13', '2017-06-14', '2017-06-15', '2017-06-16', '2017-06-17', '2017-06-18', '2017-06-19', '2017-06-20', '2017-06-21', '2017-06-22', '2017-06-23', '2017-06-24', '2017-06-25', '2017-06-26', '2017-06-27', '2017-06-28', '2017-06-29', '2017-06-30', '2017-07-01', '2017-07-02', '2017-07-03', '2017-07-04', '2017-07-05', '2017-07-06', '2017-07-07', '2017-07-08', '2017-07-09', '2017-07-10', '2017-07-11', '2017-07-12', '2017-07-13', '2017-07-14', '2017-07-15', '2017-07-16', '2017-07-17', '2017-07-18', '2017-07-19', '2017-07-24', '2017-07-25', '2017-07-26', '2017-07-27', '2017-07-28', '2017-07-29', '2017-07-30', '2017-07-31', '2017-08-01', '2017-08-02', '2017-08-03', '2017-08-04', '2017-08-05', '2017-08-06', '2017-08-07', '2017-08-08', '2017-08-09', '2017-08-10', '2017-08-11', '2017-08-12', '2017-08-13', '2017-08-14', '2017-08-15', '2017-08-16', '2017-08-17', '2017-08-18', '2017-08-19', '2017-08-20', '2017-08-21', '2017-08-22', '2017-08-23', '2017-08-24', '2017-08-25', '2017-08-26', '2017-08-27', '2017-08-28', '2017-08-29', '2017-08-30', '2017-08-31', '2017-09-01', '2017-09-02', '2017-09-03', '2017-09-04', '2017-09-05', '2017-09-06', '2017-09-07', '2017-09-08', '2017-09-09', '2017-09-10', '2017-09-11', '2017-09-12', '2017-09-13', '2017-09-14', '2017-09-15', '2017-09-16', '2017-09-17', '2017-09-18', '2017-09-19', '2017-09-20', '2017-09-21', '2017-09-22', '2017-09-23', '2017-09-24', '2017-09-25', '2017-09-26', '2017-09-27', '2017-09-28', '2017-09-29', '2017-09-30', '2017-10-01', '2017-10-02', '2017-10-03', '2017-10-04', '2017-10-05', '2017-10-06', '2017-10-07', '2017-10-08', '2017-10-09', '2017-10-10', '2017-10-11', '2017-10-12', '2017-10-13', '2017-10-14', '2017-10-15', '2017-10-16', '2017-10-17', '2017-10-18', '2017-10-19', '2017-10-20', '2017-10-21', '2017-10-22', '2017-10-23', '2017-10-24', '2017-10-25', '2017-10-26', '2017-10-27', '2017-10-28', '2017-10-29', '2017-10-30', '2017-10-31', '2017-11-01', '2017-11-02', '2017-11-03', '2017-11-04', '2017-11-05', '2017-11-06', '2017-11-07', '2017-11-08', '2017-11-15', '2017-11-16', '2017-11-17', '2017-11-18', '2017-11-19', '2017-11-20', '2017-11-21', '2017-11-22', '2017-11-23', '2017-11-24', '2017-11-25', '2017-11-26', '2017-11-27', '2017-11-28', '2017-11-29', '2017-11-30', '2017-12-01', '2017-12-02', '2017-12-03', '2017-12-04', '2017-12-05', '2017-12-06', '2017-12-07', '2017-12-08', '2017-12-09', '2017-12-10', '2017-12-11', '2017-12-12', '2017-12-13', '2017-12-14', '2017-12-15', '2017-12-16', '2017-12-17', '2017-12-18', '2017-12-19', '2017-12-20', '2017-12-21', '2017-12-22', '2017-12-23', '2017-12-24', '2017-12-25', '2017-12-26', '2017-12-27', '2017-12-28', '2017-12-29', '2017-12-30', '2017-12-31', '2018-01-01'])




```python
# Total number of unique songs
songs = {(track['song'], track['artist']) for day in stats for track in stats[day]}
print(f'Total no. of unique songs: {len(songs)}')
print(songs)
```

    Total no. of unique songs: 1618
    {('Wet Dreamz', 'J. Cole'), ('Some Way', 'NAV'), ('Drippy', 'Young Dolph'), ('New Illuminati', 'Future'), ('Doves In The Wind', 'SZA'), ('Life Changes', 'Thomas Rhett'), ('Despacito - Remix', 'Luis Fonsi'), ('Plain Jane REMIX', 'A$AP Ferg'), ('Flip', 'Future'), ('Revival (Interlude)', 'Eminem'), ('Rise Up', 'Imagine Dragons'), ("We Don't Talk Anymore (feat. Selena Gomez)", 'Charlie Puth'), ("Can't Have Everything", 'Drake'), ("She's Mine Pt. 1", 'J. Cole'), ('Still Serving', '21 Savage'), ('LUST.', 'Kendrick Lamar'), ('In My Feelings', 'Lana Del Rey'), ('A Lie', 'French Montana'), ('Cash Machine', 'DRAM'), ('No Comparison', 'A Boogie Wit da Hoodie'), ('Good Man (feat. Pusha T & Jadakiss)', 'DJ Khaled'), ('OK', 'Robin Schulz'), ('Stayin\' Alive - From "Saturday Night Fever" Soundtrack', 'Bee Gees'), ('Caroline', 'Aminé'), ('Nasty (Who Dat)', 'A$AP Ferg'), ('Free Smoke', 'Drake'), ('Gang Up (with Young Thug, 2 Chainz & Wiz Khalifa feat. PnB Rock)', 'Young Thug'), ('Shed a Light', 'Robin Schulz'), ('Christmas Eve - Recorded at Spotify Studios NYC', 'Kelly Clarkson'), ("Mary Jane's Last Dance", 'Tom Petty and the Heartbreakers'), ('Two®', 'Lil Uzi Vert'), ('This Town', 'Niall Horan'), ('Shooters', 'Tory Lanez'), ('Get Low (with Liam Payne)', 'Zedd'), ('Big Poppa', 'The Notorious B.I.G.'), ('Santa Claus Is Coming To Town', 'The Jackson 5'), ('Heavy (feat. Kiiara)', 'Linkin Park'), ('GOOD MORNING AMERIKKKA', 'Joey Bada$$'), ('TEMPTATION', 'Joey Bada$$'), ('4422', 'Drake'), ('Trap And A Dream', 'A$AP Ferg'), ('YAH.', 'Kendrick Lamar'), ('Eye 2 Eye', 'Huncho Jack'), ('Never Be the Same - Radio Edit', 'Camila Cabello'), ('Sober', 'Lorde'), ('Skateboard P (feat. Big Sean)', 'MadeinTYO'), ('Naked', 'James Arthur'), ('Rich Girl', 'Daryl Hall & John Oates'), ('O Christmas Tree', 'Tony Bennett'), ('Bon Appétit', 'Katy Perry'), ('The Fighter', 'Keith Urban'), ('Trumpets', 'Jason Derulo'), ('No Complaints', 'Metro Boomin'), ('I Need To Know', 'Tom Petty and the Heartbreakers'), ('13 Beaches', 'Lana Del Rey'), ('End Game', 'Taylor Swift'), ('The Weekend - Funk Wav Remix', 'SZA'), ('Malibu', 'Miley Cyrus'), ('Look At Me!', 'XXXTENTACION'), ('Super Trapper', 'Future'), ('I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)"', 'ZAYN'), ('Drowning (feat. Kodak Black)', 'A Boogie Wit da Hoodie'), ("Somebody's Watching Me - Single Version", 'Rockwell'), ('God, Your Mama, And Me', 'Florida Georgia Line'), ('Scared to Be Lonely', 'Martin Garrix'), ("Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC", 'Miley Cyrus'), ("(I Can't Get No) Satisfaction - Mono Version / Remastered 2002", 'The Rolling Stones'), ('From The D To The A (feat. Lil Yachty)', 'Tee Grizzley'), ('Selfish', 'PnB Rock'), ("I'm Tryna Fuck", 'Ugly God'), ('What They Want', 'Russ'), ('Fresh Air', 'Future'), ('Christmas Time', 'The Platters'), ('Dirty Mouth', 'Lil Yachty'), ('Make Me (Cry)', 'Noah Cyrus'), ('Photograph', 'Ed Sheeran'), ('Hard Times', 'Paramore'), ('Love Galore', 'SZA'), ('High Stakes', 'Bryson Tiller'), ('Major Bag Alert (feat. Migos)', 'DJ Khaled'), ("That's My N**** (with Meek Mill, YG & Snoop Dogg)", 'Meek Mill'), ('Sleigh Ride', 'Carpenters'), ('Party', 'Chris Brown'), ('My Type', 'The Chainsmokers'), ('Wildflowers', 'Tom Petty'), ('Icon', 'Jaden Smith'), ('I Think She Like Me', 'Rick Ross'), ('Down', 'Fifth Harmony'), ('Peek A Boo', 'Lil Yachty'), ("It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra)", 'Perry Como'), ('Deja Vu', 'Post Malone'), ('Youngest Flexer (feat. Gucci Mane)', 'Lil Pump'), ('Ride', 'Twenty One Pilots'), ('Million Reasons', 'Lady Gaga'), ('Miss You', 'James Hersey'), ('El Amante', 'Nicky Jam'), ('Perry Aye', 'A$AP Mob'), ('POA', 'Future'), ('Sacrifices', 'Drake'), ('Heatstroke (feat. Young Thug, Pharrell Williams & Ariana Grande)', 'Calvin Harris'), ('The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version', 'Bebe Rexha'), ('Get to the Money (feat. Troyse, Cito G & Flames)', 'Chad Focus'), ('...Ready For It?', 'Taylor Swift'), ('beibs in the trap', 'Travis Scott'), ('O Tannenbaum', 'Vince Guaraldi Trio'), ('KMT', 'Drake'), ('Pumped Up Kicks', 'Foster The People'), ('Young And Menace', 'Fall Out Boy'), ('Everybody Dies In Their Nightmares', 'XXXTENTACION'), ('Saint Laurent Mask', 'Huncho Jack'), ('Eraser', 'Ed Sheeran'), ('Liger', 'Young Thug'), ('Again', 'Noah Cyrus'), ('Everybody', 'Logic'), ('Kiwi', 'Harry Styles'), ('Remind Me', 'Eminem'), ('Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)"', 'Nick Jonas'), ('Born In The U.S.A.', 'Bruce Springsteen'), ('My Choppa Hate Niggas', '21 Savage'), ('Lot to Learn', 'Luke Christopher'), ('Wanted You (feat. Lil Uzi Vert)', 'NAV'), ('Battle Symphony', 'Linkin Park'), ('Small Town Boy', 'Dustin Lynch'), ('Anziety', 'Logic'), ('High Demand', 'Future'), ('Coolin and Booted', 'Kodak Black'), ('Three', 'Future'), ('Champion', 'Fall Out Boy'), ('Cake By The Ocean', 'DNCE'), ('Help Me Out (with Julia Michaels)', 'Maroon 5'), ('Sacrifices', 'Big Sean'), ('Juicy', 'The Notorious B.I.G.'), ('Codeine Dreaming (feat. Lil Wayne)', 'Kodak Black'), ('Into The Great Wide Open', 'Tom Petty and the Heartbreakers'), ('FYBR (First Year Being Rich)', 'A$AP Mob'), ('Roses', 'The Chainsmokers'), ('Delicate', 'Taylor Swift'), ('Kissing Strangers', 'DNCE'), ('I Feel It Coming', 'The Weeknd'), ('Good Day (feat. DJ Snake & Elliphant)', 'Yellow Claw'), ('Issues', 'Meek Mill'), ('Marmalade (feat. Lil Yachty)', 'Macklemore'), ('Praying', 'Kesha'), ('Orlando', 'XXXTENTACION'), ('(What A) Wonderful World - Remastered', 'Sam Cooke'), ('Jingle Bell Rock', 'Anita Kerr Singers'), ('Ill Nana (feat. Trippie Redd)', 'DRAM'), ('Shape of You (Major Lazer Remix) [feat. Nyla & Kranium]', 'Ed Sheeran'), ('Walking The Wire', 'Imagine Dragons'), ('Go Off (with Lil Uzi Vert, Quavo & Travis Scott)', 'Lil Uzi Vert'), ('Big Fish', 'Vince Staples'), ('P.Y.T. (Pretty Young Thing)', 'Michael Jackson'), ('Leave Right Now', 'Thomas Rhett'), ('Drew Barrymore', 'SZA'), ('Woman', 'Harry Styles'), ('How To Talk', 'Lil Uzi Vert'), ('Have Yourself a Merry Little Christmas', 'Christina Aguilera'), ('Closer', 'The Chainsmokers'), ('Too Good', 'Drake'), ('Molly', 'Lil Pump'), ('Merry Christmas Darling - Album Version/Remix', 'Carpenters'), ('Everyday We Lit', 'YFN Lucci'), ('Broken Halos', 'Chris Stapleton'), ('I Would Die For You', 'Miley Cyrus'), ('Ignition - Remix', 'R. Kelly'), ('Lights Down Low', 'MAX'), ('Strip That Down', 'Liam Payne'), ('Saved', 'Khalid'), ('I Love You so Much (feat. Chance the Rapper)', 'DJ Khaled'), ('Iced Out My Arms (feat. Future, Migos, 21 Savage & T.I.)', 'DJ Khaled'), ('Escape', 'Kehlani'), ('I Did Something Bad', 'Taylor Swift'), ('Fake Happy', 'Paramore'), ('Roll In Peace (feat. XXXTENTACION)', 'Kodak Black'), ('One Step Closer', 'Linkin Park'), ('Line Of Sight (feat. WYNNE & Mansionair)', 'ODESZA'), ('Go Legend (& Metro Boomin)', 'Big Sean'), ('Owe Me', 'Big Sean'), ('Walk On Water', 'Thirty Seconds To Mars'), ('Capsize', 'FRENSHIP'), ('Signs', 'Drake'), ('AfricAryaN', 'Logic'), ('Bahamas', 'A$AP Mob'), ('Be The One', 'Dua Lipa'), ('The Man With The Bag', 'Kay Starr'), ('No Cap', 'Future'), ('Ever Since New York', 'Harry Styles'), ('What Lovers Do (feat. SZA)', 'Maroon 5'), ('Momentz (feat. De La Soul)', 'Gorillaz'), ('Radioactive', 'Imagine Dragons'), ('Rich Love (with Seeb)', 'OneRepublic'), ('Deserve (feat. Travis Scott)', 'Kris Wu'), ('Christmas (Baby Please Come Home)', 'Michael Bublé'), ('He Like That', 'Fifth Harmony'), ('Christmas (Baby Please Come Home)', 'Mariah Carey'), ('Fell On Black Days', 'Soundgarden'), ('Paper Planes', 'M.I.A.'), ('Baby Girl', '21 Savage'), ('Swang', 'Rae Sremmurd'), ('Go Go', 'BTS'), ('Week Without You', 'Miley Cyrus'), ('Body Like A Back Road', 'Sam Hunt'), ('Ex Calling', '6LACK'), ('The Happiest Christmas Tree - 2009 Digital Remaster', 'Nat King Cole'), ('Pendulum', 'Katy Perry'), ('Don’t Blame Me', 'Taylor Swift'), ('Black Barbies', 'Nicki Minaj'), ('Supermarket Flowers', 'Ed Sheeran'), ('Swalla (feat. Nicki Minaj & Ty Dolla $ign)', 'Jason Derulo'), ('Trap Check', '2 Chainz'), ('I Knew You Were Trouble.', 'Taylor Swift'), ('Money Convo', '21 Savage'), ('CRZY', 'Kehlani'), ('Busted and Blue', 'Gorillaz'), ('Nowadays (feat. Landon Cube)', 'Lil Skies'), ('Woman', 'Kesha'), ('Live Up to My Name', 'Baka Not Nice'), ('Driving Home for Christmas', 'Chris Rea'), ('Arose', 'Eminem'), ('8TEEN', 'Khalid'), ('Only Love', 'Ben Howard'), ('By Your Side', 'Jonas Blue'), ('September', 'Earth, Wind & Fire'), ('Here Comes My Girl', 'Tom Petty and the Heartbreakers'), ('Secrets', 'The Weeknd'), ('Rendezvous', 'PARTYNEXTDOOR'), ('Jumpman', 'Drake'), ('Boredom', 'Tyler, The Creator'), ('When I Was Broke', 'Future'), ('Timeless (DJ SPINKING)', 'A Boogie Wit da Hoodie'), ('Blue Pill', 'Metro Boomin'), ('Begin (feat. Wales)', 'Shallou'), ('All Time Low', 'Jon Bellion'), ('Sidewalks', 'The Weeknd'), ('OMG', 'Camila Cabello'), ('Flicker', 'Niall Horan'), ('Summer Bummer (feat. A$AP Rocky & Playboi Carti)', 'Lana Del Rey'), ('The Way Life Goes (feat. Oh Wonder)', 'Lil Uzi Vert'), ('Use Me', 'Future'), ('Reminding Me', 'Shawn Hook'), ('Dusk Till Dawn - Radio Edit', 'ZAYN'), ('Cut It (feat. Young Dolph)', 'O.T. Genasis'), ('Falls (feat. Sasha Sloan)', 'ODESZA'), ('Killing Spree', 'Logic'), ('Best Of Me', 'BTS'), ('Underneath the Tree', 'Kelly Clarkson'), ('Kept Me Crying', 'HAIM'), ('Six Feet Under', 'The Weeknd'), ('Sober II (Melodrama)', 'Lorde'), ('Exchange', 'Bryson Tiller'), ('Location', 'Khalid'), ('DUCKWORTH.', 'Kendrick Lamar'), ('God Rest Ye Merry Gentlemen - Single Version', 'Bing Crosby'), ('OK (feat. Lil Pump)', 'Smokepurpp'), ('Revenge', 'XXXTENTACION'), ('Back (feat. Lil Yachty)', 'Lil Pump'), ('Starving', 'Hailee Steinfeld'), ('Rudolph the Rednose Reindeer', 'DMX'), ('Hotline Bling', 'Drake'), ('My Girl', 'Dylan Scott'), ('Even The Odds (& Metro Boomin)', 'Big Sean'), ('Wonderwall - Remastered', 'Oasis'), ('Alone', 'Halsey'), ("I'm the One", 'DJ Khaled'), ('Send My Love (To Your New Lover)', 'Adele'), ('True Colors', 'The Weeknd'), ("It's Beginning to Look a Lot Like Christmas", 'Michael Bublé'), ('Bastards', 'Kesha'), ('Deja Vu', 'J. Cole'), ('The Hills', 'The Weeknd'), ('Ahora Dice', 'Chris Jeday'), ('Give Me Love', 'Ed Sheeran'), ('Mama', 'Jonas Blue'), ('Want Her', 'Mustard'), ('Foldin Clothes', 'J. Cole'), ('Miracles (Someone Special)', 'Coldplay'), ('Panda', 'Desiigner'), ('Both (feat. Drake)', 'Gucci Mane'), ('America', 'Logic'), ('Nobody Else But You', 'Trey Songz'), ('BUTTERFLY EFFECT', 'Travis Scott'), ('Hunt You Down', 'Kesha'), ('Hymn', 'Kesha'), ('Breakdown', 'Tom Petty and the Heartbreakers'), ('Blue Christmas', 'Elvis Presley'), ('Castle', 'Eminem'), ('Need Me (feat. Pink)', 'Eminem'), ('Perfect Illusion', 'Lady Gaga'), ('Confess', 'Logic'), ('For Whom The Bell Tolls', 'J. Cole'), ('The Man', 'The Killers'), ('Skrt Skrt', 'Tory Lanez'), ('Run Me Dry', 'Bryson Tiller'), ('Walk On Water (feat. Beyoncé)', 'Eminem'), ('No Promises (feat. Demi Lovato)', 'Cheat Codes'), ('Who Dat Boy', 'Tyler, The Creator'), ('No Heart', '21 Savage'), ('Do I Make You Wanna', 'Billy Currington'), ('Step Into Christmas', 'Elton John'), ('Save Myself', 'Ed Sheeran'), ('Welcome to the Booty Tape', 'Ugly God'), ('First Love', 'Lost Kings'), ('Gospel', 'Rich Brian'), ('Call On Me - Ryan Riback Extended Remix', 'Starley'), ('First Time', 'Kygo'), ('For Now', 'P!nk'), ('ROCKABYE BABY (feat. ScHoolboy Q)', 'Joey Bada$$'), ('Needed Me', 'Rihanna'), ('Jorja Interlude', 'Drake'), ('Solo Dance', 'Martin Jensen'), ("Rockin' Around The Christmas Tree - Single Version", 'Brenda Lee'), ('Crew REMIX', 'GoldLink'), ('All Ass', 'Migos'), ('End of the World', 'Kelsea Ballerini'), ('White Christmas (duet with Shania Twain)', 'Michael Bublé'), ('Learning To Fly', 'Tom Petty and the Heartbreakers'), ('I Love You', 'Axwell /\\ Ingrosso'), ('Mos Definitely', 'Logic'), ('Hurricane', 'Luke Combs'), ('Changed It', 'Nicki Minaj'), ("Don't Do Me Like That", 'Tom Petty and the Heartbreakers'), ('Tomorrow Til Infinity (feat. Gunna)', 'Young Thug'), ('CAN\'T STOP THE FEELING! (Original Song from DreamWorks Animation\'s "TROLLS")', 'Justin Timberlake'), ('DN Freestyle', 'Lil Yachty'), ('Attention', 'Charlie Puth'), ('My Love (feat. Major Lazer, WizKid, Dua Lipa)', 'Wale'), ('The Thrill Of It All', 'Sam Smith'), ('You Da Baddest', 'Future'), ('Here Comes The Sun - Remastered', 'The Beatles'), ('Gucci On My (feat. 21 Savage, YG & Migos)', 'Mike WiLL Made-It'), ('Like A Star', 'Lil Yachty'), ('Believe', 'Eminem'), ('The Louvre', 'Lorde'), ('Saturday Night', '2 Chainz'), ('Feel So Close - Radio Edit', 'Calvin Harris'), ('Say It (feat. Tove Lo)', 'Flume'), ('I Fall Apart', 'Post Malone'), ('Wake Up Where You Are', 'State of Sound'), ('FEEL.', 'Kendrick Lamar'), ('Gold', 'Kiiara'), ('Sympathy For The Devil', 'The Rolling Stones'), ('Rudolph the Red-Nosed Reindeer', 'Gene Autry'), ('The Christmas Waltz', 'Peggy Lee'), ('Dirty Sexy Money (feat. Charli XCX & French Montana)', 'David Guetta'), ('Stranger Things', 'Kyle Dixon & Michael Stein'), ('Numb', 'Linkin Park'), ('Lookin Exotic', 'Future'), ('Apple of My Eye', 'Rick Ross'), ("i hate u, i love u (feat. olivia o'brien)", 'gnash'), ("Do They Know It's Christmas? - 1984 Version", 'Band Aid'), ('At the Door', 'Lil Pump'), ('Heat', 'Eminem'), ('Castro', 'Yo Gotti'), ('Cold', 'Maroon 5'), ('To the Max', 'DJ Khaled'), ('Rollin (feat. Future & Khalid)', 'Calvin Harris'), ('That Range Rover Came With Steps (feat. Future & Yo Gotti)', 'DJ Khaled'), ('Boss', 'Lil Pump'), ('Framed', 'Eminem'), ('Whatever It Takes', 'Imagine Dragons'), ('Make Love', 'Gucci Mane'), ('Savage Time (& Metro Boomin)', 'Big Sean'), ('Slippery (feat. Gucci Mane)', 'Migos'), ('Save That Shit', 'Lil Peep'), ('Look Alive', 'Rae Sremmurd'), ('Bad Things - With Camila Cabello', 'Machine Gun Kelly'), ('Saturnz Barz (feat. Popcaan)', 'Gorillaz'), ('Bonita', 'J Balvin'), ('Heartache On The Dance Floor', 'Jon Pardi'), ('Flex Like Ouu', 'Lil Pump'), ("Somethin' I'm Good At", 'Brett Eldredge'), ("What I've Done", 'Linkin Park'), ('First Day Out', 'Tee Grizzley'), ('MIC Drop (feat. Desiigner) [Steve Aoki Remix]', 'BTS'), ('Courtesy Of The Red, White And Blue (The Angry American)', 'Toby Keith'), ('Getaway Car', 'Taylor Swift'), ('A Thousand Years', 'Christina Perri'), ('Bad Husband (feat. X Ambassadors)', 'Eminem'), ('Somebody Else', 'VÉRITÉ'), ('Krippy Kush - Remix', 'Farruko'), ('How U Feel', 'Huncho Jack'), ('Purple Rain', 'Prince'), ("I'm so Groovy", 'Future'), ('Sometimes...', 'Tyler, The Creator'), ('Teenage Fever', 'Drake'), ('Legend', 'G-Eazy'), ('Silent Night', 'Carpenters'), ('Merry Christmas, Happy Holidays', '*NSYNC'), ('Despacito (Featuring Daddy Yankee)', 'Luis Fonsi'), ('All I Know', 'The Weeknd'), ('Crazy', 'Lil Pump'), ('Mr. Brightside', 'The Killers'), ('Yeah Yeah (feat. Young Thug)', 'Travis Scott'), ('Little Of Your Love - BloodPop® Remix', 'HAIM'), ('Hello', 'Adele'), ('Nancy Mulligan', 'Ed Sheeran'), ('Just Hold On', 'Steve Aoki'), ('Get The Bag', 'A$AP Mob'), ("Don't Sleep On Me (feat. Future and 24hrs)", 'Ty Dolla $ign'), ('Most Girls', 'Hailee Steinfeld'), ('Bring Dem Things', 'French Montana'), ('Christmas Lights', 'Coldplay'), ('hell is where i dreamt of u and woke up alone', 'blackbear'), ('For Free', 'DJ Khaled'), ('Feel Good (feat. Daya)', 'Gryffin'), ('Jocelyn Flores', 'XXXTENTACION'), ('Nevermind This Interlude', 'Bryson Tiller'), ('Light', 'Big Sean'), ('No Fear', 'DeJ Loaf'), ('No Problem (feat. Lil Wayne & 2 Chainz)', 'Chance the Rapper'), ('How Far I\'ll Go - From "Moana"', 'Alessia Cara'), ('OG Kush Diet', '2 Chainz'), ('Told You So', 'Paramore'), ('Quit (feat. Ariana Grande)', 'Cashmere Cat'), ('Sixteen', 'Thomas Rhett'), ('Better', 'Lil Yachty'), ('Solo', 'Future'), ('This Town (feat. Sasha Sloan)', 'Kygo'), ('XXX. FEAT. U2.', 'Kendrick Lamar'), ('In Tune (& Metro Boomin)', 'Big Sean'), ('Disrespectful', 'GASHI'), ('Time To Move On', 'Tom Petty'), ('Lips', 'The xx'), ('Move Your Body - Single Mix', 'Sia'), ('ILL NANA (feat. Trippie Redd)', 'DRAM'), ("Baby, It's Cold Outside (feat. Meghan Trainor)", 'Brett Eldredge'), ('Listen To Her Heart', 'Tom Petty and the Heartbreakers'), ('Love On The Brain', 'Rihanna'), ('Run Up (feat. PARTYNEXTDOOR & Nicki Minaj)', 'Major Lazer'), ('Get Mine', 'Bryson Tiller'), ('V. 3005', 'Childish Gambino'), ('In the Blood', 'John Mayer'), ('Outta Time', 'Future'), ('Angels (feat. Saba)', 'Chance the Rapper'), ('Glitter', 'Tyler, The Creator'), ('Pineapple Skies', 'Miguel'), ('Wonderful Christmastime - Remastered 2011 / Edited Version', 'Paul McCartney'), ('Relationship (feat. Future)', 'Young Thug'), ('Goodbye', 'Echosmith'), ('Back to You (feat. Bebe Rexha & Digital Farm Animals)', 'Louis Tomlinson'), ("I'm the One (feat. Justin Bieber, Quavo, Chance the Rapper & Lil Wayne)", 'DJ Khaled'), ('Down', 'Marian Hill'), ('santa monica & la brea', 'blackbear'), ("F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar)", 'A$AP Rocky'), ('Let You Down', 'NF'), ('When It Rains It Pours', 'Luke Combs'), ("Free Fallin'", 'Tom Petty'), ('Juju On That Beat (TZ Anthem)', 'Zay Hilfigerrr'), ('Die A Happy Man', 'Thomas Rhett'), ('DNA', 'BTS'), ('The Weekend', 'Brantley Gilbert'), ('LUV', 'Tory Lanez'), ('Selfish (feat. Rihanna)', 'Future'), ('SUBEME LA RADIO', 'Enrique Iglesias'), ('One Dance', 'Drake'), ('The Plan', 'G-Eazy'), ('Christmas (Baby Please Come Home)', 'Darlene Love'), ("It Ain't Me (with Selena Gomez)", 'Kygo'), ("Blue Ain't Your Color", 'Keith Urban'), ('Moving On and Getting Over', 'John Mayer'), ('Heaven In Hiding', 'Halsey'), ("It's Good To Be King", 'Tom Petty'), ('Run Rudolph Run - Single Version', 'Chuck Berry'), ('Out Of The Woods', 'Taylor Swift'), ('Chanel', 'Frank Ocean'), ('Harley', 'Lil Yachty'), ('Carol of the Bells', 'Mykola Dmytrovych Leontovych'), ('Plain Jane', 'A$AP Ferg'), ('Dreams', 'ZHU'), ('Stir Fry', 'Migos'), ('Seven Million (feat. Future)', 'Lil Uzi Vert'), ('All Night (feat. Knox Fortune)', 'Chance the Rapper'), ('Fortunate Son', 'Creedence Clearwater Revival'), ('Riding Shotgun', 'Kygo'), ('The Chain - 2004 Remaster', 'Fleetwood Mac'), ('The Last Of The Real Ones', 'Fall Out Boy'), ('Light It Up (feat. Nyla & Fuse ODG) - Remix', 'Major Lazer'), ('Mercy', 'Shawn Mendes'), ('High End', 'Chris Brown'), ('(Not) The One', 'Bebe Rexha'), ('Wildest Dreams', 'Taylor Swift'), ('Neva Missa Lost', 'Future'), ('Linus And Lucy', 'Vince Guaraldi Trio'), ('Get It Together', 'Drake'), ('Like a Stone', 'Audioslave'), ("You're Gonna Live Forever in Me", 'John Mayer'), ('HUMBLE.', 'Kendrick Lamar'), ('Ric Flair Drip (& Metro Boomin)', 'Offset'), ('Wake Up Alone', 'The Chainsmokers'), ('Lust For Life (with The Weeknd)', 'Lana Del Rey'), ('Into You', 'Ariana Grande'), ('Corazón', 'Maluma'), ('Feed Me Dope', 'Future'), ('That Far', '6LACK'), ('Gold Digger', 'Kanye West'), ('No Frauds', 'Nicki Minaj'), ('Only 4 Me', 'Chris Brown'), ('Water Under the Bridge', 'Adele'), ('Galway Girl', 'Ed Sheeran'), ('Breakfast (feat. A$AP Rocky)', 'Jaden Smith'), ('What Do I Know?', 'Ed Sheeran'), ('City Of Stars - From "La La Land" Soundtrack', 'Ryan Gosling'), ('Work', 'Rihanna'), ('What Ifs', 'Kane Brown'), ('Tragic Endings (feat. Skylar Grey)', 'Eminem'), ('PRBLMS', '6LACK'), ('A$AP Ferg', 'NAV'), ('I Thank U', 'Future'), ('Light', 'San Holo'), ('Chantaje', 'Shakira'), ('I Like Me Better', 'Lauv'), ('Gangsta', 'Kehlani'), ('Born This Way', 'Lady Gaga'), ('Bad Blood', 'Taylor Swift'), ('Stargazing', 'Kygo'), ('RAF', 'A$AP Mob'), ('Dead Inside (Interlude)', 'XXXTENTACION'), ('What Child Is This?/The Holly And The Ivy', 'Bing Crosby'), ('Love Yourself', 'Justin Bieber'), ('Too Hotty', 'Quality Control'), ('IDGAF', 'Dua Lipa'), ('Only Angel', 'Harry Styles'), ('Fashion (feat. Rich The Kid)', 'Jay Critch'), ('SUPER PREDATOR (feat. Styles P)', 'Joey Bada$$'), ('Feds Did a Sweep', 'Future'), ("Y U DON'T LOVE ME? (MISS AMERIKKKA)", 'Joey Bada$$'), ('Highway to Hell', 'AC/DC'), ('How Long', 'Charlie Puth'), ('Hi Bich', 'Bhad Bhabie'), ('Really Really', 'Kevin Gates'), ('Toxic', 'Britney Spears'), ('Call on Me - Ryan Riback Remix', 'Starley'), ('Start Over', 'Imagine Dragons'), ('PILLOWTALK', 'ZAYN'), ('Baptized In Fire', 'Kid Cudi'), ('Should I Stay or Should I Go - Remastered', 'The Clash'), ('Hear Me Now', 'Alok'), ('On Everything (feat. Travis Scott, Rick Ross & Big Sean)', 'DJ Khaled'), ('Complicated (feat. Kiiara) (feat. Kiiara)', 'Dimitri Vegas & Like Mike'), ('So Good (& Metro Boomin)', 'Big Sean'), ('My Dawg', 'Quality Control'), ('Dancing In The Dark', 'Imagine Dragons'), ('Black & Chinese', 'Huncho Jack'), ('Incredible', 'Future'), ('4 AM', '2 Chainz'), ('For Real', 'Lil Uzi Vert'), ("(Don't Fear) The Reaper", 'Blue Öyster Cult'), ('Romantic - NOTD Remix', 'Stanaj'), ("It's Gotta Be You", 'Isaiah'), ('Walk On Water', 'A$AP Mob'), ('Where U From', 'Huncho Jack'), ('My Only Wish (This Year)', 'Britney Spears'), ('Shook Ones, Pt. II', 'Mobb Deep'), ('Anywhere', 'Rita Ora'), ('Can I Be Him', 'James Arthur'), ('The Other', 'Lauv'), ('Light It Up', 'Luke Bryan'), ('Mr. Blue Sky', 'Electric Light Orchestra'), ('Losin Control', 'Russ'), ('Myself', 'NAV'), ('Supermodel', 'SZA'), ('Work REMIX', 'A$AP Ferg'), ('Love Me Like You Do - From "Fifty Shades Of Grey"', 'Ellie Goulding'), ('HOLD ME TIGHT OR DON’T', 'Fall Out Boy'), ('Set It Off', 'Bryson Tiller'), ('Fuck Love (feat. Trippie Redd)', 'XXXTENTACION'), ('top priority (with Ne-Yo)', 'blackbear'), ('I Think Of You', 'Jeremih'), ('Candy Paint', 'Post Malone'), ('Rubbin Off The Paint', 'YBN Nahmir'), ('Mask Off', 'Future'), ('Symphony (feat. Zara Larsson)', 'Clean Bandit'), ('Super Far', 'LANY'), ('Charger (feat. Grace Jones)', 'Gorillaz'), ('Sex for Breakfast', 'Life of Dillon'), ('The Greatest Show', 'Hugh Jackman'), ('Mi Gente (feat. Beyoncé)', 'J Balvin'), ('Young', 'The Chainsmokers'), ('Under The Bridge', 'Red Hot Chili Peppers'), ('Too Many Years', 'Kodak Black'), ("Baby, It's Cold Outside", 'Dean Martin'), ("Drinkin' Too Much", 'Sam Hunt'), ('Before You Judge', 'Bryson Tiller'), ('Uh Huh', 'Julia Michaels'), ('The Explanation', 'XXXTENTACION'), ('Smooth Like The Summer', 'Thomas Rhett'), ('Come Closer', 'WizKid'), ('Ambitionz Az A Ridah', '2Pac'), ('Taped Up Heart (feat. Clara Mae)', 'KREAM'), ('The Way Life Goes (feat. Nicki Minaj & Oh Wonder) - Remix', 'Lil Uzi Vert'), ('rockstar', 'Post Malone'), ('Killing Time', 'R3HAB'), ('Mall', 'Gucci Mane'), ("Sweet Child O' Mine", "Guns N' Roses"), ('Royals', 'Lorde'), ('Juke Jam (feat. Justin Bieber & Towkio)', 'Chance the Rapper'), ('Something Just Like This', 'The Chainsmokers'), ('Damage', 'PARTYNEXTDOOR'), ('Pray', 'Sam Smith'), ('Self-Made', 'Bryson Tiller'), ('H.O.L.Y.', 'Florida Georgia Line'), ('Love U Better (feat. Lil Wayne & The-Dream)', 'Ty Dolla $ign'), ('Your Body Is a Wonderland', 'John Mayer'), ('Dear Hate', 'Maren Morris'), ('Conscience (feat. Future)', 'Kodak Black'), ('Feel It Still', 'Portugal. The Man'), ('Hymn for the Weekend - Seeb Remix', 'Coldplay'), ("Man's Not Hot", 'Big Shaq'), ('Tip Toe (feat. French Montana)', 'Jason Derulo'), ('A Holly Jolly Christmas - Single Version', 'Burl Ives'), ('Santa Baby (with Henri René & His Orchestra)', 'Eartha Kitt'), ('You Could Be', 'R3HAB'), ("Don't Leave", 'Snakehips'), ('Santa Tell Me', 'Ariana Grande'), ('Go', 'Huncho Jack'), ('Perfect Duet (Ed Sheeran & Beyoncé)', 'Ed Sheeran'), ('Teach Me a Lesson', 'Bryson Tiller'), ('Slow Hands', 'Niall Horan'), ('Sleigh Ride', 'Andy Williams'), ('Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night', 'Perry Como'), ('Sleigh Ride', 'The Ronettes'), ('Let Me Go (with Alesso, Florida Georgia Line & watt)', 'Hailee Steinfeld'), ('Group Home', 'Future'), ('Jingle Bells - Remastered 1999', 'Frank Sinatra'), ('Worst In Me', 'Julia Michaels'), ('Bad Romance', 'Lady Gaga'), ('Two Birds, One Stone', 'Drake'), ('Tell Me You Love Me', 'Demi Lovato'), ('GUMMO', '6ix9ine'), ('Coaster', 'Khalid'), ('Sway (feat. Quavo & Lil Yachty)', 'NexXthursday'), ("Don't Judge Me (feat. Future and Swae Lee)", 'Ty Dolla $ign'), ('Escápate Conmigo', 'Wisin'), ('Sit Next to Me', 'Foster The People'), ('Love Galore (feat. Travis Scott)', 'SZA'), ('gucci linen (feat. 2 Chainz)', 'blackbear'), ('Questions', 'Chris Brown'), ('679 (feat. Remy Boyz)', 'Fetty Wap'), ('Champions', 'Kanye West'), ("Don't Say", 'The Chainsmokers'), ('Portland', 'Drake'), ('Échame La Culpa', 'Luis Fonsi'), ('20 Min', 'Lil Uzi Vert'), ('O Little Town of Bethlehem', 'Elvis Presley'), ('Supercut', 'Lorde'), ('Whatever (feat. Future, Young Thug, Rick Ross & 2 Chainz)', 'DJ Khaled'), ('Too Good At Goodbyes', 'Sam Smith'), ('Bad At Love', 'Halsey'), ('Chicken Fried', 'Zac Brown Band'), ("Stunting Ain't Nuthin (feat. Slim Jxmmi & Young Dolph)", 'Gucci Mane'), ('Audition (The Fools Who Dream) - From "La La Land" Soundtrack', 'Emma Stone'), ('Without You (feat. Sandro Cavazza)', 'Avicii'), ('Marry Me', 'Thomas Rhett'), ('Chantaje (feat. Maluma)', 'Shakira'), ('PRIDE.', 'Kendrick Lamar'), ('Cut To The Feeling', 'Carly Rae Jepsen'), ('In The End', 'Linkin Park'), ('Reggaetón Lento (Remix)', 'CNCO'), ('We Wish You A Merry Christmas', 'John Denver'), ('Running Back (feat. Lil Wayne)', 'Wale'), ('Cold Water (feat. Justin Bieber & MØ)', 'Major Lazer'), ('wokeuplikethis*', 'Playboi Carti'), ('Mink Flow', 'Future'), ('Mess Is Mine', 'Vance Joy'), ('Famous', '21 Savage'), ("I Ain't Got Time!", 'Tyler, The Creator'), ('Look at Me!', 'XXXTENTACION'), ('Disrespectful', '21 Savage'), ("I'm Shipping Up To Boston", 'Dropkick Murphys'), ('Iced Out (feat. 2 Chainz)', 'Lil Pump'), ('Final Song', 'MØ'), ('Both (feat. Drake & Lil Wayne) - Remix', 'Gucci Mane'), ('Sweat', 'The All-American Rejects'), ('Chloraseptic (feat. Phresher)', 'Eminem'), ('Huncho Jack', 'Huncho Jack'), ('La Modelo', 'Ozuna'), ('You Can Call Me Al', 'Paul Simon'), ('Mi Gente', 'J Balvin'), ("Buy U a Drank (Shawty Snappin')", 'T-Pain'), ("You Don't Do It For Me Anymore", 'Demi Lovato'), ('Liability (Reprise)', 'Lorde'), ('U Said', 'Lil Peep'), ('Want You Back', 'HAIM'), ('Disco Tits', 'Tove Lo'), ('A Million Dreams', 'Ziv Zaifman'), ("It Wasn't Me", 'Shaggy'), ('Happier', 'Ed Sheeran'), ('Nowhere Fast (feat. Kehlani)', 'Eminem'), ('Thug Life', '21 Savage'), ('Halfway Off The Balcony', 'Big Sean'), ('Zoom', 'Future'), ('Thunder', 'Imagine Dragons'), ('Undefeated (feat. 21 Savage)', 'A Boogie Wit da Hoodie'), ('Provider', 'Frank Ocean'), ('Nothin New', '21 Savage'), ('Would You Ever', 'Skrillex'), ('Early 20 Rager', 'Lil Uzi Vert'), ('Still Got Time', 'ZAYN'), ('Misunderstood', 'PnB Rock'), ('Up', 'Desiigner'), ('New', 'Daya'), ('Respect', 'Aretha Franklin'), ('Pop Style', 'Drake'), ('You Got Lucky', 'Tom Petty and the Heartbreakers'), ('You & Me', 'Marc E. Bassy'), ('Feel Me', 'Tyga'), ('Kelly Price (feat. Travis Scott)', 'Migos'), ('Bad Mood', 'Miley Cyrus'), ('FaceTime', '21 Savage'), ('The A Team', 'Ed Sheeran'), ('What If', 'Kevin Gates'), ("She's My Collar (feat. Kali Uchis)", 'Gorillaz'), ('A Guy With a Girl', 'Blake Shelton'), ('ELEMENT.', 'Kendrick Lamar'), ('Greatest Love Story', 'LANCO'), ("Stop Draggin' My Heart Around (with Tom Petty & the Heartbreakers) - 2016 Remaster; Remastered", 'Stevie Nicks'), ('Seeing Blind', 'Niall Horan'), ('Attention', 'The Weeknd'), ('Kiss', 'Prince'), ('Learn To Let Go', 'Kesha'), ('Hard Feelings/Loveless', 'Lorde'), ('DEVASTATED', 'Joey Bada$$'), ('Havana - Remix', 'Camila Cabello'), ('Up', 'NAV'), ('Close My Eyes', '21 Savage'), ('Jump Out The Window', 'Big Sean'), ('Yours', 'Russell Dickerson'), ('Either Way', 'Chris Stapleton'), ('Please Shut Up', 'A$AP Mob'), ('Money Trees', 'Kendrick Lamar'), ('A Different Way (with Lauv)', 'DJ Snake'), ('Whole Lot', '21 Savage'), ('Erase Your Social', 'Lil Uzi Vert'), ('Blem', 'Drake'), ('All of Me', 'John Legend'), ("In Case You Didn't Know", 'Brett Young'), ('Lust for Life (with The Weeknd)', 'Lana Del Rey'), ("Who's Stopping Me (& Metro Boomin)", 'Big Sean'), ('Shot Down', 'Khalid'), ('Sunset Lover', 'Petit Biscuit'), ('Issues', 'Julia Michaels'), ('Spoonman', 'Soundgarden'), ('Garden Shed', 'Tyler, The Creator'), ('Whitney (feat. Chief Keef)', 'Lil Pump'), ('T-Shirt (Spotify Mix) - Recorded at Spotify Studios NYC', 'Migos'), ('Bedroom Floor', 'Liam Payne'), ('Idfc', 'blackbear'), ('Moves', 'Big Sean'), ('From the Dining Table', 'Harry Styles'), ('Losing Sleep', 'Chris Young'), ('Now and Later', 'Sage The Gemini'), ('Come On Eileen', 'Dexys Midnight Runners'), ('A Nightmare on My Street', 'DJ Jazzy Jeff & The Fresh Prince'), ('Massage In My Room', 'Future'), ('Angel', 'Fifth Harmony'), ('Monster Mash', 'Bobby "Boris" Pickett & The Crypt-Kickers'), ('Se Preparó', 'Ozuna'), ('Where This Flower Blooms', 'Tyler, The Creator'), ('Go For Broke (feat. James Arthur)', 'Machine Gun Kelly'), ('Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording', 'Judy Garland'), ('No Scrubs', 'TLC'), ('Bodak Yellow', 'Cardi B'), ('Neon Guts (feat. Pharrell Williams)', 'Lil Uzi Vert'), ('Mask Off - Remix', 'Future'), ("I'll Be Home For Christmas - Single Version", 'Bing Crosby'), ('Love So Soft', 'Kelly Clarkson'), ('Two Ghosts', 'Harry Styles'), ('Crew (feat. Brent Faiyaz & Shy Glizzy)', 'GoldLink'), ('Thriller', 'Michael Jackson'), ('Poker Face', 'Lady Gaga'), ("Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus]", 'Lou Monte'), ('Lighthouse - Andrelli Remix', 'Hearts & Colors'), ('Stay With Me', 'Sam Smith'), ('Jingle Bells (feat. The Puppini Sisters)', 'Michael Bublé'), ('10 Feet Down', 'NF'), ('Get You (feat. Kali Uchis)', 'Daniel Caesar'), ('Poor Fool', '2 Chainz'), ('Smoke My Dope (feat. Smokepurpp)', 'Lil Pump'), ('Better Off - Dying', 'Lil Peep'), ('Never Be the Same', 'Camila Cabello'), ('September Song', 'JP Cooper'), ('Love on the Weekend', 'John Mayer'), ('Work from Home (feat. Ty Dolla $ign)', 'Fifth Harmony'), ('Hometown Girl', 'Josh Turner'), ("Don't Let Me Down", 'The Chainsmokers'), ('Skrt On Me (feat. Nicki Minaj)', 'Calvin Harris'), ("Family Don't Matter (feat. Millie Go Lightly)", 'Young Thug'), ('Mayores', 'Becky G'), ('Passionfruit', 'Drake'), ('Black Beatles', 'Rae Sremmurd'), ('0 To 100 / The Catch Up', 'Drake'), ('Submission (feat. Danny Brown & Kelela)', 'Gorillaz'), ('Boys', 'Charli XCX'), ('Smoke Break (feat. Future)', 'Chance the Rapper'), ('Damage', 'Future'), ('Beamer Boy', 'Lil Peep'), ('Hey Ya! - Radio Mix / Club Mix', 'OutKast'), ('When You Look Like That', 'Thomas Rhett'), ('Slide (feat. Frank Ocean & Migos)', 'Calvin Harris'), ('In The Arms Of A Stranger - Grey Remix', 'Mike Posner'), ('Money Problems / Benz Truck', 'Bryson Tiller'), ('Magnolia', 'Playboi Carti'), ('Liability', 'Lorde'), ('Mouth Of The River', 'Imagine Dragons'), ('Both Eyes Closed (feat. 2 Chainz and Young Dolph)', 'Gucci Mane'), ('Sorry', 'Future'), ('You & Me', 'Marshmello'), ('Rubbin off the Paint', 'YBN Nahmir'), ('Sober', 'G-Eazy'), ('Something New (feat. Ty Dolla $ign)', 'Wiz Khalifa'), ('24K Magic', 'Bruno Mars'), ('Ghostbusters', 'Ray Parker, Jr.'), ('Outro: Her', 'BTS'), ('Change', 'J. Cole'), ('Starboy', 'The Weeknd'), ('The Waiting', 'Tom Petty and the Heartbreakers'), ('Dangerous Woman', 'Ariana Grande'), ('Intro: Serendipity', 'BTS'), ('Whippin (feat. Felix Snow)', 'Kiiara'), ('How Would You Feel (Paean)', 'Ed Sheeran'), ("Don't Wanna Know", 'Maroon 5'), ('One Foot', 'WALK THE MOON'), ('Water', 'Ugly God'), ('Beast Mode (feat. PnB Rock & YoungBoy Never Broke Again)', 'A Boogie Wit da Hoodie'), ('Cheap Thrills', 'Sia'), ('Ink Blot', 'Logic'), ('Scars To Your Beautiful', 'Alessia Cara'), ("Hearts Don't Break Around Here", 'Ed Sheeran'), ('Pothole', 'Tyler, The Creator'), ('Wicked', 'Future'), ('Bohemian Rhapsody - Remastered 2011', 'Queen'), ("What U Sayin' (feat. Smokepurpp)", 'Lil Pump'), ('You Broke Up with Me', 'Walker Hayes'), ('Trap Paris (feat. Quavo & Ty Dolla $ign)', 'Machine Gun Kelly'), ('J-Boy', 'Phoenix'), ('Black SpiderMan', 'Logic'), ('Depression & Obsession', 'XXXTENTACION'), ('do re mi', 'blackbear'), ('Love Myself', 'Hailee Steinfeld'), ('The Greatest', 'Sia'), ('Broken Clocks', 'SZA'), ('D Rose', 'Lil Pump'), ('River - Recorded At RAK Studios, London', 'Sam Smith'), ('Thrift Shop (feat. Wanz)', 'Macklemore & Ryan Lewis'), ('Pills & Automobiles', 'Chris Brown'), ('FEAR.', 'Kendrick Lamar'), ('Immortal', 'J. Cole'), ('My Collection', 'Future'), ('A Violent Noise', 'The xx'), ('You Belong With Me', 'Taylor Swift'), ('Instruction (feat. Demi Lovato & Stefflon Don)', 'Jax Jones'), ('No Lies (feat. Wiz Khalifa)', 'Ugly God'), ('Versatile', 'Kodak Black'), ('goosebumps', 'Travis Scott'), ('Setting Fires', 'The Chainsmokers'), ('Hard to Love (feat. Jessie Reyez)', 'Calvin Harris'), ('All Falls Down (feat. Juliander)', 'Alan Walker'), ('Uptown Funk', 'Mark Ronson'), ('Rainbowland', 'Miley Cyrus'), ('Feels Great (feat. Fetty Wap & CVBZ)', 'Cheat Codes'), ('Style', 'Taylor Swift'), ('Foreword', 'Tyler, The Creator'), ('1942 Flows', 'Meek Mill'), ('The Christmas Song (Merry Christmas To You)', 'Nat King Cole'), ('Bigger Than Me', 'Big Sean'), ('The Weekend', 'SZA'), ('Sign of the Times', 'Harry Styles'), ('Uber Everywhere', 'MadeinTYO'), ('No Type', 'Rae Sremmurd'), ('Redbone', 'Childish Gambino'), ('Let Her Go', 'Passenger'), ('Wolves', 'Selena Gomez'), ('Written in the Sand', 'Old Dominion'), ('Ophelia', 'The Lumineers'), ('Congratulations - Remix', 'Post Malone'), ('Party In The U.S.A.', 'Miley Cyrus'), ('Tu Sabes Que Te Quiero', 'Chucho Flash'), ('Twelve Days Of Christmas - Single Version', 'Bing Crosby'), ('Me You', 'Russ'), ('I Got You', 'Bebe Rexha'), ('White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London', 'George Ezra'), ('Grave', 'Thomas Rhett'), ('Earned It (Fifty Shades Of Grey)', 'The Weeknd'), ('I Have Questions', 'Camila Cabello'), ('Blowing Smoke', 'Bryson Tiller'), ('Big On Big', 'Migos'), ('The Cure', 'Lady Gaga'), ('Now Or Never', 'Halsey'), ('Bibia Be Ye Ye', 'Ed Sheeran'), ('Too Much Sauce', 'DJ Esco'), ('Oceans Away', 'A R I Z O N A'), ('Bartier Cardi (feat. 21 Savage)', 'Cardi B'), ('Ayala (Outro)', 'XXXTENTACION'), ('Yeah Right', 'Vince Staples'), ('Rain Interlude', 'Bryson Tiller'), ('I Write Sins Not Tragedies', 'Panic! At The Disco'), ('Havana', 'Camila Cabello'), ('Big Bidness (& Metro Boomin)', 'Big Sean'), ('Betrayed', 'Lil Xan'), ('Good Drank', '2 Chainz'), ('Culture (feat. DJ Khaled)', 'Migos'), ('History', 'Olivia Holt'), ('Up All Night', 'Beck'), ('anxiety (with FRND)', 'blackbear'), ('American Teen', 'Khalid'), ('Santeria', 'Sublime'), ("You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas'", 'Thurl Ravenscroft'), ('Sweetheart', 'Thomas Rhett'), ('Him & I (with Halsey)', 'G-Eazy'), ('UnFazed (feat. The Weeknd)', 'Lil Uzi Vert'), ('I Took A Pill In Ibiza - Seeb Remix', 'Mike Posner'), ('Star Of The Show', 'Thomas Rhett'), ('Obsession (feat. Jon Bellion)', 'Vice'), ('Unforgettable', 'French Montana'), ('Thunder / Young Dumb & Broke (with Khalid) - Medley', 'Imagine Dragons'), ('Offended', 'Eminem'), ('Treat You Better', 'Shawn Mendes'), ('Telephone', 'Lady Gaga'), ('Beautiful People Beautiful Problems (feat. Stevie Nicks)', 'Lana Del Rey'), ('Hypnotised', 'Coldplay'), ("You Don't Know Me - Radio Edit", 'Jax Jones'), ('Homemade Dynamite - REMIX', 'Lorde'), ('This Is Me', 'Keala Settle'), ('Iris', 'The Goo Goo Dolls'), ('Billie Jean', 'Michael Jackson'), ('Good Life (with G-Eazy & Kehlani)', 'G-Eazy'), ('Johnny B. Goode', 'Chuck Berry'), ('Twist And Shout - Remastered', 'The Beatles'), ('King Of My Heart', 'Taylor Swift'), ('Let Me Explain', 'Bryson Tiller'), ('Fuck Ugly God', 'Ugly God'), ('Here Comes Santa Claus (Right Down Santa Claus Lane)', 'Gene Autry'), ('No Limit', 'G-Eazy'), ('Easy Love', 'Lauv'), ('MIC Drop', 'BTS'), ('Pull Up N Wreck (& Metro Boomin)', 'Big Sean'), ('So Good (feat. Ty Dolla $ign)', 'Zara Larsson'), ('American Dream (feat. J.Cole, Kendrick Lamar)', 'Jeezy'), ('Still Here', 'Drake'), ('On Hold', 'The xx'), ('Take It Back', 'Logic'), ('The Race', '22 Savage'), ('Issues (feat. Russ)', 'PnB Rock'), ('Winter Wonderland', 'Bing Crosby'), ('Gassed Up', 'Nebu Kiniza'), ('Patty Cake', 'Kodak Black'), ('Happy - From "Despicable Me 2"', 'Pharrell Williams'), ('The Day I Tried To Live', 'Soundgarden'), ('Is That For Me', 'Alesso'), ('Mixtape (feat. Young Thug & Lil Yachty)', 'Chance the Rapper'), ('Audi.', 'Smokepurpp'), ('The Brightside', 'Lil Peep'), ('Fetish (feat. Gucci Mane)', 'Selena Gomez'), ('Me and Julio Down by the Schoolyard', 'Paul Simon'), ('100 Letters', 'Halsey'), ('Somethin Tells Me', 'Bryson Tiller'), ('Spice Girl', 'Aminé'), ('O Come, All Ye Faithful', 'Pentatonix'), ('Lose You', 'Drake'), ('There He Go', 'Kodak Black'), ('Hallelujah', 'Pentatonix'), ('Bounce Back', 'Big Sean'), ('Younger Now', 'Miley Cyrus'), ('Weak', 'AJR'), ('Sweet Home Alabama', 'Lynyrd Skynyrd'), ('River (feat. Ed Sheeran)', 'Eminem'), ('Feels So Good', 'A$AP Mob'), ("Can't Feel My Face", 'The Weeknd'), ('Kids in Love', 'Kygo'), ('Controlla', 'Drake'), ('Prayers Up (feat. Travis Scott & A-Trak)', 'Calvin Harris'), ("bright pink tims (feat. Cam'ron)", 'blackbear'), ('The Race', 'Tay-K'), ('Feelings Mutual', 'Lil Uzi Vert'), ('How Long (feat. French Montana) - Remix', 'Charlie Puth'), ('Help Me Out', 'Maroon 5'), ('X (feat. Future)', '21 Savage'), ("'Till I Collapse", 'Eminem'), ('Privacy', 'Chris Brown'), ('Find You', 'Nick Jonas'), ('Dark Knight Dummo (Feat. Travis Scott)', 'Trippie Redd'), ('So Am I (feat. Damian Marley & Skrillex)', 'Ty Dolla $ign'), ('...Baby One More Time - Recorded at Spotify Studios NYC', 'Ed Sheeran'), ('Monster Mash', 'Bobby "Boris" Pickett'), ('Cold December Night', 'Michael Bublé'), ('Congratulations', 'Post Malone'), ('I Dare You', 'The xx'), ('Malfunction', 'Lil Uzi Vert'), ('ABC', 'The Jackson 5'), ('Legend', 'Drake'), ('Death Of A Bachelor', 'Panic! At The Disco'), ('Do What I Want', 'Lil Uzi Vert'), ('Skepta Interlude', 'Drake'), ('No Promises', 'A Boogie Wit da Hoodie'), ('All I Want for Christmas Is You', 'Michael Bublé'), ('American Girl', 'Tom Petty and the Heartbreakers'), ("It Won't Kill Ya", 'The Chainsmokers'), ('Even The Losers', 'Tom Petty and the Heartbreakers'), ('Living Single', 'Big Sean'), ('Perplexing Pegasus', 'Rae Sremmurd'), ('BOOGIE', 'BROCKHAMPTON'), ('Let It Snow! Let It Snow! Let It Snow!', 'Dean Martin'), ('Writer In The Dark', 'Lorde'), ('Burning', 'Sam Smith'), ('All Night', 'The Vamps'), ('Money Team', 'Friyie'), ('Perfect', 'Ed Sheeran'), ('At My Best (feat. Hailee Steinfeld)', 'Machine Gun Kelly'), ('Ghostface Killers', '21 Savage'), ('Keep Quiet', 'Future'), ('Call Casting', 'Migos'), ('High For Hours', 'J. Cole'), ('Wyclef Jean', 'Young Thug'), ('Scars', 'Sam Smith'), ("Ain't No Mountain High Enough", 'Marvin Gaye'), ('So It Goes...', 'Taylor Swift'), ("You Can't Hurry Love - 2016 Remastered", 'Phil Collins'), ('Vuelve', 'Daddy Yankee'), ('Jingle Bell Rock', 'Bobby Helms'), ('Nothings Into Somethings', 'Drake'), ('Reason (& Metro Boomin)', 'Big Sean'), ('Dab of Ranch - Recorded at Spotify Studios NYC', 'Migos'), ("Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975", 'Bruce Springsteen'), ('True Feeling', 'Galantis'), ('Always (Outro)', 'Bryson Tiller'), ('Sooner Or Later', 'Aaron Carter'), ("Santa's Coming For Us", 'Sia'), ('Just Dance', 'Lady Gaga'), ('Ice Melts', 'Drake'), ('Jump', 'French Montana'), ("Any Ol' Barstool", 'Jason Aldean'), ('Heatstroke', 'Calvin Harris'), ('You Spin Me Round (Like a Record)', 'Dead Or Alive'), ('Miss You', 'Louis Tomlinson'), ('Party Monster', 'The Weeknd'), ('Stand by Me', 'Otis Redding'), ('Carry On', 'XXXTENTACION'), ('In Your Head', 'Eminem'), ("All We Got (feat. Kanye West & Chicago Children's Choir)", 'Chance the Rapper'), ('Madiba Riddim', 'Drake'), ('Never Let You Go', 'Kygo'), ('Tone it Down (feat. Chris Brown)', 'Gucci Mane'), ('Arrows', 'Foo Fighters'), ('Changing', 'John Mayer'), ('Happy Xmas (War Is Over) - Remastered', 'John Lennon'), ('Pretty Mami', 'Lil Uzi Vert'), ('I Want You Back', 'The Jackson 5'), ('False Alarm', 'The Weeknd'), ("Jingle Bell Rock - Daryl's Version", 'Daryl Hall & John Oates'), ('Poles 1469', 'Trippie Redd'), ('Motorcycle Patches', 'Huncho Jack'), ('The Night We Met', 'Lord Huron'), ('Jingle Bell Rock (Glee Cast Version)', 'Glee Cast'), ('Home (with Machine Gun Kelly, X Ambassadors & Bebe Rexha)', 'Machine Gun Kelly'), ('Never Enough', 'Loren Allred'), ('Peepin out the Blinds', 'Gucci Mane'), ("Anything That's Rock 'N' Roll", 'Tom Petty and the Heartbreakers'), ('All Me', 'Drake'), ('Here We Come a-Caroling / We Wish You a Merry Christmas', 'Perry Como'), ('Feliz Navidad', 'José Feliciano'), ('Looking for a Star', 'XXXTENTACION'), ('Stop Smoking Black & Milds', 'Ugly God'), ('Run For Cover', 'The Killers'), ('Forgiveness', 'Paramore'), ('What About Us', 'P!nk'), ('LOYALTY. FEAT. RIHANNA.', 'Kendrick Lamar'), ('Plot Twist', 'Marc E. Bassy'), ('No Option', 'Post Malone'), ('The One', 'The Chainsmokers'), ('You Got It', 'Bryson Tiller'), ("Don't Stop Believin'", 'Journey'), ('No Vacancy', 'OneRepublic'), ('Real Friends', 'Camila Cabello'), ('One More Light', 'Linkin Park'), ('Shake It Off', 'Taylor Swift'), ('May I Have This Dance (Remix) [feat. Chance the Rapper]', 'Francis and the Lights'), ('Better Man', 'Little Big Town'), ('Have Yourself a Merry Little Christmas', 'Michael Bublé'), ('Pull a Caper (feat. Kodak Black, Gucci Mane & Rick Ross)', 'DJ Khaled'), ('Last Christmas', 'Wham!'), ('Father Stretch My Hands Pt. 1', 'Kanye West'), ('Sorry Not Sorry', 'Demi Lovato'), ("How Far I'll Go", "Auli'i Cravalho"), ('Love Scars', 'Trippie Redd'), ('Me, Myself & I', 'G-Eazy'), ('Skinny Love', 'Bon Iver'), ('Little Saint Nick - 1991 Remix', 'The Beach Boys'), ('Cochise', 'Audioslave'), ('Downtown', 'Anitta'), ('Dark Queen', 'Lil Uzi Vert'), ('Whiskey (feat. A$AP Rocky)', 'Maroon 5'), ('Come Over', 'Trey Songz'), ('O Tannenbaum', 'Nat King Cole'), ('A L I E N S', 'Coldplay'), ('Rudolph The Red-Nosed Reindeer', 'Burl Ives'), ("I'm a Nasty Hoe", 'Ugly God'), ('All da Smoke', 'Future'), ('The Beautiful & Damned', 'G-Eazy'), ('Sweet Creature', 'Harry Styles'), ('Emoji of a Wave', 'John Mayer'), ('Ordinary Life', 'The Weeknd'), ('200', 'Future'), ('4 da Gang', 'Future'), ('Call Me Maybe', 'Carly Rae Jepsen'), ('Another Day Of Sun - From "La La Land" Soundtrack', 'La La Land Cast'), ('Cherry Hill', 'Russ'), ('Testify', 'Future'), ('Fake Love', 'Drake'), ('Lemon', 'N.E.R.D'), ("I'll Name the Dogs", 'Blake Shelton'), ('Pied Piper', 'BTS'), ('Too Good At Goodbyes - Edit', 'Sam Smith'), ('do re mi (feat. Gucci Mane)', 'blackbear'), ('Fuck That Check Up (feat. Lil Uzi Vert)', 'Meek Mill'), ('Neighbors', 'J. Cole'), ('1-800-273-8255', 'Logic'), ('Outlet', 'Desiigner'), ('New Year’s Day', 'Taylor Swift'), ('Not Going Home', 'DVBBS'), ('I Sip', 'Tory Lanez'), ('Shining', 'DJ Khaled'), ('Everyday', 'Ariana Grande'), ('Stay (with Alessia Cara)', 'Zedd'), ('Lift Me Up - Michael Brun Remix', 'OneRepublic'), ('Summer Friends (feat. Jeremih & Francis & The Lights)', 'Chance the Rapper'), ('Oh Lord', 'MiC LOWRY'), ("Why Don't You Come On", 'DJDS'), ('The Heart Part 4', 'Kendrick Lamar'), ('Lose Yourself - From "8 Mile" Soundtrack', 'Eminem'), ('Moon Rock', 'Huncho Jack'), ('Dirt On My Boots', 'Jon Pardi'), ('Thriller - 2003 Edit', 'Michael Jackson'), ('Perfect Pint (feat. Kendrick Lamar, Gucci Mane & Rae Sremmurd)', 'Mike WiLL Made-It'), ('Bad Liar', 'Selena Gomez'), ('No Flag', 'London On Da Track'), ('Blue Cheese', '2 Chainz'), ('Midnight Train', 'Sam Smith'), ('Sucker For Pain (with Wiz Khalifa, Imagine Dragons, Logic & Ty Dolla $ign feat. X Ambassadors)', 'Lil Wayne'), ('High Without Your Love', 'Loote'), ('RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko)', 'Joey Bada$$'), ("If I'm Lucky", 'Jason Derulo'), ('Do Not Disturb', 'Drake'), ('oui', 'Jeremih'), ('Wanna Be That Song', 'Brett Eldredge'), ('Rockin’', 'The Weeknd'), ("There's Nothing Holdin' Me Back", 'Shawn Mendes'), ('Call Me', 'NAV'), ('Joy To The World', 'Nat King Cole'), ('Turn On Me', 'Future'), ("I'll Be Home For Christmas - Recorded at Spotify Studios NYC", 'Demi Lovato'), ('Like Home (feat. Alicia Keys)', 'Eminem'), ("Don't Kill My Vibe", 'Sigrid'), ('Unhappy', 'A Boogie Wit da Hoodie'), ('Back On', 'Gucci Mane'), ('Last Day Alive', 'The Chainsmokers'), ('Money Longer', 'Lil Uzi Vert'), ('House Party', 'Sam Hunt'), ('Sauce It Up', 'Lil Uzi Vert'), ('Green Light', 'Lorde'), ('A.D.H.D', 'Kendrick Lamar'), ('All I Want For Christmas (Is My Two Front Teeth) - Remastered', 'Nat King Cole Trio'), ('So Close', 'Andrew McMahon in the Wilderness'), ('Never Be Like You', 'Flume'), ('Paris', 'The Chainsmokers'), ('Middle', 'DJ Snake'), ('Bust Down', 'Trippie Redd'), ('Silver Bells', 'Dean Martin'), ('Andromeda (feat. DRAM)', 'Gorillaz'), ('We Are Young (feat. Janelle Monáe)', 'fun.'), ('Sorry for Now', 'Linkin Park'), ('Blessings', 'Chance the Rapper'), ('Go Flex', 'Post Malone'), ('dimple', 'BTS'), ('Gorgeous', 'Taylor Swift'), ('Break Up Every Night', 'The Chainsmokers'), ('Felices los 4', 'Maluma'), ('Litty (feat. Tory Lanez)', 'Meek Mill'), ('Frat Rules', 'A$AP Mob'), ('MotorSport', 'Migos'), ("(Intro) I'm so Grateful (feat. Sizzla)", 'DJ Khaled'), ('She Will Be Loved - Radio Mix', 'Maroon 5'), ('I Miss You', 'Grey'), ('Bloodstream', 'The Chainsmokers'), ('Wins & Losses', 'Meek Mill'), ('Refugee', 'Tom Petty and the Heartbreakers'), ('Riptide', 'Vance Joy'), ('Lil Favorite (feat. MadeinTYO)', 'Ty Dolla $ign'), ("I Won't Back Down", 'Tom Petty'), ('Craving You', 'Thomas Rhett'), ('Starships', 'Nicki Minaj'), ('Undercover', 'Kehlani'), ('Show Me How to Live', 'Audioslave'), ('F*ck Up Some Commas', 'Future'), ('Let Me Out (feat. Mavis Staples & Pusha T)', 'Gorillaz'), ('Have Yourself A Merry Little Christmas', 'Sam Smith'), ('Rake It Up', 'Yo Gotti'), ('Glorious (feat. Skylar Grey)', 'Macklemore'), ('Dangerous', 'The xx'), ('Unsteady', 'X Ambassadors'), ('Holiday (feat. Snoop Dogg, John Legend & Takeoff)', 'Calvin Harris'), ('Dickriders', 'Gucci Mane'), ('What Christmas Means To Me', 'Stevie Wonder'), ('Flatliner (feat. Dierks Bentley)', 'Cole Swindell'), ('Letterman', 'Wiz Khalifa'), ("Can't Hold Us - feat. Ray Dalton", 'Macklemore & Ryan Lewis'), ('Trap Trap Trap', 'Rick Ross'), ('Lay It On Me', 'Vance Joy'), ("Don't Stop Me Now - Remastered", 'Queen'), ('Yesterday', 'Imagine Dragons'), ('Versace On The Floor', 'Bruno Mars'), ('Antidote', 'Travis Scott'), ('Feel It', 'Young Thug'), ('No Hearts, No Love (& Metro Boomin)', 'Big Sean'), ('Awful Things', 'Lil Peep'), ('Baby, You Make Me Crazy', 'Sam Smith'), ('Childs Play', 'Drake'), ('They Like', 'Yo Gotti'), ('444+222', 'Lil Uzi Vert'), ('We Got The Power (feat. Jehnny Beth)', 'Gorillaz'), ('Numb / Encore', 'JAY Z'), ('More Than You Know', 'Axwell /\\ Ingrosso'), ('Homemade Dynamite (Feat. Khalid, Post Malone & SZA) - REMIX', 'Lorde'), ('Side To Side', 'Ariana Grande'), ('Trust Nobody (feat. Selena Gomez & Tory Lanez)', 'Cashmere Cat'), ('Outshined', 'Soundgarden'), ('This Is Halloween', 'The Citizens of Halloween'), ('Sorry', 'Justin Bieber'), ('Total Eclipse of The Heart', 'Bonnie Tyler'), ("Say A'", 'A Boogie Wit da Hoodie'), ('Sunday Morning Jetpack', 'Big Sean'), ("Transportin'", 'Kodak Black'), ('Welcome To New York', 'Taylor Swift'), ('Gucci Gang', 'Lil Pump'), ('Stressed Out', 'Twenty One Pilots'), ('OOOUUU', 'Young M.A'), ('U Aint Never', 'Kodak Black'), ('iSpy (feat. Lil Yachty)', 'KYLE'), ('FOR MY PEOPLE', 'Joey Bada$$'), ('Modern Slavery', 'Huncho Jack'), ('Burden In My Hand', 'Soundgarden'), ('Horses (with PnB Rock, Kodak Black & A Boogie Wit da Hoodie)', 'PnB Rock'), ('Rewrite The Stars', 'Zac Efron'), ('Gave Your Love Away', 'Majid Jordan'), ('BLOOD.', 'Kendrick Lamar'), ('Thinking out Loud', 'Ed Sheeran'), ('Distraction', 'Kehlani'), ('Rent Money', 'Future'), ('Out Yo Way', 'Migos'), ('Ex (feat. YG)', 'Ty Dolla $ign'), ('Helpless', 'John Mayer'), ('HIM', 'Sam Smith'), ('Comin Out Strong (feat. The Weeknd)', 'Future'), ('Will He', 'Joji'), ('Me Rehúso', 'Danny Ocean'), ('Ruin The Friendship', 'Demi Lovato'), ('What Lovers Do', 'Maroon 5'), ('Rockabye (feat. Sean Paul & Anne-Marie)', 'Clean Bandit'), ('Might as Well', 'Future'), ('Feels (feat. Pharrell Williams, Katy Perry & Big Sean)', 'Calvin Harris'), ('Homemade Dynamite', 'Lorde'), ("Don't Get Too High", 'Bryson Tiller'), ("It's the Most Wonderful Time of the Year", 'Andy Williams'), ('Reminder - Remix', 'The Weeknd'), ('Minute', 'NAV'), ('Come and See Me (feat. Drake)', 'PARTYNEXTDOOR'), ('Drugs', 'August Alsina'), ('Blank Space', 'Taylor Swift'), ('Skir Skirr', 'Lil Uzi Vert'), ('Perfect Places', 'Lorde'), ('Dress', 'Taylor Swift'), ('Riverdale Rd', '2 Chainz'), ('You Make My Dreams', 'Daryl Hall & John Oates'), ('No Such Thing as a Broken Heart', 'Old Dominion'), ('Brown Paper Bag', 'Migos'), ('Love Story', 'Taylor Swift'), ('Bad Things (with Camila Cabello)', 'Machine Gun Kelly'), ('Love (feat. Rae Sremmurd)', 'ILoveMakonnen'), ("I Just Can't", 'R3HAB'), ('The Other Side', 'Hugh Jackman'), ('Run Up the Racks', '21 Savage'), ('Touch', 'Little Mix'), ('My Shit', 'A Boogie Wit da Hoodie'), ('Same Drugs', 'Chance the Rapper'), ('Love Me Now', 'John Legend'), ('BABYLON (feat. Chronixx)', 'Joey Bada$$'), ('Heathens', 'Twenty One Pilots'), ('Hallucinating', 'Future'), ('Realize', '2 Chainz'), ('Down for Life (feat. PARTYNEXTDOOR, Future, Travis Scott, Rick Ross & Kodak Black)', 'DJ Khaled'), ('T-Shirt', 'Migos'), ('Know No Better (feat. Travis Scott, Camila Cabello & Quavo)', 'Major Lazer'), ('Nightmare', 'Offset'), ('Castle on the Hill', 'Ed Sheeran'), ('Titanium (feat. Sia)', 'David Guetta'), ('Die For You', 'The Weeknd'), ('Get It Right (feat. MØ)', 'Diplo'), ('Idols Become Rivals', 'Rick Ross'), ('美女と野獣', 'Ariana Grande'), ('Sky Walker (feat. Travis Scott)', 'Miguel'), ('Chill Bill', 'Rob $tone'), ("Don't", 'Ed Sheeran'), ('Pray For Me', 'G-Eazy'), ('Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC', 'Fifth Harmony'), ('The Mack', 'Nevada'), ('Inspire Me', 'Big Sean'), ('Saint', 'Huncho Jack'), ('Santa Claus Is Coming to Town', 'Michael Bublé'), ('One Night', 'Lil Yachty'), ('Stronger', 'Kanye West'), ('Come Through and Chill', 'Miguel'), ('Met Gala (feat. Offset)', 'Gucci Mane'), ('One Last Song', 'Sam Smith'), ("Sugar, We're Goin Down", 'Fall Out Boy'), ('Why', 'Sabrina Carpenter'), ('Sensualidad', 'Bad Bunny'), ('Dance of the Sugar Plum Fairy', 'Pentatonix'), ('You Wreck Me', 'Tom Petty'), ('Extra Luv', 'Future'), ('Rusty Cage', 'Soundgarden'), ('No Peace', 'Sam Smith'), ('Faking It (feat. Kehlani & Lil Yachty)', 'Calvin Harris'), ('Mistletoe And Holly - Remastered 1999', 'Frank Sinatra'), ('XO TOUR Llif3', 'Lil Uzi Vert'), ("The Apprentice (feat. Rag'n'Bone Man, Zebra Katz & RAY BLK)", 'Gorillaz'), ('Bank Account', '21 Savage'), ('Dynamite (feat. Pretty Sister)', 'Nause'), ('911 / Mr. Lonely', 'Tyler, The Creator'), ('Wait', 'Maroon 5'), ('Rap God', 'Eminem'), ("I Can't Even Lie (feat. Future & Nicki Minaj)", 'DJ Khaled'), ('Crying in the Club', 'Camila Cabello'), ('Rap Saved Me', '21 Savage'), ('White Iverson', 'Post Malone'), ('Real Love', 'Future'), ('Killed Before', 'Young Thug'), ('Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix', 'Lana Del Rey'), ('Say Something Loving', 'The xx'), ('Dive', 'Ed Sheeran'), ('Numb', '21 Savage'), ('Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet)', 'Frank Sinatra'), ("She's Mine Pt. 2", 'J. Cole'), ('Swish Swish', 'Katy Perry'), ('LOVE. FEAT. ZACARI.', 'Kendrick Lamar'), ('Black Hole Sun', 'Soundgarden'), ('Nothing Left For You', 'Sam Smith'), ('Rainbow', 'Kesha'), ('Dubai Shit', 'Huncho Jack'), ('All I Want for Christmas Is You', 'Mariah Carey'), ('Same Time Pt. 1', 'Big Sean'), ('A-YO', 'Lady Gaga'), ('Intro', 'Big Sean'), ('Either Way (feat. Joey Bada$$)', 'Snakehips'), ('Glow', 'Drake'), ('Meet Me in the Hallway', 'Harry Styles'), ('Ice Tray', 'Quality Control'), ('Everyday We Lit (Remix)', 'YFN Lucci'), ('Gyalchester', 'Drake'), ('Bring It Back (with Drake & Mike WiLL Made-It)', 'Trouble'), ('Up Down (Feat. Florida Georgia Line)', 'Morgan Wallen'), ('Waiting Room', 'Logic'), ('Some Kind Of Drug', 'G-Eazy'), ('Light My Body Up (feat. Nicki Minaj & Lil Wayne)', 'David Guetta'), ('Low Life', 'Future'), ('Built My Legacy (feat. Offset)', 'Kodak Black'), ('Silence', 'Marshmello'), ('New Rules', 'Dua Lipa'), ("Blowin' Minds (Skateboard)", 'A$AP Mob'), ('You Shook Me All Night Long', 'AC/DC'), ('m.A.A.d city', 'Kendrick Lamar'), ('Day For Day', 'Kodak Black'), ("Droppin' Seeds", 'Tyler, The Creator'), ('BYF', 'A$AP Mob'), ('Rich Ass Junkie', 'Gucci Mane'), ('Take Me To Church', 'Hozier'), ('Feels Like Summer', 'Weezer'), ('Get Right Witcha', 'Migos'), ('PIE', 'Future'), ('everybody dies', 'J. Cole'), ('Christmas Time Is Here - Vocal', 'Vince Guaraldi Trio'), ('Look What You Made Me Do', 'Taylor Swift'), ('Shining (feat. Beyoncé & Jay-Z)', 'DJ Khaled'), ('Come and Get Your Love - Single Edit', 'Redbone'), ('New Freezer (feat. Kendrick Lamar)', 'Rich The Kid'), ('Up In Here', 'Kodak Black'), ('Criminal', 'Natti Natasha'), ('On + Off', 'Maggie Rogers'), ('Nothing Wrong', 'G-Eazy'), ("That's It (feat. Gucci Mane & 2 Chainz)", 'Bebe Rexha'), ('pick up the phone', 'Young Thug'), ('Black Card', 'A$AP Mob'), ('Remember I Told You', 'Nick Jonas'), ("Runnin' Down A Dream", 'Tom Petty'), ('DNA.', 'Kendrick Lamar'), ('Carolina', 'Harry Styles'), ('Say It First', 'Sam Smith'), ("It's Secured (feat. Nas & Travis Scott)", 'DJ Khaled'), ('The First Noel - Remastered 1999', 'Frank Sinatra'), ('Bon appétit', 'Katy Perry'), ('Cherry', 'Lana Del Rey'), ('Mele Kalikimaka - Single Version', 'Bing Crosby'), ('Eyes Closed', 'Halsey'), ('Meant to Be (feat. Florida Georgia Line)', 'Bebe Rexha'), ('Finding You', 'Kesha'), ('May We All', 'Florida Georgia Line'), ('Chained To The Rhythm', 'Katy Perry'), ('Lonely Together (feat. Rita Ora)', 'Avicii'), ('This Is What You Came For', 'Calvin Harris'), ("Don't Quit (feat. Travis Scott & Jeremih)", 'DJ Khaled'), ('Dead Presidents', 'Rick Ross'), ('Barcelona', 'Ed Sheeran'), ('Foreign', 'Lil Pump'), ('Drip on Me', 'Future'), ('Hypnotize - 2014 Remastered Version', 'The Notorious B.I.G.'), ('Whatever You Need (feat. Chris Brown & Ty Dolla $ign)', 'Meek Mill'), ('Love', 'Lana Del Rey'), ('Ville Mentality', 'J. Cole'), ('X Men', 'Lil Yachty'), ('Sneakin’', 'Drake'), ('Keep On', 'Kehlani'), ('Shape of You', 'Ed Sheeran'), ('Rollin', 'Calvin Harris'), ('Unforgettable', 'Thomas Rhett'), ('Ni**as In Paris', 'JAY Z'), ('Darkside (with Ty Dolla $ign & Future feat. Kiiara)', 'Ty Dolla $ign'), ('We Both Know', 'Bryson Tiller'), ('7 Years', 'Lukas Graham'), ('Let Me Love You', 'DJ Snake'), ('Still Feel Like Your Man', 'John Mayer'), ('Young Dumb & Broke', 'Khalid'), ('In Cold Blood', 'alt-J'), ('Palace', 'Sam Smith'), ('Love Is Gone', 'G-Eazy'), ('No Role Modelz', 'J. Cole'), ('In Check', 'Bryson Tiller'), ('Almost Like Praying (feat. Artists for Puerto Rico)', 'Lin-Manuel Miranda'), ('No Flockin', 'Kodak Black'), ('Work In Progress (Intro)', 'Gucci Mane'), ('Raincoat (feat. Shy Martin)', 'Timeflies'), ('Mistletoe', 'Justin Bieber'), ('White Mustang', 'Lana Del Rey'), ('Save Me', 'XXXTENTACION'), ('On My Way', 'Tiësto'), ('Ok', 'Lil Pump'), ('Liife', 'Desiigner'), ('Stay', 'Zedd'), ('Good Dope', 'Future'), ('Mad Stalkers', '21 Savage'), ('Nights With You', 'MØ'), ('Reminder', 'The Weeknd'), ('Since Way Back', 'Drake'), ('Purple Lamborghini (with Rick Ross)', 'Skrillex'), ('Tiimmy Turner', 'Desiigner'), ('Special', '21 Savage'), ('See You Again', 'Tyler, The Creator'), ('All My Love (feat. Conor Maynard)', 'Cash Cash'), ('Bad Business', '21 Savage'), ('No Sleep Leak', 'Lil Uzi Vert'), ('On The Come Up (feat. Big Sean)', 'Mike WiLL Made-It'), ('No Favors', 'Big Sean'), ('This Christmas', 'Chris Brown'), ('Famous', 'Kanye West'), ("Don't Come Around Here No More", 'Tom Petty and the Heartbreakers'), ('Dancing With Our Hands Tied', 'Taylor Swift'), ('Crazy Brazy', 'A$AP Mob'), ('Wishlist', 'Kiiara'), ('All Night', 'Steve Aoki'), ('LEGENDARY (feat. J. Cole)', 'Joey Bada$$'), ('My Girl', 'The Temptations'), ('Biking', 'Frank Ocean'), ('Patek Water', 'Future'), ('Young, Wild & Free (feat. Bruno Mars)', 'Snoop Dogg'), ('This Is Why We Can’t Have Nice Things', 'Taylor Swift'), ('I Would Like', 'Zara Larsson'), ('Waterfall', 'Stargate'), ("You Don't Know How It Feels", 'Tom Petty'), ('White Christmas', 'Bing Crosby'), ('Bad and Boujee (feat. Lil Uzi Vert)', 'Migos'), ('Bad Bitch (feat. Ty Dolla $ign)', 'Bebe Rexha'), ('Deadz (feat. 2 Chainz)', 'Migos'), ('I Get The Bag (feat. Migos)', 'Gucci Mane'), ('Changes', 'Hazers'), ('Darth Vader', '21 Savage'), ('Hallelujah', 'Logic'), ('No Long Talk', 'Drake'), ('I Miss You (feat. Julia Michaels)', 'Clean Bandit'), ('make daddy proud', 'blackbear'), ("Don't Worry Be Happy", 'Bobby McFerrin'), ('Make You Feel My Love', 'Adele'), ('Girls On Boys', 'Galantis'), ('Magic', 'Thomas Gold'), ('All I Can Think About Is You', 'Coldplay'), ('X', 'Lil Uzi Vert'), ('Untouchable', 'Eminem'), ('Steady 1234 (feat. Jasmine Thompson & Skizzy Mars)', 'Vice'), ("Don't Don't Do It!", 'N.E.R.D'), ('Strangers', 'Halsey'), ('Groupie Love (feat. A$AP Rocky)', 'Lana Del Rey'), ('Enormous (feat. Ty Dolla $ign)', 'Gucci Mane'), ('Love Incredible (feat. Camila Cabello)', 'Cashmere Cat'), ('Draco', 'Future'), ('playboy shit (feat. lil aaron)', 'blackbear'), ('The Promise', 'Chris Cornell'), ('California Love - Original Version', '2Pac'), ('Strobelite (feat. Peven Everett)', 'Gorillaz'), ('Mary, Did You Know?', 'Pentatonix'), ('No Smoke', 'YoungBoy Never Broke Again'), ('Rolex', 'Ayo & Teo'), ('Two High', 'Moon Taxi'), ('Ascension (feat. Vince Staples)', 'Gorillaz'), ('Thumbs', 'Sabrina Carpenter'), ('Do You Hear What I Hear?', 'Bing Crosby'), ('Friends (with BloodPop®)', 'Justin Bieber'), ('Dead People', '21 Savage'), ('Good Old Days (feat. Kesha)', 'Macklemore'), ('I Don’t Know Why', 'Imagine Dragons'), ("Say You Won't Let Go", 'James Arthur'), ('Let It Go', 'James Bay'), ('In the Name of Love', 'Martin Garrix'), ('My Way', 'Calvin Harris'), ('You Was Right', 'Lil Uzi Vert'), ('Honest', 'The Chainsmokers'), ('Werewolves of London - 2007 Remaster', 'Warren Zevon'), ('Cash Out (feat. ScHoolboy Q, PARTYNEXTDOOR & D.R.A.M.)', 'Calvin Harris'), ('There for You', 'Martin Garrix'), ('Everyday We Lit (feat. PnB Rock)', 'YFN Lucci'), ('Sorry', 'Halsey'), ('Superstition - Single Version', 'Stevie Wonder'), ('Not Nice', 'PARTYNEXTDOOR'), ("It's A Vibe", '2 Chainz'), ("That's What I Like", 'Bruno Mars'), ('7 Min Freestyle', '21 Savage'), ("Baby, It's Cold Outside (Glee Cast Version)", 'Glee Cast'), ('Skateboard P', 'MadeinTYO'), ('Pretty Girl - Cheat Codes X CADE Remix', 'Maggie Lindemann'), ('Headlines', 'Drake'), ('Wild Thoughts (feat. Rihanna & Bryson Tiller)', 'DJ Khaled'), ('Benz Truck - гелик', 'Lil Peep'), ("Let's Start The New Year Off Right", 'Bing Crosby'), ('Drink A Little Beer', 'Thomas Rhett'), ('Cake - Challenge Version', 'Flo Rida'), ("I Don't Fuck With You", 'Big Sean'), ('Rain On Me (Intro)', 'Bryson Tiller'), ('Scrape', 'Future'), ("Lovin' (feat. A Boogie Wit da Hoodie)", 'PnB Rock'), ('Cruise Ship', 'Young Thug'), ('Black', 'Dierks Bentley'), ('Trap Queen', 'Fetty Wap'), ('KOODA', '6ix9ine'), ('Stranger Things', 'Kygo'), ('New Man', 'Ed Sheeran'), ('I’ll Make It Up To You', 'Imagine Dragons'), ('So Far Away (feat. Jamie Scott & Romy Dya)', 'Martin Garrix'), ('Best Man', 'Huncho Jack'), ('But A Dream', 'G-Eazy'), ('Get to the Money', 'Chad Focus'), ("Signed, Sealed, Delivered (I'm Yours)", 'Stevie Wonder'), ('What The Price', 'Migos'), ('Not Afraid Anymore', 'Halsey'), ('Instinct (feat. MadeinTYO)', 'Roy Woods'), ('Broccoli (feat. Lil Yachty)', 'DRAM'), ('Real Thing (feat. Future)', 'Tory Lanez'), ('Voices In My Head/Stick To The Plan', 'Big Sean'), ('Beautiful Trauma', 'P!nk'), ('Pull Up N Wreck (With Metro Boomin)', 'Big Sean'), ('Miss My Woe (feat. Rico Love)', 'Gucci Mane'), ('Big Amount', '2 Chainz'), ('Holly Jolly Christmas', 'Michael Bublé'), ('Colombia Heights (Te Llamo) [feat. J Balvin]', 'Wale'), ("Don't", 'Bryson Tiller'), ('One Day At A Time', 'Sam Smith'), ('TG4M', 'Zara Larsson'), ('My House', 'Flo Rida'), ('2U (feat. Justin Bieber)', 'David Guetta'), ('No Longer Friends', 'Bryson Tiller'), ('Him & I', 'G-Eazy'), ('Rose-Colored Boy', 'Paramore'), ("Let 'Em Talk", 'Kesha'), ('Tunnel Vision', 'Kodak Black'), ('up in this (with Tinashe)', 'blackbear'), ('LAND OF THE FREE', 'Joey Bada$$'), ('Carnival (feat. Anthony Hamilton)', 'Gorillaz'), ('Fairytale of New York (feat. Kirsty MacColl)', 'The Pogues'), ('PICK IT UP (feat. A$AP Rocky)', 'Famous Dex'), ('Shape of You - Galantis Remix', 'Ed Sheeran'), ('Hunger Strike', 'Temple Of The Dog'), ('Mistakes', 'Tove Styrke'), ('Money Make Ya Handsome', 'Gucci Mane'), ('Do U Dirty', 'Kehlani'), ('Your Song', 'Rita Ora'), ('Believer', 'Imagine Dragons'), ('Jungle', 'Drake'), ('4 Your Eyez Only', 'J. Cole'), ("I'll Be Home", 'Meghan Trainor'), ('The Little Drummer Boy', 'Bing Crosby'), ('Brown Eyed Girl', 'Van Morrison'), ('Curve (feat. The Weeknd)', 'Gucci Mane'), ('Halo', 'Beyoncé'), ('November', 'Tyler, The Creator'), ('Dennis Rodman', 'mansionz'), ('Used to This', 'Future'), ('Cross My Mind Pt. 2 (feat. Kiiara)', 'A R I Z O N A'), ("Poppin' Tags", 'Future'), ('On The Loose', 'Niall Horan'), ('Jingle Bell Rock', 'MC Ty'), ('Sex Murder Party (feat. Jamie Principle & Zebra Katz)', 'Gorillaz'), ('All We Know', 'The Chainsmokers'), ('Stay Blessed', 'Bryson Tiller'), ('Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered', 'Bing Crosby'), ('Danger (with Migos & Marshmello)', 'Migos'), ('Too Much To Ask', 'Niall Horan'), ('Gilligan', 'DRAM'), ('GOD.', 'Kendrick Lamar'), ('Dance with the Devil', 'Gucci Mane'), ('Firework', 'Katy Perry'), ('No Stopping You', 'Brett Eldredge'), ('Call It What You Want', 'Taylor Swift'), ('Nobody (feat. Alicia Keys & Nicki Minaj)', 'DJ Khaled'), ('Better Together', 'Jack Johnson')}



```python
stats['2017-01-01'][2]
```




    {'position': '3',
     'song': 'Starboy',
     'artist': 'The Weeknd',
     'streams': '1,064,351',
     'meta': {'track_id': 114837357,
      'track_name': 'Starboy',
      'track_name_translation_list': [],
      'track_rating': 83,
      'commontrack_id': 63309876,
      'instrumental': 0,
      'explicit': 1,
      'has_lyrics': 1,
      'has_subtitles': 1,
      'has_richsync': 1,
      'num_favourite': 26808,
      'album_id': 23977356,
      'album_name': 'Starboy',
      'artist_id': 32104638,
      'artist_name': 'The Weeknd feat. Daft Punk',
      'track_share_url': 'https://www.musixmatch.com/lyrics/The-Weeknd-feat-Daft-Punk/Starboy?utm_source=application&utm_campaign=api&utm_medium=',
      'track_edit_url': 'https://www.musixmatch.com/lyrics/The-Weeknd-feat-Daft-Punk/Starboy/edit?utm_source=application&utm_campaign=api&utm_medium=',
      'restricted': 0,
      'updated_time': '2016-09-22T10:10:59Z',
      'primary_genres': {'music_genre_list': [{'music_genre': {'music_genre_id': 7,
          'music_genre_parent_id': 34,
          'music_genre_name': 'Electronic',
          'music_genre_name_extended': 'Electronic',
          'music_genre_vanity': 'Electronic'}},
        {'music_genre': {'music_genre_id': 14,
          'music_genre_parent_id': 34,
          'music_genre_name': 'Pop',
          'music_genre_name_extended': 'Pop',
          'music_genre_vanity': 'Pop'}},
        {'music_genre': {'music_genre_id': 1136,
          'music_genre_parent_id': 15,
          'music_genre_name': 'Contemporary R&B',
          'music_genre_name_extended': 'R&B/Soul / Contemporary R&B',
          'music_genre_vanity': 'R-B-Soul-Contemporary-R-B'}}]}}}




```python
m = Musixmatch('866c170bce14ac32778c7b92dc03701d')
```


```python
# Let's get the lyrics for Starboy by The Weeknd
lyrics = m.track_lyrics_get('114837357')
lyrics
```




    {'message': {'header': {'status_code': 200, 'execute_time': 0.099917888641357},
      'body': {'lyrics': {'lyrics_id': 15915537,
        'explicit': 1,
        'lyrics_body': "I'm tryna put you in the worst mood, ah\nP1 cleaner than your church shoes, ah\nMilli point two just to hurt you, ah\nAll red Lamb' just to tease you, ah\nNone of these toys on lease too, ah\nMade your whole year in a week too, yah\nMain bitch out your league too, ah\nSide bitch out of your league too, ah\n\nHouse so empty, need a centerpiece\nTwenty racks a table, carved from ebony\nCut that ivory into skinny pieces\nThen she clean it with her face man I love my baby\nYou talking money, need a hearing aid\nYou talking 'bout me, I don't see a shade\nSwitch out my side, I'll take any lane\nI switch out my car if I kill any pain\n\nLook what you've done\nI'm a motherfucking Starboy\nLook what you've done\nI'm a motherfucking Starboy\n\nEvery day a nigga try to test me, ah\n...\n\n******* This Lyrics is NOT for Commercial use *******\n(1409618279599)",
        'script_tracking_url': 'https://tracking.musixmatch.com/t1.0/m_js/e_1/sn_0/l_15915537/su_0/rs_0/tr_3vUCAH1D7E8KI54ha459ZRJbgvLmnc5ab0AAaltfnJ45TcwvI0DEqMYM6oA8JvHyh5w8vPJopaLSKTVLmtPmx7Wmv3oSWcyQDHZdq16ZBmi3QDjxlSrWZsuhyl-AzScV4LUJWTsO0Ntc8TXwTrH5UhD5qDmdrJjqQUAWU8f39YeFodaJ0wyvP1eKn-b0zkVTlvLui3chtaS_VqutTI8hpr0ixHbU32tgVSdZNqJDBeMdApmW4nQ-kRkONzcBZF84nOwsRCv0L2iAnWF5hqY716or-EAwMn478s1Kc0DuDxpqt8TwXTgCcZ5hYvTMJXMmWnLQ0g8wlmfX6d133COIbAcadRKdqLQ5cr_jhI6qYzY_SSXodt0I6z1yhtS1FqqwMQV399L9P2XSwBJjtoDp5m5e55c7-cUwiQmaSXdK3N5czDaJi9ODQUieN9NkUKM9CB94mqEHPnHCuGMsNS7hm0vQ/',
        'pixel_tracking_url': 'https://tracking.musixmatch.com/t1.0/m_img/e_1/sn_0/l_15915537/su_0/rs_0/tr_3vUCAOeIL2iakBaBq-1W9M2av2emSkezNq3AHATPT3tFC9pNoHFFUypwlSD7OJmRUEvk0zOQWBpqFO-afT0pUlTABr7fyOo9K6G4wq6BuqhIIn6k8SDodwrYYV-v9eKfFM3V-KM_g86R3nC3Xj0WLASFJQRmjlyscJQ7RY270n2ikZpbHBOlQj6DoVtfuHGnfUJiUeMw79W6PgRwVjdsRHsGJAVZsCbWNXIVZ2hovICqoub5bczEQpbdnLYjnGemNBQSqnF_GdG6jAN9YKrAnYF2N5tQtOhxbyIY-4NDF3aC9a8k3bwJCR73gDUjbTKLWOuvYQzaEubPnvXIMFk9wZLndz-1oTslXkMgSPgbq2CHjDqUIPsZkXFtg_zBRhwL4wwISqJ2JGIU7p3EkKXN7U0Ftn_3Fa7P5ZzvGpbmbbRAg-Js8cgWK0bOZwhaRtXrE2CGS2gj7lto4Z9HnCma9jdZ/',
        'lyrics_copyright': 'Lyrics powered by www.musixmatch.com. This Lyrics is NOT for Commercial use and only 30% of the lyrics are returned.',
        'updated_time': '2019-03-13T11:57:05Z'}}}}




```python
# Only 30%?!
print(lyrics['message']['body']['lyrics']['lyrics_body'])
```

    I'm tryna put you in the worst mood, ah
    P1 cleaner than your church shoes, ah
    Milli point two just to hurt you, ah
    All red Lamb' just to tease you, ah
    None of these toys on lease too, ah
    Made your whole year in a week too, yah
    Main bitch out your league too, ah
    Side bitch out of your league too, ah
    
    House so empty, need a centerpiece
    Twenty racks a table, carved from ebony
    Cut that ivory into skinny pieces
    Then she clean it with her face man I love my baby
    You talking money, need a hearing aid
    You talking 'bout me, I don't see a shade
    Switch out my side, I'll take any lane
    I switch out my car if I kill any pain
    
    Look what you've done
    I'm a motherfucking Starboy
    Look what you've done
    I'm a motherfucking Starboy
    
    Every day a nigga try to test me, ah
    ...
    
    ******* This Lyrics is NOT for Commercial use *******
    (1409618279599)



```python
lyrics = lyricwikia.get_lyrics('The Weeknd', 'Starboy')
print(lyrics)
```

    I'm tryna put you in the worst mood, ah
    P1 cleaner than your church shoes, ah
    Milli point two just to hurt you, ah
    All red Lamb' just to tease you, ah
    
    None of these toys on lease too, ah
    Made your whole year in a week too, yah
    Main bitch out of your league too, ah
    Side bitch out of your league too, ah
    
    House so empty, need a centerpiece
    20 racks a table cut from ebony
    Cut that ivory into skinny pieces
    Then she clean it with her face
    Man, I love my baby
    
    You talking money, need a hearing aid
    You talking 'bout me, I don't see the shade
    Switch up my style, I take any lane
    I switch up my cup, I kill any pain
    
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy
    
    Every day a nigga try to test me, ah
    Every day a nigga try to end me, ah
    Pull off in that Roadster SV, ah
    Pockets overweight, gettin' hefty, ah
    
    Coming for the king, that's a far cry, ah
    I come alive in the fall time, I
    No competition, I don't really listen
    I'm in the blue Mulsanne pumping New Edition
    
    House so empty, need a centerpiece
    20 racks a table cut from ebony
    Cut that ivory into skinny pieces
    Then she clean it with her face
    Man, I love my baby
    
    You talking money, need a hearing aid
    You talking 'bout me, I don’t see the shade
    Switch up my style, I take any lane
    I switch up my cup, I kill any pain
    
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I’m a motherfuckin' starboy
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin’ starboy
    
    Let a nigga Brad Pitt
    Legend of the fall took the year like a bandit
    Bought mama a crib and a brand new wagon
    Now she hit the grocery shop looking lavish
    
    Star Trek roof in that Wraith of Khan
    Girls get loose when they hear this song
    100 on the dash, get me close to God
    We don't pray for love, we just pray for cars
    
    House so empty, need a centerpiece
    20 racks a table cut from ebony
    Cut that ivory into skinny pieces
    Then she clean it with her face
    But I love my baby
    
    You talking money, need a hearing aid
    You talking 'bout me, I don't see the shade
    Switch up my style, I take any lane
    I switch up my cup, I kill any pain
    
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy
    
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    Look what you've done
    (Ha-ha-ha-ha-ha-ha-ha-ha-ha-ha)
    I'm a motherfuckin' starboy



```python
lyric_dict = {}
not_found = set()
for idx, (song, artist) in enumerate(songs, 1):
    try:
        lyric_dict[(song, artist)] = lyricwikia.get_lyrics(artist, song)
    except lyricwikia.LyricsNotFound:
        print(f'Cannot find {song} by {artist}.')
        not_found.add((song, artist))
    time.sleep(random.randint(1, 3))
    if idx % 100 == 0:
        print(f'Completed {idx}...')
print(f'Could not find {len(not_found)} lyrics.')
```

    Cannot find Drippy by Young Dolph.
    Cannot find Doves In The Wind by SZA.
    Cannot find Despacito - Remix by Luis Fonsi.
    Cannot find Plain Jane REMIX by A$AP Ferg.
    Cannot find She's Mine Pt. 1 by J. Cole.
    Cannot find Still Serving by 21 Savage.
    Cannot find Cash Machine by DRAM.
    Cannot find OK by Robin Schulz.
    Cannot find Stayin' Alive - From "Saturday Night Fever" Soundtrack by Bee Gees.
    Cannot find Nasty (Who Dat) by A$AP Ferg.
    Cannot find Gang Up (with Young Thug, 2 Chainz & Wiz Khalifa feat. PnB Rock) by Young Thug.
    Cannot find Shed a Light by Robin Schulz.
    Cannot find Christmas Eve - Recorded at Spotify Studios NYC by Kelly Clarkson.
    Cannot find Shooters by Tory Lanez.
    Cannot find Get Low (with Liam Payne) by Zedd.
    Cannot find Heavy (feat. Kiiara) by Linkin Park.
    Cannot find GOOD MORNING AMERIKKKA by Joey Bada$$.
    Cannot find TEMPTATION by Joey Bada$$.
    Cannot find Trap And A Dream by A$AP Ferg.
    Cannot find Never Be the Same - Radio Edit by Camila Cabello.
    Cannot find Skateboard P (feat. Big Sean) by MadeinTYO.
    Cannot find The Weekend - Funk Wav Remix by SZA.
    Cannot find Look At Me! by XXXTENTACION.
    Cannot find I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN.
    Cannot find Somebody's Watching Me - Single Version by Rockwell.
    Cannot find Scared to Be Lonely by Martin Garrix.
    Cannot find Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus.
    Cannot find (I Can't Get No) Satisfaction - Mono Version / Remastered 2002 by The Rolling Stones.
    Cannot find From The D To The A (feat. Lil Yachty) by Tee Grizzley.
    Cannot find Selfish by PnB Rock.
    Cannot find I'm Tryna Fuck by Ugly God.
    Cannot find Love Galore by SZA.
    Cannot find That's My N**** (with Meek Mill, YG & Snoop Dogg) by Meek Mill.
    Cannot find I Think She Like Me by Rick Ross.
    Cannot find It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como.
    Cannot find Perry Aye by A$AP Mob.
    Cannot find POA by Future.
    Completed 100...
    Cannot find The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha.
    Cannot find Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus.
    Cannot find KMT by Drake.
    Cannot find Liger by Young Thug.
    Cannot find Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas.
    Cannot find My Choppa Hate Niggas by 21 Savage.
    Cannot find Lot to Learn by Luke Christopher.
    Cannot find Wanted You (feat. Lil Uzi Vert) by NAV.
    Cannot find Three by Future.
    Cannot find Cake By The Ocean by DNCE.
    Cannot find Help Me Out (with Julia Michaels) by Maroon 5.
    Cannot find Sacrifices by Big Sean.
    Cannot find FYBR (First Year Being Rich) by A$AP Mob.
    Cannot find Kissing Strangers by DNCE.
    Cannot find (What A) Wonderful World - Remastered by Sam Cooke.
    Cannot find Jingle Bell Rock by Anita Kerr Singers.
    Cannot find Ill Nana (feat. Trippie Redd) by DRAM.
    Cannot find Shape of You (Major Lazer Remix) [feat. Nyla & Kranium] by Ed Sheeran.
    Cannot find Go Off (with Lil Uzi Vert, Quavo & Travis Scott) by Lil Uzi Vert.
    Cannot find Drew Barrymore by SZA.
    Cannot find Merry Christmas Darling - Album Version/Remix by Carpenters.
    Cannot find Everyday We Lit by YFN Lucci.
    Cannot find Go Legend (& Metro Boomin) by Big Sean.
    Cannot find Owe Me by Big Sean.
    Cannot find AfricAryaN by Logic.
    Cannot find Bahamas by A$AP Mob.
    Cannot find The Man With The Bag by Kay Starr.
    Cannot find No Cap by Future.
    Cannot find Rich Love (with Seeb) by OneRepublic.
    Cannot find Go Go by BTS.
    Completed 200...
    Cannot find Ex Calling by 6LACK.
    Cannot find The Happiest Christmas Tree - 2009 Digital Remaster by Nat King Cole.
    Cannot find Don’t Blame Me by Taylor Swift.
    Cannot find CRZY by Kehlani.
    Cannot find Live Up to My Name by Baka Not Nice.
    Cannot find Rendezvous by PARTYNEXTDOOR.
    Cannot find Timeless (DJ SPINKING) by A Boogie Wit da Hoodie.
    Cannot find Blue Pill by Metro Boomin.
    Cannot find Begin (feat. Wales) by Shallou.
    Cannot find OMG by Camila Cabello.
    Cannot find Reminding Me by Shawn Hook.
    Cannot find Dusk Till Dawn - Radio Edit by ZAYN.
    Cannot find Best Of Me by BTS.
    Cannot find Sober II (Melodrama) by Lorde.
    Cannot find God Rest Ye Merry Gentlemen - Single Version by Bing Crosby.
    Cannot find OK (feat. Lil Pump) by Smokepurpp.
    Cannot find Rudolph the Rednose Reindeer by DMX.
    Cannot find Even The Odds (& Metro Boomin) by Big Sean.
    Cannot find Wonderwall - Remastered by Oasis.
    Cannot find It's Beginning to Look a Lot Like Christmas by Michael Bublé.
    Cannot find Ahora Dice by Chris Jeday.
    Cannot find Want Her by Mustard.
    Cannot find Skrt Skrt by Tory Lanez.
    Completed 300...
    Cannot find Welcome to the Booty Tape by Ugly God.
    Cannot find Gospel by Rich Brian.
    Cannot find Call On Me - Ryan Riback Extended Remix by Starley.
    Cannot find First Time by Kygo.
    Cannot find For Now by P!nk.
    Cannot find ROCKABYE BABY (feat. ScHoolboy Q) by Joey Bada$$.
    Cannot find Rockin' Around The Christmas Tree - Single Version by Brenda Lee.
    Cannot find Crew REMIX by GoldLink.
    Cannot find White Christmas (duet with Shania Twain) by Michael Bublé.
    Cannot find DN Freestyle by Lil Yachty.
    Cannot find Here Comes The Sun - Remastered by The Beatles.
    Cannot find Gucci On My (feat. 21 Savage, YG & Migos) by Mike WiLL Made-It.
    Cannot find Feel So Close - Radio Edit by Calvin Harris.
    Cannot find Wake Up Where You Are by State of Sound.
    Cannot find Dirty Sexy Money (feat. Charli XCX & French Montana) by David Guetta.
    Cannot find Stranger Things by Kyle Dixon & Michael Stein.
    Cannot find Apple of My Eye by Rick Ross.
    Cannot find Do They Know It's Christmas? - 1984 Version by Band Aid.
    Cannot find Castro by Yo Gotti.
    Cannot find Make Love by Gucci Mane.
    Cannot find Savage Time (& Metro Boomin) by Big Sean.
    Cannot find First Day Out by Tee Grizzley.
    Cannot find MIC Drop (feat. Desiigner) [Steve Aoki Remix] by BTS.
    Cannot find Krippy Kush - Remix by Farruko.
    Cannot find Merry Christmas, Happy Holidays by *NSYNC.
    Cannot find Yeah Yeah (feat. Young Thug) by Travis Scott.
    Cannot find Little Of Your Love - BloodPop® Remix by HAIM.
    Cannot find Get The Bag by A$AP Mob.
    Cannot find Don't Sleep On Me (feat. Future and 24hrs) by Ty Dolla $ign.
    Completed 400...
    Cannot find Feel Good (feat. Daya) by Gryffin.
    Cannot find Light by Big Sean.
    Cannot find No Fear by DeJ Loaf.
    Cannot find How Far I'll Go - From "Moana" by Alessia Cara.
    Cannot find OG Kush Diet by 2 Chainz.
    Cannot find XXX. FEAT. U2. by Kendrick Lamar.
    Cannot find In Tune (& Metro Boomin) by Big Sean.
    Cannot find Disrespectful by GASHI.
    Cannot find Move Your Body - Single Mix by Sia.
    Cannot find ILL NANA (feat. Trippie Redd) by DRAM.
    Cannot find Baby, It's Cold Outside (feat. Meghan Trainor) by Brett Eldredge.
    Cannot find Get Mine by Bryson Tiller.
    Cannot find Wonderful Christmastime - Remastered 2011 / Edited Version by Paul McCartney.
    Cannot find santa monica & la brea by blackbear.
    Cannot find F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky.
    Cannot find Let You Down by NF.
    Cannot find Juju On That Beat (TZ Anthem) by Zay Hilfigerrr.
    Cannot find DNA by BTS.
    Cannot find SUBEME LA RADIO by Enrique Iglesias.
    Cannot find It Ain't Me (with Selena Gomez) by Kygo.
    Cannot find Run Rudolph Run - Single Version by Chuck Berry.
    Cannot find Carol of the Bells by Mykola Dmytrovych Leontovych.
    Cannot find Plain Jane by A$AP Ferg.
    Cannot find Riding Shotgun by Kygo.
    Cannot find The Chain - 2004 Remaster by Fleetwood Mac.
    Cannot find That Far by 6LACK.
    Cannot find Breakfast (feat. A$AP Rocky) by Jaden Smith.
    Completed 500...
    Cannot find City Of Stars - From "La La Land" Soundtrack by Ryan Gosling.
    Cannot find PRBLMS by 6LACK.
    Cannot find A$AP Ferg by NAV.
    Cannot find Light by San Holo.
    Cannot find RAF by A$AP Mob.
    Cannot find Too Hotty by Quality Control.
    Cannot find IDGAF by Dua Lipa.
    Cannot find Fashion (feat. Rich The Kid) by Jay Critch.
    Cannot find SUPER PREDATOR (feat. Styles P) by Joey Bada$$.
    Cannot find Y U DON'T LOVE ME? (MISS AMERIKKKA) by Joey Bada$$.
    Cannot find Should I Stay or Should I Go - Remastered by The Clash.
    Cannot find Hear Me Now by Alok.
    Cannot find Complicated (feat. Kiiara) (feat. Kiiara) by Dimitri Vegas & Like Mike.
    Cannot find So Good (& Metro Boomin) by Big Sean.
    Cannot find My Dawg by Quality Control.
    Cannot find 4 AM by 2 Chainz.
    Cannot find Romantic - NOTD Remix by Stanaj.
    Cannot find Walk On Water by A$AP Mob.
    Cannot find Shook Ones, Pt. II by Mobb Deep.
    Cannot find Supermodel by SZA.
    Cannot find Work REMIX by A$AP Ferg.
    Cannot find HOLD ME TIGHT OR DON’T by Fall Out Boy.
    Cannot find top priority (with Ne-Yo) by blackbear.
    Cannot find I Think Of You by Jeremih.
    Cannot find Rubbin Off The Paint by YBN Nahmir.
    Cannot find Sex for Breakfast by Life of Dillon.
    Cannot find The Greatest Show by Hugh Jackman.
    Cannot find Mi Gente (feat. Beyoncé) by J Balvin.
    Cannot find Too Many Years by Kodak Black.
    Cannot find Come Closer by WizKid.
    Cannot find Taped Up Heart (feat. Clara Mae) by KREAM.
    Cannot find Killing Time by R3HAB.
    Cannot find Damage by PARTYNEXTDOOR.
    Completed 600...
    Cannot find Love U Better (feat. Lil Wayne & The-Dream) by Ty Dolla $ign.
    Cannot find A Holly Jolly Christmas - Single Version by Burl Ives.
    Cannot find You Could Be by R3HAB.
    Cannot find Don't Leave by Snakehips.
    Cannot find Perfect Duet (Ed Sheeran & Beyoncé) by Ed Sheeran.
    Cannot find Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night by Perry Como.
    Cannot find Let Me Go (with Alesso, Florida Georgia Line & watt) by Hailee Steinfeld.
    Cannot find Group Home by Future.
    Cannot find Jingle Bells - Remastered 1999 by Frank Sinatra.
    Cannot find GUMMO by 6ix9ine.
    Cannot find Sway (feat. Quavo & Lil Yachty) by NexXthursday.
    Cannot find Don't Judge Me (feat. Future and Swae Lee) by Ty Dolla $ign.
    Cannot find Escápate Conmigo by Wisin.
    Cannot find Love Galore (feat. Travis Scott) by SZA.
    Cannot find gucci linen (feat. 2 Chainz) by blackbear.
    Cannot find Champions by Kanye West.
    Cannot find 20 Min by Lil Uzi Vert.
    Cannot find Reggaetón Lento (Remix) by CNCO.
    Cannot find Mink Flow by Future.
    Cannot find Look at Me! by XXXTENTACION.
    Cannot find Disrespectful by 21 Savage.
    Cannot find Final Song by MØ.
    Cannot find Sweat by The All-American Rejects.
    Cannot find La Modelo by Ozuna.
    Cannot find A Million Dreams by Ziv Zaifman.
    Cannot find Halfway Off The Balcony by Big Sean.
    Cannot find Misunderstood by PnB Rock.
    Cannot find Up by Desiigner.
    Completed 700...
    Cannot find Feel Me by Tyga.
    Cannot find FaceTime by 21 Savage.
    Cannot find DEVASTATED by Joey Bada$$.
    Cannot find Havana - Remix by Camila Cabello.
    Cannot find Please Shut Up by A$AP Mob.
    Cannot find A Different Way (with Lauv) by DJ Snake.
    Cannot find Who's Stopping Me (& Metro Boomin) by Big Sean.
    Cannot find Now and Later by Sage The Gemini.
    Cannot find A Nightmare on My Street by DJ Jazzy Jeff & The Fresh Prince.
    Cannot find Se Preparó by Ozuna.
    Cannot find Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland.
    Cannot find Mask Off - Remix by Future.
    Cannot find I'll Be Home For Christmas - Single Version by Bing Crosby.
    Cannot find Crew (feat. Brent Faiyaz & Shy Glizzy) by GoldLink.
    Cannot find Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] by Lou Monte.
    Cannot find Lighthouse - Andrelli Remix by Hearts & Colors.
    Cannot find Jingle Bells (feat. The Puppini Sisters) by Michael Bublé.
    Cannot find 10 Feet Down by NF.
    Cannot find Better Off - Dying by Lil Peep.
    Cannot find September Song by JP Cooper.
    Cannot find Boys by Charli XCX.
    Cannot find Beamer Boy by Lil Peep.
    Cannot find Hey Ya! - Radio Mix / Club Mix by OutKast.
    Cannot find In The Arms Of A Stranger - Grey Remix by Mike Posner.
    Completed 800...
    Cannot find Both Eyes Closed (feat. 2 Chainz and Young Dolph) by Gucci Mane.
    Cannot find Rubbin off the Paint by YBN Nahmir.
    Cannot find Outro: Her by BTS.
    Cannot find Intro: Serendipity by BTS.
    Cannot find Whippin (feat. Felix Snow) by Kiiara.
    Cannot find Water by Ugly God.
    Cannot find Black SpiderMan by Logic.
    Cannot find Broken Clocks by SZA.
    Cannot find River - Recorded At RAK Studios, London by Sam Smith.
    Cannot find No Lies (feat. Wiz Khalifa) by Ugly God.
    Cannot find Bigger Than Me by Big Sean.
    Cannot find The Weekend by SZA.
    Cannot find Uber Everywhere by MadeinTYO.
    Cannot find Congratulations - Remix by Post Malone.
    Cannot find Tu Sabes Que Te Quiero by Chucho Flash.
    Cannot find Twelve Days Of Christmas - Single Version by Bing Crosby.
    Cannot find White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London by George Ezra.
    Cannot find Too Much Sauce by DJ Esco.
    Cannot find Oceans Away by A R I Z O N A.
    Cannot find Big Bidness (& Metro Boomin) by Big Sean.
    Completed 900...
    Cannot find anxiety (with FRND) by blackbear.
    Cannot find You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft.
    Cannot find Him & I (with Halsey) by G-Eazy.
    Cannot find UnFazed (feat. The Weeknd) by Lil Uzi Vert.
    Cannot find Obsession (feat. Jon Bellion) by Vice.
    Cannot find Thunder / Young Dumb & Broke (with Khalid) - Medley by Imagine Dragons.
    Cannot find You Don't Know Me - Radio Edit by Jax Jones.
    Cannot find Homemade Dynamite - REMIX by Lorde.
    Cannot find This Is Me by Keala Settle.
    Cannot find Good Life (with G-Eazy & Kehlani) by G-Eazy.
    Cannot find Twist And Shout - Remastered by The Beatles.
    Cannot find Let Me Explain by Bryson Tiller.
    Cannot find Fuck Ugly God by Ugly God.
    Cannot find MIC Drop by BTS.
    Cannot find Pull Up N Wreck (& Metro Boomin) by Big Sean.
    Cannot find American Dream (feat. J.Cole, Kendrick Lamar) by Jeezy.
    Cannot find The Race by 22 Savage.
    Cannot find Issues (feat. Russ) by PnB Rock.
    Cannot find Gassed Up by Nebu Kiniza.
    Cannot find Happy - From "Despicable Me 2" by Pharrell Williams.
    Cannot find Is That For Me by Alesso.
    Cannot find Audi. by Smokepurpp.
    Cannot find Weak by AJR.
    Cannot find Feels So Good by A$AP Mob.
    Cannot find bright pink tims (feat. Cam'ron) by blackbear.
    Cannot find The Race by Tay-K.
    Cannot find X (feat. Future) by 21 Savage.
    Cannot find So Am I (feat. Damian Marley & Skrillex) by Ty Dolla $ign.
    Cannot find ...Baby One More Time - Recorded at Spotify Studios NYC by Ed Sheeran.
    Completed 1000...
    Cannot find Money Team by Friyie.
    Cannot find Ghostface Killers by 21 Savage.
    Cannot find High For Hours by J. Cole.
    Cannot find Ain't No Mountain High Enough by Marvin Gaye.
    Cannot find You Can't Hurry Love - 2016 Remastered by Phil Collins.
    Cannot find Vuelve by Daddy Yankee.
    Cannot find Reason (& Metro Boomin) by Big Sean.
    Cannot find Dab of Ranch - Recorded at Spotify Studios NYC by Migos.
    Cannot find Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975 by Bruce Springsteen.
    Cannot find Happy Xmas (War Is Over) - Remastered by John Lennon.
    Cannot find Jingle Bell Rock - Daryl's Version by Daryl Hall & John Oates.
    Cannot find Home (with Machine Gun Kelly, X Ambassadors & Bebe Rexha) by Machine Gun Kelly.
    Cannot find Anything That's Rock 'N' Roll by Tom Petty and the Heartbreakers.
    Cannot find Here We Come a-Caroling / We Wish You a Merry Christmas by Perry Como.
    Cannot find Stop Smoking Black & Milds by Ugly God.
    Cannot find What About Us by P!nk.
    Cannot find LOYALTY. FEAT. RIHANNA. by Kendrick Lamar.
    Cannot find May I Have This Dance (Remix) [feat. Chance the Rapper] by Francis and the Lights.
    Cannot find How Far I'll Go by Auli'i Cravalho.
    Cannot find Little Saint Nick - 1991 Remix by The Beach Boys.
    Cannot find Downtown by Anitta.
    Cannot find I'm a Nasty Hoe by Ugly God.
    Cannot find All da Smoke by Future.
    Completed 1100...
    Cannot find 200 by Future.
    Cannot find Pied Piper by BTS.
    Cannot find Too Good At Goodbyes - Edit by Sam Smith.
    Cannot find Outlet by Desiigner.
    Cannot find New Year’s Day by Taylor Swift.
    Cannot find Not Going Home by DVBBS.
    Cannot find I Sip by Tory Lanez.
    Cannot find Stay (with Alessia Cara) by Zedd.
    Cannot find Lift Me Up - Michael Brun Remix by OneRepublic.
    Cannot find Oh Lord by MiC LOWRY.
    Cannot find Why Don't You Come On by DJDS.
    Cannot find Lose Yourself - From "8 Mile" Soundtrack by Eminem.
    Cannot find Thriller - 2003 Edit by Michael Jackson.
    Cannot find Perfect Pint (feat. Kendrick Lamar, Gucci Mane & Rae Sremmurd) by Mike WiLL Made-It.
    Cannot find No Flag by London On Da Track.
    Cannot find Sucker For Pain (with Wiz Khalifa, Imagine Dragons, Logic & Ty Dolla $ign feat. X Ambassadors) by Lil Wayne.
    Cannot find High Without Your Love by Loote.
    Cannot find RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko) by Joey Bada$$.
    Cannot find Rockin’ by The Weeknd.
    Cannot find Call Me by NAV.
    Cannot find I'll Be Home For Christmas - Recorded at Spotify Studios NYC by Demi Lovato.
    Cannot find All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio.
    Cannot find So Close by Andrew McMahon in the Wilderness.
    Cannot find Middle by DJ Snake.
    Cannot find dimple by BTS.
    Cannot find Frat Rules by A$AP Mob.
    Cannot find MotorSport by Migos.
    Cannot find (Intro) I'm so Grateful (feat. Sizzla) by DJ Khaled.
    Cannot find I Miss You by Grey.
    Cannot find Lil Favorite (feat. MadeinTYO) by Ty Dolla $ign.
    Cannot find F*ck Up Some Commas by Future.
    Cannot find Have Yourself A Merry Little Christmas by Sam Smith.
    Completed 1200...
    Cannot find Can't Hold Us - feat. Ray Dalton by Macklemore & Ryan Lewis.
    Cannot find Trap Trap Trap by Rick Ross.
    Cannot find Don't Stop Me Now - Remastered by Queen.
    Cannot find No Hearts, No Love (& Metro Boomin) by Big Sean.
    Cannot find They Like by Yo Gotti.
    Cannot find Numb / Encore by JAY Z.
    Cannot find Sunday Morning Jetpack by Big Sean.
    Cannot find iSpy (feat. Lil Yachty) by KYLE.
    Cannot find FOR MY PEOPLE by Joey Bada$$.
    Cannot find Horses (with PnB Rock, Kodak Black & A Boogie Wit da Hoodie) by PnB Rock.
    Cannot find Rewrite The Stars by Zac Efron.
    Cannot find Ex (feat. YG) by Ty Dolla $ign.
    Cannot find Me Rehúso by Danny Ocean.
    Cannot find Reminder - Remix by The Weeknd.
    Cannot find Minute by NAV.
    Cannot find Drugs by August Alsina.
    Cannot find Skir Skirr by Lil Uzi Vert.
    Cannot find Bad Things (with Camila Cabello) by Machine Gun Kelly.
    Cannot find Love (feat. Rae Sremmurd) by ILoveMakonnen.
    Cannot find I Just Can't by R3HAB.
    Cannot find Run Up the Racks by 21 Savage.
    Cannot find BABYLON (feat. Chronixx) by Joey Bada$$.
    Cannot find Nightmare by Offset.
    Cannot find Idols Become Rivals by Rick Ross.
    Cannot find 美女と野獣 by Ariana Grande.
    Cannot find Chill Bill by Rob $tone.
    Completed 1300...
    Cannot find Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC by Fifth Harmony.
    Cannot find The Mack by Nevada.
    Cannot find Inspire Me by Big Sean.
    Cannot find Met Gala (feat. Offset) by Gucci Mane.
    Cannot find Sensualidad by Bad Bunny.
    Cannot find Extra Luv by Future.
    Cannot find Mistletoe And Holly - Remastered 1999 by Frank Sinatra.
    Cannot find XO TOUR Llif3 by Lil Uzi Vert.
    Cannot find Rap Saved Me by 21 Savage.
    Cannot find Real Love by Future.
    Cannot find Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix by Lana Del Rey.
    Cannot find She's Mine Pt. 2 by J. Cole.
    Cannot find LOVE. FEAT. ZACARI. by Kendrick Lamar.
    Cannot find Same Time Pt. 1 by Big Sean.
    Cannot find Either Way (feat. Joey Bada$$) by Snakehips.
    Cannot find Ice Tray by Quality Control.
    Cannot find Everyday We Lit (Remix) by YFN Lucci.
    Cannot find Bring It Back (with Drake & Mike WiLL Made-It) by Trouble.
    Cannot find Blowin' Minds (Skateboard) by A$AP Mob.
    Cannot find BYF by A$AP Mob.
    Cannot find Christmas Time Is Here - Vocal by Vince Guaraldi Trio.
    Cannot find Come and Get Your Love - Single Edit by Redbone.
    Cannot find New Freezer (feat. Kendrick Lamar) by Rich The Kid.
    Cannot find Criminal by Natti Natasha.
    Cannot find Nothing Wrong by G-Eazy.
    Cannot find Black Card by A$AP Mob.
    Cannot find DNA. by Kendrick Lamar.
    Cannot find The First Noel - Remastered 1999 by Frank Sinatra.
    Cannot find Mele Kalikimaka - Single Version by Bing Crosby.
    Completed 1400...
    Cannot find Don't Quit (feat. Travis Scott & Jeremih) by DJ Khaled.
    Cannot find Dead Presidents by Rick Ross.
    Cannot find Drip on Me by Future.
    Cannot find Hypnotize - 2014 Remastered Version by The Notorious B.I.G..
    Cannot find Sneakin’ by Drake.
    Cannot find Ni**as In Paris by JAY Z.
    Cannot find Darkside (with Ty Dolla $ign & Future feat. Kiiara) by Ty Dolla $ign.
    Cannot find Raincoat (feat. Shy Martin) by Timeflies.
    Cannot find Ok by Lil Pump.
    Cannot find Liife by Desiigner.
    Cannot find Mad Stalkers by 21 Savage.
    Cannot find Nights With You by MØ.
    Cannot find Purple Lamborghini (with Rick Ross) by Skrillex.
    Cannot find On The Come Up (feat. Big Sean) by Mike WiLL Made-It.
    Cannot find Crazy Brazy by A$AP Mob.
    Cannot find Wishlist by Kiiara.
    Cannot find All Night by Steve Aoki.
    Cannot find LEGENDARY (feat. J. Cole) by Joey Bada$$.
    Cannot find Biking by Frank Ocean.
    Cannot find Patek Water by Future.
    Cannot find This Is Why We Can’t Have Nice Things by Taylor Swift.
    Cannot find Changes by Hazers.
    Cannot find Darth Vader by 21 Savage.
    Cannot find Girls On Boys by Galantis.
    Cannot find Steady 1234 (feat. Jasmine Thompson & Skizzy Mars) by Vice.
    Cannot find Don't Don't Do It! by N.E.R.D.
    Completed 1500...
    Cannot find playboy shit (feat. lil aaron) by blackbear.
    Cannot find California Love - Original Version by 2Pac.
    Cannot find No Smoke by YoungBoy Never Broke Again.
    Cannot find Friends (with BloodPop®) by Justin Bieber.
    Cannot find I Don’t Know Why by Imagine Dragons.
    Cannot find Werewolves of London - 2007 Remaster by Warren Zevon.
    Cannot find Everyday We Lit (feat. PnB Rock) by YFN Lucci.
    Cannot find Superstition - Single Version by Stevie Wonder.
    Cannot find Skateboard P by MadeinTYO.
    Cannot find Pretty Girl - Cheat Codes X CADE Remix by Maggie Lindemann.
    Cannot find Benz Truck - гелик by Lil Peep.
    Cannot find Cake - Challenge Version by Flo Rida.
    Cannot find Lovin' (feat. A Boogie Wit da Hoodie) by PnB Rock.
    Cannot find KOODA by 6ix9ine.
    Cannot find I’ll Make It Up To You by Imagine Dragons.
    Cannot find So Far Away (feat. Jamie Scott & Romy Dya) by Martin Garrix.
    Cannot find Get to the Money by Chad Focus.
    Cannot find Signed, Sealed, Delivered (I'm Yours) by Stevie Wonder.
    Cannot find Instinct (feat. MadeinTYO) by Roy Woods.
    Cannot find Broccoli (feat. Lil Yachty) by DRAM.
    Cannot find Real Thing (feat. Future) by Tory Lanez.
    Cannot find Voices In My Head/Stick To The Plan by Big Sean.
    Cannot find Beautiful Trauma by P!nk.
    Cannot find Pull Up N Wreck (With Metro Boomin) by Big Sean.
    Cannot find Colombia Heights (Te Llamo) [feat. J Balvin] by Wale.
    Cannot find TG4M by Zara Larsson.
    Cannot find 2U (feat. Justin Bieber) by David Guetta.
    Cannot find up in this (with Tinashe) by blackbear.
    Cannot find LAND OF THE FREE by Joey Bada$$.
    Cannot find PICK IT UP (feat. A$AP Rocky) by Famous Dex.
    Cannot find Shape of You - Galantis Remix by Ed Sheeran.
    Cannot find I'll Be Home by Meghan Trainor.
    Completed 1600...
    Cannot find Cross My Mind Pt. 2 (feat. Kiiara) by A R I Z O N A.
    Cannot find Jingle Bell Rock by MC Ty.
    Cannot find Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered by Bing Crosby.
    Cannot find Danger (with Migos & Marshmello) by Migos.
    Cannot find Gilligan by DRAM.
    Cannot find Dance with the Devil by Gucci Mane.
    Could not find 454 lyrics.



```python
# Let's see which database is more robust. Just for fun?
genius = lyricsgenius.Genius('KRi_eRUm3yLWgNuWbZnMjW8fq2Z60CXTTqYbQYl16ZoJ-BPXABqbzNsq6ZPMTlWh')
genius.remove_section_headers = True
```


```python
song_dict = {}
failed = set()

for idx, (song, artist) in enumerate(songs, 1):
    result = genius.search_song(song, artist, get_full_info=False)
    if not result:
        print(f'Could not find {song} by {artist}')
        failed.add((song, artist))
        lyrics = None
    else:
        lyrics = result.lyrics
    
    song_dict[(song, artist)] = lyrics
    if idx % 100 == 0:
        print(f'Completed {idx}...')
    time.sleep(random.randint(1, 3))

print(f'Could not find {len(failed)} lyrics.')
```

    Searching for "Wet Dreamz" by J. Cole...
    Done.
    Searching for "Some Way" by NAV...
    Done.
    Searching for "Drippy" by Young Dolph...
    Done.
    Searching for "New Illuminati" by Future...
    Done.
    Searching for "Doves In The Wind" by SZA...
    Done.
    Searching for "Life Changes" by Thomas Rhett...
    Done.
    Searching for "Despacito - Remix" by Luis Fonsi...
    Done.
    Searching for "Plain Jane REMIX" by A$AP Ferg...
    Done.
    Searching for "Flip" by Future...
    Done.
    Searching for "Revival (Interlude)" by Eminem...
    Done.
    Searching for "Rise Up" by Imagine Dragons...
    Done.
    Searching for "We Don't Talk Anymore (feat. Selena Gomez)" by Charlie Puth...
    Done.
    Searching for "Can't Have Everything" by Drake...
    Done.
    Searching for "She's Mine Pt. 1" by J. Cole...
    Done.
    Searching for "Still Serving" by 21 Savage...
    Done.
    Searching for "LUST." by Kendrick Lamar...
    Done.
    Searching for "In My Feelings" by Lana Del Rey...
    Done.
    Searching for "A Lie" by French Montana...
    Done.
    Searching for "Cash Machine" by DRAM...
    Done.
    Searching for "No Comparison" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Good Man (feat. Pusha T & Jadakiss)" by DJ Khaled...
    Done.
    Searching for "OK" by Robin Schulz...
    Done.
    Searching for "Stayin' Alive - From "Saturday Night Fever" Soundtrack" by Bee Gees...
    No results found for: 'Stayin' Alive - From "Saturday Night Fever" Soundtrack Bee Gees'
    Could not find Stayin' Alive - From "Saturday Night Fever" Soundtrack by Bee Gees
    Searching for "Caroline" by Aminé...
    Done.
    Searching for "Nasty (Who Dat)" by A$AP Ferg...
    Done.
    Searching for "Free Smoke" by Drake...
    Done.
    Searching for "Gang Up (with Young Thug, 2 Chainz & Wiz Khalifa feat. PnB Rock)" by Young Thug...
    Done.
    Searching for "Shed a Light" by Robin Schulz...
    Done.
    Searching for "Christmas Eve - Recorded at Spotify Studios NYC" by Kelly Clarkson...
    Done.
    Searching for "Mary Jane's Last Dance" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Two®" by Lil Uzi Vert...
    Done.
    Searching for "This Town" by Niall Horan...
    Done.
    Searching for "Shooters" by Tory Lanez...
    Done.
    Searching for "Get Low (with Liam Payne)" by Zedd...
    Done.
    Searching for "Big Poppa" by The Notorious B.I.G....
    Done.
    Searching for "Santa Claus Is Coming To Town" by The Jackson 5...
    Done.
    Searching for "Heavy (feat. Kiiara)" by Linkin Park...
    Done.
    Searching for "GOOD MORNING AMERIKKKA" by Joey Bada$$...
    Done.
    Searching for "TEMPTATION" by Joey Bada$$...
    Done.
    Searching for "4422" by Drake...
    Done.
    Searching for "Trap And A Dream" by A$AP Ferg...
    Done.
    Searching for "YAH." by Kendrick Lamar...
    Done.
    Searching for "Eye 2 Eye" by Huncho Jack...
    Done.
    Searching for "Never Be the Same - Radio Edit" by Camila Cabello...
    Done.
    Searching for "Sober" by Lorde...
    Done.
    Searching for "Skateboard P (feat. Big Sean)" by MadeinTYO...
    Done.
    Searching for "Naked" by James Arthur...
    Done.
    Searching for "Rich Girl" by Daryl Hall & John Oates...
    Done.
    Searching for "O Christmas Tree" by Tony Bennett...
    Done.
    Searching for "Bon Appétit" by Katy Perry...
    Done.
    Searching for "The Fighter" by Keith Urban...
    Done.
    Searching for "Trumpets" by Jason Derulo...
    Done.
    Searching for "No Complaints" by Metro Boomin...
    Done.
    Searching for "I Need To Know" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "13 Beaches" by Lana Del Rey...
    Done.
    Searching for "End Game" by Taylor Swift...
    Done.
    Searching for "The Weekend - Funk Wav Remix" by SZA...
    Done.
    Searching for "Malibu" by Miley Cyrus...
    Done.
    Searching for "Look At Me!" by XXXTENTACION...
    Done.
    Searching for "Super Trapper" by Future...
    Done.
    Searching for "I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)"" by ZAYN...
    No results found for: 'I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" ZAYN'
    Could not find I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    Searching for "Drowning (feat. Kodak Black)" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Somebody's Watching Me - Single Version" by Rockwell...
    Done.
    Searching for "God, Your Mama, And Me" by Florida Georgia Line...
    Done.
    Searching for "Scared to Be Lonely" by Martin Garrix...
    Done.
    Searching for "Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC" by Miley Cyrus...
    No results found for: 'Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC Miley Cyrus'
    Could not find Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    Searching for "(I Can't Get No) Satisfaction - Mono Version / Remastered 2002" by The Rolling Stones...
    No results found for: '(I Can't Get No) Satisfaction - Mono Version / Remastered 2002 The Rolling Stones'
    Could not find (I Can't Get No) Satisfaction - Mono Version / Remastered 2002 by The Rolling Stones
    Searching for "From The D To The A (feat. Lil Yachty)" by Tee Grizzley...
    Done.
    Searching for "Selfish" by PnB Rock...
    Done.
    Searching for "I'm Tryna Fuck" by Ugly God...
    Done.
    Searching for "What They Want" by Russ...
    Done.
    Searching for "Fresh Air" by Future...
    Done.
    Searching for "Christmas Time" by The Platters...
    Done.
    Searching for "Dirty Mouth" by Lil Yachty...
    Done.
    Searching for "Make Me (Cry)" by Noah Cyrus...
    Done.
    Searching for "Photograph" by Ed Sheeran...
    Done.
    Searching for "Hard Times" by Paramore...
    Done.
    Searching for "Love Galore" by SZA...
    Done.
    Searching for "High Stakes" by Bryson Tiller...
    Done.
    Searching for "Major Bag Alert (feat. Migos)" by DJ Khaled...
    
    search_genius_web failed, using old search method.
    Searching for "Major Bag Alert (feat. Migos)" by DJ Khaled...
    Done.
    Searching for "That's My N**** (with Meek Mill, YG & Snoop Dogg)" by Meek Mill...
    Done.
    Searching for "Sleigh Ride" by Carpenters...
    Done.
    Searching for "Party" by Chris Brown...
    Done.
    Searching for "My Type" by The Chainsmokers...
    Done.
    Searching for "Wildflowers" by Tom Petty...
    Done.
    Searching for "Icon" by Jaden Smith...
    Done.
    Searching for "I Think She Like Me" by Rick Ross...
    Done.
    Searching for "Down" by Fifth Harmony...
    Done.
    Searching for "Peek A Boo" by Lil Yachty...
    Done.
    Searching for "It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra)" by Perry Como...
    No results found for: 'It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) Perry Como'
    Could not find It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    Searching for "Deja Vu" by Post Malone...
    Done.
    Searching for "Youngest Flexer (feat. Gucci Mane)" by Lil Pump...
    Done.
    Searching for "Ride" by Twenty One Pilots...
    Done.
    Searching for "Million Reasons" by Lady Gaga...
    Done.
    Searching for "Miss You" by James Hersey...
    Done.
    Searching for "El Amante" by Nicky Jam...
    Done.
    Searching for "Perry Aye" by A$AP Mob...
    Done.
    Searching for "POA" by Future...
    Done.
    Searching for "Sacrifices" by Drake...
    Done.
    Searching for "Heatstroke (feat. Young Thug, Pharrell Williams & Ariana Grande)" by Calvin Harris...
    Done.
    Completed 100...
    Searching for "The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version" by Bebe Rexha...
    No results found for: 'The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version Bebe Rexha'
    Could not find The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    Searching for "Get to the Money (feat. Troyse, Cito G & Flames)" by Chad Focus...
    No results found for: 'Get to the Money (feat. Troyse, Cito G & Flames) Chad Focus'
    Could not find Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    Searching for "...Ready For It?" by Taylor Swift...
    Done.
    Searching for "beibs in the trap" by Travis Scott...
    Done.
    Searching for "O Tannenbaum" by Vince Guaraldi Trio...
    Done.
    Searching for "KMT" by Drake...
    Done.
    Searching for "Pumped Up Kicks" by Foster The People...
    Done.
    Searching for "Young And Menace" by Fall Out Boy...
    Done.
    Searching for "Everybody Dies In Their Nightmares" by XXXTENTACION...
    Done.
    Searching for "Saint Laurent Mask" by Huncho Jack...
    Done.
    Searching for "Eraser" by Ed Sheeran...
    Done.
    Searching for "Liger" by Young Thug...
    Done.
    Searching for "Again" by Noah Cyrus...
    Done.
    Searching for "Everybody" by Logic...
    Done.
    Searching for "Kiwi" by Harry Styles...
    Done.
    Searching for "Remind Me" by Eminem...
    Done.
    Searching for "Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)"" by Nick Jonas...
    No results found for: 'Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" Nick Jonas'
    Could not find Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    Searching for "Born In The U.S.A." by Bruce Springsteen...
    Done.
    Searching for "My Choppa Hate Niggas" by 21 Savage...
    Done.
    Searching for "Lot to Learn" by Luke Christopher...
    Done.
    Searching for "Wanted You (feat. Lil Uzi Vert)" by NAV...
    Done.
    Searching for "Battle Symphony" by Linkin Park...
    Done.
    Searching for "Small Town Boy" by Dustin Lynch...
    Done.
    Searching for "Anziety" by Logic...
    Done.
    Searching for "High Demand" by Future...
    Done.
    Searching for "Coolin and Booted" by Kodak Black...
    Done.
    Searching for "Three" by Future...
    Done.
    Searching for "Champion" by Fall Out Boy...
    Done.
    Searching for "Cake By The Ocean" by DNCE...
    Done.
    Searching for "Help Me Out (with Julia Michaels)" by Maroon 5...
    Done.
    Searching for "Sacrifices" by Big Sean...
    Done.
    Searching for "Juicy" by The Notorious B.I.G....
    Done.
    Searching for "Codeine Dreaming (feat. Lil Wayne)" by Kodak Black...
    Done.
    Searching for "Into The Great Wide Open" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "FYBR (First Year Being Rich)" by A$AP Mob...
    Done.
    Searching for "Roses" by The Chainsmokers...
    Done.
    Searching for "Delicate" by Taylor Swift...
    Done.
    Searching for "Kissing Strangers" by DNCE...
    Done.
    Searching for "I Feel It Coming" by The Weeknd...
    Done.
    Searching for "Good Day (feat. DJ Snake & Elliphant)" by Yellow Claw...
    Done.
    Searching for "Issues" by Meek Mill...
    Done.
    Searching for "Marmalade (feat. Lil Yachty)" by Macklemore...
    Done.
    Searching for "Praying" by Kesha...
    Done.
    Searching for "Orlando" by XXXTENTACION...
    Done.
    Searching for "(What A) Wonderful World - Remastered" by Sam Cooke...
    Done.
    Searching for "Jingle Bell Rock" by Anita Kerr Singers...
    Done.
    Searching for "Ill Nana (feat. Trippie Redd)" by DRAM...
    Done.
    Searching for "Shape of You (Major Lazer Remix) [feat. Nyla & Kranium]" by Ed Sheeran...
    Done.
    Searching for "Walking The Wire" by Imagine Dragons...
    Done.
    Searching for "Go Off (with Lil Uzi Vert, Quavo & Travis Scott)" by Lil Uzi Vert...
    Done.
    Searching for "Big Fish" by Vince Staples...
    Done.
    Searching for "P.Y.T. (Pretty Young Thing)" by Michael Jackson...
    Done.
    Searching for "Leave Right Now" by Thomas Rhett...
    Done.
    Searching for "Drew Barrymore" by SZA...
    Done.
    Searching for "Woman" by Harry Styles...
    Done.
    Searching for "How To Talk" by Lil Uzi Vert...
    Done.
    Searching for "Have Yourself a Merry Little Christmas" by Christina Aguilera...
    Done.
    Searching for "Closer" by The Chainsmokers...
    Done.
    Searching for "Too Good" by Drake...
    Done.
    Searching for "Molly" by Lil Pump...
    Done.
    Searching for "Merry Christmas Darling - Album Version/Remix" by Carpenters...
    Done.
    Searching for "Everyday We Lit" by YFN Lucci...
    Done.
    Searching for "Broken Halos" by Chris Stapleton...
    Done.
    Searching for "I Would Die For You" by Miley Cyrus...
    Done.
    Searching for "Ignition - Remix" by R. Kelly...
    Done.
    Searching for "Lights Down Low" by MAX...
    Done.
    Searching for "Strip That Down" by Liam Payne...
    Done.
    Searching for "Saved" by Khalid...
    Done.
    Searching for "I Love You so Much (feat. Chance the Rapper)" by DJ Khaled...
    Done.
    Searching for "Iced Out My Arms (feat. Future, Migos, 21 Savage & T.I.)" by DJ Khaled...
    Done.
    Searching for "Escape" by Kehlani...
    Done.
    Searching for "I Did Something Bad" by Taylor Swift...
    Done.
    Searching for "Fake Happy" by Paramore...
    Done.
    Searching for "Roll In Peace (feat. XXXTENTACION)" by Kodak Black...
    Done.
    Searching for "One Step Closer" by Linkin Park...
    Done.
    Searching for "Line Of Sight (feat. WYNNE & Mansionair)" by ODESZA...
    Done.
    Searching for "Go Legend (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Owe Me" by Big Sean...
    Done.
    Searching for "Walk On Water" by Thirty Seconds To Mars...
    Done.
    Searching for "Capsize" by FRENSHIP...
    Done.
    Searching for "Signs" by Drake...
    Done.
    Searching for "AfricAryaN" by Logic...
    Done.
    Searching for "Bahamas" by A$AP Mob...
    Done.
    Searching for "Be The One" by Dua Lipa...
    Done.
    Searching for "The Man With The Bag" by Kay Starr...
    Done.
    Searching for "No Cap" by Future...
    Done.
    Searching for "Ever Since New York" by Harry Styles...
    Done.
    Searching for "What Lovers Do (feat. SZA)" by Maroon 5...
    Done.
    Searching for "Momentz (feat. De La Soul)" by Gorillaz...
    Done.
    Searching for "Radioactive" by Imagine Dragons...
    Done.
    Searching for "Rich Love (with Seeb)" by OneRepublic...
    Done.
    Searching for "Deserve (feat. Travis Scott)" by Kris Wu...
    Done.
    Searching for "Christmas (Baby Please Come Home)" by Michael Bublé...
    Done.
    Searching for "He Like That" by Fifth Harmony...
    Done.
    Searching for "Christmas (Baby Please Come Home)" by Mariah Carey...
    Done.
    Searching for "Fell On Black Days" by Soundgarden...
    Done.
    Searching for "Paper Planes" by M.I.A....
    Done.
    Searching for "Baby Girl" by 21 Savage...
    Done.
    Searching for "Swang" by Rae Sremmurd...
    Done.
    Searching for "Go Go" by BTS...
    Done.
    Completed 200...
    Searching for "Week Without You" by Miley Cyrus...
    Done.
    Searching for "Body Like A Back Road" by Sam Hunt...
    Done.
    Searching for "Ex Calling" by 6LACK...
    Done.
    Searching for "The Happiest Christmas Tree - 2009 Digital Remaster" by Nat King Cole...
    No results found for: 'The Happiest Christmas Tree - 2009 Digital Remaster Nat King Cole'
    Could not find The Happiest Christmas Tree - 2009 Digital Remaster by Nat King Cole
    Searching for "Pendulum" by Katy Perry...
    Done.
    Searching for "Don’t Blame Me" by Taylor Swift...
    Done.
    Searching for "Black Barbies" by Nicki Minaj...
    Done.
    Searching for "Supermarket Flowers" by Ed Sheeran...
    Done.
    Searching for "Swalla (feat. Nicki Minaj & Ty Dolla $ign)" by Jason Derulo...
    Done.
    Searching for "Trap Check" by 2 Chainz...
    Done.
    Searching for "I Knew You Were Trouble." by Taylor Swift...
    Done.
    Searching for "Money Convo" by 21 Savage...
    Done.
    Searching for "CRZY" by Kehlani...
    Done.
    Searching for "Busted and Blue" by Gorillaz...
    Done.
    Searching for "Nowadays (feat. Landon Cube)" by Lil Skies...
    Done.
    Searching for "Woman" by Kesha...
    Done.
    Searching for "Live Up to My Name" by Baka Not Nice...
    Done.
    Searching for "Driving Home for Christmas" by Chris Rea...
    Done.
    Searching for "Arose" by Eminem...
    Done.
    Searching for "8TEEN" by Khalid...
    Done.
    Searching for "Only Love" by Ben Howard...
    Done.
    Searching for "By Your Side" by Jonas Blue...
    Done.
    Searching for "September" by Earth, Wind & Fire...
    Done.
    Searching for "Here Comes My Girl" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Secrets" by The Weeknd...
    Done.
    Searching for "Rendezvous" by PARTYNEXTDOOR...
    Done.
    Searching for "Jumpman" by Drake...
    Done.
    Searching for "Boredom" by Tyler, The Creator...
    Done.
    Searching for "When I Was Broke" by Future...
    Done.
    Searching for "Timeless (DJ SPINKING)" by A Boogie Wit da Hoodie...
    Specified song does not contain lyrics. Rejecting.
    Could not find Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    Searching for "Blue Pill" by Metro Boomin...
    Done.
    Searching for "Begin (feat. Wales)" by Shallou...
    Done.
    Searching for "All Time Low" by Jon Bellion...
    Done.
    Searching for "Sidewalks" by The Weeknd...
    Done.
    Searching for "OMG" by Camila Cabello...
    Done.
    Searching for "Flicker" by Niall Horan...
    Done.
    Searching for "Summer Bummer (feat. A$AP Rocky & Playboi Carti)" by Lana Del Rey...
    Done.
    Searching for "The Way Life Goes (feat. Oh Wonder)" by Lil Uzi Vert...
    Done.
    Searching for "Use Me" by Future...
    Done.
    Searching for "Reminding Me" by Shawn Hook...
    Done.
    Searching for "Dusk Till Dawn - Radio Edit" by ZAYN...
    Done.
    Searching for "Cut It (feat. Young Dolph)" by O.T. Genasis...
    Done.
    Searching for "Falls (feat. Sasha Sloan)" by ODESZA...
    Done.
    Searching for "Killing Spree" by Logic...
    Done.
    Searching for "Best Of Me" by BTS...
    Done.
    Searching for "Underneath the Tree" by Kelly Clarkson...
    Done.
    Searching for "Kept Me Crying" by HAIM...
    Done.
    Searching for "Six Feet Under" by The Weeknd...
    Done.
    Searching for "Sober II (Melodrama)" by Lorde...
    Done.
    Searching for "Exchange" by Bryson Tiller...
    Done.
    Searching for "Location" by Khalid...
    Done.
    Searching for "DUCKWORTH." by Kendrick Lamar...
    Done.
    Searching for "God Rest Ye Merry Gentlemen - Single Version" by Bing Crosby...
    Done.
    Searching for "OK (feat. Lil Pump)" by Smokepurpp...
    Done.
    Searching for "Revenge" by XXXTENTACION...
    Done.
    Searching for "Back (feat. Lil Yachty)" by Lil Pump...
    Done.
    Searching for "Starving" by Hailee Steinfeld...
    Done.
    Searching for "Rudolph the Rednose Reindeer" by DMX...
    Done.
    Searching for "Hotline Bling" by Drake...
    Done.
    Searching for "My Girl" by Dylan Scott...
    Done.
    Searching for "Even The Odds (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Wonderwall - Remastered" by Oasis...
    No results found for: 'Wonderwall - Remastered Oasis'
    Could not find Wonderwall - Remastered by Oasis
    Searching for "Alone" by Halsey...
    Done.
    Searching for "I'm the One" by DJ Khaled...
    Done.
    Searching for "Send My Love (To Your New Lover)" by Adele...
    Done.
    Searching for "True Colors" by The Weeknd...
    Done.
    Searching for "It's Beginning to Look a Lot Like Christmas" by Michael Bublé...
    Done.
    Searching for "Bastards" by Kesha...
    Done.
    Searching for "Deja Vu" by J. Cole...
    Done.
    Searching for "The Hills" by The Weeknd...
    Done.
    Searching for "Ahora Dice" by Chris Jeday...
    Done.
    Searching for "Give Me Love" by Ed Sheeran...
    Done.
    Searching for "Mama" by Jonas Blue...
    Done.
    Searching for "Want Her" by Mustard...
    Done.
    Searching for "Foldin Clothes" by J. Cole...
    Done.
    Searching for "Miracles (Someone Special)" by Coldplay...
    Done.
    Searching for "Panda" by Desiigner...
    Done.
    Searching for "Both (feat. Drake)" by Gucci Mane...
    Done.
    Searching for "America" by Logic...
    Done.
    Searching for "Nobody Else But You" by Trey Songz...
    Done.
    Searching for "BUTTERFLY EFFECT" by Travis Scott...
    Done.
    Searching for "Hunt You Down" by Kesha...
    Done.
    Searching for "Hymn" by Kesha...
    Done.
    Searching for "Breakdown" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Blue Christmas" by Elvis Presley...
    Done.
    Searching for "Castle" by Eminem...
    Done.
    Searching for "Need Me (feat. Pink)" by Eminem...
    Done.
    Searching for "Perfect Illusion" by Lady Gaga...
    Done.
    Searching for "Confess" by Logic...
    Done.
    Searching for "For Whom The Bell Tolls" by J. Cole...
    Done.
    Searching for "The Man" by The Killers...
    Done.
    Searching for "Skrt Skrt" by Tory Lanez...
    Done.
    Searching for "Run Me Dry" by Bryson Tiller...
    Done.
    Searching for "Walk On Water (feat. Beyoncé)" by Eminem...
    Done.
    Searching for "No Promises (feat. Demi Lovato)" by Cheat Codes...
    Done.
    Searching for "Who Dat Boy" by Tyler, The Creator...
    Done.
    Searching for "No Heart" by 21 Savage...
    Done.
    Searching for "Do I Make You Wanna" by Billy Currington...
    Done.
    Searching for "Step Into Christmas" by Elton John...
    Done.
    Searching for "Save Myself" by Ed Sheeran...
    Done.
    Completed 300...
    Searching for "Welcome to the Booty Tape" by Ugly God...
    Done.
    Searching for "First Love" by Lost Kings...
    Done.
    Searching for "Gospel" by Rich Brian...
    Done.
    Searching for "Call On Me - Ryan Riback Extended Remix" by Starley...
    Done.
    Searching for "First Time" by Kygo...
    Done.
    Searching for "For Now" by P!nk...
    Done.
    Searching for "ROCKABYE BABY (feat. ScHoolboy Q)" by Joey Bada$$...
    Done.
    Searching for "Needed Me" by Rihanna...
    Done.
    Searching for "Jorja Interlude" by Drake...
    Done.
    Searching for "Solo Dance" by Martin Jensen...
    Done.
    Searching for "Rockin' Around The Christmas Tree - Single Version" by Brenda Lee...
    No results found for: 'Rockin' Around The Christmas Tree - Single Version Brenda Lee'
    Could not find Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    Searching for "Crew REMIX" by GoldLink...
    Done.
    Searching for "All Ass" by Migos...
    Done.
    Searching for "End of the World" by Kelsea Ballerini...
    Done.
    Searching for "White Christmas (duet with Shania Twain)" by Michael Bublé...
    No results found for: 'White Christmas (duet with Shania Twain) Michael Bublé'
    Could not find White Christmas (duet with Shania Twain) by Michael Bublé
    Searching for "Learning To Fly" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "I Love You" by Axwell /\ Ingrosso...
    Done.
    Searching for "Mos Definitely" by Logic...
    Done.
    Searching for "Hurricane" by Luke Combs...
    Done.
    Searching for "Changed It" by Nicki Minaj...
    Done.
    Searching for "Don't Do Me Like That" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Tomorrow Til Infinity (feat. Gunna)" by Young Thug...
    Done.
    Searching for "CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS")" by Justin Timberlake...
    No results found for: 'CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") Justin Timberlake'
    Could not find CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    Searching for "DN Freestyle" by Lil Yachty...
    Done.
    Searching for "Attention" by Charlie Puth...
    Done.
    Searching for "My Love (feat. Major Lazer, WizKid, Dua Lipa)" by Wale...
    Done.
    Searching for "The Thrill Of It All" by Sam Smith...
    Done.
    Searching for "You Da Baddest" by Future...
    Done.
    Searching for "Here Comes The Sun - Remastered" by The Beatles...
    Done.
    Searching for "Gucci On My (feat. 21 Savage, YG & Migos)" by Mike WiLL Made-It...
    Done.
    Searching for "Like A Star" by Lil Yachty...
    Done.
    Searching for "Believe" by Eminem...
    Done.
    Searching for "The Louvre" by Lorde...
    Done.
    Searching for "Saturday Night" by 2 Chainz...
    Done.
    Searching for "Feel So Close - Radio Edit" by Calvin Harris...
    Done.
    Searching for "Say It (feat. Tove Lo)" by Flume...
    Done.
    Searching for "I Fall Apart" by Post Malone...
    Done.
    Searching for "Wake Up Where You Are" by State of Sound...
    Done.
    Searching for "FEEL." by Kendrick Lamar...
    Done.
    Searching for "Gold" by Kiiara...
    Done.
    Searching for "Sympathy For The Devil" by The Rolling Stones...
    Done.
    Searching for "Rudolph the Red-Nosed Reindeer" by Gene Autry...
    Done.
    Searching for "The Christmas Waltz" by Peggy Lee...
    Done.
    Searching for "Dirty Sexy Money (feat. Charli XCX & French Montana)" by David Guetta...
    Done.
    Searching for "Stranger Things" by Kyle Dixon & Michael Stein...
    Specified song does not have a valid URL with lyrics. Rejecting.
    Could not find Stranger Things by Kyle Dixon & Michael Stein
    Searching for "Numb" by Linkin Park...
    Done.
    Searching for "Lookin Exotic" by Future...
    Done.
    Searching for "Apple of My Eye" by Rick Ross...
    Done.
    Searching for "i hate u, i love u (feat. olivia o'brien)" by gnash...
    Done.
    Searching for "Do They Know It's Christmas? - 1984 Version" by Band Aid...
    Done.
    Searching for "At the Door" by Lil Pump...
    Done.
    Searching for "Heat" by Eminem...
    Done.
    Searching for "Castro" by Yo Gotti...
    Done.
    Searching for "Cold" by Maroon 5...
    Done.
    Searching for "To the Max" by DJ Khaled...
    Done.
    Searching for "Rollin (feat. Future & Khalid)" by Calvin Harris...
    Done.
    Searching for "That Range Rover Came With Steps (feat. Future & Yo Gotti)" by DJ Khaled...
    Done.
    Searching for "Boss" by Lil Pump...
    Done.
    Searching for "Framed" by Eminem...
    Done.
    Searching for "Whatever It Takes" by Imagine Dragons...
    Done.
    Searching for "Make Love" by Gucci Mane...
    Done.
    Searching for "Savage Time (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Slippery (feat. Gucci Mane)" by Migos...
    Done.
    Searching for "Save That Shit" by Lil Peep...
    Done.
    Searching for "Look Alive" by Rae Sremmurd...
    Done.
    Searching for "Bad Things - With Camila Cabello" by Machine Gun Kelly...
    Done.
    Searching for "Saturnz Barz (feat. Popcaan)" by Gorillaz...
    Done.
    Searching for "Bonita" by J Balvin...
    Done.
    Searching for "Heartache On The Dance Floor" by Jon Pardi...
    Done.
    Searching for "Flex Like Ouu" by Lil Pump...
    Done.
    Searching for "Somethin' I'm Good At" by Brett Eldredge...
    Done.
    Searching for "What I've Done" by Linkin Park...
    Done.
    Searching for "First Day Out" by Tee Grizzley...
    Done.
    Searching for "MIC Drop (feat. Desiigner) [Steve Aoki Remix]" by BTS...
    Done.
    Searching for "Courtesy Of The Red, White And Blue (The Angry American)" by Toby Keith...
    Done.
    Searching for "Getaway Car" by Taylor Swift...
    Done.
    Searching for "A Thousand Years" by Christina Perri...
    Done.
    Searching for "Bad Husband (feat. X Ambassadors)" by Eminem...
    Done.
    Searching for "Somebody Else" by VÉRITÉ...
    Done.
    Searching for "Krippy Kush - Remix" by Farruko...
    Done.
    Searching for "How U Feel" by Huncho Jack...
    Done.
    Searching for "Purple Rain" by Prince...
    Done.
    Searching for "I'm so Groovy" by Future...
    Done.
    Searching for "Sometimes..." by Tyler, The Creator...
    Done.
    Searching for "Teenage Fever" by Drake...
    Done.
    Searching for "Legend" by G-Eazy...
    Done.
    Searching for "Silent Night" by Carpenters...
    Done.
    Searching for "Merry Christmas, Happy Holidays" by *NSYNC...
    Done.
    Searching for "Despacito (Featuring Daddy Yankee)" by Luis Fonsi...
    Done.
    Searching for "All I Know" by The Weeknd...
    Done.
    Searching for "Crazy" by Lil Pump...
    Done.
    Searching for "Mr. Brightside" by The Killers...
    Done.
    Searching for "Yeah Yeah (feat. Young Thug)" by Travis Scott...
    Done.
    Searching for "Little Of Your Love - BloodPop® Remix" by HAIM...
    Done.
    Searching for "Hello" by Adele...
    Done.
    Searching for "Nancy Mulligan" by Ed Sheeran...
    Done.
    Searching for "Just Hold On" by Steve Aoki...
    Done.
    Searching for "Get The Bag" by A$AP Mob...
    Done.
    Searching for "Don't Sleep On Me (feat. Future and 24hrs)" by Ty Dolla $ign...
    Done.
    Searching for "Most Girls" by Hailee Steinfeld...
    Done.
    Completed 400...
    Searching for "Bring Dem Things" by French Montana...
    Done.
    Searching for "Christmas Lights" by Coldplay...
    Done.
    Searching for "hell is where i dreamt of u and woke up alone" by blackbear...
    Done.
    Searching for "For Free" by DJ Khaled...
    Done.
    Searching for "Feel Good (feat. Daya)" by Gryffin...
    Done.
    Searching for "Jocelyn Flores" by XXXTENTACION...
    Done.
    Searching for "Nevermind This Interlude" by Bryson Tiller...
    Done.
    Searching for "Light" by Big Sean...
    Done.
    Searching for "No Fear" by DeJ Loaf...
    Done.
    Searching for "No Problem (feat. Lil Wayne & 2 Chainz)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    Searching for "How Far I'll Go - From "Moana"" by Alessia Cara...
    Done.
    Searching for "OG Kush Diet" by 2 Chainz...
    Done.
    Searching for "Told You So" by Paramore...
    Done.
    Searching for "Quit (feat. Ariana Grande)" by Cashmere Cat...
    Done.
    Searching for "Sixteen" by Thomas Rhett...
    Done.
    Searching for "Better" by Lil Yachty...
    Done.
    Searching for "Solo" by Future...
    Done.
    Searching for "This Town (feat. Sasha Sloan)" by Kygo...
    Done.
    Searching for "XXX. FEAT. U2." by Kendrick Lamar...
    Done.
    Searching for "In Tune (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Disrespectful" by GASHI...
    Done.
    Searching for "Time To Move On" by Tom Petty...
    Done.
    Searching for "Lips" by The xx...
    Done.
    Searching for "Move Your Body - Single Mix" by Sia...
    Done.
    Searching for "ILL NANA (feat. Trippie Redd)" by DRAM...
    Done.
    Searching for "Baby, It's Cold Outside (feat. Meghan Trainor)" by Brett Eldredge...
    Done.
    Searching for "Listen To Her Heart" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Love On The Brain" by Rihanna...
    Done.
    Searching for "Run Up (feat. PARTYNEXTDOOR & Nicki Minaj)" by Major Lazer...
    Done.
    Searching for "Get Mine" by Bryson Tiller...
    Done.
    Searching for "V. 3005" by Childish Gambino...
    Done.
    Searching for "In the Blood" by John Mayer...
    Done.
    Searching for "Outta Time" by Future...
    Done.
    Searching for "Angels (feat. Saba)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find Angels (feat. Saba) by Chance the Rapper
    Searching for "Glitter" by Tyler, The Creator...
    Done.
    Searching for "Pineapple Skies" by Miguel...
    Done.
    Searching for "Wonderful Christmastime - Remastered 2011 / Edited Version" by Paul McCartney...
    Done.
    Searching for "Relationship (feat. Future)" by Young Thug...
    Done.
    Searching for "Goodbye" by Echosmith...
    Done.
    Searching for "Back to You (feat. Bebe Rexha & Digital Farm Animals)" by Louis Tomlinson...
    Done.
    Searching for "I'm the One (feat. Justin Bieber, Quavo, Chance the Rapper & Lil Wayne)" by DJ Khaled...
    Done.
    Searching for "Down" by Marian Hill...
    Done.
    Searching for "santa monica & la brea" by blackbear...
    Done.
    Searching for "F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar)" by A$AP Rocky...
    No results found for: 'F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) A$AP Rocky'
    Could not find F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    Searching for "Let You Down" by NF...
    Done.
    Searching for "When It Rains It Pours" by Luke Combs...
    Done.
    Searching for "Free Fallin'" by Tom Petty...
    Done.
    Searching for "Juju On That Beat (TZ Anthem)" by Zay Hilfigerrr...
    Done.
    Searching for "Die A Happy Man" by Thomas Rhett...
    Done.
    Searching for "DNA" by BTS...
    Done.
    Searching for "The Weekend" by Brantley Gilbert...
    Done.
    Searching for "LUV" by Tory Lanez...
    Done.
    Searching for "Selfish (feat. Rihanna)" by Future...
    Done.
    Searching for "SUBEME LA RADIO" by Enrique Iglesias...
    Done.
    Searching for "One Dance" by Drake...
    Done.
    Searching for "The Plan" by G-Eazy...
    Done.
    Searching for "Christmas (Baby Please Come Home)" by Darlene Love...
    Done.
    Searching for "It Ain't Me (with Selena Gomez)" by Kygo...
    Done.
    Searching for "Blue Ain't Your Color" by Keith Urban...
    Done.
    Searching for "Moving On and Getting Over" by John Mayer...
    Done.
    Searching for "Heaven In Hiding" by Halsey...
    Done.
    Searching for "It's Good To Be King" by Tom Petty...
    Done.
    Searching for "Run Rudolph Run - Single Version" by Chuck Berry...
    Done.
    Searching for "Out Of The Woods" by Taylor Swift...
    Done.
    Searching for "Chanel" by Frank Ocean...
    Done.
    Searching for "Harley" by Lil Yachty...
    Done.
    Searching for "Carol of the Bells" by Mykola Dmytrovych Leontovych...
    No results found for: 'Carol of the Bells Mykola Dmytrovych Leontovych'
    Could not find Carol of the Bells by Mykola Dmytrovych Leontovych
    Searching for "Plain Jane" by A$AP Ferg...
    Done.
    Searching for "Dreams" by ZHU...
    Done.
    Searching for "Stir Fry" by Migos...
    Done.
    Searching for "Seven Million (feat. Future)" by Lil Uzi Vert...
    Done.
    Searching for "All Night (feat. Knox Fortune)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find All Night (feat. Knox Fortune) by Chance the Rapper
    Searching for "Fortunate Son" by Creedence Clearwater Revival...
    Done.
    Searching for "Riding Shotgun" by Kygo...
    Done.
    Searching for "The Chain - 2004 Remaster" by Fleetwood Mac...
    Done.
    Searching for "The Last Of The Real Ones" by Fall Out Boy...
    Done.
    Searching for "Light It Up (feat. Nyla & Fuse ODG) - Remix" by Major Lazer...
    Done.
    Searching for "Mercy" by Shawn Mendes...
    Done.
    Searching for "High End" by Chris Brown...
    Done.
    Searching for "(Not) The One" by Bebe Rexha...
    Done.
    Searching for "Wildest Dreams" by Taylor Swift...
    Done.
    Searching for "Neva Missa Lost" by Future...
    Done.
    Searching for "Linus And Lucy" by Vince Guaraldi Trio...
    Done.
    Searching for "Get It Together" by Drake...
    Done.
    Searching for "Like a Stone" by Audioslave...
    Done.
    Searching for "You're Gonna Live Forever in Me" by John Mayer...
    Done.
    Searching for "HUMBLE." by Kendrick Lamar...
    Done.
    Searching for "Ric Flair Drip (& Metro Boomin)" by Offset...
    Done.
    Searching for "Wake Up Alone" by The Chainsmokers...
    Done.
    Searching for "Lust For Life (with The Weeknd)" by Lana Del Rey...
    Done.
    Searching for "Into You" by Ariana Grande...
    Done.
    Searching for "Corazón" by Maluma...
    Done.
    Searching for "Feed Me Dope" by Future...
    Done.
    Searching for "That Far" by 6LACK...
    Done.
    Searching for "Gold Digger" by Kanye West...
    Done.
    Searching for "No Frauds" by Nicki Minaj...
    Done.
    Searching for "Only 4 Me" by Chris Brown...
    Done.
    Searching for "Water Under the Bridge" by Adele...
    Done.
    Searching for "Galway Girl" by Ed Sheeran...
    Done.
    Searching for "Breakfast (feat. A$AP Rocky)" by Jaden Smith...
    Done.
    Completed 500...
    Searching for "What Do I Know?" by Ed Sheeran...
    Done.
    Searching for "City Of Stars - From "La La Land" Soundtrack" by Ryan Gosling...
    No results found for: 'City Of Stars - From "La La Land" Soundtrack Ryan Gosling'
    Could not find City Of Stars - From "La La Land" Soundtrack by Ryan Gosling
    Searching for "Work" by Rihanna...
    Done.
    Searching for "What Ifs" by Kane Brown...
    Done.
    Searching for "Tragic Endings (feat. Skylar Grey)" by Eminem...
    Done.
    Searching for "PRBLMS" by 6LACK...
    Done.
    Searching for "A$AP Ferg" by NAV...
    Done.
    Searching for "I Thank U" by Future...
    Done.
    Searching for "Light" by San Holo...
    Done.
    Searching for "Chantaje" by Shakira...
    Done.
    Searching for "I Like Me Better" by Lauv...
    Done.
    Searching for "Gangsta" by Kehlani...
    Done.
    Searching for "Born This Way" by Lady Gaga...
    Done.
    Searching for "Bad Blood" by Taylor Swift...
    Done.
    Searching for "Stargazing" by Kygo...
    Done.
    Searching for "RAF" by A$AP Mob...
    Done.
    Searching for "Dead Inside (Interlude)" by XXXTENTACION...
    Done.
    Searching for "What Child Is This?/The Holly And The Ivy" by Bing Crosby...
    Done.
    Searching for "Love Yourself" by Justin Bieber...
    Done.
    Searching for "Too Hotty" by Quality Control...
    Done.
    Searching for "IDGAF" by Dua Lipa...
    Done.
    Searching for "Only Angel" by Harry Styles...
    Done.
    Searching for "Fashion (feat. Rich The Kid)" by Jay Critch...
    Done.
    Searching for "SUPER PREDATOR (feat. Styles P)" by Joey Bada$$...
    Done.
    Searching for "Feds Did a Sweep" by Future...
    Done.
    Searching for "Y U DON'T LOVE ME? (MISS AMERIKKKA)" by Joey Bada$$...
    Done.
    Searching for "Highway to Hell" by AC/DC...
    Done.
    Searching for "How Long" by Charlie Puth...
    Done.
    Searching for "Hi Bich" by Bhad Bhabie...
    Done.
    Searching for "Really Really" by Kevin Gates...
    Done.
    Searching for "Toxic" by Britney Spears...
    Done.
    Searching for "Call on Me - Ryan Riback Remix" by Starley...
    Done.
    Searching for "Start Over" by Imagine Dragons...
    Done.
    Searching for "PILLOWTALK" by ZAYN...
    Done.
    Searching for "Baptized In Fire" by Kid Cudi...
    Done.
    Searching for "Should I Stay or Should I Go - Remastered" by The Clash...
    Done.
    Searching for "Hear Me Now" by Alok...
    Done.
    Searching for "On Everything (feat. Travis Scott, Rick Ross & Big Sean)" by DJ Khaled...
    Done.
    Searching for "Complicated (feat. Kiiara) (feat. Kiiara)" by Dimitri Vegas & Like Mike...
    Done.
    Searching for "So Good (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "My Dawg" by Quality Control...
    Done.
    Searching for "Dancing In The Dark" by Imagine Dragons...
    Done.
    Searching for "Black & Chinese" by Huncho Jack...
    Done.
    Searching for "Incredible" by Future...
    Done.
    Searching for "4 AM" by 2 Chainz...
    Done.
    Searching for "For Real" by Lil Uzi Vert...
    Done.
    Searching for "(Don't Fear) The Reaper" by Blue Öyster Cult...
    Done.
    Searching for "Romantic - NOTD Remix" by Stanaj...
    Done.
    Searching for "It's Gotta Be You" by Isaiah...
    Done.
    Searching for "Walk On Water" by A$AP Mob...
    Done.
    Searching for "Where U From" by Huncho Jack...
    Done.
    Searching for "My Only Wish (This Year)" by Britney Spears...
    Done.
    Searching for "Shook Ones, Pt. II" by Mobb Deep...
    Specified song does not contain lyrics. Rejecting.
    Could not find Shook Ones, Pt. II by Mobb Deep
    Searching for "Anywhere" by Rita Ora...
    Done.
    Searching for "Can I Be Him" by James Arthur...
    Done.
    Searching for "The Other" by Lauv...
    Done.
    Searching for "Light It Up" by Luke Bryan...
    Done.
    Searching for "Mr. Blue Sky" by Electric Light Orchestra...
    Done.
    Searching for "Losin Control" by Russ...
    Done.
    Searching for "Myself" by NAV...
    Done.
    Searching for "Supermodel" by SZA...
    Done.
    Searching for "Work REMIX" by A$AP Ferg...
    Done.
    Searching for "Love Me Like You Do - From "Fifty Shades Of Grey"" by Ellie Goulding...
    Done.
    Searching for "HOLD ME TIGHT OR DON’T" by Fall Out Boy...
    Done.
    Searching for "Set It Off" by Bryson Tiller...
    Done.
    Searching for "Fuck Love (feat. Trippie Redd)" by XXXTENTACION...
    Done.
    Searching for "top priority (with Ne-Yo)" by blackbear...
    Done.
    Searching for "I Think Of You" by Jeremih...
    Done.
    Searching for "Candy Paint" by Post Malone...
    Done.
    Searching for "Rubbin Off The Paint" by YBN Nahmir...
    Done.
    Searching for "Mask Off" by Future...
    Done.
    Searching for "Symphony (feat. Zara Larsson)" by Clean Bandit...
    Done.
    Searching for "Super Far" by LANY...
    Done.
    Searching for "Charger (feat. Grace Jones)" by Gorillaz...
    Done.
    Searching for "Sex for Breakfast" by Life of Dillon...
    Done.
    Searching for "The Greatest Show" by Hugh Jackman...
    Done.
    Searching for "Mi Gente (feat. Beyoncé)" by J Balvin...
    Done.
    Searching for "Young" by The Chainsmokers...
    Done.
    Searching for "Under The Bridge" by Red Hot Chili Peppers...
    Done.
    Searching for "Too Many Years" by Kodak Black...
    Done.
    Searching for "Baby, It's Cold Outside" by Dean Martin...
    Done.
    Searching for "Drinkin' Too Much" by Sam Hunt...
    Done.
    Searching for "Before You Judge" by Bryson Tiller...
    Done.
    Searching for "Uh Huh" by Julia Michaels...
    Done.
    Searching for "The Explanation" by XXXTENTACION...
    Done.
    Searching for "Smooth Like The Summer" by Thomas Rhett...
    Done.
    Searching for "Come Closer" by WizKid...
    Done.
    Searching for "Ambitionz Az A Ridah" by 2Pac...
    Done.
    Searching for "Taped Up Heart (feat. Clara Mae)" by KREAM...
    Done.
    Searching for "The Way Life Goes (feat. Nicki Minaj & Oh Wonder) - Remix" by Lil Uzi Vert...
    Done.
    Searching for "rockstar" by Post Malone...
    Done.
    Searching for "Killing Time" by R3HAB...
    Done.
    Searching for "Mall" by Gucci Mane...
    Done.
    Searching for "Sweet Child O' Mine" by Guns N' Roses...
    Done.
    Searching for "Royals" by Lorde...
    Done.
    Searching for "Juke Jam (feat. Justin Bieber & Towkio)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    Searching for "Something Just Like This" by The Chainsmokers...
    Done.
    Searching for "Damage" by PARTYNEXTDOOR...
    Done.
    Searching for "Pray" by Sam Smith...
    Done.
    Searching for "Self-Made" by Bryson Tiller...
    Done.
    Completed 600...
    Searching for "H.O.L.Y." by Florida Georgia Line...
    Done.
    Searching for "Love U Better (feat. Lil Wayne & The-Dream)" by Ty Dolla $ign...
    Done.
    Searching for "Your Body Is a Wonderland" by John Mayer...
    Done.
    Searching for "Dear Hate" by Maren Morris...
    Done.
    Searching for "Conscience (feat. Future)" by Kodak Black...
    Done.
    Searching for "Feel It Still" by Portugal. The Man...
    Done.
    Searching for "Hymn for the Weekend - Seeb Remix" by Coldplay...
    Done.
    Searching for "Man's Not Hot" by Big Shaq...
    Done.
    Searching for "Tip Toe (feat. French Montana)" by Jason Derulo...
    Done.
    Searching for "A Holly Jolly Christmas - Single Version" by Burl Ives...
    Done.
    Searching for "Santa Baby (with Henri René & His Orchestra)" by Eartha Kitt...
    No results found for: 'Santa Baby (with Henri René & His Orchestra) Eartha Kitt'
    Could not find Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    Searching for "You Could Be" by R3HAB...
    Done.
    Searching for "Don't Leave" by Snakehips...
    Done.
    Searching for "Santa Tell Me" by Ariana Grande...
    Done.
    Searching for "Go" by Huncho Jack...
    Done.
    Searching for "Perfect Duet (Ed Sheeran & Beyoncé)" by Ed Sheeran...
    Done.
    Searching for "Teach Me a Lesson" by Bryson Tiller...
    Done.
    Searching for "Slow Hands" by Niall Horan...
    Done.
    Searching for "Sleigh Ride" by Andy Williams...
    Done.
    Searching for "Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night" by Perry Como...
    No results found for: 'Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night Perry Como'
    Could not find Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night by Perry Como
    Searching for "Sleigh Ride" by The Ronettes...
    Done.
    Searching for "Let Me Go (with Alesso, Florida Georgia Line & watt)" by Hailee Steinfeld...
    Done.
    Searching for "Group Home" by Future...
    Done.
    Searching for "Jingle Bells - Remastered 1999" by Frank Sinatra...
    Done.
    Searching for "Worst In Me" by Julia Michaels...
    Done.
    Searching for "Bad Romance" by Lady Gaga...
    Done.
    Searching for "Two Birds, One Stone" by Drake...
    Done.
    Searching for "Tell Me You Love Me" by Demi Lovato...
    Done.
    Searching for "GUMMO" by 6ix9ine...
    Done.
    Searching for "Coaster" by Khalid...
    Done.
    Searching for "Sway (feat. Quavo & Lil Yachty)" by NexXthursday...
    Done.
    Searching for "Don't Judge Me (feat. Future and Swae Lee)" by Ty Dolla $ign...
    Done.
    Searching for "Escápate Conmigo" by Wisin...
    Done.
    Searching for "Sit Next to Me" by Foster The People...
    Done.
    Searching for "Love Galore (feat. Travis Scott)" by SZA...
    Specified song does not contain lyrics. Rejecting.
    Could not find Love Galore (feat. Travis Scott) by SZA
    Searching for "gucci linen (feat. 2 Chainz)" by blackbear...
    Done.
    Searching for "Questions" by Chris Brown...
    Done.
    Searching for "679 (feat. Remy Boyz)" by Fetty Wap...
    Done.
    Searching for "Champions" by Kanye West...
    Done.
    Searching for "Don't Say" by The Chainsmokers...
    Done.
    Searching for "Portland" by Drake...
    Done.
    Searching for "Échame La Culpa" by Luis Fonsi...
    Done.
    Searching for "20 Min" by Lil Uzi Vert...
    Done.
    Searching for "O Little Town of Bethlehem" by Elvis Presley...
    Done.
    Searching for "Supercut" by Lorde...
    Done.
    Searching for "Whatever (feat. Future, Young Thug, Rick Ross & 2 Chainz)" by DJ Khaled...
    Done.
    Searching for "Too Good At Goodbyes" by Sam Smith...
    Done.
    Searching for "Bad At Love" by Halsey...
    Done.
    Searching for "Chicken Fried" by Zac Brown Band...
    Done.
    Searching for "Stunting Ain't Nuthin (feat. Slim Jxmmi & Young Dolph)" by Gucci Mane...
    Done.
    Searching for "Audition (The Fools Who Dream) - From "La La Land" Soundtrack" by Emma Stone...
    No results found for: 'Audition (The Fools Who Dream) - From "La La Land" Soundtrack Emma Stone'
    Could not find Audition (The Fools Who Dream) - From "La La Land" Soundtrack by Emma Stone
    Searching for "Without You (feat. Sandro Cavazza)" by Avicii...
    Done.
    Searching for "Marry Me" by Thomas Rhett...
    Done.
    Searching for "Chantaje (feat. Maluma)" by Shakira...
    Done.
    Searching for "PRIDE." by Kendrick Lamar...
    Done.
    Searching for "Cut To The Feeling" by Carly Rae Jepsen...
    Done.
    Searching for "In The End" by Linkin Park...
    Done.
    Searching for "Reggaetón Lento (Remix)" by CNCO...
    Done.
    Searching for "We Wish You A Merry Christmas" by John Denver...
    Done.
    Searching for "Running Back (feat. Lil Wayne)" by Wale...
    Done.
    Searching for "Cold Water (feat. Justin Bieber & MØ)" by Major Lazer...
    Done.
    Searching for "wokeuplikethis*" by Playboi Carti...
    Done.
    Searching for "Mink Flow" by Future...
    Done.
    Searching for "Mess Is Mine" by Vance Joy...
    Done.
    Searching for "Famous" by 21 Savage...
    Done.
    Searching for "I Ain't Got Time!" by Tyler, The Creator...
    Done.
    Searching for "Look at Me!" by XXXTENTACION...
    Done.
    Searching for "Disrespectful" by 21 Savage...
    Done.
    Searching for "I'm Shipping Up To Boston" by Dropkick Murphys...
    Done.
    Searching for "Iced Out (feat. 2 Chainz)" by Lil Pump...
    Done.
    Searching for "Final Song" by MØ...
    Done.
    Searching for "Both (feat. Drake & Lil Wayne) - Remix" by Gucci Mane...
    Done.
    Searching for "Sweat" by The All-American Rejects...
    Done.
    Searching for "Chloraseptic (feat. Phresher)" by Eminem...
    Done.
    Searching for "Huncho Jack" by Huncho Jack...
    Done.
    Searching for "La Modelo" by Ozuna...
    Done.
    Searching for "You Can Call Me Al" by Paul Simon...
    Done.
    Searching for "Mi Gente" by J Balvin...
    Done.
    Searching for "Buy U a Drank (Shawty Snappin')" by T-Pain...
    Done.
    Searching for "You Don't Do It For Me Anymore" by Demi Lovato...
    Done.
    Searching for "Liability (Reprise)" by Lorde...
    Done.
    Searching for "U Said" by Lil Peep...
    Done.
    Searching for "Want You Back" by HAIM...
    Done.
    Searching for "Disco Tits" by Tove Lo...
    Done.
    Searching for "A Million Dreams" by Ziv Zaifman...
    Done.
    Searching for "It Wasn't Me" by Shaggy...
    Done.
    Searching for "Happier" by Ed Sheeran...
    Done.
    Searching for "Nowhere Fast (feat. Kehlani)" by Eminem...
    Done.
    Searching for "Thug Life" by 21 Savage...
    Done.
    Searching for "Halfway Off The Balcony" by Big Sean...
    Done.
    Searching for "Zoom" by Future...
    Done.
    Searching for "Thunder" by Imagine Dragons...
    Done.
    Searching for "Undefeated (feat. 21 Savage)" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Provider" by Frank Ocean...
    Done.
    Searching for "Nothin New" by 21 Savage...
    Done.
    Searching for "Would You Ever" by Skrillex...
    Done.
    Searching for "Early 20 Rager" by Lil Uzi Vert...
    Done.
    Searching for "Still Got Time" by ZAYN...
    Done.
    Searching for "Misunderstood" by PnB Rock...
    Done.
    Searching for "Up" by Desiigner...
    Done.
    Completed 700...
    Searching for "New" by Daya...
    Done.
    Searching for "Respect" by Aretha Franklin...
    Done.
    Searching for "Pop Style" by Drake...
    Done.
    Searching for "You Got Lucky" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "You & Me" by Marc E. Bassy...
    Done.
    Searching for "Feel Me" by Tyga...
    Done.
    Searching for "Kelly Price (feat. Travis Scott)" by Migos...
    Done.
    Searching for "Bad Mood" by Miley Cyrus...
    Done.
    Searching for "FaceTime" by 21 Savage...
    Done.
    Searching for "The A Team" by Ed Sheeran...
    Done.
    Searching for "What If" by Kevin Gates...
    Done.
    Searching for "She's My Collar (feat. Kali Uchis)" by Gorillaz...
    Done.
    Searching for "A Guy With a Girl" by Blake Shelton...
    Done.
    Searching for "ELEMENT." by Kendrick Lamar...
    Done.
    Searching for "Greatest Love Story" by LANCO...
    Done.
    Searching for "Stop Draggin' My Heart Around (with Tom Petty & the Heartbreakers) - 2016 Remaster; Remastered" by Stevie Nicks...
    No results found for: 'Stop Draggin' My Heart Around (with Tom Petty & the Heartbreakers) - 2016 Remaster; Remastered Stevie Nicks'
    Could not find Stop Draggin' My Heart Around (with Tom Petty & the Heartbreakers) - 2016 Remaster; Remastered by Stevie Nicks
    Searching for "Seeing Blind" by Niall Horan...
    Done.
    Searching for "Attention" by The Weeknd...
    Done.
    Searching for "Kiss" by Prince...
    Done.
    Searching for "Learn To Let Go" by Kesha...
    Done.
    Searching for "Hard Feelings/Loveless" by Lorde...
    Done.
    Searching for "DEVASTATED" by Joey Bada$$...
    Done.
    Searching for "Havana - Remix" by Camila Cabello...
    Done.
    Searching for "Up" by NAV...
    Done.
    Searching for "Close My Eyes" by 21 Savage...
    Done.
    Searching for "Jump Out The Window" by Big Sean...
    Done.
    Searching for "Yours" by Russell Dickerson...
    Done.
    Searching for "Either Way" by Chris Stapleton...
    Done.
    Searching for "Please Shut Up" by A$AP Mob...
    Done.
    Searching for "Money Trees" by Kendrick Lamar...
    Done.
    Searching for "A Different Way (with Lauv)" by DJ Snake...
    Done.
    Searching for "Whole Lot" by 21 Savage...
    Done.
    Searching for "Erase Your Social" by Lil Uzi Vert...
    Done.
    Searching for "Blem" by Drake...
    Done.
    Searching for "All of Me" by John Legend...
    Done.
    Searching for "In Case You Didn't Know" by Brett Young...
    Done.
    Searching for "Lust for Life (with The Weeknd)" by Lana Del Rey...
    Done.
    Searching for "Who's Stopping Me (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Shot Down" by Khalid...
    Done.
    Searching for "Sunset Lover" by Petit Biscuit...
    Done.
    Searching for "Issues" by Julia Michaels...
    Done.
    Searching for "Spoonman" by Soundgarden...
    Done.
    Searching for "Garden Shed" by Tyler, The Creator...
    Done.
    Searching for "Whitney (feat. Chief Keef)" by Lil Pump...
    Done.
    Searching for "T-Shirt (Spotify Mix) - Recorded at Spotify Studios NYC" by Migos...
    No results found for: 'T-Shirt (Spotify Mix) - Recorded at Spotify Studios NYC Migos'
    Could not find T-Shirt (Spotify Mix) - Recorded at Spotify Studios NYC by Migos
    Searching for "Bedroom Floor" by Liam Payne...
    Done.
    Searching for "Idfc" by blackbear...
    Done.
    Searching for "Moves" by Big Sean...
    Done.
    Searching for "From the Dining Table" by Harry Styles...
    Done.
    Searching for "Losing Sleep" by Chris Young...
    Done.
    Searching for "Now and Later" by Sage The Gemini...
    Done.
    Searching for "Come On Eileen" by Dexys Midnight Runners...
    Done.
    Searching for "A Nightmare on My Street" by DJ Jazzy Jeff & The Fresh Prince...
    Done.
    Searching for "Massage In My Room" by Future...
    Done.
    Searching for "Angel" by Fifth Harmony...
    Done.
    Searching for "Monster Mash" by Bobby "Boris" Pickett & The Crypt-Kickers...
    Done.
    Searching for "Se Preparó" by Ozuna...
    Done.
    Searching for "Where This Flower Blooms" by Tyler, The Creator...
    Done.
    Searching for "Go For Broke (feat. James Arthur)" by Machine Gun Kelly...
    Done.
    Searching for "Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording" by Judy Garland...
    No results found for: 'Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording Judy Garland'
    Could not find Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    Searching for "No Scrubs" by TLC...
    Done.
    Searching for "Bodak Yellow" by Cardi B...
    Done.
    Searching for "Neon Guts (feat. Pharrell Williams)" by Lil Uzi Vert...
    Done.
    Searching for "Mask Off - Remix" by Future...
    Done.
    Searching for "I'll Be Home For Christmas - Single Version" by Bing Crosby...
    Done.
    Searching for "Love So Soft" by Kelly Clarkson...
    Done.
    Searching for "Two Ghosts" by Harry Styles...
    Done.
    Searching for "Crew (feat. Brent Faiyaz & Shy Glizzy)" by GoldLink...
    Done.
    Searching for "Thriller" by Michael Jackson...
    Done.
    Searching for "Poker Face" by Lady Gaga...
    Done.
    Searching for "Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus]" by Lou Monte...
    No results found for: 'Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] Lou Monte'
    Could not find Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] by Lou Monte
    Searching for "Lighthouse - Andrelli Remix" by Hearts & Colors...
    Done.
    Searching for "Stay With Me" by Sam Smith...
    Done.
    Searching for "Jingle Bells (feat. The Puppini Sisters)" by Michael Bublé...
    Done.
    Searching for "10 Feet Down" by NF...
    Done.
    Searching for "Get You (feat. Kali Uchis)" by Daniel Caesar...
    Done.
    Searching for "Poor Fool" by 2 Chainz...
    Done.
    Searching for "Smoke My Dope (feat. Smokepurpp)" by Lil Pump...
    Done.
    Searching for "Better Off - Dying" by Lil Peep...
    Done.
    Searching for "Never Be the Same" by Camila Cabello...
    Done.
    Searching for "September Song" by JP Cooper...
    Done.
    Searching for "Love on the Weekend" by John Mayer...
    Done.
    Searching for "Work from Home (feat. Ty Dolla $ign)" by Fifth Harmony...
    Done.
    Searching for "Hometown Girl" by Josh Turner...
    Done.
    Searching for "Don't Let Me Down" by The Chainsmokers...
    Done.
    Searching for "Skrt On Me (feat. Nicki Minaj)" by Calvin Harris...
    Done.
    Searching for "Family Don't Matter (feat. Millie Go Lightly)" by Young Thug...
    Done.
    Searching for "Mayores" by Becky G...
    Done.
    Searching for "Passionfruit" by Drake...
    Done.
    Searching for "Black Beatles" by Rae Sremmurd...
    Done.
    Searching for "0 To 100 / The Catch Up" by Drake...
    Done.
    Searching for "Submission (feat. Danny Brown & Kelela)" by Gorillaz...
    Done.
    Searching for "Boys" by Charli XCX...
    Done.
    Searching for "Smoke Break (feat. Future)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find Smoke Break (feat. Future) by Chance the Rapper
    Searching for "Damage" by Future...
    Done.
    Searching for "Beamer Boy" by Lil Peep...
    Done.
    Searching for "Hey Ya! - Radio Mix / Club Mix" by OutKast...
    Done.
    Searching for "When You Look Like That" by Thomas Rhett...
    Done.
    Searching for "Slide (feat. Frank Ocean & Migos)" by Calvin Harris...
    Done.
    Searching for "In The Arms Of A Stranger - Grey Remix" by Mike Posner...
    Done.
    Completed 800...
    Searching for "Money Problems / Benz Truck" by Bryson Tiller...
    Done.
    Searching for "Magnolia" by Playboi Carti...
    Done.
    Searching for "Liability" by Lorde...
    Done.
    Searching for "Mouth Of The River" by Imagine Dragons...
    Done.
    Searching for "Both Eyes Closed (feat. 2 Chainz and Young Dolph)" by Gucci Mane...
    Done.
    Searching for "Sorry" by Future...
    Done.
    Searching for "You & Me" by Marshmello...
    Done.
    Searching for "Rubbin off the Paint" by YBN Nahmir...
    Done.
    Searching for "Sober" by G-Eazy...
    Done.
    Searching for "Something New (feat. Ty Dolla $ign)" by Wiz Khalifa...
    Done.
    Searching for "24K Magic" by Bruno Mars...
    Done.
    Searching for "Ghostbusters" by Ray Parker, Jr....
    Done.
    Searching for "Outro: Her" by BTS...
    Done.
    Searching for "Change" by J. Cole...
    Done.
    Searching for "Starboy" by The Weeknd...
    Done.
    Searching for "The Waiting" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Dangerous Woman" by Ariana Grande...
    Done.
    Searching for "Intro: Serendipity" by BTS...
    Done.
    Searching for "Whippin (feat. Felix Snow)" by Kiiara...
    Done.
    Searching for "How Would You Feel (Paean)" by Ed Sheeran...
    Done.
    Searching for "Don't Wanna Know" by Maroon 5...
    Done.
    Searching for "One Foot" by WALK THE MOON...
    Done.
    Searching for "Water" by Ugly God...
    Done.
    Searching for "Beast Mode (feat. PnB Rock & YoungBoy Never Broke Again)" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Cheap Thrills" by Sia...
    Done.
    Searching for "Ink Blot" by Logic...
    Done.
    Searching for "Scars To Your Beautiful" by Alessia Cara...
    Done.
    Searching for "Hearts Don't Break Around Here" by Ed Sheeran...
    Done.
    Searching for "Pothole" by Tyler, The Creator...
    Done.
    Searching for "Wicked" by Future...
    Done.
    Searching for "Bohemian Rhapsody - Remastered 2011" by Queen...
    Done.
    Searching for "What U Sayin' (feat. Smokepurpp)" by Lil Pump...
    Done.
    Searching for "You Broke Up with Me" by Walker Hayes...
    Done.
    Searching for "Trap Paris (feat. Quavo & Ty Dolla $ign)" by Machine Gun Kelly...
    Done.
    Searching for "J-Boy" by Phoenix...
    Done.
    Searching for "Black SpiderMan" by Logic...
    Done.
    Searching for "Depression & Obsession" by XXXTENTACION...
    Done.
    Searching for "do re mi" by blackbear...
    Done.
    Searching for "Love Myself" by Hailee Steinfeld...
    Done.
    Searching for "The Greatest" by Sia...
    Done.
    Searching for "Broken Clocks" by SZA...
    Done.
    Searching for "D Rose" by Lil Pump...
    Done.
    Searching for "River - Recorded At RAK Studios, London" by Sam Smith...
    Done.
    Searching for "Thrift Shop (feat. Wanz)" by Macklemore & Ryan Lewis...
    Specified song does not contain lyrics. Rejecting.
    Could not find Thrift Shop (feat. Wanz) by Macklemore & Ryan Lewis
    Searching for "Pills & Automobiles" by Chris Brown...
    Done.
    Searching for "FEAR." by Kendrick Lamar...
    Done.
    Searching for "Immortal" by J. Cole...
    Done.
    Searching for "My Collection" by Future...
    Done.
    Searching for "A Violent Noise" by The xx...
    Done.
    Searching for "You Belong With Me" by Taylor Swift...
    Done.
    Searching for "Instruction (feat. Demi Lovato & Stefflon Don)" by Jax Jones...
    Done.
    Searching for "No Lies (feat. Wiz Khalifa)" by Ugly God...
    Done.
    Searching for "Versatile" by Kodak Black...
    Done.
    Searching for "goosebumps" by Travis Scott...
    Done.
    Searching for "Setting Fires" by The Chainsmokers...
    Done.
    Searching for "Hard to Love (feat. Jessie Reyez)" by Calvin Harris...
    Done.
    Searching for "All Falls Down (feat. Juliander)" by Alan Walker...
    Done.
    Searching for "Uptown Funk" by Mark Ronson...
    Done.
    Searching for "Rainbowland" by Miley Cyrus...
    Done.
    Searching for "Feels Great (feat. Fetty Wap & CVBZ)" by Cheat Codes...
    Done.
    Searching for "Style" by Taylor Swift...
    Done.
    Searching for "Foreword" by Tyler, The Creator...
    Done.
    Searching for "1942 Flows" by Meek Mill...
    Done.
    Searching for "The Christmas Song (Merry Christmas To You)" by Nat King Cole...
    Done.
    Searching for "Bigger Than Me" by Big Sean...
    Done.
    Searching for "The Weekend" by SZA...
    Done.
    Searching for "Sign of the Times" by Harry Styles...
    Done.
    Searching for "Uber Everywhere" by MadeinTYO...
    Done.
    Searching for "No Type" by Rae Sremmurd...
    Done.
    Searching for "Redbone" by Childish Gambino...
    Done.
    Searching for "Let Her Go" by Passenger...
    Done.
    Searching for "Wolves" by Selena Gomez...
    Done.
    Searching for "Written in the Sand" by Old Dominion...
    Done.
    Searching for "Ophelia" by The Lumineers...
    Done.
    Searching for "Congratulations - Remix" by Post Malone...
    Done.
    Searching for "Party In The U.S.A." by Miley Cyrus...
    Done.
    Searching for "Tu Sabes Que Te Quiero" by Chucho Flash...
    Done.
    Searching for "Twelve Days Of Christmas - Single Version" by Bing Crosby...
    Done.
    Searching for "Me You" by Russ...
    Done.
    Searching for "I Got You" by Bebe Rexha...
    Done.
    Searching for "White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London" by George Ezra...
    No results found for: 'White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London George Ezra'
    Could not find White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London by George Ezra
    Searching for "Grave" by Thomas Rhett...
    Done.
    Searching for "Earned It (Fifty Shades Of Grey)" by The Weeknd...
    Done.
    Searching for "I Have Questions" by Camila Cabello...
    Done.
    Searching for "Blowing Smoke" by Bryson Tiller...
    Done.
    Searching for "Big On Big" by Migos...
    Done.
    Searching for "The Cure" by Lady Gaga...
    Done.
    Searching for "Now Or Never" by Halsey...
    Done.
    Searching for "Bibia Be Ye Ye" by Ed Sheeran...
    Done.
    Searching for "Too Much Sauce" by DJ Esco...
    Done.
    Searching for "Oceans Away" by A R I Z O N A...
    Done.
    Searching for "Bartier Cardi (feat. 21 Savage)" by Cardi B...
    Done.
    Searching for "Ayala (Outro)" by XXXTENTACION...
    Done.
    Searching for "Yeah Right" by Vince Staples...
    Done.
    Searching for "Rain Interlude" by Bryson Tiller...
    Done.
    Searching for "I Write Sins Not Tragedies" by Panic! At The Disco...
    Done.
    Searching for "Havana" by Camila Cabello...
    Done.
    Searching for "Big Bidness (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Betrayed" by Lil Xan...
    Done.
    Searching for "Good Drank" by 2 Chainz...
    Done.
    Completed 900...
    Searching for "Culture (feat. DJ Khaled)" by Migos...
    Done.
    Searching for "History" by Olivia Holt...
    Done.
    Searching for "Up All Night" by Beck...
    Done.
    Searching for "anxiety (with FRND)" by blackbear...
    Done.
    Searching for "American Teen" by Khalid...
    Done.
    Searching for "Santeria" by Sublime...
    Done.
    Searching for "You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas'" by Thurl Ravenscroft...
    No results found for: 'You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' Thurl Ravenscroft'
    Could not find You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    Searching for "Sweetheart" by Thomas Rhett...
    Done.
    Searching for "Him & I (with Halsey)" by G-Eazy...
    Done.
    Searching for "UnFazed (feat. The Weeknd)" by Lil Uzi Vert...
    Done.
    Searching for "I Took A Pill In Ibiza - Seeb Remix" by Mike Posner...
    Done.
    Searching for "Star Of The Show" by Thomas Rhett...
    Done.
    Searching for "Obsession (feat. Jon Bellion)" by Vice...
    Done.
    Searching for "Unforgettable" by French Montana...
    Done.
    Searching for "Thunder / Young Dumb & Broke (with Khalid) - Medley" by Imagine Dragons...
    Done.
    Searching for "Offended" by Eminem...
    Done.
    Searching for "Treat You Better" by Shawn Mendes...
    Done.
    Searching for "Telephone" by Lady Gaga...
    Done.
    Searching for "Beautiful People Beautiful Problems (feat. Stevie Nicks)" by Lana Del Rey...
    Done.
    Searching for "Hypnotised" by Coldplay...
    Done.
    Searching for "You Don't Know Me - Radio Edit" by Jax Jones...
    Done.
    Searching for "Homemade Dynamite - REMIX" by Lorde...
    Done.
    Searching for "This Is Me" by Keala Settle...
    Done.
    Searching for "Iris" by The Goo Goo Dolls...
    Done.
    Searching for "Billie Jean" by Michael Jackson...
    Done.
    Searching for "Good Life (with G-Eazy & Kehlani)" by G-Eazy...
    Done.
    Searching for "Johnny B. Goode" by Chuck Berry...
    Done.
    Searching for "Twist And Shout - Remastered" by The Beatles...
    Done.
    Searching for "King Of My Heart" by Taylor Swift...
    Done.
    Searching for "Let Me Explain" by Bryson Tiller...
    Done.
    Searching for "Fuck Ugly God" by Ugly God...
    Done.
    Searching for "Here Comes Santa Claus (Right Down Santa Claus Lane)" by Gene Autry...
    Done.
    Searching for "No Limit" by G-Eazy...
    Done.
    Searching for "Easy Love" by Lauv...
    Done.
    Searching for "MIC Drop" by BTS...
    Done.
    Searching for "Pull Up N Wreck (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "So Good (feat. Ty Dolla $ign)" by Zara Larsson...
    Done.
    Searching for "American Dream (feat. J.Cole, Kendrick Lamar)" by Jeezy...
    Done.
    Searching for "Still Here" by Drake...
    Done.
    Searching for "On Hold" by The xx...
    Done.
    Searching for "Take It Back" by Logic...
    Done.
    Searching for "The Race" by 22 Savage...
    Done.
    Searching for "Issues (feat. Russ)" by PnB Rock...
    Done.
    Searching for "Winter Wonderland" by Bing Crosby...
    Done.
    Searching for "Gassed Up" by Nebu Kiniza...
    Done.
    Searching for "Patty Cake" by Kodak Black...
    Done.
    Searching for "Happy - From "Despicable Me 2"" by Pharrell Williams...
    No results found for: 'Happy - From "Despicable Me 2" Pharrell Williams'
    Could not find Happy - From "Despicable Me 2" by Pharrell Williams
    Searching for "The Day I Tried To Live" by Soundgarden...
    Done.
    Searching for "Is That For Me" by Alesso...
    Done.
    Searching for "Mixtape (feat. Young Thug & Lil Yachty)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find Mixtape (feat. Young Thug & Lil Yachty) by Chance the Rapper
    Searching for "Audi." by Smokepurpp...
    Done.
    Searching for "The Brightside" by Lil Peep...
    Done.
    Searching for "Fetish (feat. Gucci Mane)" by Selena Gomez...
    Done.
    Searching for "Me and Julio Down by the Schoolyard" by Paul Simon...
    Done.
    Searching for "100 Letters" by Halsey...
    Done.
    Searching for "Somethin Tells Me" by Bryson Tiller...
    Done.
    Searching for "Spice Girl" by Aminé...
    Done.
    Searching for "O Come, All Ye Faithful" by Pentatonix...
    Done.
    Searching for "Lose You" by Drake...
    Done.
    Searching for "There He Go" by Kodak Black...
    Done.
    Searching for "Hallelujah" by Pentatonix...
    Done.
    Searching for "Bounce Back" by Big Sean...
    Done.
    Searching for "Younger Now" by Miley Cyrus...
    Done.
    Searching for "Weak" by AJR...
    Done.
    Searching for "Sweet Home Alabama" by Lynyrd Skynyrd...
    Done.
    Searching for "River (feat. Ed Sheeran)" by Eminem...
    Done.
    Searching for "Feels So Good" by A$AP Mob...
    Done.
    Searching for "Can't Feel My Face" by The Weeknd...
    Done.
    Searching for "Kids in Love" by Kygo...
    Done.
    Searching for "Controlla" by Drake...
    Done.
    Searching for "Prayers Up (feat. Travis Scott & A-Trak)" by Calvin Harris...
    Done.
    Searching for "bright pink tims (feat. Cam'ron)" by blackbear...
    Done.
    Searching for "The Race" by Tay-K...
    Done.
    Searching for "Feelings Mutual" by Lil Uzi Vert...
    Done.
    Searching for "How Long (feat. French Montana) - Remix" by Charlie Puth...
    Done.
    Searching for "Help Me Out" by Maroon 5...
    Done.
    Searching for "X (feat. Future)" by 21 Savage...
    Done.
    Searching for "'Till I Collapse" by Eminem...
    Done.
    Searching for "Privacy" by Chris Brown...
    Done.
    Searching for "Find You" by Nick Jonas...
    Done.
    Searching for "Dark Knight Dummo (Feat. Travis Scott)" by Trippie Redd...
    Done.
    Searching for "So Am I (feat. Damian Marley & Skrillex)" by Ty Dolla $ign...
    Done.
    Searching for "...Baby One More Time - Recorded at Spotify Studios NYC" by Ed Sheeran...
    Done.
    Searching for "Monster Mash" by Bobby "Boris" Pickett...
    Done.
    Searching for "Cold December Night" by Michael Bublé...
    Done.
    Searching for "Congratulations" by Post Malone...
    Done.
    Searching for "I Dare You" by The xx...
    Done.
    Searching for "Malfunction" by Lil Uzi Vert...
    Done.
    Searching for "ABC" by The Jackson 5...
    Done.
    Searching for "Legend" by Drake...
    Done.
    Searching for "Death Of A Bachelor" by Panic! At The Disco...
    Done.
    Searching for "Do What I Want" by Lil Uzi Vert...
    Done.
    Searching for "Skepta Interlude" by Drake...
    Done.
    Searching for "No Promises" by A Boogie Wit da Hoodie...
    Done.
    Searching for "All I Want for Christmas Is You" by Michael Bublé...
    Done.
    Searching for "American Girl" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "It Won't Kill Ya" by The Chainsmokers...
    Done.
    Searching for "Even The Losers" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Living Single" by Big Sean...
    Done.
    Searching for "Perplexing Pegasus" by Rae Sremmurd...
    Done.
    Completed 1000...
    Searching for "BOOGIE" by BROCKHAMPTON...
    Done.
    Searching for "Let It Snow! Let It Snow! Let It Snow!" by Dean Martin...
    Done.
    Searching for "Writer In The Dark" by Lorde...
    Done.
    Searching for "Burning" by Sam Smith...
    Done.
    Searching for "All Night" by The Vamps...
    Done.
    Searching for "Money Team" by Friyie...
    Done.
    Searching for "Perfect" by Ed Sheeran...
    Done.
    Searching for "At My Best (feat. Hailee Steinfeld)" by Machine Gun Kelly...
    Done.
    Searching for "Ghostface Killers" by 21 Savage...
    Done.
    Searching for "Keep Quiet" by Future...
    Done.
    Searching for "Call Casting" by Migos...
    Done.
    Searching for "High For Hours" by J. Cole...
    Done.
    Searching for "Wyclef Jean" by Young Thug...
    Done.
    Searching for "Scars" by Sam Smith...
    Done.
    Searching for "Ain't No Mountain High Enough" by Marvin Gaye...
    Done.
    Searching for "So It Goes..." by Taylor Swift...
    Done.
    Searching for "You Can't Hurry Love - 2016 Remastered" by Phil Collins...
    No results found for: 'You Can't Hurry Love - 2016 Remastered Phil Collins'
    Could not find You Can't Hurry Love - 2016 Remastered by Phil Collins
    Searching for "Vuelve" by Daddy Yankee...
    Done.
    Searching for "Jingle Bell Rock" by Bobby Helms...
    Done.
    Searching for "Nothings Into Somethings" by Drake...
    Done.
    Searching for "Reason (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Dab of Ranch - Recorded at Spotify Studios NYC" by Migos...
    No results found for: 'Dab of Ranch - Recorded at Spotify Studios NYC Migos'
    Could not find Dab of Ranch - Recorded at Spotify Studios NYC by Migos
    Searching for "Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975" by Bruce Springsteen...
    No results found for: 'Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975 Bruce Springsteen'
    Could not find Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975 by Bruce Springsteen
    Searching for "True Feeling" by Galantis...
    Done.
    Searching for "Always (Outro)" by Bryson Tiller...
    Done.
    Searching for "Sooner Or Later" by Aaron Carter...
    Done.
    Searching for "Santa's Coming For Us" by Sia...
    Done.
    Searching for "Just Dance" by Lady Gaga...
    Done.
    Searching for "Ice Melts" by Drake...
    Done.
    Searching for "Jump" by French Montana...
    Done.
    Searching for "Any Ol' Barstool" by Jason Aldean...
    Done.
    Searching for "Heatstroke" by Calvin Harris...
    Done.
    Searching for "You Spin Me Round (Like a Record)" by Dead Or Alive...
    Done.
    Searching for "Miss You" by Louis Tomlinson...
    Done.
    Searching for "Party Monster" by The Weeknd...
    Done.
    Searching for "Stand by Me" by Otis Redding...
    Done.
    Searching for "Carry On" by XXXTENTACION...
    Done.
    Searching for "In Your Head" by Eminem...
    Done.
    Searching for "All We Got (feat. Kanye West & Chicago Children's Choir)" by Chance the Rapper...
    Specified song does not contain lyrics. Rejecting.
    Could not find All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    Searching for "Madiba Riddim" by Drake...
    Done.
    Searching for "Never Let You Go" by Kygo...
    Done.
    Searching for "Tone it Down (feat. Chris Brown)" by Gucci Mane...
    Done.
    Searching for "Arrows" by Foo Fighters...
    Done.
    Searching for "Changing" by John Mayer...
    Done.
    Searching for "Happy Xmas (War Is Over) - Remastered" by John Lennon...
    No results found for: 'Happy Xmas (War Is Over) - Remastered John Lennon'
    Could not find Happy Xmas (War Is Over) - Remastered by John Lennon
    Searching for "Pretty Mami" by Lil Uzi Vert...
    Done.
    Searching for "I Want You Back" by The Jackson 5...
    Done.
    Searching for "False Alarm" by The Weeknd...
    Done.
    Searching for "Jingle Bell Rock - Daryl's Version" by Daryl Hall & John Oates...
    Done.
    Searching for "Poles 1469" by Trippie Redd...
    Done.
    Searching for "Motorcycle Patches" by Huncho Jack...
    Done.
    Searching for "The Night We Met" by Lord Huron...
    Done.
    Searching for "Jingle Bell Rock (Glee Cast Version)" by Glee Cast...
    Done.
    Searching for "Home (with Machine Gun Kelly, X Ambassadors & Bebe Rexha)" by Machine Gun Kelly...
    Done.
    Searching for "Never Enough" by Loren Allred...
    Done.
    Searching for "Peepin out the Blinds" by Gucci Mane...
    Done.
    Searching for "Anything That's Rock 'N' Roll" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "All Me" by Drake...
    Done.
    Searching for "Here We Come a-Caroling / We Wish You a Merry Christmas" by Perry Como...
    Done.
    Searching for "Feliz Navidad" by José Feliciano...
    Done.
    Searching for "Looking for a Star" by XXXTENTACION...
    Done.
    Searching for "Stop Smoking Black & Milds" by Ugly God...
    Done.
    Searching for "Run For Cover" by The Killers...
    Done.
    Searching for "Forgiveness" by Paramore...
    Done.
    Searching for "What About Us" by P!nk...
    Done.
    Searching for "LOYALTY. FEAT. RIHANNA." by Kendrick Lamar...
    Done.
    Searching for "Plot Twist" by Marc E. Bassy...
    Done.
    Searching for "No Option" by Post Malone...
    Done.
    Searching for "The One" by The Chainsmokers...
    Done.
    Searching for "You Got It" by Bryson Tiller...
    Done.
    Searching for "Don't Stop Believin'" by Journey...
    Done.
    Searching for "No Vacancy" by OneRepublic...
    Done.
    Searching for "Real Friends" by Camila Cabello...
    Done.
    Searching for "One More Light" by Linkin Park...
    Done.
    Searching for "Shake It Off" by Taylor Swift...
    Done.
    Searching for "May I Have This Dance (Remix) [feat. Chance the Rapper]" by Francis and the Lights...
    Done.
    Searching for "Better Man" by Little Big Town...
    Done.
    Searching for "Have Yourself a Merry Little Christmas" by Michael Bublé...
    Done.
    Searching for "Pull a Caper (feat. Kodak Black, Gucci Mane & Rick Ross)" by DJ Khaled...
    Specified song does not contain lyrics. Rejecting.
    Could not find Pull a Caper (feat. Kodak Black, Gucci Mane & Rick Ross) by DJ Khaled
    Searching for "Last Christmas" by Wham!...
    Done.
    Searching for "Father Stretch My Hands Pt. 1" by Kanye West...
    Done.
    Searching for "Sorry Not Sorry" by Demi Lovato...
    Done.
    Searching for "How Far I'll Go" by Auli'i Cravalho...
    Done.
    Searching for "Love Scars" by Trippie Redd...
    Done.
    Searching for "Me, Myself & I" by G-Eazy...
    Done.
    Searching for "Skinny Love" by Bon Iver...
    Done.
    Searching for "Little Saint Nick - 1991 Remix" by The Beach Boys...
    Done.
    Searching for "Cochise" by Audioslave...
    Done.
    Searching for "Downtown" by Anitta...
    Done.
    Searching for "Dark Queen" by Lil Uzi Vert...
    Done.
    Searching for "Whiskey (feat. A$AP Rocky)" by Maroon 5...
    Done.
    Searching for "Come Over" by Trey Songz...
    Done.
    Searching for "O Tannenbaum" by Nat King Cole...
    Done.
    Searching for "A L I E N S" by Coldplay...
    Done.
    Searching for "Rudolph The Red-Nosed Reindeer" by Burl Ives...
    Done.
    Searching for "I'm a Nasty Hoe" by Ugly God...
    Done.
    Searching for "All da Smoke" by Future...
    Done.
    Searching for "The Beautiful & Damned" by G-Eazy...
    Done.
    Searching for "Sweet Creature" by Harry Styles...
    Done.
    Searching for "Emoji of a Wave" by John Mayer...
    Done.
    Completed 1100...
    Searching for "Ordinary Life" by The Weeknd...
    Done.
    Searching for "200" by Future...
    Done.
    Searching for "4 da Gang" by Future...
    Done.
    Searching for "Call Me Maybe" by Carly Rae Jepsen...
    Done.
    Searching for "Another Day Of Sun - From "La La Land" Soundtrack" by La La Land Cast...
    Done.
    Searching for "Cherry Hill" by Russ...
    Done.
    Searching for "Testify" by Future...
    Done.
    Searching for "Fake Love" by Drake...
    Done.
    Searching for "Lemon" by N.E.R.D...
    Done.
    Searching for "I'll Name the Dogs" by Blake Shelton...
    Done.
    Searching for "Pied Piper" by BTS...
    Done.
    Searching for "Too Good At Goodbyes - Edit" by Sam Smith...
    Done.
    Searching for "do re mi (feat. Gucci Mane)" by blackbear...
    Done.
    Searching for "Fuck That Check Up (feat. Lil Uzi Vert)" by Meek Mill...
    Done.
    Searching for "Neighbors" by J. Cole...
    Done.
    Searching for "1-800-273-8255" by Logic...
    Done.
    Searching for "Outlet" by Desiigner...
    Done.
    Searching for "New Year’s Day" by Taylor Swift...
    Done.
    Searching for "Not Going Home" by DVBBS...
    Done.
    Searching for "I Sip" by Tory Lanez...
    Done.
    Searching for "Shining" by DJ Khaled...
    Done.
    Searching for "Everyday" by Ariana Grande...
    Done.
    Searching for "Stay (with Alessia Cara)" by Zedd...
    Done.
    Searching for "Lift Me Up - Michael Brun Remix" by OneRepublic...
    Done.
    Searching for "Summer Friends (feat. Jeremih & Francis & The Lights)" by Chance the Rapper...
    Done.
    Searching for "Oh Lord" by MiC LOWRY...
    Done.
    Searching for "Why Don't You Come On" by DJDS...
    Done.
    Searching for "The Heart Part 4" by Kendrick Lamar...
    Done.
    Searching for "Lose Yourself - From "8 Mile" Soundtrack" by Eminem...
    Specified song does not contain lyrics. Rejecting.
    Could not find Lose Yourself - From "8 Mile" Soundtrack by Eminem
    Searching for "Moon Rock" by Huncho Jack...
    Done.
    Searching for "Dirt On My Boots" by Jon Pardi...
    Done.
    Searching for "Thriller - 2003 Edit" by Michael Jackson...
    Done.
    Searching for "Perfect Pint (feat. Kendrick Lamar, Gucci Mane & Rae Sremmurd)" by Mike WiLL Made-It...
    Done.
    Searching for "Bad Liar" by Selena Gomez...
    Done.
    Searching for "No Flag" by London On Da Track...
    Done.
    Searching for "Blue Cheese" by 2 Chainz...
    Done.
    Searching for "Midnight Train" by Sam Smith...
    Done.
    Searching for "Sucker For Pain (with Wiz Khalifa, Imagine Dragons, Logic & Ty Dolla $ign feat. X Ambassadors)" by Lil Wayne...
    Done.
    Searching for "High Without Your Love" by Loote...
    Done.
    Searching for "RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko)" by Joey Bada$$...
    Specified song does not contain lyrics. Rejecting.
    Could not find RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko) by Joey Bada$$
    Searching for "If I'm Lucky" by Jason Derulo...
    Done.
    Searching for "Do Not Disturb" by Drake...
    Done.
    Searching for "oui" by Jeremih...
    Done.
    Searching for "Wanna Be That Song" by Brett Eldredge...
    Done.
    Searching for "Rockin’" by The Weeknd...
    Done.
    Searching for "There's Nothing Holdin' Me Back" by Shawn Mendes...
    Done.
    Searching for "Call Me" by NAV...
    Done.
    Searching for "Joy To The World" by Nat King Cole...
    Done.
    Searching for "Turn On Me" by Future...
    Done.
    Searching for "I'll Be Home For Christmas - Recorded at Spotify Studios NYC" by Demi Lovato...
    Done.
    Searching for "Like Home (feat. Alicia Keys)" by Eminem...
    Done.
    Searching for "Don't Kill My Vibe" by Sigrid...
    Done.
    Searching for "Unhappy" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Back On" by Gucci Mane...
    Done.
    Searching for "Last Day Alive" by The Chainsmokers...
    Done.
    Searching for "Money Longer" by Lil Uzi Vert...
    Done.
    Searching for "House Party" by Sam Hunt...
    Done.
    Searching for "Sauce It Up" by Lil Uzi Vert...
    Done.
    Searching for "Green Light" by Lorde...
    Done.
    Searching for "A.D.H.D" by Kendrick Lamar...
    Done.
    Searching for "All I Want For Christmas (Is My Two Front Teeth) - Remastered" by Nat King Cole Trio...
    No results found for: 'All I Want For Christmas (Is My Two Front Teeth) - Remastered Nat King Cole Trio'
    Could not find All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio
    Searching for "So Close" by Andrew McMahon in the Wilderness...
    Done.
    Searching for "Never Be Like You" by Flume...
    Done.
    Searching for "Paris" by The Chainsmokers...
    Done.
    Searching for "Middle" by DJ Snake...
    Done.
    Searching for "Bust Down" by Trippie Redd...
    Done.
    Searching for "Silver Bells" by Dean Martin...
    Done.
    Searching for "Andromeda (feat. DRAM)" by Gorillaz...
    Done.
    Searching for "We Are Young (feat. Janelle Monáe)" by fun....
    Done.
    Searching for "Sorry for Now" by Linkin Park...
    Done.
    Searching for "Blessings" by Chance the Rapper...
    Done.
    Searching for "Go Flex" by Post Malone...
    Done.
    Searching for "dimple" by BTS...
    Done.
    Searching for "Gorgeous" by Taylor Swift...
    Done.
    Searching for "Break Up Every Night" by The Chainsmokers...
    Done.
    Searching for "Felices los 4" by Maluma...
    Done.
    Searching for "Litty (feat. Tory Lanez)" by Meek Mill...
    Done.
    Searching for "Frat Rules" by A$AP Mob...
    Done.
    Searching for "MotorSport" by Migos...
    Done.
    Searching for "(Intro) I'm so Grateful (feat. Sizzla)" by DJ Khaled...
    Done.
    Searching for "She Will Be Loved - Radio Mix" by Maroon 5...
    Done.
    Searching for "I Miss You" by Grey...
    Done.
    Searching for "Bloodstream" by The Chainsmokers...
    Done.
    Searching for "Wins & Losses" by Meek Mill...
    Done.
    Searching for "Refugee" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Riptide" by Vance Joy...
    Done.
    Searching for "Lil Favorite (feat. MadeinTYO)" by Ty Dolla $ign...
    Done.
    Searching for "I Won't Back Down" by Tom Petty...
    Done.
    Searching for "Craving You" by Thomas Rhett...
    Done.
    Searching for "Starships" by Nicki Minaj...
    Done.
    Searching for "Undercover" by Kehlani...
    Done.
    Searching for "Show Me How to Live" by Audioslave...
    Done.
    Searching for "F*ck Up Some Commas" by Future...
    Done.
    Searching for "Let Me Out (feat. Mavis Staples & Pusha T)" by Gorillaz...
    Done.
    Searching for "Have Yourself A Merry Little Christmas" by Sam Smith...
    Done.
    Searching for "Rake It Up" by Yo Gotti...
    Done.
    Searching for "Glorious (feat. Skylar Grey)" by Macklemore...
    Done.
    Searching for "Dangerous" by The xx...
    Done.
    Searching for "Unsteady" by X Ambassadors...
    Done.
    Searching for "Holiday (feat. Snoop Dogg, John Legend & Takeoff)" by Calvin Harris...
    Done.
    Completed 1200...
    Searching for "Dickriders" by Gucci Mane...
    Done.
    Searching for "What Christmas Means To Me" by Stevie Wonder...
    Done.
    Searching for "Flatliner (feat. Dierks Bentley)" by Cole Swindell...
    Done.
    Searching for "Letterman" by Wiz Khalifa...
    Done.
    Searching for "Can't Hold Us - feat. Ray Dalton" by Macklemore & Ryan Lewis...
    Specified song does not contain lyrics. Rejecting.
    Could not find Can't Hold Us - feat. Ray Dalton by Macklemore & Ryan Lewis
    Searching for "Trap Trap Trap" by Rick Ross...
    Done.
    Searching for "Lay It On Me" by Vance Joy...
    Done.
    Searching for "Don't Stop Me Now - Remastered" by Queen...
    Done.
    Searching for "Yesterday" by Imagine Dragons...
    Done.
    Searching for "Versace On The Floor" by Bruno Mars...
    Done.
    Searching for "Antidote" by Travis Scott...
    Done.
    Searching for "Feel It" by Young Thug...
    Done.
    Searching for "No Hearts, No Love (& Metro Boomin)" by Big Sean...
    Done.
    Searching for "Awful Things" by Lil Peep...
    Done.
    Searching for "Baby, You Make Me Crazy" by Sam Smith...
    Done.
    Searching for "Childs Play" by Drake...
    Done.
    Searching for "They Like" by Yo Gotti...
    Done.
    Searching for "444+222" by Lil Uzi Vert...
    Done.
    Searching for "We Got The Power (feat. Jehnny Beth)" by Gorillaz...
    Done.
    Searching for "Numb / Encore" by JAY Z...
    Done.
    Searching for "More Than You Know" by Axwell /\ Ingrosso...
    Done.
    Searching for "Homemade Dynamite (Feat. Khalid, Post Malone & SZA) - REMIX" by Lorde...
    Done.
    Searching for "Side To Side" by Ariana Grande...
    Done.
    Searching for "Trust Nobody (feat. Selena Gomez & Tory Lanez)" by Cashmere Cat...
    Done.
    Searching for "Outshined" by Soundgarden...
    Done.
    Searching for "This Is Halloween" by The Citizens of Halloween...
    Done.
    Searching for "Sorry" by Justin Bieber...
    Done.
    Searching for "Total Eclipse of The Heart" by Bonnie Tyler...
    Done.
    Searching for "Say A'" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Sunday Morning Jetpack" by Big Sean...
    Done.
    Searching for "Transportin'" by Kodak Black...
    Done.
    Searching for "Welcome To New York" by Taylor Swift...
    Done.
    Searching for "Gucci Gang" by Lil Pump...
    Done.
    Searching for "Stressed Out" by Twenty One Pilots...
    Done.
    Searching for "OOOUUU" by Young M.A...
    Done.
    Searching for "U Aint Never" by Kodak Black...
    Done.
    Searching for "iSpy (feat. Lil Yachty)" by KYLE...
    Done.
    Searching for "FOR MY PEOPLE" by Joey Bada$$...
    Done.
    Searching for "Modern Slavery" by Huncho Jack...
    Done.
    Searching for "Burden In My Hand" by Soundgarden...
    Done.
    Searching for "Horses (with PnB Rock, Kodak Black & A Boogie Wit da Hoodie)" by PnB Rock...
    Done.
    Searching for "Rewrite The Stars" by Zac Efron...
    Done.
    Searching for "Gave Your Love Away" by Majid Jordan...
    Done.
    Searching for "BLOOD." by Kendrick Lamar...
    Done.
    Searching for "Thinking out Loud" by Ed Sheeran...
    Done.
    Searching for "Distraction" by Kehlani...
    Done.
    Searching for "Rent Money" by Future...
    Done.
    Searching for "Out Yo Way" by Migos...
    Done.
    Searching for "Ex (feat. YG)" by Ty Dolla $ign...
    Done.
    Searching for "Helpless" by John Mayer...
    Done.
    Searching for "HIM" by Sam Smith...
    Done.
    Searching for "Comin Out Strong (feat. The Weeknd)" by Future...
    Done.
    Searching for "Will He" by Joji...
    Done.
    Searching for "Me Rehúso" by Danny Ocean...
    Done.
    Searching for "Ruin The Friendship" by Demi Lovato...
    Done.
    Searching for "What Lovers Do" by Maroon 5...
    Done.
    Searching for "Rockabye (feat. Sean Paul & Anne-Marie)" by Clean Bandit...
    Done.
    Searching for "Might as Well" by Future...
    Done.
    Searching for "Feels (feat. Pharrell Williams, Katy Perry & Big Sean)" by Calvin Harris...
    Done.
    Searching for "Homemade Dynamite" by Lorde...
    Done.
    Searching for "Don't Get Too High" by Bryson Tiller...
    Done.
    Searching for "It's the Most Wonderful Time of the Year" by Andy Williams...
    Done.
    Searching for "Reminder - Remix" by The Weeknd...
    Done.
    Searching for "Minute" by NAV...
    Done.
    Searching for "Come and See Me (feat. Drake)" by PARTYNEXTDOOR...
    Done.
    Searching for "Drugs" by August Alsina...
    Done.
    Searching for "Blank Space" by Taylor Swift...
    Done.
    Searching for "Skir Skirr" by Lil Uzi Vert...
    Done.
    Searching for "Perfect Places" by Lorde...
    Done.
    Searching for "Dress" by Taylor Swift...
    Done.
    Searching for "Riverdale Rd" by 2 Chainz...
    Done.
    Searching for "You Make My Dreams" by Daryl Hall & John Oates...
    Done.
    Searching for "No Such Thing as a Broken Heart" by Old Dominion...
    Done.
    Searching for "Brown Paper Bag" by Migos...
    Done.
    Searching for "Love Story" by Taylor Swift...
    Done.
    Searching for "Bad Things (with Camila Cabello)" by Machine Gun Kelly...
    Done.
    Searching for "Love (feat. Rae Sremmurd)" by ILoveMakonnen...
    Done.
    Searching for "I Just Can't" by R3HAB...
    Done.
    Searching for "The Other Side" by Hugh Jackman...
    Done.
    Searching for "Run Up the Racks" by 21 Savage...
    Done.
    Searching for "Touch" by Little Mix...
    Done.
    Searching for "My Shit" by A Boogie Wit da Hoodie...
    Done.
    Searching for "Same Drugs" by Chance the Rapper...
    Done.
    Searching for "Love Me Now" by John Legend...
    Done.
    Searching for "BABYLON (feat. Chronixx)" by Joey Bada$$...
    Done.
    Searching for "Heathens" by Twenty One Pilots...
    Done.
    Searching for "Hallucinating" by Future...
    Done.
    Searching for "Realize" by 2 Chainz...
    Done.
    Searching for "Down for Life (feat. PARTYNEXTDOOR, Future, Travis Scott, Rick Ross & Kodak Black)" by DJ Khaled...
    Done.
    Searching for "T-Shirt" by Migos...
    Done.
    Searching for "Know No Better (feat. Travis Scott, Camila Cabello & Quavo)" by Major Lazer...
    Done.
    Searching for "Nightmare" by Offset...
    Done.
    Searching for "Castle on the Hill" by Ed Sheeran...
    Done.
    Searching for "Titanium (feat. Sia)" by David Guetta...
    Done.
    Searching for "Die For You" by The Weeknd...
    Done.
    Searching for "Get It Right (feat. MØ)" by Diplo...
    Done.
    Searching for "Idols Become Rivals" by Rick Ross...
    Done.
    Searching for "美女と野獣" by Ariana Grande...
    No results found for: '美女と野獣 Ariana Grande'
    Could not find 美女と野獣 by Ariana Grande
    Searching for "Sky Walker (feat. Travis Scott)" by Miguel...
    Done.
    Searching for "Chill Bill" by Rob $tone...
    Done.
    Completed 1300...
    Searching for "Don't" by Ed Sheeran...
    Done.
    Searching for "Pray For Me" by G-Eazy...
    Done.
    Searching for "Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC" by Fifth Harmony...
    No results found for: 'Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC Fifth Harmony'
    Could not find Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC by Fifth Harmony
    Searching for "The Mack" by Nevada...
    Done.
    Searching for "Inspire Me" by Big Sean...
    Done.
    Searching for "Saint" by Huncho Jack...
    Done.
    Searching for "Santa Claus Is Coming to Town" by Michael Bublé...
    Done.
    Searching for "One Night" by Lil Yachty...
    Done.
    Searching for "Stronger" by Kanye West...
    Done.
    Searching for "Come Through and Chill" by Miguel...
    Done.
    Searching for "Met Gala (feat. Offset)" by Gucci Mane...
    Done.
    Searching for "One Last Song" by Sam Smith...
    Done.
    Searching for "Sugar, We're Goin Down" by Fall Out Boy...
    Done.
    Searching for "Why" by Sabrina Carpenter...
    Done.
    Searching for "Sensualidad" by Bad Bunny...
    Done.
    Searching for "Dance of the Sugar Plum Fairy" by Pentatonix...
    Done.
    Searching for "You Wreck Me" by Tom Petty...
    Done.
    Searching for "Extra Luv" by Future...
    Done.
    Searching for "Rusty Cage" by Soundgarden...
    Done.
    Searching for "No Peace" by Sam Smith...
    Done.
    Searching for "Faking It (feat. Kehlani & Lil Yachty)" by Calvin Harris...
    Done.
    Searching for "Mistletoe And Holly - Remastered 1999" by Frank Sinatra...
    Done.
    Searching for "XO TOUR Llif3" by Lil Uzi Vert...
    Done.
    Searching for "The Apprentice (feat. Rag'n'Bone Man, Zebra Katz & RAY BLK)" by Gorillaz...
    Done.
    Searching for "Bank Account" by 21 Savage...
    Done.
    Searching for "Dynamite (feat. Pretty Sister)" by Nause...
    Done.
    Searching for "911 / Mr. Lonely" by Tyler, The Creator...
    Done.
    Searching for "Wait" by Maroon 5...
    Done.
    Searching for "Rap God" by Eminem...
    Done.
    Searching for "I Can't Even Lie (feat. Future & Nicki Minaj)" by DJ Khaled...
    Done.
    Searching for "Crying in the Club" by Camila Cabello...
    Done.
    Searching for "Rap Saved Me" by 21 Savage...
    Done.
    Searching for "White Iverson" by Post Malone...
    Done.
    Searching for "Real Love" by Future...
    Done.
    Searching for "Killed Before" by Young Thug...
    Done.
    Searching for "Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix" by Lana Del Rey...
    No results found for: 'Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix Lana Del Rey'
    Could not find Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix by Lana Del Rey
    Searching for "Say Something Loving" by The xx...
    Done.
    Searching for "Dive" by Ed Sheeran...
    Done.
    Searching for "Numb" by 21 Savage...
    Done.
    Searching for "Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet)" by Frank Sinatra...
    No results found for: 'Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) Frank Sinatra'
    Could not find Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    Searching for "She's Mine Pt. 2" by J. Cole...
    Done.
    Searching for "Swish Swish" by Katy Perry...
    Done.
    Searching for "LOVE. FEAT. ZACARI." by Kendrick Lamar...
    Done.
    Searching for "Black Hole Sun" by Soundgarden...
    Done.
    Searching for "Nothing Left For You" by Sam Smith...
    Done.
    Searching for "Rainbow" by Kesha...
    Done.
    Searching for "Dubai Shit" by Huncho Jack...
    Done.
    Searching for "All I Want for Christmas Is You" by Mariah Carey...
    Done.
    Searching for "Same Time Pt. 1" by Big Sean...
    Done.
    Searching for "A-YO" by Lady Gaga...
    Done.
    Searching for "Intro" by Big Sean...
    Done.
    Searching for "Either Way (feat. Joey Bada$$)" by Snakehips...
    Done.
    Searching for "Glow" by Drake...
    Done.
    Searching for "Meet Me in the Hallway" by Harry Styles...
    Done.
    Searching for "Ice Tray" by Quality Control...
    Done.
    Searching for "Everyday We Lit (Remix)" by YFN Lucci...
    Done.
    Searching for "Gyalchester" by Drake...
    Done.
    Searching for "Bring It Back (with Drake & Mike WiLL Made-It)" by Trouble...
    Done.
    Searching for "Up Down (Feat. Florida Georgia Line)" by Morgan Wallen...
    Done.
    Searching for "Waiting Room" by Logic...
    Done.
    Searching for "Some Kind Of Drug" by G-Eazy...
    Done.
    Searching for "Light My Body Up (feat. Nicki Minaj & Lil Wayne)" by David Guetta...
    Done.
    Searching for "Low Life" by Future...
    Done.
    Searching for "Built My Legacy (feat. Offset)" by Kodak Black...
    Done.
    Searching for "Silence" by Marshmello...
    Done.
    Searching for "New Rules" by Dua Lipa...
    Done.
    Searching for "Blowin' Minds (Skateboard)" by A$AP Mob...
    Done.
    Searching for "You Shook Me All Night Long" by AC/DC...
    Done.
    Searching for "m.A.A.d city" by Kendrick Lamar...
    Done.
    Searching for "Day For Day" by Kodak Black...
    Done.
    Searching for "Droppin' Seeds" by Tyler, The Creator...
    Done.
    Searching for "BYF" by A$AP Mob...
    Done.
    Searching for "Rich Ass Junkie" by Gucci Mane...
    Done.
    Searching for "Take Me To Church" by Hozier...
    Done.
    Searching for "Feels Like Summer" by Weezer...
    Done.
    Searching for "Get Right Witcha" by Migos...
    Done.
    Searching for "PIE" by Future...
    Done.
    Searching for "everybody dies" by J. Cole...
    Done.
    Searching for "Christmas Time Is Here - Vocal" by Vince Guaraldi Trio...
    Done.
    Searching for "Look What You Made Me Do" by Taylor Swift...
    Done.
    Searching for "Shining (feat. Beyoncé & Jay-Z)" by DJ Khaled...
    Done.
    Searching for "Come and Get Your Love - Single Edit" by Redbone...
    Done.
    Searching for "New Freezer (feat. Kendrick Lamar)" by Rich The Kid...
    Done.
    Searching for "Up In Here" by Kodak Black...
    Done.
    Searching for "Criminal" by Natti Natasha...
    Done.
    Searching for "On + Off" by Maggie Rogers...
    Done.
    Searching for "Nothing Wrong" by G-Eazy...
    Done.
    Searching for "That's It (feat. Gucci Mane & 2 Chainz)" by Bebe Rexha...
    Done.
    Searching for "pick up the phone" by Young Thug...
    Done.
    Searching for "Black Card" by A$AP Mob...
    Done.
    Searching for "Remember I Told You" by Nick Jonas...
    Done.
    Searching for "Runnin' Down A Dream" by Tom Petty...
    Done.
    Searching for "DNA." by Kendrick Lamar...
    Done.
    Searching for "Carolina" by Harry Styles...
    Done.
    Searching for "Say It First" by Sam Smith...
    Done.
    Searching for "It's Secured (feat. Nas & Travis Scott)" by DJ Khaled...
    Done.
    Searching for "The First Noel - Remastered 1999" by Frank Sinatra...
    Done.
    Searching for "Bon appétit" by Katy Perry...
    Done.
    Searching for "Cherry" by Lana Del Rey...
    Done.
    Searching for "Mele Kalikimaka - Single Version" by Bing Crosby...
    Done.
    Completed 1400...
    Searching for "Eyes Closed" by Halsey...
    Done.
    Searching for "Meant to Be (feat. Florida Georgia Line)" by Bebe Rexha...
    Done.
    Searching for "Finding You" by Kesha...
    Done.
    Searching for "May We All" by Florida Georgia Line...
    Done.
    Searching for "Chained To The Rhythm" by Katy Perry...
    Done.
    Searching for "Lonely Together (feat. Rita Ora)" by Avicii...
    Done.
    Searching for "This Is What You Came For" by Calvin Harris...
    Done.
    Searching for "Don't Quit (feat. Travis Scott & Jeremih)" by DJ Khaled...
    Done.
    Searching for "Dead Presidents" by Rick Ross...
    Done.
    Searching for "Barcelona" by Ed Sheeran...
    Done.
    Searching for "Foreign" by Lil Pump...
    Done.
    Searching for "Drip on Me" by Future...
    Done.
    Searching for "Hypnotize - 2014 Remastered Version" by The Notorious B.I.G....
    No results found for: 'Hypnotize - 2014 Remastered Version The Notorious B.I.G.'
    Could not find Hypnotize - 2014 Remastered Version by The Notorious B.I.G.
    Searching for "Whatever You Need (feat. Chris Brown & Ty Dolla $ign)" by Meek Mill...
    Done.
    Searching for "Love" by Lana Del Rey...
    Done.
    Searching for "Ville Mentality" by J. Cole...
    Done.
    Searching for "X Men" by Lil Yachty...
    Done.
    Searching for "Sneakin’" by Drake...
    Done.
    Searching for "Keep On" by Kehlani...
    Done.
    Searching for "Shape of You" by Ed Sheeran...
    Done.
    Searching for "Rollin" by Calvin Harris...
    Done.
    Searching for "Unforgettable" by Thomas Rhett...
    Done.
    Searching for "Ni**as In Paris" by JAY Z...
    Done.
    Searching for "Darkside (with Ty Dolla $ign & Future feat. Kiiara)" by Ty Dolla $ign...
    Done.
    Searching for "We Both Know" by Bryson Tiller...
    Done.
    Searching for "7 Years" by Lukas Graham...
    Done.
    Searching for "Let Me Love You" by DJ Snake...
    Done.
    Searching for "Still Feel Like Your Man" by John Mayer...
    Done.
    Searching for "Young Dumb & Broke" by Khalid...
    Done.
    Searching for "In Cold Blood" by alt-J...
    Done.
    Searching for "Palace" by Sam Smith...
    Done.
    Searching for "Love Is Gone" by G-Eazy...
    Done.
    Searching for "No Role Modelz" by J. Cole...
    Done.
    Searching for "In Check" by Bryson Tiller...
    Done.
    Searching for "Almost Like Praying (feat. Artists for Puerto Rico)" by Lin-Manuel Miranda...
    Done.
    Searching for "No Flockin" by Kodak Black...
    Done.
    Searching for "Work In Progress (Intro)" by Gucci Mane...
    Done.
    Searching for "Raincoat (feat. Shy Martin)" by Timeflies...
    Done.
    Searching for "Mistletoe" by Justin Bieber...
    Done.
    Searching for "White Mustang" by Lana Del Rey...
    Done.
    Searching for "Save Me" by XXXTENTACION...
    Done.
    Searching for "On My Way" by Tiësto...
    Done.
    Searching for "Ok" by Lil Pump...
    Done.
    Searching for "Liife" by Desiigner...
    Done.
    Searching for "Stay" by Zedd...
    Done.
    Searching for "Good Dope" by Future...
    Done.
    Searching for "Mad Stalkers" by 21 Savage...
    Done.
    Searching for "Nights With You" by MØ...
    Done.
    Searching for "Reminder" by The Weeknd...
    Done.
    Searching for "Since Way Back" by Drake...
    Done.
    Searching for "Purple Lamborghini (with Rick Ross)" by Skrillex...
    Done.
    Searching for "Tiimmy Turner" by Desiigner...
    Done.
    Searching for "Special" by 21 Savage...
    Done.
    Searching for "See You Again" by Tyler, The Creator...
    Done.
    Searching for "All My Love (feat. Conor Maynard)" by Cash Cash...
    Done.
    Searching for "Bad Business" by 21 Savage...
    Done.
    Searching for "No Sleep Leak" by Lil Uzi Vert...
    Done.
    Searching for "On The Come Up (feat. Big Sean)" by Mike WiLL Made-It...
    Done.
    Searching for "No Favors" by Big Sean...
    Done.
    Searching for "This Christmas" by Chris Brown...
    Done.
    Searching for "Famous" by Kanye West...
    Done.
    Searching for "Don't Come Around Here No More" by Tom Petty and the Heartbreakers...
    Done.
    Searching for "Dancing With Our Hands Tied" by Taylor Swift...
    Done.
    Searching for "Crazy Brazy" by A$AP Mob...
    Done.
    Searching for "Wishlist" by Kiiara...
    Done.
    Searching for "All Night" by Steve Aoki...
    Done.
    Searching for "LEGENDARY (feat. J. Cole)" by Joey Bada$$...
    Done.
    Searching for "My Girl" by The Temptations...
    Done.
    Searching for "Biking" by Frank Ocean...
    Done.
    Searching for "Patek Water" by Future...
    Done.
    Searching for "Young, Wild & Free (feat. Bruno Mars)" by Snoop Dogg...
    Done.
    Searching for "This Is Why We Can’t Have Nice Things" by Taylor Swift...
    Done.
    Searching for "I Would Like" by Zara Larsson...
    Done.
    Searching for "Waterfall" by Stargate...
    Done.
    Searching for "You Don't Know How It Feels" by Tom Petty...
    Done.
    Searching for "White Christmas" by Bing Crosby...
    Done.
    Searching for "Bad and Boujee (feat. Lil Uzi Vert)" by Migos...
    Done.
    Searching for "Bad Bitch (feat. Ty Dolla $ign)" by Bebe Rexha...
    Done.
    Searching for "Deadz (feat. 2 Chainz)" by Migos...
    Done.
    Searching for "I Get The Bag (feat. Migos)" by Gucci Mane...
    Done.
    Searching for "Changes" by Hazers...
    Done.
    Searching for "Darth Vader" by 21 Savage...
    Done.
    Searching for "Hallelujah" by Logic...
    Done.
    Searching for "No Long Talk" by Drake...
    Done.
    Searching for "I Miss You (feat. Julia Michaels)" by Clean Bandit...
    Done.
    Searching for "make daddy proud" by blackbear...
    Done.
    Searching for "Don't Worry Be Happy" by Bobby McFerrin...
    Done.
    Searching for "Make You Feel My Love" by Adele...
    Done.
    Searching for "Girls On Boys" by Galantis...
    Done.
    Searching for "Magic" by Thomas Gold...
    Done.
    Searching for "All I Can Think About Is You" by Coldplay...
    Done.
    Searching for "X" by Lil Uzi Vert...
    Done.
    Searching for "Untouchable" by Eminem...
    Done.
    Searching for "Steady 1234 (feat. Jasmine Thompson & Skizzy Mars)" by Vice...
    Done.
    Searching for "Don't Don't Do It!" by N.E.R.D...
    Done.
    Searching for "Strangers" by Halsey...
    Done.
    Searching for "Groupie Love (feat. A$AP Rocky)" by Lana Del Rey...
    Done.
    Searching for "Enormous (feat. Ty Dolla $ign)" by Gucci Mane...
    Done.
    Searching for "Love Incredible (feat. Camila Cabello)" by Cashmere Cat...
    Done.
    Searching for "Draco" by Future...
    Done.
    Completed 1500...
    Searching for "playboy shit (feat. lil aaron)" by blackbear...
    Done.
    Searching for "The Promise" by Chris Cornell...
    Done.
    Searching for "California Love - Original Version" by 2Pac...
    Done.
    Searching for "Strobelite (feat. Peven Everett)" by Gorillaz...
    Done.
    Searching for "Mary, Did You Know?" by Pentatonix...
    Done.
    Searching for "No Smoke" by YoungBoy Never Broke Again...
    Done.
    Searching for "Rolex" by Ayo & Teo...
    Done.
    Searching for "Two High" by Moon Taxi...
    Done.
    Searching for "Ascension (feat. Vince Staples)" by Gorillaz...
    Done.
    Searching for "Thumbs" by Sabrina Carpenter...
    Done.
    Searching for "Do You Hear What I Hear?" by Bing Crosby...
    Done.
    Searching for "Friends (with BloodPop®)" by Justin Bieber...
    Specified song does not contain lyrics. Rejecting.
    Could not find Friends (with BloodPop®) by Justin Bieber
    Searching for "Dead People" by 21 Savage...
    Done.
    Searching for "Good Old Days (feat. Kesha)" by Macklemore...
    Done.
    Searching for "I Don’t Know Why" by Imagine Dragons...
    Done.
    Searching for "Say You Won't Let Go" by James Arthur...
    Done.
    Searching for "Let It Go" by James Bay...
    Done.
    Searching for "In the Name of Love" by Martin Garrix...
    Done.
    Searching for "My Way" by Calvin Harris...
    Done.
    Searching for "You Was Right" by Lil Uzi Vert...
    Done.
    Searching for "Honest" by The Chainsmokers...
    Done.
    Searching for "Werewolves of London - 2007 Remaster" by Warren Zevon...
    No results found for: 'Werewolves of London - 2007 Remaster Warren Zevon'
    Could not find Werewolves of London - 2007 Remaster by Warren Zevon
    Searching for "Cash Out (feat. ScHoolboy Q, PARTYNEXTDOOR & D.R.A.M.)" by Calvin Harris...
    Done.
    Searching for "There for You" by Martin Garrix...
    Done.
    Searching for "Everyday We Lit (feat. PnB Rock)" by YFN Lucci...
    Done.
    Searching for "Sorry" by Halsey...
    Done.
    Searching for "Superstition - Single Version" by Stevie Wonder...
    Done.
    Searching for "Not Nice" by PARTYNEXTDOOR...
    Done.
    Searching for "It's A Vibe" by 2 Chainz...
    Done.
    Searching for "That's What I Like" by Bruno Mars...
    Done.
    Searching for "7 Min Freestyle" by 21 Savage...
    Done.
    Searching for "Baby, It's Cold Outside (Glee Cast Version)" by Glee Cast...
    Done.
    Searching for "Skateboard P" by MadeinTYO...
    Done.
    Searching for "Pretty Girl - Cheat Codes X CADE Remix" by Maggie Lindemann...
    Done.
    Searching for "Headlines" by Drake...
    Done.
    Searching for "Wild Thoughts (feat. Rihanna & Bryson Tiller)" by DJ Khaled...
    Done.
    Searching for "Benz Truck - гелик" by Lil Peep...
    Done.
    Searching for "Let's Start The New Year Off Right" by Bing Crosby...
    Done.
    Searching for "Drink A Little Beer" by Thomas Rhett...
    Done.
    Searching for "Cake - Challenge Version" by Flo Rida...
    Done.
    Searching for "I Don't Fuck With You" by Big Sean...
    Done.
    Searching for "Rain On Me (Intro)" by Bryson Tiller...
    Done.
    Searching for "Scrape" by Future...
    Done.
    Searching for "Lovin' (feat. A Boogie Wit da Hoodie)" by PnB Rock...
    Done.
    Searching for "Cruise Ship" by Young Thug...
    Done.
    Searching for "Black" by Dierks Bentley...
    Done.
    Searching for "Trap Queen" by Fetty Wap...
    Done.
    Searching for "KOODA" by 6ix9ine...
    Done.
    Searching for "Stranger Things" by Kygo...
    Done.
    Searching for "New Man" by Ed Sheeran...
    Done.
    Searching for "I’ll Make It Up To You" by Imagine Dragons...
    Done.
    Searching for "So Far Away (feat. Jamie Scott & Romy Dya)" by Martin Garrix...
    Done.
    Searching for "Best Man" by Huncho Jack...
    Done.
    Searching for "But A Dream" by G-Eazy...
    Done.
    Searching for "Get to the Money" by Chad Focus...
    Done.
    Searching for "Signed, Sealed, Delivered (I'm Yours)" by Stevie Wonder...
    Done.
    Searching for "What The Price" by Migos...
    Done.
    Searching for "Not Afraid Anymore" by Halsey...
    Done.
    Searching for "Instinct (feat. MadeinTYO)" by Roy Woods...
    Done.
    Searching for "Broccoli (feat. Lil Yachty)" by DRAM...
    Done.
    Searching for "Real Thing (feat. Future)" by Tory Lanez...
    Done.
    Searching for "Voices In My Head/Stick To The Plan" by Big Sean...
    Done.
    Searching for "Beautiful Trauma" by P!nk...
    Done.
    Searching for "Pull Up N Wreck (With Metro Boomin)" by Big Sean...
    No results found for: 'Pull Up N Wreck (With Metro Boomin) Big Sean'
    Could not find Pull Up N Wreck (With Metro Boomin) by Big Sean
    Searching for "Miss My Woe (feat. Rico Love)" by Gucci Mane...
    Done.
    Searching for "Big Amount" by 2 Chainz...
    Done.
    Searching for "Holly Jolly Christmas" by Michael Bublé...
    Done.
    Searching for "Colombia Heights (Te Llamo) [feat. J Balvin]" by Wale...
    Done.
    Searching for "Don't" by Bryson Tiller...
    Done.
    Searching for "One Day At A Time" by Sam Smith...
    Done.
    Searching for "TG4M" by Zara Larsson...
    Done.
    Searching for "My House" by Flo Rida...
    Done.
    Searching for "2U (feat. Justin Bieber)" by David Guetta...
    Done.
    Searching for "No Longer Friends" by Bryson Tiller...
    Done.
    Searching for "Him & I" by G-Eazy...
    Done.
    Searching for "Rose-Colored Boy" by Paramore...
    Done.
    Searching for "Let 'Em Talk" by Kesha...
    Done.
    Searching for "Tunnel Vision" by Kodak Black...
    Done.
    Searching for "up in this (with Tinashe)" by blackbear...
    Done.
    Searching for "LAND OF THE FREE" by Joey Bada$$...
    Done.
    Searching for "Carnival (feat. Anthony Hamilton)" by Gorillaz...
    Done.
    Searching for "Fairytale of New York (feat. Kirsty MacColl)" by The Pogues...
    Done.
    Searching for "PICK IT UP (feat. A$AP Rocky)" by Famous Dex...
    Done.
    Searching for "Shape of You - Galantis Remix" by Ed Sheeran...
    Done.
    Searching for "Hunger Strike" by Temple Of The Dog...
    Done.
    Searching for "Mistakes" by Tove Styrke...
    Done.
    Searching for "Money Make Ya Handsome" by Gucci Mane...
    Done.
    Searching for "Do U Dirty" by Kehlani...
    Done.
    Searching for "Your Song" by Rita Ora...
    Done.
    Searching for "Believer" by Imagine Dragons...
    Done.
    Searching for "Jungle" by Drake...
    Done.
    Searching for "4 Your Eyez Only" by J. Cole...
    Done.
    Searching for "I'll Be Home" by Meghan Trainor...
    Done.
    Searching for "The Little Drummer Boy" by Bing Crosby...
    Done.
    Searching for "Brown Eyed Girl" by Van Morrison...
    Done.
    Searching for "Curve (feat. The Weeknd)" by Gucci Mane...
    Done.
    Searching for "Halo" by Beyoncé...
    Done.
    Searching for "November" by Tyler, The Creator...
    Done.
    Searching for "Dennis Rodman" by mansionz...
    Done.
    Searching for "Used to This" by Future...
    Done.
    Completed 1600...
    Searching for "Cross My Mind Pt. 2 (feat. Kiiara)" by A R I Z O N A...
    Done.
    Searching for "Poppin' Tags" by Future...
    Done.
    Searching for "On The Loose" by Niall Horan...
    Done.
    Searching for "Jingle Bell Rock" by MC Ty...
    Specified song does not contain lyrics. Rejecting.
    Could not find Jingle Bell Rock by MC Ty
    Searching for "Sex Murder Party (feat. Jamie Principle & Zebra Katz)" by Gorillaz...
    Done.
    Searching for "All We Know" by The Chainsmokers...
    Done.
    Searching for "Stay Blessed" by Bryson Tiller...
    Done.
    Searching for "Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered" by Bing Crosby...
    No results found for: 'Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered Bing Crosby'
    Could not find Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered by Bing Crosby
    Searching for "Danger (with Migos & Marshmello)" by Migos...
    Done.
    Searching for "Too Much To Ask" by Niall Horan...
    Done.
    Searching for "Gilligan" by DRAM...
    Done.
    Searching for "GOD." by Kendrick Lamar...
    Done.
    Searching for "Dance with the Devil" by Gucci Mane...
    Done.
    Searching for "Firework" by Katy Perry...
    Done.
    Searching for "No Stopping You" by Brett Eldredge...
    Done.
    Searching for "Call It What You Want" by Taylor Swift...
    Done.
    Searching for "Nobody (feat. Alicia Keys & Nicki Minaj)" by DJ Khaled...
    Done.
    Searching for "Better Together" by Jack Johnson...
    Done.
    Could not find 57 lyrics.



```python
# Genius (57 not found) is clearly much better than LyricWiki (454 not found).
```


```python
with open('spotify_lyrics.pkl', 'wb') as f:
    pickle.dump(song_dict, f)
```


```python
def add_attr(track, attr, attr_dict):
    song = track['song']
    artist = track['artist']
    a = attr_dict.get((song, artist))
    if not a:
        print(f'{attr} not found for: {song} by {artist}')
    track[attr] = a
    return track
```


```python
for date in stats:
    for track in stats[date]:
        add_attr(track, 'lyrics', song_dict)
```

    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Happy - From "Despicable Me 2" by Pharrell Williams
    lyrics not found for: Can't Hold Us - feat. Ray Dalton by Macklemore & Ryan Lewis
    lyrics not found for: Stayin' Alive - From "Saturday Night Fever" Soundtrack by Bee Gees
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: (I Can't Get No) Satisfaction - Mono Version / Remastered 2002 by The Rolling Stones
    lyrics not found for: You Can't Hurry Love - 2016 Remastered by Phil Collins
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: City Of Stars - From "La La Land" Soundtrack by Ryan Gosling
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: City Of Stars - From "La La Land" Soundtrack by Ryan Gosling
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Wonderwall - Remastered by Oasis
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: T-Shirt (Spotify Mix) - Recorded at Spotify Studios NYC by Migos
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Dab of Ranch - Recorded at Spotify Studios NYC by Migos
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Dab of Ranch - Recorded at Spotify Studios NYC by Migos
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Mixtape (feat. Young Thug & Lil Yachty) by Chance the Rapper
    lyrics not found for: Dab of Ranch - Recorded at Spotify Studios NYC by Migos
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Wonderwall - Remastered by Oasis
    lyrics not found for: Mixtape (feat. Young Thug & Lil Yachty) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Mixtape (feat. Young Thug & Lil Yachty) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Dab of Ranch - Recorded at Spotify Studios NYC by Migos
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Bom Bidi Bom - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by Nick Jonas
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: City Of Stars - From "La La Land" Soundtrack by Ryan Gosling
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Audition (The Fools Who Dream) - From "La La Land" Soundtrack by Emma Stone
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: City Of Stars - From "La La Land" Soundtrack by Ryan Gosling
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Angels (feat. Saba) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Hypnotize - 2014 Remastered Version by The Notorious B.I.G.
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Timeless (DJ SPINKING) by A Boogie Wit da Hoodie
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: All We Got (feat. Kanye West & Chicago Children's Choir) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Smoke Break (feat. Future) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: 美女と野獣 by Ariana Grande
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko) by Joey Bada$$
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: RING THE ALARM (feat. Nyck Caution, Kirk Knight & Meechy Darko) by Joey Bada$$
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: F**kin' Problems (feat. Drake, 2 Chainz & Kendrick Lamar) by A$AP Rocky
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: All Night (feat. Knox Fortune) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Shook Ones, Pt. II by Mobb Deep
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Pull a Caper (feat. Kodak Black, Gucci Mane & Rick Ross) by DJ Khaled
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Summertime Sadness [Lana Del Rey vs. Cedric Gervais] - Cedric Gervais Remix by Lana Del Rey
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Thrift Shop (feat. Wanz) by Macklemore & Ryan Lewis
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: The Way I Are (Dance with Somebody) (feat. Lil Wayne) - Spotify Version by Bebe Rexha
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Juke Jam (feat. Justin Bieber & Towkio) by Chance the Rapper
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: CAN'T STOP THE FEELING! (Original Song from DreamWorks Animation's "TROLLS") by Justin Timberlake
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Get to the Money (feat. Troyse, Cito G & Flames) by Chad Focus
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Stop Draggin' My Heart Around (with Tom Petty & the Heartbreakers) - 2016 Remaster; Remastered by Stevie Nicks
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Lose Yourself - From "8 Mile" Soundtrack by Eminem
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Werewolves of London - 2007 Remaster by Warren Zevon
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Stranger Things by Kyle Dixon & Michael Stein
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Jingle Bell Rock by MC Ty
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Friends (with BloodPop®) by Justin Bieber
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Pull Up N Wreck (With Metro Boomin) by Big Sean
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio
    lyrics not found for: Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] by Lou Monte
    lyrics not found for: The Happiest Christmas Tree - 2009 Digital Remaster by Nat King Cole
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: The Happiest Christmas Tree - 2009 Digital Remaster by Nat King Cole
    lyrics not found for: Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] by Lou Monte
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night by Perry Como
    lyrics not found for: Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered by Bing Crosby
    lyrics not found for: Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975 by Bruce Springsteen
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Have Yourself A Merry Little Christmas - "Meet Me In St. Louis" Original Cast Recording by Judy Garland
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: You're A Mean One, Mr. Grinch - From Dr. Seuss' 'How The Grinch Stole Christmas' by Thurl Ravenscroft
    lyrics not found for: All I Want For Christmas (Is My Two Front Teeth) - Remastered by Nat King Cole Trio
    lyrics not found for: The Happiest Christmas Tree - 2009 Digital Remaster by Nat King Cole
    lyrics not found for: Medley: Caroling, Caroling / The First Noel / Hark! The Herald Angels Sing / Silent Night by Perry Como
    lyrics not found for: Dominick The Donkey (The Italian Christmas Donkey) [With Joe Reisman's Orchestra and Chorus] by Lou Monte
    lyrics not found for: Hark! The Herald Angels Sing/It Came Upon A Midnight Clear - Remastered by Bing Crosby
    lyrics not found for: Rockin' Around The Christmas Tree - Recorded at Spotify Studios NYC by Miley Cyrus
    lyrics not found for: White Christmas (duet with Shania Twain) by Michael Bublé
    lyrics not found for: Santa Claus Is Comin' to Town - Live at C.W. Post College, Greenvale, NY - December 1975 by Bruce Springsteen
    lyrics not found for: Can You See - Spotify Singles - Holiday, Recorded at Spotify Studios NYC by Fifth Harmony
    lyrics not found for: White Christmas - Spotify Singles - Holiday, Recorded at Air Studios, London by George Ezra
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Rockin' Around The Christmas Tree - Single Version by Brenda Lee
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Let It Snow! Let It Snow! Let It Snow! (with The B. Swanson Quartet) by Frank Sinatra
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: Happy Xmas (War Is Over) - Remastered by John Lennon
    lyrics not found for: Carol of the Bells by Mykola Dmytrovych Leontovych
    lyrics not found for: Santa Baby (with Henri René & His Orchestra) by Eartha Kitt
    lyrics not found for: It's Beginning to Look a Lot Like Christmas (with Mitchell Ayres & His Orchestra) by Perry Como
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Can't Hold Us - feat. Ray Dalton by Macklemore & Ryan Lewis
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: Can't Hold Us - feat. Ray Dalton by Macklemore & Ryan Lewis
    lyrics not found for: Love Galore (feat. Travis Scott) by SZA
    lyrics not found for: Stayin' Alive - From "Saturday Night Fever" Soundtrack by Bee Gees
    lyrics not found for: No Problem (feat. Lil Wayne & 2 Chainz) by Chance the Rapper
    lyrics not found for: I Don’t Wanna Live Forever (Fifty Shades Darker) - From "Fifty Shades Darker (Original Motion Picture Soundtrack)" by ZAYN



```python
stopwords.words('english')
```




    ['i',
     'me',
     'my',
     'myself',
     'we',
     'our',
     'ours',
     'ourselves',
     'you',
     "you're",
     "you've",
     "you'll",
     "you'd",
     'your',
     'yours',
     'yourself',
     'yourselves',
     'he',
     'him',
     'his',
     'himself',
     'she',
     "she's",
     'her',
     'hers',
     'herself',
     'it',
     "it's",
     'its',
     'itself',
     'they',
     'them',
     'their',
     'theirs',
     'themselves',
     'what',
     'which',
     'who',
     'whom',
     'this',
     'that',
     "that'll",
     'these',
     'those',
     'am',
     'is',
     'are',
     'was',
     'were',
     'be',
     'been',
     'being',
     'have',
     'has',
     'had',
     'having',
     'do',
     'does',
     'did',
     'doing',
     'a',
     'an',
     'the',
     'and',
     'but',
     'if',
     'or',
     'because',
     'as',
     'until',
     'while',
     'of',
     'at',
     'by',
     'for',
     'with',
     'about',
     'against',
     'between',
     'into',
     'through',
     'during',
     'before',
     'after',
     'above',
     'below',
     'to',
     'from',
     'up',
     'down',
     'in',
     'out',
     'on',
     'off',
     'over',
     'under',
     'again',
     'further',
     'then',
     'once',
     'here',
     'there',
     'when',
     'where',
     'why',
     'how',
     'all',
     'any',
     'both',
     'each',
     'few',
     'more',
     'most',
     'other',
     'some',
     'such',
     'no',
     'nor',
     'not',
     'only',
     'own',
     'same',
     'so',
     'than',
     'too',
     'very',
     's',
     't',
     'can',
     'will',
     'just',
     'don',
     "don't",
     'should',
     "should've",
     'now',
     'd',
     'll',
     'm',
     'o',
     're',
     've',
     'y',
     'ain',
     'aren',
     "aren't",
     'couldn',
     "couldn't",
     'didn',
     "didn't",
     'doesn',
     "doesn't",
     'hadn',
     "hadn't",
     'hasn',
     "hasn't",
     'haven',
     "haven't",
     'isn',
     "isn't",
     'ma',
     'mightn',
     "mightn't",
     'mustn',
     "mustn't",
     'needn',
     "needn't",
     'shan',
     "shan't",
     'shouldn',
     "shouldn't",
     'wasn',
     "wasn't",
     'weren',
     "weren't",
     'won',
     "won't",
     'wouldn',
     "wouldn't"]




```python
# Get unique lyrics for each genre

def get_genre(track):
    if not track['meta']:
        return ['Unknown']
    genre_list = track['meta']['primary_genres']['music_genre_list']
    if not genre_list:
        return ['Unknown']
    genres = [genre_dict['music_genre']['music_genre_name'] for genre_dict in genre_list]
    return genres

def get_lyrics(stats):
    genre_lyric_dict = {}
    for date in stats:
        for track in stats[date]:
            genres = get_genre(track)
            lyrics = track['lyrics']
            if not lyrics:
                continue
            for genre in genres:
                lyric_set = genre_lyric_dict.get(genre, set())
                lyric_set.add(lyrics)
                genre_lyric_dict[genre] = lyric_set
    return genre_lyric_dict
                
def preprocess(genre_lyric_dict):
    genre_lyric_freq = {}
    en_stop = stopwords.words('english')
    for genre in genre_lyric_dict:
        lyric_list = []
        lyrics = genre_lyric_dict[genre]
        for lyric in lyrics:
            lyric = [word.lower() for word in re.split(r'\s', lyric) if word.lower() not in en_stop and word.isalpha()]
            lyric_list.extend(lyric)
        genre_lyric_freq[genre] = Counter(lyric_list)
        
    return genre_lyric_freq
```


```python
genre_lyric_dict = get_lyrics(stats)
```


```python
print(genre_lyric_dict.keys())
```

    dict_keys(['Unknown', 'Hip Hop/Rap', 'Electronic', 'Pop', 'Contemporary R&B', 'Garage', 'Afro-Beat', 'Dancehall', 'Disco', 'Funk', 'R&B/Soul', 'Dance', 'Reggae', 'Alternative Rap', 'Hip-Hop', 'Folk', 'House', 'Rock', 'Alternative', 'Punk', 'Jazz', 'Electronica', 'Country Blues', 'Contemporary Country', 'Country', 'Big Band', 'Dubstep', 'Singer/Songwriter', 'Folk-Rock', 'Pop/Rock', 'Soul', 'East Coast Rap', 'Soft Rock', 'Classical Crossover', 'Contemporary Folk', 'Celtic Folk', 'Traditional Country', 'Indie Rock', 'Latin Urban', 'Southern Gospel', 'Salsa y Tropical', 'EMO', 'Pop Punk', 'Teen Pop', 'Latin', 'Pop in Spanish', 'Psychedelic', 'Indie Pop', 'Heavy Metal', 'Ambient', 'Dirty South', 'K-Pop', 'Gospel', 'Christmas', 'Holiday', 'Vocal', 'Easy Listening'])



```python
genre_lyric_counter = preprocess(genre_lyric_dict)
```


```python
genre_lyric_counter.keys()
```




    dict_keys(['Unknown', 'Hip Hop/Rap', 'Electronic', 'Pop', 'Contemporary R&B', 'Garage', 'Afro-Beat', 'Dancehall', 'Disco', 'Funk', 'R&B/Soul', 'Dance', 'Reggae', 'Alternative Rap', 'Hip-Hop', 'Folk', 'House', 'Rock', 'Alternative', 'Punk', 'Jazz', 'Electronica', 'Country Blues', 'Contemporary Country', 'Country', 'Big Band', 'Dubstep', 'Singer/Songwriter', 'Folk-Rock', 'Pop/Rock', 'Soul', 'East Coast Rap', 'Soft Rock', 'Classical Crossover', 'Contemporary Folk', 'Celtic Folk', 'Traditional Country', 'Indie Rock', 'Latin Urban', 'Southern Gospel', 'Salsa y Tropical', 'EMO', 'Pop Punk', 'Teen Pop', 'Latin', 'Pop in Spanish', 'Psychedelic', 'Indie Pop', 'Heavy Metal', 'Ambient', 'Dirty South', 'K-Pop', 'Gospel', 'Christmas', 'Holiday', 'Vocal', 'Easy Listening'])




```python
plt.style.use('fivethirtyeight')

def plot(dic, genre, types=10):
    fig, ax = plt.subplots()
    labels, values = zip(*dic[genre].most_common(types))
    ax.bar(labels, values)
    ax.set_title(genre)
    for tick in ax.get_xticklabels():
        tick.set_rotation(45)
    plt.show()
```


```python
plot(genre_lyric_counter, 'Hip Hop/Rap')
```


![png](index_files/index_23_0.png)



```python
plot(genre_lyric_counter, 'Electronic')
```


![png](index_files/index_24_0.png)



```python
plot(genre_lyric_counter, 'Pop')
```


![png](index_files/index_25_0.png)



```python
plot(genre_lyric_counter, 'R&B/Soul')
```


![png](index_files/index_26_0.png)



```python
plot(genre_lyric_counter, 'Folk')
```


![png](index_files/index_27_0.png)



```python
plot(genre_lyric_counter, 'Easy Listening')
```


![png](index_files/index_28_0.png)



```python
plot(genre_lyric_counter, 'Gospel')
```


![png](index_files/index_29_0.png)



```python
plot(genre_lyric_counter, 'Unknown')
```


![png](index_files/index_30_0.png)



```python

```
