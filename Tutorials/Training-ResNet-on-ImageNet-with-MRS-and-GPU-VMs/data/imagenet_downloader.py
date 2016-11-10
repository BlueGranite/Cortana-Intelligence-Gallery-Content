import urllib
import pandas as pd
import cv2
import os
import wget


class ImageNetDownloader:
    def __init__(self):
        self.host = 'http://www.image-net.org'
        self.exts = ('.jpg', '.jpeg', '.png', '.gif')

    def download_file(self, url, path='.'):
        resp = wget.download(url=url, out=path)
        fname = url.split('/')[-1]
        fpath = path + '/' + fname
        if not os.path.isfile(fpath):
            os.remove(fpath)
            raise ValueError("The object downloaded is not a file")
        suffix = os.path.splitext(fname)[1].lower()
        if suffix not in self.exts:
            os.remove(fpath)
            raise ValueError("Extension not correct")
        img = cv2.imread(fpath)
        if img is None:
            os.remove(fpath)
            raise ValueError("Image not correct")

        return fpath

    def get_image_urls_of_wnid(self, wnid):
        url = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=' + str(wnid)
        f = urllib.urlopen(url)
        contents = f.read().split('\n')
        image_urls = []

        for each_line in contents:
            # Remove unnecessary char
            each_line = each_line.replace('\r', '').strip()
            if each_line:
                image_urls.append(each_line)

        return image_urls

    def make_wnid_dir(self, wnid):
        if not os.path.exists(wnid):
            os.mkdir(wnid)
        return os.path.abspath(wnid)

    def download_images_by_urls(self, wnid, image_urls, rewrite_files=True):
        if not rewrite_files:
            ldir = [d for d in os.listdir(os.getcwd()) if os.path.isdir(d)]
            if wnid in ldir:
                print("Class %s already downloaded" % wnid)
                files_in_folder = [f for f in os.listdir(wnid)]
                return files_in_folder
        wnid_dir = self.make_wnid_dir(wnid)
        image_path_list = []
        for url in image_urls:
            try:
                image_path = self.download_file(url, wnid_dir)
                image_path_list.append(image_path)
            except Exception, error:
                print ('Fail to download : ' + url)
                print (str(error))
        return image_path_list

    def read_class_file(self, filename):
        #Load the classes
        df = pd.read_csv(filename, sep='\s{2,}', names=['col'])
        df['class'] = df['col'].str.split().apply(lambda x: x[0])
        df['description'] = df['col'].str.join('').apply(lambda x: str(x).split(' ',1)[1])
        del(df['col'])
        return df

    def remove_folder(self, foldername):
        os.rmdir(foldername)

if __name__ == '__main__':

    # Initialize variables
    rewrite_files = False
    imagenet_classes_file = 'synset.txt'

    # Image downloader
    downloader = ImageNetDownloader()
    class_list = downloader.read_class_file(imagenet_classes_file)
    for c in class_list['class']:
        print("Downloading class: %s" % c)
        url_list = downloader.get_image_urls_of_wnid(wnid=c)
        image_path_list = downloader.download_images_by_urls(wnid=c, image_urls=url_list,
                                                             rewrite_files=rewrite_files)
