#!/usr/bin/python
# coding: utf-8

# -----------------------------------------------------------
# Code by: Simon Gabay and Caroline Corbières
# Python script to import IIIF images
# -----------------------------------------------------------

import argparse
import json
import os
import re
import requests
import time


# This script is based on URI Manifest model: {scheme}://{host}/{prefix}/{identifier}/manifest

# If you want to import IIIF Images from Gallica, you can used the default arguments.   https://bibliotheque-numerique.inha.fr/iiif/21124/manifest

parser = argparse.ArgumentParser(description='IIIF Images import.')
parser.add_argument( '-s', '--scheme', type=str, default='https', help='protocol')
parser.add_argument('-d', '--domain', type=str, default='gallica.bnf.fr', help='hostname')
parser.add_argument('-p', '--prefix', type=str, default='iiif', help='prefix of the service localisation')
parser.add_argument('identifier', type=str, help='document identifier like the ark id')
parser.add_argument('-m', '--manifest', type=str, default='manifest.json', help='manifest’s name in the uri')
parser.add_argument('-l', '--limit', type=int, default=None)
parser.add_argument('-q', '--quality', type=str, default='full')
parser.add_argument('-v', '--verbose', action="store_true")
parser.add_argument('-e', '--export_location', type=str, default='downloads')
args = parser.parse_args()

# Specify in the terminal the arguments you need to complete the manifest's url
manifest_url = '%s://%s/%s/%s/%s' %(
    args.scheme, args.domain, args.prefix, args.identifier, args.manifest)
response = requests.get(manifest_url)
manifest = json.loads(response.content)
try:
    canvases = manifest['sequences'][0]['canvases']
except (KeyError, IndexError):
    raise ValueError("Couldn't figure out where the images are.")

for i, canvas in enumerate(canvases[:args.limit]):
    try:
        url = canvas['images'][0]['resource']['@id']
    except (KeyError, IndexError):
        raise ValueError("No image for canvas %s" % canvas['@id'])

    # replaces quality in the image's uri
    url = re.sub(r'/full/full/', '/full/%s/' % args.quality, url)
    if args.verbose:
        print('Fetching %s' % url)

    r = requests.get(url, stream=True)
    if r.status_code == 200:
        if args.identifier.startswith('ark:'):
            identifier_name = ''.join(args.identifier[11:])
        elif '/' in args.identifier:
            identifier_name = ''.join(args.identifier.replace('/', '_'))
        else:
            identifier_name = ''.join(args.identifier)
        path = os.path.join(args.export_location, identifier_name)
        try:
            if os.path.isdir(args.export_location):
                os.mkdir(path)
            else:
                os.mkdir(args.export_location)
                os.mkdir(path)

        except OSError:
           pass  # directory already exists
        fpath = os.path.join(path, '%d.jpg' % (i+1))  # assuming it's always jpg (?)
        with open(fpath, 'wb+') as f:
            for chunk in r:
                f.write(chunk)

    # throtling fetch to avoid being blacklisted
    time.sleep(0.5)  # 0.5s is a lot, 0.1 should be enough but better safe than sorry.
