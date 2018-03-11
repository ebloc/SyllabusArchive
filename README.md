## WIKI USAGE

- Please create a wiki page for the parts that you work on and try to explain the purpose and implementation

## DEVELOPMENT WORKFLOW

We are working on the development branch, for every feature that you are going to implement please do the following:
- create an issue for the feature and explain it
- pull the development branch: ```git pull origin development``` and create a feature branch from development: ```git checkout -b featureName development``` 
- implement the feature in your feature branch and after everything is done commit your changes, **to avoid merge conflicts do the following:** checkout to the development: ```git checkout development```, pull up-to-date development code: ```git pull origin development``` , checkout to your feature branch: ```git checkout featureName```, merge development to your feature branch with --no-ff flag: ```git merge --no-ff development```, ***if there is any merge conflict solve them manually and commit changes*** and finally push your feature branch to the origin: ```git push origin featureName```
- create a pull request to the development branch in GitHub.
- after the pull request is merged, close the issue of the feature by citing the pull request id (like #12)

## CRAWLER

- crawler folder contains the spiders, to run the course_fetch.py spider:

```cd crawler/course_fetcher/spiders```

You should add the semester as an argument

```scrapy runspider course_fetch.py -a semester='2017-2018-2'```

## FileManager 

- Open up remix.ethereum.org

- Copy and paste the code in fileManager.sol

- Compile and run the program

- At right side console, fill setFile arguments as "fileName","Hash_From_İpfs"

- To get file hash, fill getFileHash argument as "fileName" and it returns the hash of it

- To get file uploader, fill getFileIssuer argument as "fileName" and it returns address of file Issuer
