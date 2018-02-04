#!/usr/bin/python

import optparse
import os
import re
import string
import sys


def main(argv):
    options, args = parse_cmdline(argv)
    synonyms = {}

    if not os.path.isfile(options.wordnet):
        print("file {} does not exist".format(options.wordnet))
        return

    # sample line: s(100102927,1,'motorization',n,1,0).
    p = re.compile("^s\((\d+),\d+,'([^']+)',\w+")

    with open(options.wordnet, "r") as f:
        for line in f:
            line = string.replace(line, ",'''", ",'__")
            line = string.replace(line, "''", "__")
            m = p.match(line)
            if m:
                key = m.group(1)
                word = m.group(2)
                word = string.replace(word, "__", "'")

                if key in synonyms:
                    synonyms[key] += [word]
                else:
                    synonyms[key] = [word]
            else:
                print("[ERROR] mal-formatted line: {}".format(line))

    for k, v in synonyms.iteritems():
        if len(v) <= 1:
            continue
        print("{0} = {1}".format(k, ','.join(v)))
        print("{0} = {1}".format(v[0], ','.join(v[1:])))



def parse_cmdline(argv):
    parser = optparse.OptionParser(description='Convert wordnet database to synonym text file')
    parser.add_option('--wordnet', dest='wordnet', type='str',
                      default='/home/yongtao/tmp/wordnet/prolog/wn_s.pl',
                      help='Name of the wordnet prolog database file')
    (options, args) = parser.parse_args(args=argv[1:])
    return options, args


if __name__ == "__main__":
    main(sys.argv)
