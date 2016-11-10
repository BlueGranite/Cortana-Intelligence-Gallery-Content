# Predict using model trained in imagenet
require(mxnet)
require(argparse)
require(imager)

# Arguments
parse_args <- function() {
  parser <- ArgumentParser(description="predict an image using a model trained on ImageNet")
  parser$add_argument('--data-dir', type='character', default='data',
                      help="the data directory")
  parser$add_argument('--img', type='character', default='test.jpg',
                      help="the image to predict")
  parser$add_argument('--synset', type='character', default='synset.txt', 
                      help="file containing the name of the class")
  parser$add_argument('--model-prefix', type='character',
                      help="the prefix of the model to load")
  parser$add_argument('--load-epoch', type='integer',
                      help="load the model on an epoch using the model-prefix")
  parser$parse_args()
}
args <- parse_args()

# Load model
model_path <- file.path(args$data_dir,args$model_prefix)
model = mx.model.load(model_path, args$load_epoch)

# Load image
img_path <- file.path(args$data_dir,args$img)
img <- load.image(img_path)
#plot(img)

# Preprocess image
preproc.image <- function(im, size=224) {
  # crop the image
  shape <- dim(im)
  short.edge <- min(shape[1:2])
  xx <- floor((shape[1] - short.edge) / 2)
  yy <- floor((shape[2] - short.edge) / 2)
  croped <- crop.borders(im, xx, yy)
  # resize to size x size, needed by input of the model.
  resized <- resize(croped, size, size)
  # convert to array (x, y, channel)
  arr <- as.array(resized)*255
  # Reshape to format needed by mxnet (width, height, channel, num)
  dim(arr) <- c(size, size, 3, 1)
  return(arr)
}
img <- preproc.image(img)

# Predict using the pretrained model
prob <- predict(model, X=img)

# Load synset
synset_path = file.path(args$data_dir,args$synset)
synset <- readLines(synset_path)

# Prediction top 1
top1_idx <- max.col(t(prob))
cat(paste0("Predicted Top-class: ", synset[[top1_idx]], "\n"))

# Prediction top 5
top5_idx <- order(prob[,1], decreasing = TRUE)[1:5]
cat("Top 5 predictions:\n")
print(synset[top5_idx])

