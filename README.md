# PhenoGenRESTR
R Package to access PhenoGen Data via REST API

We will continue to develop this.  Initially this will primarily be a file with
a set of functions. We will work to turn this into a package and submit it to 
a repository.

Check for updates frequently we will try to update along with new REST API 
functions.

As downloaded this will call the production REST API version (https://rest.phenogen.org).  
Please use this for all analysis.  You are welcome to use the development and test 
version, by changing the phenogenURL variable to (https://rest-test.phenogen.org), but 
please only use this for testing and please be aware the rate of calls allows is more limited.

New functions that haven't been deployed to production will appear in testing first and will 
be implemented in development branch first.

## Currently supported functions:

### getDatasets()
getDatasets(genomeVer,organism,panel,type,tissue,help) - returns a 
dataframe containing a list of datasets available.  If you specify any parameters
it will filter the list based on the parameters. (type must be either "totalRNA"
or "smallRNA")

### getDatasetResults()
getDatasetResults(datasetID,help) - returns a list of results for the dataset.  
Results reflect different types of data, transcriptome reconstruction, RSEM 
results on a specific version of the transcriptome.  From the results you can 
request a list of files( getDatasetResultFiles() ).

### getDatasetResultFiles()
getDatasetResultFiles(datasetID,resultID,help) - returns a list of files for the 
dataset/result specified.  The results include the URL to download the file and
can be given to getDatasetResultFile() to load the file into R.

### getDatasetResultFile()
getDatasetResultFile(URL) - tries to read a table from the given file and return
the dataframe.  It does support gzipped files and unzipped files.  Currently it
assumes tab delimited for anything other than .csv.  It will change the delimiter
if the file ends in .csv.

### getDatasetSamples()
getDatasetSamples(datasetID,help) - creates a table of sample details from the metadata of the dataset.

### getDatasetPipelineDetails()
getDatasetPipelineDetails(datasetID,help) - creates a table of pipelines used to process the data in the results.
Each pipeline has steps associated with it that can be viewed that can include the programs used with versions,
URL for the program, and even the command line used if provided.

### getDatasetProtocolDetails()
getDatasetProtocolDetails(datasetID,help) - creates a table of protocols used in the library preparation.
Beyond title and description details are provided as a download.  When available the URL will be provided to download
the protocol used. Further detail not yet provided can include notes on individual samples.

### getMarkerSets()
gets a list of MarkerSets available.

### getMarkerFiles()
 - returns a list of marker set files available.

### getMarkerFile()
getMarkerFile(URL,help) - returns a table with the marker set file loaded.


## PhenoGen REST API 

https://github.com/TabakoffLab/PhenoGenRESTAPI

## API Documentation

https://rest-doc.phenogen.org - temporarily unavailable (as of 6/17/22), but will be available within a 
few days

All functions should include help as a response if you call the function with this appended to the 
end `?help=Y`.  The response returns a JSON object with supported methods and then list of parameters 
and description of each parameter as well as a list of options if there is a defined list of values.
