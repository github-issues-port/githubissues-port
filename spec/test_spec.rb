require 'githubissues-port'

describe 'githubissues-port exporting and importing to xlsx' do
  before(:all) do
    my_github_username = '*********'
    my_github_password = '*********'
    @connection = Github.new basic_auth: "#{my_github_username}:#{my_github_password}"
  end

  it 'export should be successfull.' do
    export = Githubissues::Port::Export.new @connection, 'pythonicrubyist', 'test_issues', 'export.xlsx', fields: ['number', 'title', 'body', 'labels']
    puts export.path
    export.should_not be_nil
  end

  it 'import should be successfull.' do
    import = Githubissues::Port::Import.new @connection, 'pythonicrubyist', 'test_issues', 'spec/fixtures/sample.xlsx', fields: ['labels']
    puts import.messages.inspect
    import.should_not be_nil
  end  
end
