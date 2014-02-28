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

  it 'export should be successfull.' do
    export = Githubissues::Port::Export.new @connection, @owner, @repo, 'export.xlsx', fields: ['number', 'title', 'body', 'labels']
    #puts export.inspect
    export.should_not be_nil
  end

  it 'import should be successfull.' do
    #puts import.messages.inspect
    import.should_not be_nil
  end  
end
