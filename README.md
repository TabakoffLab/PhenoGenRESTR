# PhenoGenRESTR - R Package to access PhenoGen Data via REST API

## Sections: [Functions](#Currently-supported-functions)  [Examples](#Examples)  [Rest API](#PhenoGen-REST-API)

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
