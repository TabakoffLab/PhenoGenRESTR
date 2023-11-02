#'
#'
#'
#'
#'

library(RCurl)
library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)

phenogenURL="https://rest.phenogen.org/"



getDatasets<-function(genomeVer="",organism="",panel="",type="",tissue="",help=FALSE){
  url=paste(phenogenURL,"downloads/datasets",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE

    if(genomeVer!="" || organism!="" || panel!="" ||type!=""){
      url=paste(url,"?",sep="")
    }
    if(genomeVer!=""){
      url=paste(url,"genomeVer=",genomeVer,sep="")
      isFirst=FALSE
    }
    if(organism!=""){
      if(isFirst){
        isFirst=FALSE
      }else{
        url=paste(url,"&",sep="")
      }
      url=paste(url,"organism=",organism,sep="")
    }
    if(panel!=""){
      if(isFirst){
        isFirst=FALSE
      }else{
        url=paste(url,"&",sep="")
      }
      url=paste(url,"panel=",panel,sep="")
    }
    if(type!=""){
      if(isFirst){
        isFirst=FALSE
      }else{
        url=paste(url,"&",sep="")
      }
      url=paste(url,"type=",type,sep="")
    }
    if(tissue!=""){
      if(isFirst){
        isFirst=FALSE
      }else{
        url=paste(url,"&",sep="")
      }
      url=paste(url,"tissue=",tissue,sep="")
    }
    print(url)
    ret=getURL(url)
    tmp=fromJSON(ret)$body
    #attach(tmp)
    if( ! is.null(attr(tmp,"message")) & tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$data
    }
  }
  return(dataf)
}

getDatasetResults<-function(datasetID="",help=FALSE){
  url=paste(phenogenURL,"downloads/dataset",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?datasetID=",datasetID,sep="")
    print(url)
    ret=getURL(url)
    #print(ret)
    tmp=fromJSON(ret)$body
    #attach(tmp)
    if(!is.null(attr(tmp,"message")) & tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$results
    }
  }
  return(dataf)
}

getDatasetSamples<-function(datasetID="",help=FALSE){
  url=paste(phenogenURL,"downloads/dataset",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?datasetID=",datasetID,sep="")
    print(url)
    ret=getURL(url)
    #print(ret)
    tmp=fromJSON(ret)$body
    if(!is.null(attr(tmp,"message")) & tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$metaData$samples
    }
  }
  return(dataf)
}

getDatasetPipelineDetails<-function(datasetID="",help=FALSE){
  url=paste(phenogenURL,"downloads/dataset",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?datasetID=",datasetID,sep="")
    print(url)
    ret=getURL(url)
    #print(ret)
    tmp=fromJSON(ret)$body
    #attach(tmp)
    if(!is.null(attr(tmp,"message")) & tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$metaData$pipelines
    }
  }
  return(dataf)
}

getDatasetProtocolDetails<-function(datasetID="",help=FALSE){
  url=paste(phenogenURL,"downloads/dataset",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?datasetID=",datasetID,sep="")
    print(url)
    ret=getURL(url)
    #print(ret)
    tmp=fromJSON(ret)$body
    #attach(tmp)
    if(!is.null(attr(tmp,"message")) & tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$metaData$protocols
    }
  }
  return(dataf)
}

getDatasetResultFiles<-function(datasetID,resultID,help=FALSE){
  url=paste(phenogenURL,"downloads/datasetFiles",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?datasetID=",datasetID,"&resultID=",resultID,sep="")
    print(url)
    ret=getURL(url)
    tmp1=fromJSON(ret)$body
    #attach(tmp1)
    if(!is.null(attr(tmp1,"message")) & tmp1$message != ""){
      print(tmp1$message)
    }else{
      tmp=tmp1$datasetResult
      dataf=tmp[["resultFiles"]]
    }

  }
  return(dataf)
}

getDatasetResultFile<-function(URL=""){
  if(grepl(".gtf",URL)){
    return(getDatasetGTF(URL))
  }else if(endsWith(URL,"gz")){
    con = gzcon(url(URL))
    txt = readLines(con)
    curSep="\t"
    if(endsWith(URL,".csv.gz")){
      curSep=","
    }
    if(grepl("v6",URL)){
      curSep=" "
    }
    txtCon=textConnection(txt)
    dataf = read.table(txtCon,sep=curSep)
    close(txtCon)
  }else{
    con = url(URL)
    txt = readLines(con)
    curSep="\t"
    if(endsWith(URL,".csv")){
      curSep=","
    }
    if(grepl("v6",URL)){
      curSep=" "
    }
    txtCon=textConnection(txt)
    dataf = read.table(txtCon,sep = curSep)
    close(txtCon)
  }
  return(dataf)
}

getDatasetGTF<-function(URL="",splitIDColumn=FALSE,select="ALL"){
  if(endsWith(URL,"gz")){
    con = gzcon(url(URL))
    txt = readLines(con)
  }else{
    con = url(URL)
    txt = readLines(con)
  }
  txtCon=textConnection(txt)
  dataf = read.table(txtCon,sep = "\t")
  close(txtCon)
  dataf <- dataf %>%
    rename(
       'Chromosome' = 'V1' ,
      'Source' = 'V2' ,
      'Feature' = 'V3',
      'Coord_Start' = 'V4',
      'Coord_End' = 'V5',
      'Score' = 'V6',
      'Strand' = 'V7'
    )
  dataf <- filterGTF(dataf,splitIDColumn=splitIDColumn,select=select)
  return(dataf)
}



filterGTF <- function(gtfDataFrame,splitIDColumn=FALSE,select="ALL"){
  newDataf <- gtfDataFrame
  if(splitIDColumn){
    #temporary Only deal with first 2 IDs and assume they are in order GENE; Transcript;
    newDataf <- newDataf %>% separate_wider_delim(cols="V9" , delim = ";",names=c("Gene","Transcript"), too_many = "drop")
    newDataf <- newDataf %>% mutate(across('Gene', \(x) str_replace(x,'gene_id ', '')))
    newDataf <- newDataf %>% mutate(across('Transcript', \(x) str_replace(x,'transcript_id ', '')))
    #working on new code to handle any number of IDs and handle being out of order
    #newDataf <- newDataf %>% separate_wider_delim(cols="V9" , delim = ";",names_sep = "_", names_repair = nameFunct)
    #newDataf %>% mutate(across('V9_2', \(x) str_replace(x,'^ | $', '')))
    #colList <- unique(newDataf %>% separate_wider_delim(cols="V9_*" , delim = " ", names="ID,VALUE")$ID)

  }
  if(select!="ALL"){
    if(select=="TRANSCRIPTS"){
      newDataf <- newDataf[grepl("transcript", newDataf$Feature),]
    }else if(select=="EXONS"){
      newDataf <- newDataf[grepl("exon", newDataf$Feature),]
    }else{
      warning("WARNING: select = ALL,TRANSCRIPTS,EXONS is supported.  No Filtering was performed.")
    }
  }
  return(newDataf)
}


nameFunct <- function(name){
  newName=name

  return(newName)
}




getMarkerSets<-function(genomeVer="",organism="",help=FALSE){
  url=paste(phenogenURL,"downloads/markerSets",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    if(genomeVer!="" || organism!=""){
      url=paste(url,"?",sep="")
    }
    if(genomeVer!=""){
      url=paste(url,"genomeVer=",genomeVer,sep="")
      isFirst=FALSE
    }
    if(organism!=""){
      if(isFirst){
        isFirst=FALSE
      }else{
        url=paste(url,"&",sep="")
      }
      url=paste(url,"organism=",organism,sep="")
    }
    print(url)
    ret=getURL(url)
    tmp=fromJSON(ret)$body
    #attach(tmp)
    if(!is.null(attr(tmp,"message")) &tmp$message !=""){
      print(tmp$message)
    }else{
      dataf=tmp$data
    }
  }
  return(dataf)
}

getMarkerFiles<-function(markerSetID,help=FALSE){
  url=paste(phenogenURL,"downloads/markerFiles/",sep="")
  dataf <- NULL
  if(help){
    url=paste(url,"?help=Y",sep="")
    ret=getURL(url)
    dataf=fromJSON(fromJSON(ret)$body)
  }else{
    isFirst=TRUE
    url=paste(url,"?markerSetID=",markerSetID,sep="")
    print(url)
    ret=getURL(url)
    tmp1=fromJSON(ret)$body
    #attach(tmp1)
    if(!is.null(attr(tmp1,"message")) & tmp1$message !=""){
      print(tmp1$message)
    }else{
      tmp=tmp1$data
      dataf=tmp
    }

  }
  return(dataf)
}

getMarkerFile<-function(URL=""){
  if(endsWith(URL,"gz")){
    con = gzcon(url(URL))
    txt = readLines(con)
    curSep="\t"
    txtCon=textConnection(txt)
    dataf = read.table(txtCon,sep=curSep)
    close(txtCon)
  }else{
    con = url(URL)
    txt = readLines(con)
    curSep="\t"
    if(endsWith(URL,".csv")){
      curSep=","
    }
    if(grepl("v6",URL)){
      curSep=" "
    }
    txtCon=textConnection(txt)
    dataf = read.table(txtCon,sep = curSep)
    close(txtCon)
  }
  return(dataf)
}










