import glob
import shutil
import sys

if len(sys.argv) != 3:
    print "python merge_directory.py directory_to_merge outfile"
    exit(-1)



directory_to_merge = sys.argv[1]
outfilename = sys.argv[2]

with open(outfilename, 'wb') as outfile:
    for filename in glob.glob(directory_to_merge + '/*.*'):
        if filename == outfilename:
            # don't want to copy the output into the output
            continue
        with open(filename, 'rb') as readfile:
            shutil.copyfileobj(readfile, outfile)
