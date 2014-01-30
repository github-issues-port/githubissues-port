require 'github_api'
require 'creek'

module Githubissues
  module Port   
    class Githubissues::Port::Import
      attr_reader :path, :messages
      def initialize connection, owner, repo, path 
        creek = Creek::Book.new path, :check_file_extension => false
        sheet= creek.sheets[0]
        @messages = []
        sheet.rows.each_with_index do |r, i|
          next if i.eql? 0
          number = r["A#{i+1}"]
          break if number.nil?
          label_string =  r["D#{i+1}"]
          labels = (label_string.nil?) ? [] : label_string.split(',')     
          issue = connection.issues.edit owner, repo, number, labels: labels
          @messages.push "The label for issue ##{number} updated to #{labels.join(',')}."
        end
        @messages
      end
    end
  end
end