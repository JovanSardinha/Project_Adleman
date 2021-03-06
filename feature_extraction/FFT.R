
FFTFunction <- function(fileTyes, progressBlock, FFTWidth){
  dataDir <- paste0("./data/", fileTyes, "/")
  
  
  # read in data
  fileNames <- list.files(dataDir, pattern="*.bytes", full.names=TRUE)
  noTrain <- length(fileNames)
  
#   # variable to break the job into 1000 blocks
#   progressBlock <- 100
#   
#   # variable to set the width of FFT analysis to keep
#   FFTWidth <-100
  
  # create empty matrix to contain results
  myFFT <- matrix(,nrow=noTrain,ncol=2*FFTWidth)
  
  
  # label the matrix using the base part of the filenames
  row.names(myFFT)=substr(fileNames,14,33)
  
  
  for (i in 1:noTrain) {
    print(fileNames[i])
    
    # take FFT of the decimal values of the hex values in the .bytes file with 1st column (labels) removed
    thisFFT=fft(as.numeric(sprintf("%d",unlist(read.table(fileNames[i])[,2:17], use.names=FALSE))))[1:FFTWidth]
    
    # separate out the resulting complex numbers into amplitude and phase parts and store them separately
    myFFT[i,1:FFTWidth]=Mod(thisFFT)
    myFFT[i,(FFTWidth+1):(2*FFTWidth)]=Arg(thisFFT)
    
    # check on progress and dump results so far if it's warranted
    if ((i %% progressBlock) == 0) {
      print(i)
  
    }
  }
  
  FFT <- NULL
  # FFT$fileName <- toString(rownames(myFFT))
  FFT <- data.frame(myFFT)
  FFT$fileName <- (rownames(myFFT))
  
  # Reorganizing the FFT
  col_idx <- grep("fileName", names(FFT))
  FFT <- FFT[, c(col_idx, (1:ncol(FFT))[-col_idx])]
  
  return (FFT)

}










## CODE GRAVEYARD
# write out a copy of the results so we can restart if it crashes
#write.table(myFFT,file="FFTResults.txt",sep='\t',row.names=TRUE)


# FFTResults <- read.table("FFTResults.txt")
# FFTResults$name <- row.names(myFFT)
# 
# meltFFTResults <- melt(FFTResults, id ="name")
# 
# 
# g <- ggplot(meltFFTResults, aes(x=variable, y=value, color = name)) + geom_point() + geom_density()
# print(g)



