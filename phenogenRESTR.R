library(RCurl)
library(jsonlite)

phenogenURL="https://rest.phenogen.org/"

getDatasets<-function(genomeVer="",organism="",panel="",type="",tissue=""){
  isFirst=TRUE
  url=paste(phenogenURL,"downloads/datasets",sep="")
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
  dataf=fromJSON(fromJSON(ret)$body)$data
  return(dataf)
}

getDatasetResults<-function(datasetID=""){
  isFirst=TRUE
  url=paste(phenogenURL,"downloads/dataset?datasetID=",datasetID,sep="")
  print(url)
  ret=getURL(url)
  #print(ret)
  dataf=fromJSON(fromJSON(ret)$body)$results
  return(dataf)
}

getDatasetResultFiles<-function(datasetID,resultID){
  isFirst=TRUE
  url=paste(phenogenURL,"downloads/datasetFiles?datasetID=",datasetID,"&resultID=",resultID,sep="")
  print(url)
  ret=getURL(url)
  #print(ret)
  tmp=fromJSON(fromJSON(ret)$body)$datasetResult
  dataf=tmp[["resultFiles"]]
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
