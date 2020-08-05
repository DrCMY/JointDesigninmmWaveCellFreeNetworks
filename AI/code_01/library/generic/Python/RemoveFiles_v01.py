import os,glob
def RemoveFiles(extensions):  
    for i in extensions:
        for files in glob.glob(i):
            os.remove(files)                   