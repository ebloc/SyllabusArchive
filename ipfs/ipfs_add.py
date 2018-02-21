import os
from collections import OrderedDict
from pymongo import MongoClient
import ipfsapi

dir_path = os.path.dirname(os.path.realpath(__file__))

if not os.path.exists("syllabi"):
    print("\t\n ERROR ! Course pdfs should be included in this directory with name 'syllabi' ! \n")
    exit(1)

# INIT IPFS
try:
    ipfs = ipfsapi.connect('127.0.0.1', 5001)
except:
    print("IPFS couldn't connect. Check if 'ipfs daemon' is running!")

# INIT MONGODB
mongoDB = MongoClient()
try:
    db = mongoDB.syl_test_db
except:
    print("MongoDB couldn't start. Make sure you have the db")

print("\n\t{} PDF Files to work on...\n".format(len(os.listdir('syllabi'))))
for ind, pdf in enumerate(os.listdir('syllabi'), 1):
    pdf_file = open("syllabi/" + pdf, 'r')

    ipfs_add_res = ipfs.add(pdf_file)
    ipfs_hash = ipfs_add_res[u'Hash']

    course_name = pdf_file.name.split('_')[1].split('.')[0]
    # print("Course: {}  | Code: {} | Section: {}".format(course_name[:4],course_name[4:7],course_name[-2:]))
    course = OrderedDict()
    course['course_name']       = course_name[:4]
    course['course_code']       = course_name[4:7]
    course['local_pdf_path']    = dir_path + "/syllabi/" + pdf
    course['ipfs_hash']         = ipfs_hash

    res = db.syl_test.update({'local_pdf_path': course['local_pdf_path']}, course, upsert=True)

    # res = db.syl_test.insert_one(course)
    print("pdf # {} processed and added to db with result : {}".format(ind, res))
    print
