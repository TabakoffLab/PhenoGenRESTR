library(RCurl)
library(jsonlite)

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
    attach(tmp)
    if(exists('message') && tmp$message !=""){
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
    attach(tmp)
    if(exists('message') && tmp$message !=""){
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
    attach(tmp)
    if(exists('message') && tmp$message !=""){
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
    attach(tmp)
    if(exists('message') && tmp$message !=""){
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
    attach(tmp)
    if(exists('message') && tmp$message !=""){
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
    attach(tmp1)
    if(exists('message') && tmp1$message !=""){
      print(tmp1$message)
    }else{
      tmp=tmp1$datasetResult
      dataf=tmp[["resultFiles"]]
    }
    
  }
  return(dataf)
}

getDatasetResultFile<-function(URL=""){
  if(endsWith(URL,"gz")){
    con = gzcon(url(URL))
    txt = readLines(con)
    curSep="\t"
    if(endsWith(URL,".csv.gz")){
      curSep=","
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
    txtCon=textConnection(txt)
    dataf = read.table(txtCon,sep = curSep)
    close(txtCon)
  }
  return(dataf)
}
