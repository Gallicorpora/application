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

2. Download the appenzeller segmentation model and dentduchat HTR model.
```
curl -o oldseg.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel
curl -o oldhtr.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel
```

3. Download the segmOntoCorpusSegmentation_fineTune_best segmentation model and the Gallicorpora+_best HTR model.
```
curl -o newseg.mlmodel --location --remote-header-name --remote-name https://traces6.paris.inria.fr/media/models/7ea0421c/segmontocorpussegmentation_finetune_best.mlmodel
curl -o newhtr.mlmodel --location --remote-header-name --remote-name https://traces6.paris.inria.fr/media/models/dee69a4c/gallicorpora_best.mlmodel
```

4. Test a document on the old models.
```
cd images/bpt6k990549b
kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i ../../oldseg.mlmodel -bl ocr -m ../../oldhtr.mlmodel
cd -
mkdir test-old
mv images/bpt6k990549b/*.xml test-old/
```

5. Test a document on the new models.
```
cd images/bpt6k990549b
kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i ../../newseg.mlmodel -bl ocr -m ../../newhtr.mlmodel
cd -
mkdir test-new
mv images/bpt6k990549b/*.xml test-new/
```
6. Compare the documents' `<TAGS>`.
