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
getDatasets(genomeVer,organism,panel,type,tissue) - returns a 
dataframe containing a list of datasets available.  If you specify any parameters
it will filter the list based on the parameters. (type must be either "totalRNA"
or "smallRNA")

### getDatasetResults()
getDatasetResults(datasetID) - returns a list of results for the dataset.  
Results reflect different types of data, transcriptome reconstruction, RSEM 
results on a specific version of the transcriptome.  From the results you can 
request a list of files( getDatasetResultFiles() ).

### getDatasetResultFiles()
getDatasetResultFiles(datasetID,resultID) - returns a list of files for the 
dataset/result specified.  The results include the URL to download the file and
can be given to getDatasetResultFile() to load the file into R.

### getDatasetResultFile()
getDatasetResultFile(URL) - tries to read a table from the given file and return
the dataframe.  It does support gzipped files and unzipped files.  Currently it
assumes tab delimited for anything other than .csv.  It will change the delimiter
if the file ends in .csv.
