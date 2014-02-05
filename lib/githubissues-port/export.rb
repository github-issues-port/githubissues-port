require 'github_api'
require 'axlsx'

module Githubissues
  module Port   
    class Githubissues::Port::Export
      attr_reader :connection, :owner, :repo, :path
      def initialize connection, owner, repo, path, options = {}
        @path = path
        @connection = connection
        @owner = owner
        @repo = repo
        @default_fields = %w(number title body labels assignee  state milestone created_at closed_at comments comments_url events_url html_url labels_url) 
        @fields = (options.has_key? :fields) ? options[:fields] : @default_fields 
        generate_excel
      end

      def generate_excel
        Axlsx::Package.new do |excel|
          generate_sheet excel, 'open'
          generate_sheet excel, 'closed'
          excel.serialize path
        end
      end

      def generate_sheet excel, state
        excel.workbook.add_worksheet(:name => state) do |sheet|
          sheet.add_row @fields        
          issues = @connection.issues.list user: @owner,
                                           repo: @repo,
                                           filter: 'all',
                                           auto_pagination: true,
                                           state: state
          issues.each{|issue| sheet.add_row generate_row(issue)}
        end      
      end

      def generate_row issue
        @fields.collect do |field|
          case field.downcase
            when 'assignee'
              issue.assignee.login unless issue.assignee.nil?
            when 'labels'
              issue.labels.map(&:name).join(', ') unless issue.labels.nil?
            when 'milestone'
              issue.milestone.map(&:number) unless issue.milestone.nil?
            else
              issue.send field
          end
        end
      end
    end
  end
end