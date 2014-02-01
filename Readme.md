# Github Issues Port 
___
Ever Felt the need of Exporting your Github Issues or Importing the issues in Github via a Excel.  `githubissues-port` is your answer. :neckbeard:.

`githubissues-port` can be used from the command line or as part of a Ruby web framework.

***
___
#### Sample Application

[Sample Application with usage can be found here](http://mysterious-springs-2093.herokuapp.com/)
***
### Installation

To install the gem using terminal, run the following command:

    gem install githubissues-port

To use it in rails application add the gem to the Gemfile:

    gem "githubissues-port"    

### Basic Usage

githubissues-port can simply import or export issues from an Excel file.:

    require 'githubissues-port'
    require 'github_api'
    
    your_github_username = '***********'
    your_github_password = '***********'

    owner = '***********'
    repo = '***********'
    
    connection = Github.new(basic_auth: "#{your_github_username}:#{your_github_password}")
    
    # The import mudule will import issues from Excel, creates an issue if the number blank, otherwise, updating an existing issue by looking up the issue number.

    Githubissues::Port::Import.new(connection, owner, repo, 'import.xlsx', fields: ['title', 'labels'])
    
    # The export module will export issues to Excel.

    Githubissues::Port::Export.new(connection, owner, repo, 'export.xlsx', fields: ['number', 'title', 'body', 'labels'])

### Contributing

Contributions are welcomed. You can fork a repository, add your code changes to the forked branch, ensure all existing unit tests pass, create new unit tests cover your new changes and finally create a pull request.

After forking and then cloning the repository locally, install Bundler and then use it
to install the development gem dependecies:

    gem install bundler
    bundle install

githubissues-port this is complete, you should be able to run the test suite:

    rake spec


### Bug Reporting

Please use the {Issues}[https://github.com/githubissues-port/githubissues-port/issues] page to report bugs or suggest new enhancements.


### License

githubissues-port has been published under {MIT License}[https://github.com/githubissues-port/githubissues-port/blob/master/LICENSE.txt]