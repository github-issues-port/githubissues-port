require 'github_api'
require 'githubissues-port'

describe 'githubissues-port exporting and importing to xlsx' do
  before(:all) do
    # Replace your test git repo credentials here:
    @github_username = '**********'
    @github_password = '**********'
    @owner           = '**********'
    @repo            = '**********'
    @connection = Github.new basic_auth: "#{@github_username}:#{@github_password}"
  end

  it 'export with given fields should be successfull.' do
    lambda { Githubissues::Port::Export.new @connection, @owner, @repo, 'export.xlsx', fields: ['number', 'title', 'body', 'labels'] }.should_not raise_error
  end

  it 'export with default fields should be successfull.' do
    lambda { Githubissues::Port::Export.new @connection, @owner, @repo, 'export_full.xlsx'}.should_not raise_error
  end

  it 'import with given fields should be successfull.' do
    lambda { Githubissues::Port::Import.new @connection, @owner, @repo, 'spec/fixtures/sample.xlsx', fields: ['title', 'labels'] }.should_not raise_error
  end

  it 'import with default fields should be successfull.' do
    lambda { Githubissues::Port::Import.new @connection, @owner, @repo, 'spec/fixtures/sample.xlsx' }.should_not raise_error
  end      
end
