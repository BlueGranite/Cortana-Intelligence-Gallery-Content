# Train imagenet
require(mxnet)
require(argparse)

get_iterator <- function(args) {
  data.shape <- c(args$data_shape, args$data_shape, 3)
  train = mx.io.ImageRecordIter(
    path.imgrec     = file.path(args$data_dir, args$train_dataset),
    batch.size      = args$batch_size,
    data.shape      = data.shape,
    mean.r          = 123.68,
    mean.g          = 116.779,
    mean.b          = 103.939,
    rand.crop       = TRUE,
    rand.mirror     = TRUE
  )
  
  val = mx.io.ImageRecordIter(
    path.imgrec     = file.path(args$data_dir, args$val_dataset),
    batch.size      = args$batch_size,
    data.shape      = data.shape,
    mean.r          = 123.68,
    mean.g          = 116.779,
    mean.b          = 103.939,
    rand.crop       = FALSE,
    rand.mirror     = FALSE
  )
  ret = list(train=train, value=val)
}

parse_args <- function() {
  parser <- ArgumentParser(description='train an image classifer on ImageNet')
  parser$add_argument('--network', type='character', default='resnet',
                      choices = c('resnet', 'inception-bn', 'googlenet', 'inception-resnet-v1',
                                  'inception-resnet-v2'),
                      help = 'the cnn to use')
  parser$add_argument('--data-dir', type='character', default='../../data',
                      help='the input data directory')
  parser$add_argument('--gpus', type='character',
                      help='the gpus will be used, e.g "0,1,2,3"')
  parser$add_argument('--batch-size', type='integer', default=128,
                      help='the batch size')
  parser$add_argument('--lr', type='double', default=.01,
                      help='the initial learning rate')
  parser$add_argument('--lr-factor', type='double', default=1,
                      help='times the lr with a factor for every lr-factor-epoch epoch')
  parser$add_argument('--lr-factor-epoch', type='double', default=1,
                      help='the number of epoch to factor the lr, could be .5')
  parser$add_argument('--lr-multifactor', type='character', 
                      help='the epoch at which the lr is changed, e.g "15,30,45"')
  parser$add_argument('--mom', type='double', default=.9,
                      help='momentum for sgd')
  parser$add_argument('--wd', type='double', default=.0001,
                      help='weight decay for sgd')
  parser$add_argument('--clip-gradient', type='double', default=5,
                      help='clip min/max gradient to prevent extreme value')
  parser$add_argument('--model-prefix', type='character',
                      help='the prefix of the model to load/save')
  parser$add_argument('--load-epoch', type='integer',
                      help="load the model on an epoch using the model-prefix")
  parser$add_argument('--num-round', type='integer', default=10,
                      help='the number of iterations over training data to train the model')
  parser$add_argument('--kv-store', type='character', default='local',
                      help='the kvstore type')
  parser$add_argument('--num-examples', type='integer', default=1281167,
                      help='the number of training examples')
  parser$add_argument('--num-classes', type='integer', default=1000,
                      help='the number of classes')
  parser$add_argument('--log-file', type='character', 
                      help='the name of log file')
  parser$add_argument('--log-dir', type='character', default="/tmp/",
                      help='directory of the log file')
  parser$add_argument('--train-dataset', type='character', default="train.rec",
                      help='train dataset name')
  parser$add_argument('--val-dataset', type='character', default="val.rec",
                      help="validation dataset name")
  parser$add_argument('--data-shape', type='integer', default=224,
                      help='set images shape')
  parser$add_argument('--depth', type='integer',
                      help='the depth for resnet, it can be a value among 18, 50, 101, 152, 200, 269')
  parser$parse_args()
}
args <- parse_args()

# log
if(!is.null(args$log_file)){
  sink(file.path(args$log_dir, args$log_file), append = FALSE, 
       type=c("output", "message"))
  cat(paste0("Starting computation of ", args$network, " at ", Sys.time(), "\n"))
}
cat("Arguments")
print(unlist(args))

# network
if (args$network == 'inception-bn'){
  source("symbol_inception-bn.R")
} else if (args$network == 'googlenet'){
  if(args$data_shape < 299) stop(paste0("The data shape for ", args$network, " has to be at least 299"))
  source("symbol_googlenet.R")
} else if (args$network == 'inception-resnet-v1'){
  if(args$data_shape < 299) stop(paste0("The data shape for ", args$network, " has to be at least 299"))
  source("symbol_inception-resnet-v1.R")
}  else if (args$network == 'inception-resnet-v2'){
  if(args$data_shape < 299) stop(paste0("The data shape for ", args$network, " has to be at least 299"))
  source("symbol_inception-resnet-v2.R")
} else if (args$network == 'resnet'){
  source("symbol_resnet-v2.R")
} else{
  stop("Wrong network")
}

if (is.null(args$depth)){
  network <- get_symbol(args$num_classes)
} else{
  network <- get_symbol(args$num_classes, args$depth)
}

# data
data <- get_iterator(args)
train <- data$train
val <- data$value

# devices
if (is.null(args$gpus)) {
  devs <- mx.cpu()  
} else {
  devs <- lapply(unlist(strsplit(args$gpus, ",")), function(i) {
    mx.gpu(as.integer(i))
  })
}

# save model
if (is.null(args$model_prefix)) {
  checkpoint <- NULL
} else {
  checkpoint <- mx.callback.save.checkpoint(args$model_prefix)
}

# load pretrained model
if(!is.null(args$load_epoch)){
  if(is.null(args$model_prefix)) stop("model_prefix should not be empty")
  begin.round <- args$load_epoch
  model <- mx.model.load(args$model_prefix, iteration=begin.round)
  network <- model$symbol
  arg.params <- model$arg.params
  aux.params <- model$aux.params
} else{
  arg.params <- NULL
  aux.params <- NULL
  begin.round <- 1
}

# Multifactor scheduler 
MultiFactorScheduler <- function(step, factor_val, stop_factor_lr=1e-8, verbose=TRUE) {
  if(!all(step == cummax(step))) stop("Schedule step must be an increasing integer list")
  if(any(step < 1))  stop("Schedule step must be greater or equal than 1 round")
  if(factor_val > 1) stop("Factor must be no more than 1 to make lr reduce")
  function(optimizerEnv){
    if(is.null(optimizerEnv$cur_step_ind)){
      cur_step_ind <- 1
    } else{
      cur_step_ind <- optimizerEnv$cur_step_ind
    }
    num_update <- optimizerEnv$num_update
    lr         <- optimizerEnv$lr
    count      <- optimizerEnv$count
    if(cur_step_ind < length(step)){
      if(num_update > step[cur_step_ind]){
        count <- step[cur_step_ind]
        cur_step_ind <- cur_step_ind + 1
        lr <-  lr * factor_val
        if(lr < stop_factor_lr){
          lr <- stop_factor_lr
          if(verbose) cat(paste0("Update[", num_update, 
                                 "]: now learning rate arrived at ", lr, 
                                 "will not change in the future\n"))
        } else{
          if(verbose) cat(paste0("Update[", num_update, 
                                 "]: learning rate is changed to ", lr, "\n"))
          
        }
        optimizerEnv$lr           <- lr
        optimizerEnv$count        <- count  
        optimizerEnv$cur_step_ind <- cur_step_ind
      }
    }
  }
}

# learning rate scheduler
if (args$lr_factor < 1){
  epoch_size <- as.integer(max(args$num_examples/args$batch_size), 1)
  if(!is.null(args$lr_multifactor)){
    step <- as.integer(strsplit(args$lr_multifactor,",")[[1]])
    step.updated <- step - begin.round + 1
    step.updated <- step.updated[step.updated > 0]
    step_batch <- epoch_size*step.updated 
    lr_scheduler <- MultiFactorScheduler(step=step_batch, factor_val=args$lr_factor)
  } else{
    lr_scheduler <- mxnet:::FactorScheduler(
      step = as.integer(max(epoch_size * args$lr_factor_epoch, 1)),
      factor_val = args$lr_factor)
  }
} else{
  lr_scheduler = NULL
}

# define top-5 accuracy
is.num.in.vect <- function(vect, num){
  resp <- any(is.element(vect, num))
  return(resp)
}
mx.metric.top_k_accuracy <- mx.metric.custom("top_k_accuracy", function(label, pred, top_k = 5) {
  if(top_k == 1){
    return(mx.metric.accuracy(label,pred))
  } else{
    ypred <- apply(pred,2,function(x) order(x, decreasing=TRUE)[1:top_k])
    ans <- apply(ypred, 2, is.num.in.vect, num = as.array(label + 1))
    acc <- sum(ans)/length(label)  
    return(acc)
}
})

# train
model <- mx.model.FeedForward.create(
  X                  = train,
  eval.data          = val,
  ctx                = devs,
  symbol             = network,
  begin.round        = begin.round,
  eval.metric        = mx.metric.top_k_accuracy,
  num.round          = args$num_round,
  learning.rate      = args$lr,
  momentum           = args$mom,
  wd                 = args$wd,
  kvstore            = args$kv_store,
  array.batch.size   = args$batch_size,
  clip_gradient      = args$clip_gradient,
  lr_scheduler       = lr_scheduler,
  optimizer          = "sgd",
  initializer        = mx.init.Xavier(factor_type="in", magnitude=2),
  arg.params         = arg.params,
  aux.params         = aux.params,
  epoch.end.callback = checkpoint,
  batch.end.callback = mx.callback.log.train.metric(50)
)
cat(paste0("Finishing computation of ", args$network, " at ", Sys.time(), "\n"))


