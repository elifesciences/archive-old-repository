# Archive old (github) repository

A simple script that mirrors a repository from github and uploads the result to
an AWS S3 bucket.

Assumptions:

* you have your AWS credentials configured
* you have the AWS CLI tools installed globally

## Usage

`$ ./archive-old-repo.sh <reponame>`

## Restore

Download the mirrored repository and run:

    $ cd [mirrored repository]
    $ mkdir .git
    $ mv * .git/
    $ git init
    
And you should get a 're-initialised' type message from git.

## Copyright & Licence

[MIT licenced](LICENCE.txt)
