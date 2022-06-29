Pages from these three documents were processed twice with kraken (v. 3.0.13) using two different sets of models.


1.  The "old" directories' pages were segmented with the [appenzeller.mlmodel](https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel) from Heresta and the text was predicted with the [dentduchat.mlmodel](https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel) from Heresta.


 
2. The "new" directories' pages were segmented with the [segmOntoCorpusSegmentation_fineTune_best.mlmodel](https://traces6.paris.inria.fr/media/models/7ea0421c/segmontocorpussegmentation_finetune_best.mlmodel) from traces and the text was predicted with the [Gallicorpora+_best.mlmodel](https://traces6.paris.inria.fr/media/models/dee69a4c/gallicorpora_best.mlmodel) from traces.


# Reproduce Problem
To reproduce the problem described in [Issue #1](https://github.com/Gallicorpora/application/issues/1):

1. Create a virtual environment, activate it, and install requirements.
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r transcribe_requirements.txt
```

2. Download the [appenzeller](https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel) segmentation model and [dentduchat](https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel) HTR model.
```
curl -o oldseg.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel
curl -o oldhtr.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel
```

3. Download the [segmOntoCorpusSegmentation_fineTune_best](https://traces6.paris.inria.fr/media/models/7ea0421c/segmontocorpussegmentation_finetune_best.mlmodel) segmentation model and the [Gallicorpora+_best](https://traces6.paris.inria.fr/media/models/dee69a4c/gallicorpora_best.mlmodel) HTR model.


4. 
