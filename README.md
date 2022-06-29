Pages from these three documents were processed twice 
with kraken (v. 3.0.13) using two different sets of 
models.


1.  The "old" directories' pages were segmented 
with the appenzeller.mlmodel from Heresta and the text 
was predicted with the dentduchat.mlmodel from Heresta.


 
2. The "new" directories' pages were segmented with the 
segmOntoCorpusSegmentation_fineTune_best.mlmodel from 
traces and the text was predicted with the 
Gallicorpora+_best.mlmodel from traces.


The new models create TAG lists unique to each page, 
rather than unique to a whole document. This means 
that the application `alto2tei` cannot collate the 
pages into  one document with one set of TAGREFS. The old models' 
data was able to be transformed into a TEI document. 
The new models' data posed a problem because the first 
page's list of TAGS was not the same as the list of 
TAGS on other pages and thus triggered a key error.
