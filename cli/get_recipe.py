#!/usr/bin/env python

'''
Install a new recipe into a docker4data container.
'''

import argparse
import json
import urllib2
import logging
import sys


RECIPE_BASE = u'https://raw.githubusercontent.com/talos/docker4data/master/recipes/'
LOGGER = logging.getLogger()
LOGGER.addHandler(logging.StreamHandler(sys.stderr))
LOGGER.setLevel(logging.INFO)


def main(recipe_name):
    '''
    Main method for the script.
    '''
    url = urllib2.urlparse.urljoin(RECIPE_BASE, recipe_name)
    LOGGER.info(u'Pulling recipe "%s" from "%s"', recipe_name, url)
    try:
        recipe = json.loads(urllib2.urlopen(url).read())
    except urllib2.HTTPError:
        LOGGER.error(u'Could not find recipe "%s"', recipe_name)
        sys.exit(1)



if __name__ == '__main__':
    PARSER = argparse.ArgumentParser()
    PARSER.add_argument(u"recipe", help=u"The name of the recipe to install in docker4data")
    ARGS = PARSER.parse_args()
    main(ARGS.recipe)
