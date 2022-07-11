# -----------------------------------------------------------
# Code by: Kelly Christensen
# Python script to parse digitized document's date from its IIIF manifest.
# -----------------------------------------------------------

import sys
import json
# needs imported in virtual environment
import requests


def request(document):
    # Request manifest from Gallica's IIIF Presentation API
    r = requests.get(f"https://gallica.bnf.fr/iiif/ark:/12148/{document}/manifest.json/")
    response = {d["label"]:d["value"] for d in r.json()["metadata"]}
    return response


def clean(response):
        """Clean metadata received from Gallica API.
        Returns:
            clean_data (dict): cleaned data from IIIF manifest with values == None if not present in API request
        """      
          
        # Make defaultdict for cleaned metadata
        fields = ["Language", "Date"]
        clean_data= {}
        {clean_data.setdefault(f, None) for f in fields}
        for k,v in response.items():
            if type(v) is list and list(v[0].keys())[0]=="@value":
                clean_data[k]=v[0]["@value"]
            else:
                clean_data[k]=v
        return clean_data
    

if __name__ == "__main__":
    document = sys.argv[1:]
    response = request(document[0])
    data = clean(response)
    if data["Language"]:
        century = data["Language"][:2].lower()
    else:
        century = "None"
    print(century)
    print(data["Date"][:2])