#!/usr/bin/env python

'''
Bulk add docs to an elasticsearch index.
'''

import sys
import os
import json
import logging
import subprocess
#import time

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)
LOGGER.addHandler(logging.StreamHandler(sys.stderr))


#def shell(cmd, max_attempts=7):
def shell(cmd):
    """
    Run a shell command convenience function.
    """
    LOGGER.info(cmd)
    return subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    #attempt = 1
    #while True:
    #    try:
    #        LOGGER.info(cmd)
    #        return subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    #    except subprocess.CalledProcessError as err:
    #        attempt += 1
    #        LOGGER.warn(err)
    #        LOGGER.warn('failed attempt %s of %s', attempt, max_attempts)
    #        time.sleep(1)



def bulk_post(file_handle):
    """
    Post bulk data at file_handle
    """
    LOGGER.debug(
        shell('curl -s XPOST 127.0.0.1:9200/docker4data/metadata/_bulk --data-binary @{}'.format(
            file_handle.name))
    )


#def eliminate_newlines(obj):
#    """
#    Eliminate all newlines from an object, modifies in-place.
#    """
#    for k, value in obj.iteritems():
#        if isinstance(value, dict):
#            eliminate_newlines(value)
#        elif isinstance(value, list):
#            for element in value:
#                eliminate_newlines(element)
#        elif isinstance(value, basestring):
#            value = value.replace('\n', '').replace('\r', '')
#            obj[k] = value
#
#    return obj


def index(path):
    """
    Index data.json's inside this path.
    """
    i = 0
    try:
        os.mkdir('tmp')
    except OSError:
        pass
    with open(os.path.join('tmp', 'tmp.nljson'), 'w') as tmp:
        for subpath, _, files in os.walk(path):
            if len(files):
                for datajson in files:
                    fullpath = os.path.join(subpath, datajson)
                    dataset_id = subpath.split(os.path.sep)[-1]
                    try:
                        content = json.load(open(fullpath, 'r'))
                    except ValueError:
                        LOGGER.warn("Had to skip %s because not valid JSON", fullpath)
                        continue
                    json.dump({
                        "update": {
                            "_id": dataset_id
                        }
                    }, tmp)
                    tmp.write('\n')
                    json.dump({
                        "doc": content,
                        "doc_as_upsert": True
                    }, tmp)
                    #json.dump(content, tmp)
                    tmp.write('\n')
                    i += 1
                    if i > 500:
                        bulk_post(tmp)
                        tmp.truncate(0)
                        tmp.seek(0)
                        i = 0


if __name__ == '__main__':
    index(sys.argv[1])
