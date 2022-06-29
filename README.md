Pages from these three documents were processed twice with kraken (v. 3.0.13) using two different sets of models.


1.  The "old" directories' pages were segmented with the [appenzeller.mlmodel](https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel) from Heresta and the text was predicted with the [dentduchat.mlmodel](https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel) from Heresta.


 
2. The "new" directories' pages were segmented with the [segmOntoCorpusSegmentation_fineTune_best.mlmodel](https://traces6.paris.inria.fr/media/models/7ea0421c/segmontocorpussegmentation_finetune_best.mlmodel) from traces and the text was predicted with the [Gallicorpora+_best.mlmodel](https://traces6.paris.inria.fr/media/models/dee69a4c/gallicorpora_best.mlmodel) from traces.


The new models create TAG lists unique to each page, rather than unique to a whole document. This means that the application `alto2tei` cannot collate the pages into  one document with one set of TAGREFS. The old models' data was able to be transformed into a TEI document. The new models' data posed a problem because the first page's list of TAGS was not the same as the list of TAGS on other pages and thus triggered a key error.
