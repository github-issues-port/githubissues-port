require 'github_api'
require 'axlsx'

module Githubissues
  module Port   
    class Githubissues::Port::Export
      attr_reader :connection, :owner, :repo, :path 

      DEFAULT_FIELDS = %w(number title body labels assignee  state milestone created_at closed_at comments labels comments_url events_url html_url labels_url type priority module status) 

      def initialize connection, owner, repo, path, options = {}
        @path, @connection, @owner, @repo = path, connection, owner, repo
        @fields = (options.has_key? :fields) ? options[:fields] : DEFAULT_FIELDS
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
          issues = @connection.issues.list user:            @owner,
                                           repo:            @repo,
                                           filter:          'all',
                                           auto_pagination: true,
                                           state:           state
          issues.each{|issue| sheet.add_row generate_row(issue)}
        end      
      end

      def generate_row issue
        labels = (issue.labels.nil?) ? [] : issue.labels.map{|l| l.name.downcase}
    
        @fields.collect do |field|
          case field.downcase
            when 'assignee'
              issue.assignee.login unless issue.assignee.nil?
            when 'labels'
              labels.join ', '
            when 'milestone'
              issue.milestone.title unless issue.milestone.nil?
            when 'created_at'
              DateTime.parse issue.created_at unless issue.created_at.nil?
            when 'closed_at'
              DateTime.parse issue.closed_at unless issue.closed_at.nil?
            when 'type'
              labels.select{|l| (l =~ /type*/) or (%w(bug duplicate enhancement invalid question wontfix patch).include? l)}.join ', '
            when 'priority'
              labels.select{|l| (l =~ /priority*/) or (%w(high medium low critical).include? l)}.join ', '
            when 'module'
              labels.select{|l| l =~ /module*/}.join ', '
            when 'status'
              labels.select{|l| l =~ /status*/}.join ', '
            else
              issue.send field
          end
        end
      end
    end
  end
end
