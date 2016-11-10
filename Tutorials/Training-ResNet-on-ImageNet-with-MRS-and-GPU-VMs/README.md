# Image Classification of ImageNet database with MXNet

This example shows how to use Deep Neural Networks (DNN) to train a model a big database of images and predict the class of one of them using an [Azure GPU VM](https://azure.microsoft.com/en-us/blog/azure-n-series-preview-availability/). The database of images we use is [ImageNet](http://www.image-net.org/). It consists of a database of 1000 classes where the objective is to classify objects in an image. The accuracy is meassured taking into account the error in the top-5 classes predicted. 

The CNN proposed for the current example is ResNet, based on [this paper](http://arxiv.org/abs/1502.01852) from Microsoft Research in 2015. With a higher number of layers, a DNN can learn more complex relationships but also becomes more difficult to train using the optimization routine. The ResNet architecture introduces the concept of residual units, which allow one to train very deep DNNs while improving the optimization process. The authors proposed a DNN of 152 layers that surpassed for the first time in history the human level performance in image classification. The architecture proposed for this example is ResNet-18, which consists of 18 layers. We chose the smallest architecture for demo purposes. This is the smallest architecture that can be computed to result in decent accuracy and hence is the fastest to train. There are other layer combinations that can be created: 34, 50, 101, 152, 200 and 269. 

## Download ImageNet data 

The ImageNet image dataset contains annotated objects according to the [WordNet](http://nlp.cs.swarthmore.edu/~richardw/papers/miller1995-wordnet.pdf) hierarchy. Each object in WordNet is described as a word or group of words called "synonym set" or "synset", for example: "n02123045 tabby, tabby cat", where "n02123045" is the class name and "tabby, tabby cat" is the description. ImageNet uses a subset of this dataset, and in particular we are using a subset from 2012, which contains images divided in 1000 classes. The synset file that we are going to use in this post can be accessed [here](https://mxnetstorage.blob.core.windows.net/blog3/synset.txt). 
The ImageNet data is further split into the following three datasets:  
1. Training set with 1000 classes and 1000 images for each class, which is used to train the network.
2. Validation set with 50,000 images selected randomly from each class. It is used as the ground truth to evaluate the accuracy in the training.
3. Test set with 100,000 images selected randomly from each class. It is used to evaluate the accuracy in the competition and to rank the participants. 
  
The dataset can be downloaded from the [ImageNet website](http://image-net.org/download) in two ways: by downloading the original images in a compressed format or downloading each image through its original URL using the ImageNet API. For the second option we created the script [imagenet_downloader.py](data/imagenet_downloader.py).    

If you are downloading the images from the URL you have to create a `lst` file with [im2rec.py](data/im2rec.py) tool. The following code will recursively make a list of all images, assigning a label to each folder. The output will be `filename_train.lst` and `filename_test.lst`.

	cd data
	python im2rec.py filename.lst path-to-folder-with-images --recursive True --list True --train-ratio 0.8 --test-ratio 0.2

If you are downloading the original images, you'll find two folders with the training and the validation set. The `lst` file of that date  is available for downloading using the following command: 

    cd data
    python download_data.py

Apart from the `lst` files we downloaded some other files that will be used later. 

The next step is to create the `rec` file. This file is the way MXNet has to compress all the images and their labels in a single file. It will crop and resize to `256x256`. The reason for cropping and resizing the image to a square of 256 pixels is to standardize the dataset. The output will be `train.rec` and `val.rec`.

	cd data
	python im2rec.py train.lst /path/to/folder/with/train/set --recursive True --resize 256 --center-crop True --quality 90 
	python im2rec.py val.lst /path/to/folder/with/validation/set --resize 256 --center-crop True --quality 90

It is recommended as well to add an external disk to our GPU VM for storing the rec files. To do it you can follow the instructions in this [post](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-add-disk/). We created an external disk of 1TB and attached it to an Ubuntu machine. Finally, we copied both rec files to the disk. The final structure of folders looks like this: 
    /datadrive/imagenet/train_.rec 
    /datadrive/imagenet/val.rec 

## Train Convolutional Neural Networks

Once the rec file of the training and validation set is ready, we can train a network in the dataset. For this example we are going to use ResNet architecture with 18 layers. This model takes 3 days to train with 4 Tesla K-80 GPUs. The following code was tested with [MXNet library](https://github.com/dmlc/mxnet) in checkout `8e1e7f0c9f2a7743ab3e975a8803b6fd2b786fef`. To install this version and updated the submodules:
    
    git clone --recursive https://github.com/dmlc/mxnet
    git checkout 8e1e7f0c9f2a7743ab3e975a8803b6fd2b786fef
    git submodule update --recursive

The images are fed to the training process via the iterator `mx.io.ImageRecordIter`, which is a wrapper in R of the [ImageRecordIter](https://github.com/dmlc/mxnet/blob/master/src/io/iter_image_recordio.cc) class in C++. We have to crop the image to a shape of `224x224`, which is the input of the first convolution. You can also specify the batch size, which is the number of images that are computed in parallel in the GPUs. The fastest computation in the Azure machines we tested supports a batch size of 1200, which consumes around 10GB of GPU memory, just below the limit. However, we found that the fastest convergence comes with a batch size of 512. The memory consumed by the GPU depends on the number of images but also on the complexity of the network. For ResNet-152, the maximum batch size we were able to use was 144.  

The learning rate affects significantly how the training behaves. For learning rates in the order of 0.001, training progresses too slowly. For learning rates larger than 0.5, the system fails to converge. The optimal values are between 0.1 and 0.2. In addition, it is important to have a schedule for reducing the learning rate according to the epoch count. We have tried two methods: the first is to multiply the learning rate with a factor smaller than 1 at the end of every epoch. The optimal value we found for this factor is around 0.94. The other method (multi-factor) is to keep the learning rate constant except at specific epochs, at which it is decreased by a factor. We tried with a decrease factor of 0.1 at epochs number 15, 30 and 60. We found that reducing the learning rate at every epoch results in faster convergence.   

Once the data and other parameters are set, the next step is to train the network. To do that we use the R function `mx.model.FeedForward.create`. It is important to specify values for `momentum`, `weight decay`, `initializer` and to clip the gradient to a minimum and maximum value. Instead of using the top-1 accuracy, we used the top-5,  which doesn’t record misclassification if the true class is among the top 5 predictions. The prediction output for each image is in fact a vector of size 1000 with the probability of each of the 1000 classes. The top-5 results are the 5 classes with the highest probability. To train ResNet-18 you can use the following command: 


	cd src
	Rscript train_imagenet.R --network resnet --depth 18 --batch-size 512 --lr 0.1 --lr-factor 0.94 --gpu 0,1,2,3 --num-round 30 --data-dir /path/to/recfile --train-dataset train.rec --val-dataset val.rec --log-dir $PWD --log-file resnet18-mrs-log.txt --model-prefix resnet18-mrs --kv-store device 

The following plot represents the top-5 accuracy of ResNet-18 from epochs 1 to 30. 
<p align="center">
<img src="https://mxnetstorage.blob.core.windows.net/blog3/accuracy.png" alt="top-5 accuracy" width="60%"/>
</p>

To better visualize the results, we created a top-5 accuracy confusion matrix that can be seen in the following figure. The matrix has a size of 1000 by 1000, corresponding to the 1000 classes in the synset file. The rows correspond to the true class and the columns to the predicted class. The matrix is constructed as a histogram of the predictions. For each image, we represent the pair (true label, prediction k) for the k=5 predictions. The bright green represents a high value in the histogram and the dark green represents a low value. Since the validation set consists of 50,000 images, we ended up with a matrix of 250,000 elements. We used the visualization library [datashader](https://github.com/bokeh/datashader) and the trained model of ResNet-18 at epoch 30. 
<p align="center">
<img src="https://mxnetstorage.blob.core.windows.net/blog3/confusion_matrix.png" alt="confusion matrix" width="45%"/>
</p>

The diagonal line in the confusion matrix represents perfect predictor with zero misclassification rate – the predicted class exactly matches the ground truth. Its brightness shows that most images are correctly classified among the top-5 results (in fact more than 90% of them).
We observe that there are two distinct clusters of points: one corresponding to animals and the other to objects. The animal group contains several clusters, while the group corresponding to objects is more scattered. This is because in the case of animals, certain clusters represent groups from the same species (fishes, lizards, birds, cats, dogs, etc). For example, if the true class is a golden retriever, it is better for our model to classify the image as another breed of dog than as a cat. For objects, the misclassifications are more sporadic.

The diagonal line in the confusion matrix represents perfect predictor with zero misclassification rate – the predicted class exactly matches the ground truth. Its brightness shows that most images are correctly classified among the top-5 results (in fact more than 90% of them).
In Fig. 5 we observe that there are two distinct clusters of points: one corresponding to animals and the other to objects. The animal group contains several clusters, while the group corresponding to objects is more scattered. This is because in the case of animals, certain clusters represent groups from the same species (fishes, lizards, birds, cats, dogs, etc). For example, if the true class is a golden retriever, it is better for our model to classify the image as another breed of dog than as a cat. For objects, the misclassifications are more sporadic.

We can visualize how the results change as the number of epochs increases. This is represented in the following gif (Fig. 6), where we create a matrix with the model from epoch 1 to 30 and the images in the validation set.

<p align="center">
<img src="https://mxnetstorage.blob.core.windows.net/blog3/resnet18-mrs-epochs.gif" alt="confusion matrix change" width="45%"/>
</p>


## Predict an image class

After the training we will have 30 trained models of ResNet-18. You can use any of these models to predict the class of an image. We prodive a pretrained model that can be downloaded using the previously mentioned script `download_data.py`. We can use the ResNet loaded in epoch 28 to predict what is the following image.

<p align="center">
<img src="https://mxnetstorage.blob.core.windows.net/blog3/neko.jpg" alt="cat" width="35%"/>
</p>

	Rscript predict_imagenet.R --data-dir ../../data/ --synset synset.txt --img neko.jpg --model-prefix resnet18-mrs --load-epoch 28 

The result is:

	Predicted Top-class:  
	"n02123045 tabby, tabby cat" 
	
	Top 5 predictions: 
	[1] "n02123045 tabby, tabby cat"      
	[2] "n02124075 Egyptian cat" 
	[3] "n02123159 tiger cat"             
	[4] "n02127052 lynx, catamount" 
	[5] "n02125311 cougar, puma, catamount, mountain lion, painter, panther, Felis concolor" 

As it can be seen, the model does not only correctly predicts that in the image there is a tabby cat, but the top 5 results are cat-like animals.


This example uses code from the [mxnet repo](https://github.com/dmlc/mxnet/tree/master/example/image-classification).
