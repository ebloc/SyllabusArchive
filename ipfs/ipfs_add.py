# -*- coding: utf-8 -*-
import os
from pymongo import MongoClient
import ipfsapi
import json
from itertools import groupby
from operator import itemgetter


if not os.path.exists("../syllabi"):
    print("\t\n ERROR ! Course pdfs should be included in this directory with name 'syllabi' ! \n")
    exit(1)

dir_path = os.path.dirname(os.path.realpath(__file__))
sylabi_dir = '../syllabi'
grouped_json_file = '../grouped_courses.json'
raw_json_file = '../raw_courses.json'

# INIT IPFS
try:
    ipfs = ipfsapi.connect('127.0.0.1', 5001)
except:
    print("IPFS couldn't connect. Check if 'ipfs daemon' is running!")
    exit()

# # INIT MONGODB
# mongoDB = MongoClient()
# try:
#     db = mongoDB.syl_test_db
# except:
#     print("MongoDB couldn't start. Make sure you have the db")

courses = []

print("\n\t{} PDFs to work on!".format(len(os.listdir(sylabi_dir))))
for ind, pdf in enumerate(os.listdir(sylabi_dir), 1):
    pdf_file = open(os.path.join(sylabi_dir, pdf), 'rb')

    ipfs_add_res = ipfs.add(pdf_file)
    ipfs_hash = ipfs_add_res['Hash']

    course_name = pdf_file.name.split('_')

    course = {}
    course['name']       = course_name[2].split('.pdf')[0].strip()
    course['code']       = course_name[1][-3:]
    course['department']        = course_name[1][:4]
    course['semester']          = course_name[0].split('/')[-1]
    course['ipfs_hash']         = ipfs_hash

    courses.append(course)

    # res = db.syl_test.update({'local_pdf_path': course['local_pdf_path']}, course, upsert=True)
    # res = db.syl_test.insert_one(course)

all_grouped = {}

total = 0
for semester, course_list in groupby(sorted(courses, key=itemgetter('semester')), key=itemgetter('semester')):
    grouped_deps = {}
    for course_code, course in groupby(sorted(course_list, key=itemgetter('department')), key=itemgetter('department')):
        grouped_deps[course_code] = list(course)
        total = total + len(grouped_deps[course_code])
    all_grouped[semester] = grouped_deps

# delete json files if exists
try:
    os.remove(grouped_json_file)
    os.remove(raw_json_file)
except OSError:
    pass

with open(grouped_json_file, 'w') as grouped_json:
    json.dump(all_grouped, grouped_json, indent=2, sort_keys=True)

with open(raw_json_file, 'w') as raw_json:
    json.dump(courses, raw_json, indent=2, sort_keys=True)

print("\n\t{} PDFs added to json!\n".format(total))
