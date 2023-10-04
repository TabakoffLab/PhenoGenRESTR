# PhenoGenRESTR - R Package to access PhenoGen Data via REST API

## Sections: 

[Functions](#Currently-supported-functions) 

[Example Usage](#Example-Usage) 

[Example Function Calls](#Examples)  

[Rest API](#PhenoGen-REST-API)

We will continue to develop this. Initially this will primarily be a
file with a set of functions. We will work to turn this into a package
and submit it to a repository.

Check for updates frequently we will try to update along with new REST
API functions.


As downloaded this will call the production REST API version
(<https://rest.phenogen.org>).\
Please use this for all analysis. You are welcome to use the development
and test version, by changing the phenogenURL variable to
(<https://rest-test.phenogen.org>), but please only use this for testing
and please be aware the rate of calls allows is more limited.

New functions that haven't been deployed to production will appear in
testing first and will be implemented in development branch first.

## Currently supported functions

### Datasets

#### getDatasets()

getDatasets(genomeVer,organism,panel,type,tissue,help) - returns a
dataframe containing a list of datasets available. If you specify any
parameters it will filter the list based on the parameters. (type must
be either "totalRNA" or "smallRNA")

#### getDatasetResults()

getDatasetResults(datasetID,help) - returns a list of results for the
dataset.\
Results reflect different types of data, transcriptome reconstruction,
RSEM results on a specific version of the transcriptome. From the
results you can request a list of files( getDatasetResultFiles() ).

#### getDatasetResultFiles()

getDatasetResultFiles(datasetID,resultID,help) - returns a list of files
for the dataset/result specified. The results include the URL to
download the file and can be given to getDatasetResultFile() to load the
file into R.

#### getDatasetResultFile()

getDatasetResultFile(URL) - tries to read a table from the given file
and return the dataframe. It does support gzipped files and unzipped
files. Currently it assumes tab delimited for anything other than .csv.
It will change the delimiter if the file ends in .csv.

#### getDatasetSamples()

getDatasetSamples(datasetID,help) - creates a table of sample details
from the metadata of the dataset.

#### getDatasetPipelineDetails()

getDatasetPipelineDetails(datasetID,help) - creates a table of pipelines
used to process the data in the results. Each pipeline has steps
associated with it that can be viewed that can include the programs used
with versions, URL for the program, and even the command line used if
provided.

#### getDatasetProtocolDetails()

getDatasetProtocolDetails(datasetID,help) - creates a table of protocols
used in the library preparation. Beyond title and description details
are provided as a download. When available the URL will be provided to
download the protocol used. Further detail not yet provided can include
notes on individual samples.

### Markers

#### getMarkerSets()

getMarkerSets(genomeVer="",organism="") - returns a dataFrame of MarkerSets 
available.If a genomeVer or organism is specified then it will return matching 
datasets.

#### getMarkerFiles()

getMarkerFiles(markerSetID, help)-   returns a dataFram with a list of marker 
set files available.

#### getMarkerFile()

getMarkerFile(URL,help) - returns a dataFrame with the marker set file
contents.

## Example Usage

### Load a Phenogen Data Set

#### 1. Get a list of Datasets Available on PhenoGen
```
phenoGenDatasets=getDatasets()
View(phenoGenDatasets)
```
| datasetID|organism |panel         |description                               |created             |tissue      |SeqType                    |GenomeVer |
|---------:|:--------|:-------------|:-----------------------------------------|:-------------------|:-----------|:--------------------------|:---------|
|         3|Mm       |ILS/ISS       |Whole Brain from ILS/ISS Parental Strains |2017-10-26 00:00:00 |Whole Brain |smallRNA                   |mm10      |
|         4|Mm       |ILS/ISS Panel |Whole Brain from ILS/ISS RI Panel         |2017-10-30 00:00:00 |Whole Brain |smallRNA                   |mm10      |
|         5|Rn       |HRDP          |HRDP v5 Whole Brain 45 Strains            |2020-06-20 00:00:00 |Whole Brain |ribosome depleted totalRNA |rn6       |
|         6|Rn       |HRDP          |HRDP v5 Liver 45 Strains                  |2020-06-20 00:00:00 |Liver       |ribosome depleted totalRNA |rn6       |
|         7|Rn       |HRDP          |HRDP v5 Kidney 28 Strains                 |2020-06-20 00:00:00 |Kidney      |ribosome depleted totalRNA |rn6       |
|         8|Rn       |HRDP          |HRDP v5 Heart BNLx/SHR                    |2021-08-07 00:00:00 |Heart       |ribosome depleted totalRNA |rn6       |

#### 2. Find the datasetID of the dataset to use: datasetID = 5 - for HRDPv5 Whole Brain

#### 3. Get a list of results for the selected dataset.
```
phenoGenDataset=getDatasetResults(datasetID=5)
View(phenoGenDataset)
```
| resultID|type                                 |genomeVersion |hrdpVersion |dateCreated         |
|--------:|:------------------------------------|:-------------|:-----------|:-------------------|
|        2|Quantification-RSEM - Ensembl        |rn6           |5           |2020-06-20 00:00:00 |
|        3|Transcriptome Reconstruction         |rn6           |5           |2020-06-20 00:00:00 |
|        4|Quantification-RSEM - Reconstruction |rn6           |5           |2020-06-20 00:00:00 |


#### 4. Find the resultID of the results that you would like to load typical options are typically Ensembl, RefSeq, or Reconstructed Transcriptomes:  - resultID = 4 for Expression values of the reconstructed transcriptome. 


#### 5. 
```
phenoGenDatasetResults=getDatasetResultFiles(datasetID=5,resultID=4)
View(phenoGenDatasetResults)
```

| fileID|uploadDate          |fileName                                                                     |URL                                                                                                                     |checksum                         |genomeVersion |description |annotation     |level      |strainMeans |
|------:|:-------------------|:----------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------|:--------------------------------|:-------------|:-----------|:--------------|:----------|:-----------|
|      6|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.strainMeans.txt.gz       |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.strainMeans.txt.gz       |14201681cbd5996dca0ad0c44562ea12 |rn6           |NA          |Reconstruction |Gene       |TRUE        |
|      7|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Brain.transcript.reconstruction.strainMeans.txt.gz |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.transcript.reconstruction.strainMeans.txt.gz |b463a647ae9150eade8a1459a72fafc2 |rn6           |NA          |Reconstruction |Transcript |TRUE        |
|     10|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.txt.gz                   |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.txt.gz                   |142ecc3eb16b1d8adae60d6709948ba0 |rn6           |NA          |Reconstruction |Gene       |FALSE       |
|     11|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Brain.transcript.reconstruction.txt.gz             |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.transcript.reconstruction.txt.gz             |c238dcb839fdae5acb384eef9c430592 |rn6           |NA          |Reconstruction |Transcript |FALSE       |


#### 6. Copy the URL of the file you would like to load. Options usually include gene level or transcript level quantification and individual samples or strain means. - https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.txt.gz for Gene Level individual samples on the reconstructed transcriptome.

#### 7. Get the file and load the complete file as a dataframe.
```
BrainGeneReconstruction=getDatasetResultFile(URL="https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Brain.gene.reconstruction.txt.gz")
View(BrainGeneReconstruction)
```
|               | Cop.CrCrl_1_batch9| SS_2_batch8| SR_2_batch8| SR_1_batch8| SHRSP_3_batch8| LEW.Crl_3_batch8| F344.NCl_3_batch8| DA_3_batch8| Cop.CrCrl_3_batch8| ACI.SegHsd_3_batch8| HXB31_2_batch7| HXB29_2_batch7| BXH9_3_batch7| BXH8_4_batch7| BXH6_3_batch7| BXH5_2_batch7| BXH3_3_batch7| BXH2_2_batch7| BXH11_3_batch7| BXH10_3_batch7| SHR_3_batch6| HXB27_3_batch6| HXB25_3_batch6| HXB24_3_batch6| HXB24_2_batch6| HXB23_3_batch6| HXB23_2_batch6| HXB22_3_batch6| HXB22_2_batch6| HXB21_3_batch6| HXB21_2_batch6| HXB20_3_batch6| HXB20_2_batch6| HXB2_3_batch6| HXB18_3_batch6| HXB18_2_batch6| HXB17_3_batch6| HXB1_2_batch6| BXH13_3_batch6| BXH13_2_batch6| BXH12_3_batch6| HXB7_3_batch5| HXB5_3_batch5| HXB5_2_batch5| HXB4_3_batch5| HXB4_2_batch5| HXB3_3_batch5| HXB3_2_batch5| HXB15_3_batch5| HXB15_2_batch5| HXB13_3_batch5| HXB10_3_batch5| HXB10_2_batch5| HXB1_3_batch5| BXH9_2_batch3| BXH9_1_batch3| BXH8_1_batch3| BXH6_2_batch3| BXH6_1_batch3| BXH5_1_batch3| BXH3_2_batch3| BXH3_1_batch3| BXH13_1_batch3| BXH11_2_batch3| BXH11_1_batch3| BXH10_2_batch3| BXH10_1_batch3| BNLx_2_batch3| BNLx_1_batch3| HXB5_1_batch2| HXB4_1_batch2| HXB31_1_batch2| HXB3_1_batch2| HXB29_1_batch2| HXB24_1_batch2| HXB23_1_batch2| HXB22_1_batch2| HXB21_1_batch2| HXB20_1_batch2| HXB18_1_batch2| HXB15_1_batch2| HXB10_1_batch2| HXB1_1_batch2| BXH2_1_batch2| WKY_3_batch11| SS_3_batch11| SR_3_batch11| LEW.SsNHsd_3_batch11| LEW.SsNHsd_2_batch11| LEW.SsNHsd_1_batch11| F344.NHsd_3_batch11| F344.NHsd_2_batch11| F344.NHsd_1_batch11| SHR_2_batch1| HXB7_2_batch1| HXB7_1_batch1| HXB27_2_batch1| HXB27_1_batch1| HXB25_2_batch1| HXB25_1_batch1| HXB2_2_batch1| HXB2_1_batch1| HXB17_2_batch1| HXB17_1_batch1| HXB13_2_batch1| HXB13_1_batch1| BXH12_2_batch1| BXH12_1_batch1| SHRSP_1_batch10| LEW.Crl_1_batch10| F344.NCl_1_batch10| WKY_2_batch10| WKY_1_batch10| SS_1_batch11| SHRSP_2_batch10| LEW.Crl_2_batch10| F344.NCl_2_batch10| DA_2_batch10| DA_1_batch10| Cop.CrCrl_2_batch10| ACI.SegHsd_2_batch10| ACI.SegHsd_1_batch11| HXB31_3_batch10| HXB29_3_batch10| BXH8_3_batch10| BXH5_3_batch10| BXH2_3_batch10| LE.Stm_2_batch14| BNLx_3_batch4| LE.Stm_3_batch13| F344.Stm_3_batch13| F344.Stm_2_batch13| F344.Stm_1_batch13| SHR_1_batch6| LE.Stm_1_batch14|
|:--------------|------------------:|-----------:|-----------:|-----------:|--------------:|----------------:|-----------------:|-----------:|------------------:|-------------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|--------------:|--------------:|------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|--------------:|--------------:|--------------:|-------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|--------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|------------:|------------:|--------------------:|--------------------:|--------------------:|-------------------:|-------------------:|-------------------:|------------:|-------------:|-------------:|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|---------------:|-----------------:|------------------:|-------------:|-------------:|------------:|---------------:|-----------------:|------------------:|------------:|------------:|-------------------:|--------------------:|--------------------:|---------------:|---------------:|--------------:|--------------:|--------------:|----------------:|-------------:|----------------:|------------------:|------------------:|------------------:|------------:|----------------:|
|PRN6.5G0000001 |          0.9015041|    1.553993|    2.381352|    3.366840|       1.621525|         2.402869|          2.389743|    2.055506|           2.789524|            2.293886|       2.035591|       2.222622|      1.264247|     2.5615389|     2.1922113|      1.562573|      1.199578|      2.451458|       2.382375|      1.8580741|     2.288696|      2.6892576|      0.8037906|       2.713053|      2.1153541|       2.311140|      1.9314869|       2.704566|       2.697639|       1.937302|      1.4867697|       1.699251|       1.967207|      1.962481|       2.510098|       2.722358|       1.925923|     1.2435934|      1.7463353|       1.572330|       2.190645|     1.8098031|      2.573240|     1.6961145|      1.287931|      1.617457|      2.662602|      2.123104|      0.7756686|       2.864624|       1.205841|       1.243438|      2.1043013|     1.7271936|      1.825702|     1.9956577|     2.7604304|     2.0195789|     3.2621524|      1.257348|      1.296388|      1.311475|       1.612577|      3.0601113|      2.4119596|       1.587462|       1.887902|     1.9853786|      2.567103|     2.4493267|      1.545996|      2.1581425|     2.2556750|       2.517924|       2.284219|       2.237009|       2.778412|       2.213422|       3.783119|       3.054111|      2.5732229|       2.811710|      2.276169|      1.870567|     1.8336147|     1.824086|     1.737258|            2.3545748|             1.289635|             2.854276|            2.023936|            1.290977|            2.285456|     2.475756|      2.751226|      2.146168|      2.5544311|       3.145615|       1.592265|       1.829779|      2.180615|      1.325851|      0.8801269|      2.3431665|       2.338004|      1.7629701|      2.5046370|       1.771640|        2.864588|          1.955266|          2.3402916|      2.679990|     0.8390833|    0.8620538|        1.590967|          2.607304|           2.762839|    2.0859088|     2.420274|           1.7054236|             1.313353|             1.290057|        1.958429|        1.963241|       2.799207|      2.3981490|       2.524465|         2.158394|     2.5467742|         2.405483|          1.8499461|           2.747930|           1.548196|     1.580560|         3.184267|
|PRN6.5G0000002 |          4.5954611|    4.590913|    4.485530|    5.185467|       4.700294|         4.214312|          4.768959|    4.657243|           4.484925|            4.088292|       4.466700|       3.933180|      4.375247|     4.4466475|     3.3842843|      4.088553|      4.207381|      4.567559|       4.486802|      4.3703531|     4.265717|      4.4979834|      4.3902643|       4.189746|      4.2037329|       4.353852|      4.0866334|       3.740454|       4.128175|       4.040205|      4.2308143|       4.362144|       3.762126|      4.277346|       1.840842|       3.573212|       3.779802|     4.2888660|      3.8082694|       3.501589|       3.665834|     4.3012751|      3.743925|     4.5077671|      4.320372|      4.048116|      3.734434|      4.512831|      3.8069787|       3.445512|       4.591534|       3.260750|      4.5147919|     4.4810237|      4.506001|     4.7509303|     4.0866707|     4.4005033|     4.0101932|      4.314301|      4.611081|      4.363652|       4.040692|      3.8958356|      4.6485940|       4.524782|       4.254037|     3.7097367|      4.453297|     3.8601061|      3.801102|      4.4805192|     4.2243535|       4.528530|       4.076425|       4.771581|       3.737663|       4.278753|       1.964008|       3.367746|      4.0541765|       4.719703|      4.130910|      4.110790|     4.5990622|     4.416181|     3.925109|            4.3133456|             4.468875|             4.050852|            4.535176|            4.679993|            4.936068|     4.767698|      4.413069|      4.504664|      4.4381515|       3.984339|       4.398393|       4.553390|      4.130160|      4.440855|      4.3505861|      3.5781595|       5.450794|      4.2818771|      4.1727120|       4.340343|        4.659712|          3.325563|          4.4344559|      3.751688|     4.0235290|    2.8982150|        4.297711|          4.173370|           4.437450|    4.3443649|     4.179917|           4.4770655|             4.139544|             3.817244|        3.750947|        3.681832|       4.519668|      3.4900481|       4.432348|         4.258772|     3.9009047|         4.217468|          4.7358738|           4.496875|           4.230501|     4.379841|         4.145373|
|PRN6.5G0000003 |          1.4271851|    1.579125|    1.617124|    2.094803|       1.391773|         1.634894|          1.043924|    1.366452|           1.060712|            2.708008|       2.147084|       2.721420|      1.029104|     1.6520845|     2.5947245|      1.588224|      2.051738|      1.770452|       1.617969|      0.6152209|     1.409059|      1.3190398|      1.7295608|       2.398055|      0.5570825|       0.995394|      0.5515705|       1.966052|       1.783593|       1.719163|      0.5499458|       2.357587|       1.543104|      2.323452|       1.515368|       1.273791|       1.708155|     1.0099135|      0.5593437|       1.807811|       2.125097|     2.4937162|      2.629711|     0.5341352|      2.181431|      1.387901|      2.447314|      1.732042|      1.6790040|       1.307649|       1.735882|       1.009769|      2.3591144|     0.5497403|      1.348221|     1.9516416|     2.0799091|     1.7988076|     0.6083105|      1.595660|      1.856924|      2.058692|       1.383256|      1.3800773|      1.0576368|       1.825094|       1.401889|     1.5594447|      2.051381|     1.3123192|      1.777746|      0.5761805|     1.6417638|       2.298888|       1.075442|       2.016431|       1.380298|       1.351208|       2.221713|       2.247345|      1.5646468|       1.663550|      1.873219|      2.333388|     0.6030221|     1.810047|     1.517164|            0.5953389|             1.635799|             2.096441|            2.392712|            1.379828|            1.881795|     1.695129|      1.540888|      2.080052|      1.3878175|       1.917657|       2.009587|       1.994150|      1.009052|      1.418752|      1.0663993|      2.1246021|       0.588233|      0.5676835|      2.1492623|       1.755749|        1.921475|          1.460038|          2.1217973|      2.041854|     1.3328068|    2.3068599|        1.362693|          0.643840|           2.115537|    2.4625374|     1.538913|           0.6701127|             2.218834|             0.616753|        2.198903|        1.539539|       0.957446|      0.5569069|       2.054794|         1.764562|     0.9840184|         1.849229|          2.0161829|           3.123833|           2.366216|     1.031403|         1.669373|



### Load a Phenogen Marker Set


## Examples

```phenoGenDatasets=getDatasets()```

| datasetID|organism |panel         |description                               |created             |tissue      |SeqType                    |GenomeVer |
|---------:|:--------|:-------------|:-----------------------------------------|:-------------------|:-----------|:--------------------------|:---------|
|         3|Mm       |ILS/ISS       |Whole Brain from ILS/ISS Parental Strains |2017-10-26 00:00:00 |Whole Brain |smallRNA                   |mm10      |
|         4|Mm       |ILS/ISS Panel |Whole Brain from ILS/ISS RI Panel         |2017-10-30 00:00:00 |Whole Brain |smallRNA                   |mm10      |
|         5|Rn       |HRDP          |HRDP v5 Whole Brain 45 Strains            |2020-06-20 00:00:00 |Whole Brain |ribosome depleted totalRNA |rn6       |
|         6|Rn       |HRDP          |HRDP v5 Liver 45 Strains                  |2020-06-20 00:00:00 |Liver       |ribosome depleted totalRNA |rn6       |
|         7|Rn       |HRDP          |HRDP v5 Kidney 28 Strains                 |2020-06-20 00:00:00 |Kidney      |ribosome depleted totalRNA |rn6       |
|         8|Rn       |HRDP          |HRDP v5 Heart BNLx/SHR                    |2021-08-07 00:00:00 |Heart       |ribosome depleted totalRNA |rn6       |


```phenoGenDataset=getDatasetResults(datasetID=6)```

| resultID|type                                 |genomeVersion |hrdpVersion |dateCreated         |
|--------:|:------------------------------------|:-------------|:-----------|:-------------------|
|        5|Quantification-RSEM - Ensembl        |rn6           |5           |2020-06-20 00:00:00 |
|        6|Transcriptome Reconstruction         |rn6           |5           |2020-06-20 00:00:00 |
|        7|Quantification-RSEM - Reconstruction |rn6           |5           |2020-06-20 00:00:00 |


```phenoGenDatasetFiles=getDatasetResultFiles(datasetID=6,resultID=7)```

| fileID|uploadDate          |fileName                                                                     |URL                                                                                                                     |checksum                         |genomeVersion |description |annotation     |level      |strainMeans |
|------:|:-------------------|:----------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------|:--------------------------------|:-------------|:-----------|:--------------|:----------|:-----------|
|     15|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Liver.gene.reconstruction.strainMeans.txt.gz       |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Liver.gene.reconstruction.strainMeans.txt.gz       |339492503250921c1e12f062fd538598 |rn6           |NA          |Reconstruction |Gene       |TRUE        |
|     16|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Liver.transcript.reconstruction.strainMeans.txt.gz |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Liver.transcript.reconstruction.strainMeans.txt.gz |8f2fa86774aed5602432ba20a898f116 |rn6           |NA          |Reconstruction |Transcript |TRUE        |
|     19|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Liver.gene.reconstruction.txt.gz                   |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Liver.gene.reconstruction.txt.gz                   |e7f4a4ef7d3aa94db0323abcbf7bd1f1 |rn6           |NA          |Reconstruction |Gene       |FALSE       |
|     20|2020-06-20 00:00:00 |PhenoGen.HRDP.v5.totalRNA.Liver.transcript.reconstruction.txt.gz             |https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Liver.transcript.reconstruction.txt.gz             |fad306dc42914bd071556b65f45f8eae |rn6           |NA          |Reconstruction |Transcript |FALSE       |


```phenoGenData=getDatasetResultFile(URL="https://phenogen.org/downloads/RNASeq/RSEM/PhenoGen.HRDP.v5.totalRNA.Liver.gene.reconstruction.strainMeans.txt.gz")```

|               | ACI.SegHsd|     BNLx|    BXH10|    BXH11|    BXH12|    BXH13|     BXH2|     BXH3|     BXH5|     BXH6|     BXH8|     BXH9| Cop.CrCrl|       DA| F344.NCl| F344.NHsd| F344.Stm|     HXB1|    HXB10|    HXB13|    HXB15|    HXB17|    HXB18|     HXB2|    HXB20|    HXB21|    HXB22|    HXB23|    HXB24|    HXB25|    HXB27|    HXB29|     HXB3|    HXB31|     HXB4|     HXB5|     HXB7|   LE.Stm|  LEW.Crl| LEW.SsNHsd|      SHR|    SHRSP|       SR|       SS|      WKY|
|:--------------|----------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|---------:|--------:|--------:|---------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|----------:|--------:|--------:|--------:|--------:|--------:|
|PRN6.5G0000002 |   2.471885| 2.843376| 2.988058| 2.008068| 2.803343| 3.226419| 2.690378| 2.929471| 2.899790| 2.443884| 2.979799| 3.013484|  3.344496| 3.232358| 3.859046|  3.642551| 3.162583| 2.990749| 3.571474| 3.218356| 2.849306| 3.283459| 3.291732| 2.895224| 2.301590| 2.735003| 3.224193| 3.818431| 2.636773| 2.314870| 3.309808| 2.427989| 2.829324| 4.047287| 3.250463| 2.388294| 2.550821| 2.800644| 2.594503|   2.753139| 2.611620| 3.154226| 3.356459| 2.359043| 2.032995|
|PRN6.5G0000018 |   7.972751| 7.988188| 8.327635| 7.483179| 8.308570| 8.493277| 7.656435| 8.034155| 7.419229| 7.744099| 7.772140| 7.879737|  8.892710| 8.674106| 8.926560|  8.524224| 9.830253| 7.921848| 7.782879| 8.230908| 7.810042| 7.817220| 7.938246| 7.742655| 7.662234| 7.349877| 7.665480| 8.443167| 7.403185| 7.390368| 8.295641| 7.716124| 7.821002| 8.286780| 7.841284| 8.102923| 7.772143| 8.351444| 8.188147|   8.261466| 7.580521| 8.472662| 8.664102| 9.273093| 7.726402|
|PRN6.5G0000023 |   3.635240| 3.919247| 4.123028| 3.633602| 4.865721| 4.749075| 4.191927| 3.862219| 3.688691| 4.015154| 3.978780| 4.069461|  4.312069| 4.604477| 4.507873|  3.462370| 4.377501| 4.080252| 4.425630| 4.695526| 4.251516| 4.135177| 4.516254| 3.947551| 4.046057| 3.536359| 4.247595| 4.381584| 3.699361| 3.071000| 4.919601| 4.383471| 4.343141| 4.698016| 4.225777| 4.241549| 4.812240| 4.069986| 4.749160|   3.400256| 3.408126| 3.401887| 3.625541| 5.008848| 3.008453|
...


```phenoGenMarkerSets=getMarkerSets()```

| download_group_id|display_name    |organism |genome_version |panel   |description                                                                                                           |type   |
|-----------------:|:---------------|:--------|:--------------|:-------|:---------------------------------------------------------------------------------------------------------------------|:------|
|                 1|HRDPv6 Markers  |Rat      |rn7.2          |HRDP    |HRDP v6 markers from strain sequencing variant calls                                                                  |Marker |
|                 2|HRDPv4 Markers  |Rat      |rn6            |HRDP    |STAR Consortium Genotype Arrays  ( http://oct2012.archive.ensembl.org/Rattus_norvegicus/Info/Content?file=star.html ) |Marker |
|                 3|HXB/BXH Markers |Rat      |rn5            |HXB/BXH |STAR Consortium Genotype Arrays  ( http://oct2012.archive.ensembl.org/Rattus_norvegicus/Info/Content?file=star.html ) |Marker |
|                 4|BXD Markers     |Mouse    |mm9            |BXD     |Wellcome-CTC Mouse Strain SNP Genotype Set                                                                            |Marker |
|                 5|LXS Markers     |Mouse    |mm10           |LXS     |Affymetrix Mouse Diversity SNP Array                                                                                  |Marker |

```phenoGenMarkerFiles=getMarkerFiles(markerSetID=1)```

| download_file_id| marker_set_id|description             |filename                                |checksum                         |URL                                                                                                             |
|----------------:|-------------:|:-----------------------|:---------------------------------------|:--------------------------------|:---------------------------------------------------------------------------------------------------------------|
|                1|             1|HRDPv6 Marker Genotypes |HRDP.v6.rn7.genotypes.2023-01-17.txt.gz |110da4cb07901b7e8fcec0778d89a141 |https://phenogen.org/web/sysbio/downloadLink.jsp?url=/downloads/Markers/HRDP.v6.rn7.genotypes.2023-01-17.txt.gz |
|                2|             1|HRDPv6 Marker Positions |HRDP.v6.rn7.positions.2023-01-17.txt.gz |22e76bcdb6a8b4aa6cf75ea73f969bd1 |https://phenogen.org/web/sysbio/downloadLink.jsp?url=/downloads/Markers/HRDP.v6.rn7.positions.2023-01-17.txt.gz |

```phenogenMarkerData=getMarkerFile(URL="https://phenogen.org/web/sysbio/downloadLink.jsp?url=/downloads/Markers/HRDP.v6.rn7.genotypes.2023-01-17.txt.gz")```

|           | BN.Lx_Cub_mRatNor1| BXH10_mRatNor1| BXH11_mRatNor1| BXH12_mRatNor1| BXH13_mRatNor1| BXH2_mRatNor1| BXH3_mRatNor1| BXH5_mRatNor1| BXH6_mRatNor1| BXH8_mRatNor1| BXH9_mRatNor1| HXB1_mRatNor1| HXB10_mRatNor1| HXB13_mRatNor1| HXB15_mRatNor1| HXB17_mRatNor1| HXB18_mRatNor1| HXB2_mRatNor1| HXB20_mRatNor1| HXB21_mRatNor1| HXB22_mRatNor1| HXB23_mRatNor1| HXB24_mRatNor1| HXB25_mRatNor1| HXB27_mRatNor1| HXB29_mRatNor1| HXB3_mRatNor1| HXB31_mRatNor1| HXB4_mRatNor1| HXB5_mRatNor1| HXB7_mRatNor1| SHR_OlaIpcv_mRatNor1| ACI_EurMcwi_2019NOV| BN_NHsdMcwi_2019| BUF_N_2020| DA_OlaHsd_2019NOV| F344_NCrl_2019NOV| F344_NHsd_2021| F344_Stm_2019| FHH_EurMcwi_2019NOV| FXLE12_Stm_2019NOV| FXLE13_Stm_2019NOV| FXLE14_Stm_2019NOV| FXLE15_Stm_2019NOV| FXLE16_Stm_2019| FXLE17_Stm_2019NOV| FXLE18_Stm_2019| FXLE20_Stm_2019NOV| GK_FarMcwi_2019NOV| LE_Stm_2019| LEW_Crl_2019| LXF10A_StmMcwi_2020| LEXF11_Stm_2020| LEXF1A_Stm_2019| LEXF1C_Stm_2019| LEXF2B_Stm_2019| LEXF3_Stm_2020| LEXF4_Stm_2020| LEXF5_Stm_2019NOV| LEXF6B_Stm_2019NOV| LEXF6B_Stm_2021_A| LEXF6B_Stm_2021_BH| LEXF6B_Stm_2021_FH| LEXF7A_Stm_2019NOV| LEXF8A_Stm_2021| LH_MavRrrcAek_2020| LL_MavRrrcAek_2020| LN_MavRrrcAek_2020| M520_N_2020| MR_N_2020| MWF_Hsd_2019NOV| PVG_Seac_2019| RCS_LavRrrc_2021| SHR_NCrl_2021| SHRSP_A3NCrl_2019NOV| SR_JrHsd_2020| SS_JrHsd_2021| WAG_RijCrl_2020| WKY_N_2020| WKY_NCrl_2019| WN_N_2020|
|:----------|------------------:|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|--------------:|-------------:|--------------:|-------------:|-------------:|-------------:|--------------------:|-------------------:|----------------:|----------:|-----------------:|-----------------:|--------------:|-------------:|-------------------:|------------------:|------------------:|------------------:|------------------:|---------------:|------------------:|---------------:|------------------:|------------------:|-----------:|------------:|-------------------:|---------------:|---------------:|---------------:|---------------:|--------------:|--------------:|-----------------:|------------------:|-----------------:|------------------:|------------------:|------------------:|---------------:|------------------:|------------------:|------------------:|-----------:|---------:|---------------:|-------------:|----------------:|-------------:|--------------------:|-------------:|-------------:|---------------:|----------:|-------------:|---------:|
|chr1_16211 |                  0|              0|              0|              0|              0|             0|             0|             0|             0|             0|             0|             0|              0|              0|              0|              0|              0|             0|              0|              0|              0|              0|              0|              0|              0|              0|             0|              0|             0|             0|             0|                    0|                   0|                0|          0|                 0|                 0|              0|             0|                   0|                  2|                  2|                  2|                  0|               2|                  0|               2|                  2|                  0|           2|            0|                   2|               0|               0|               0|               2|              0|              0|                 2|                  0|                 0|                  0|                  0|                  2|               0|                  0|                  0|                  0|           0|         0|               0|             0|                0|             0|                    0|             0|             0|               0|          0|             0|         0|
|chr1_17226 |                  0|              0|              0|              0|              0|             0|             0|             0|             0|             0|             0|             0|              0|              0|              0|              0|              0|             0|              0|              0|              0|              0|              0|              0|              0|              0|             0|              0|             0|             0|             0|                    0|                   0|                0|          0|                 0|                 0|              0|             0|                   0|                  2|                  2|                  2|                  0|               2|                  0|               2|                  2|                  0|           2|            0|                   2|               0|               0|               0|               2|              0|              0|                 2|                  0|                 0|                  0|                  0|                  2|               0|                  0|                  0|                  0|           0|         0|               0|             0|                0|             0|                    0|             0|             0|               0|          0|             0|         0|
|chr1_17294 |                  0|              0|              0|              0|              0|             0|             0|             0|             0|             0|             0|             0|              0|              0|              0|              0|              0|             0|              0|              0|              0|              0|              0|              0|              0|              0|             0|              0|             0|             0|             0|                    0|                   0|                0|          0|                 0|                 0|              0|             0|                   0|                  2|                  2|                  2|                  0|               2|                  0|               2|                  2|                  0|           2|            0|                   2|               0|               0|               0|               2|              0|              0|                 2|                  0|                 0|                  0|                  0|                  2|               0|                  0|                  0|                  0|           0|         0|               0|             0|                0|             0|                    0|             0|             0|               0|          0|             0|         0|

## PhenoGen REST API

<https://github.com/TabakoffLab/PhenoGenRESTAPI>

## API Documentation

<https://rest-doc.phenogen.org> - Documentation of current functions.  Please 
note some may be under development.  Future updates will seperate development 
and production documentation.

All functions should include help as a response if you call the function
with this appended to the end `?help=Y`. The response returns a JSON
object with supported methods and then list of parameters and
description of each parameter as well as a list of options if there is a
defined list of values.
