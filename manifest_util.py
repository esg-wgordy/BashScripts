# -*- coding: utf-8 -*-
"""
Created on Wed May  5 14:29:16 2021

@author: Walter Gordy

Purpose: To automate changing between remote and local developer mode on showcase. 
"""

import json
import os

MANIFEST_FILE = 'idlekit-showcase/Packages/manifest.json'

REMOTE = {'com.idlekit.analytics': 'ssh://git@github.com/Idlekit/idlekit-analytics.git#', 
          'com.idlekit.core':      'ssh://git@github.com/Idlekit/idlekit-core.git#', 
          'com.idlekit.gameplay':  'ssh://git@github.com/Idlekit/idlekit-gameplay.git#', 
          'com.idlekit.tools':     'ssh://git@github.com/Idlekit/idlekit-tools.git#'}

LOCAL =  {'com.idlekit.analytics': "file:../../idlekit-analytics",
          'com.idlekit.core':      "file:../../idlekit-core",
          'com.idlekit.gameplay':  "file:../../idlekit-gameplay",
          'com.idlekit.tools':     "file:../../idlekit-tools"}


print("Would you like to convert to Remote or Local development mode?")

choice = input("(R)emote or (L)ocal: ")

choice = choice.lower()

branch = None

replacement = LOCAL

if choice == 'r':
    branch = input("Please specify a branch: ")
    
    for key, val in REMOTE.items():
        replacement[key] = REMOTE[key] + branch
        

print(replacement)

json_data = None
manifest_data = None

if os.path.exists(MANIFEST_FILE):
    
    print("Found showcase project")
    
    with open(MANIFEST_FILE, 'r') as manifest_file:
        manifest_data = json.load(manifest_file)
    
    for key, val in manifest_data['dependencies'].items():
        if key in replacement.keys():
            manifest_data['dependencies'][key] = replacement[key]
        
    
    with open(MANIFEST_FILE, 'w') as manifest_file: 
        json.dump(manifest_data, manifest_file, indent=2)
    
else:
    print("No idlekit-showcase project could be found! Aborting.")
