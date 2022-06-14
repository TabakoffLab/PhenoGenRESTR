# PhenoGenRESTR
R Package to access PhenoGen Data via REST API

We will continue to develop this.  Initially this will primarily be a file with
a set of functions. We will work to turn this into a package and submit it to 
a repository.

Check for updates frequently we will try to update along with new REST API 
functions.

Currently supported functions:
getDatasets(genomeVer="",organism="",panel="",type="",tissue="") - returns a 
dataframe containing a list of datasets available.  If you specify any parameters
it will filter the list based on the parameters. (type must be either "totalRNA"
or "smallRNA")
