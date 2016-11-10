#Downloads the ImageNet data
import zipfile
import sys
import os
current_path = os.path.dirname(os.path.abspath(__file__))
root_path = current_path.rsplit('solutions')[0]
sys.path.insert(0,root_path)
from solutions.utils.python_utils import download_file

url_root = 'https://mxnetstorage.blob.core.windows.net/'

#Download ResNet model
url_resnet_params = url_root + 'blog3/resnet18-mrs-0028.params'
url_resnet_symbol = url_root + 'blog3/resnet18-mrs-symbol.json'
print("Downloading file %s" % url_resnet_params)
download_file(url_resnet_params)
download_file(url_resnet_symbol)

#Download images
url_cat = url_root + 'blog3/neko.jpg'
download_file(url_cat)

#Download synset
url_synset = url_root + 'blog3/synset.txt'
download_file(url_synset)

#Download lst files
url_train = url_root + 'blog3/train.lst'
download_file(url_train)
url_val = url_root + 'blog3/val.lst'
download_file(url_val)
