# PhenoGenRESTR
R Package to access PhenoGen Data via REST API

We will continue to develop this.  Initially this will primarily be a file with
a set of functions. We will work to turn this into a package and submit it to 
a repository.

Check for updates frequently we will try to update along with new REST API 
functions.

Currently supported functions:

getDatasets(genomeVer,organism,panel,type,tissue) - returns a 
dataframe containing a list of datasets available.  If you specify any parameters
it will filter the list based on the parameters. (type must be either "totalRNA"
or "smallRNA")

getDatasetResults(datasetID) - returns a list of results for the dataset.  
Results reflect different types of data, transcriptome reconstruction, RSEM 
results on a specific version of the transcriptome.  From the results you can 
request a list of files( getDatasetResultFiles() ).

getDatasetResultFiles(datasetID,resultID) - returns a list of files for the 
dataset/result specified.  The results include the URL to download the file and
can be given to getDatasetResultFile() to load the file into R.

getDatasetResultFile(URL) - tries to read a table from the given file and return
the dataframe.  It does support gzipped files and unzipped files.  Currently it
assumes tab delimited for anything other than .csv.  It will change the delimiter
if the file ends in .csv.
