# Gallic(orpor)a Application

---
### *Quick! I already have the app installed. How do I use it right now?*
```
bash install.sh -f your_models.csv
```
```
bash process.sh -f arks.txt -l 10
```

## **What It Does**
___
A demonstration of the pipeline can be seen in this [YouTube video](https://www.youtube.com/watch?v=iSpGQuKMvlY).
The Gallic(orpor)a Application downloads digital images of pages from a document on Gallica, transcribes them with Machine Learning models, and structures that transcribed data into a digital edition that conforms to the TEI (Text Encoding Initiative).

## **How to Use It**
___
## Requirements
- python 3.9
- bash shell
---
### 1. Download the Application
1. Clone this repository.
```
$ git clone https://github.com/gallicorpora/application.git
```
2. Rename and move into this repository.
```
$ mv application/ gallicorpora
$ cd gallicorpora
```
---
### 2. Set up the Application
3. Install models and dependencies.

There are 2 ways to install the Machine Learning models that this application needs.

- **OPTION 1.** If you want to download Machine Learning models from an online repository (GitHub, Zenodo, HuggingFace, etc.), follow these two steps:

    1. In the file `your_models.csv`, write the URL and some information about what the model does. That informaiton includes the training data's language, the training data's century, and the model's task: segmentation (seg) or handwritten text recognition/ocr (htr). The URL needs to be the exact URL that triggers the model's download (not simply the page on which that URL can be accessed).

        |language|century|job|url|
        |--------|-------|---|---|
        |fr|17|seg|https://github.com/...mlmodel|
        |fr|17|htr|https://github.com/...mlmodel|

        *When you download this prototype,* `your_models.csv` *already has models listed for 17th-century French texts that are ready for you to use.*

    2. With the `your_models.csv` prepared, launch the installation with the option `-f` and the path to the CSV file.
        ```
        $ bash install.sh -f your_models.csv
        ```

- **OPTION 2.** If you have Machine Learning models installed on your local machine, follow these two steps:

    1. Copy and/or rename the models in a single directory according to the following syntax:

        |language|century|job|file extension|
        |--|--|--|--|
        |`fr`|`17`|`htr`|`.mlmodel`|
        |lower-case letters|digits|"seg" or "htr"|.mlmodel

        example file name: `fr17htr.mlmodel`

    2. Launch the installation with the option `-d` and the path to the directory containing the properly (re)named models.

        ```
        $ bash install.sh -d <DIRECTORY>
        ```

>Note: The prototype currently recognizes which model to apply to a document by parsing the digitized document's IIIF manifest and extracting the first two letters of the first language the manifest ascribes to the document. This means that the prototype does not distinguish between different types of French, such as *moyen français* (frm) and *français moderne* (fra). In both cases, that document's language would be represented in the file name as "fr".

---
### 3. Run the Application
4. Run the script `process.sh` with its required parameter `-f`.

- In order to know which documents to download and to transcribe, the application needs to read a text file with a list of each document's Archival Resource Key (ARK). Each ARK should be on a new line in this simple text document, as seen in the following example:

    ```  
    bpt6k72609n
    bpt6k111525t
    ```
    After the option `-f`, give the relative path to that file.
    ```
    $ bash process.sh -f <FILE>
    ```
    *When you download this prototype, the text file* `arks.txt` *already has Archival Resource Keys that you can use.*
- If you do not want to download all of a document--and when testing this prototype it is not advisable to download all of a document--the option `-l` allows you to limit the number of pages.
    ```
    $ bash process.sh -f <FILE> -l <LIMIT>
    ```
### Result
All that's left is to sit back and watch the images get downloaded into the directory `img/`, then the transcriptions appear in the directory `data/`, and finally the TEI documents to also appear in `data/`.

## How the Model Is Chosen

How does the application determine which segmentation and HTR model to apply without any user input?

1. What would be the ideal model?


    IIIf manifests usually have data fields that label the document's language(s) and its date(s) of publication. This data is stored in a JSON format.
    
    ```json
    
    {
        "metadata":
            {
            "label":  "Language",
            "value":  "Italian"
            },
            {
            "label":  "Date",
            "value":  "1425-1450"
            }
    }
    ```
    The example IIIF manfiest metadata above, for instance, would ideally have models trained on Italian texts from the 15th century. According to this application's file naming syntax, those models would be called `it15seg.mlmodel` for segmentation and `it15htr.mlmodel` for text recognition. By parsing data from the IIIF manifest and transforming it into these ideal models' names, the application then knows what to search for in the collection of models it installed in `models/`.

2. What are the available models?

    During the installation process, either models were downloaded and named according to the syntax described above (language+century+function) or they were already locally installed on the computer. Because the installation process verifies that the locally installed models adhere to the required syntax, all the models in `models/` are named in a way that reveals for what language and century they are optimized.
    
    Also during the installation process, default models are downloaded into the directory `models/`. The URL to a default segmentation model and the URL to a default HTR model are both given in the file `install.sh`.

    
    ```bash
    # URL for a default segmentation model
    DEFAULTSEG=https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel

    # URL for a default htr model
    DEFAULTHTR=https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel
    ```
3. Is the ideal model available?

    Having determined what would be the ideal models to apply to the document, `scripts/2_transcribe_images.sh` checks if the directory `models/` contains them. If the script finds that it has a file whose name is identical to that of the ideal model, it applies that model to the document. However, if the script does not find what it believes is the ideal model, the script applies the default models `defaultseg.mlmodel` and `defaulthtr.mlmodel`. This automated assessment is possible thanks to the strict file naming syntax applied to the Machine Learning models installed with this application.
