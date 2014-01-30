require 'github_api'
require 'axlsx'

module Githubissues
  module Port   
    class Githubissues::Port::Export
      attr_reader :path
      def initialize connection, owner, repo, path
        @path = path
        issues = connection.issues.list user: owner, repo: repo, filter: 'all', auto_pagination: true          
        Axlsx::Package.new do |p|
          p.workbook.add_worksheet(:name => @repo) do |s|
            fields = %w(number title body labels assignee  state milestone created_at closed_at comments comments_url events_url html_url labels_url)
            s.add_row fields
            issues.each do |i|
              row = Array.new
              fields.each do |f|
                row.push  case f
                            when 'assignee'
                              i.assignee.login unless i.assignee.nil?
                            when 'labels'
                              i.labels.map(&:name).join(', ') unless i.labels.nil?
                            else
                              i.send f
                          end
              end unless issues.nil?
              s.add_row row
            end
          end
          p.serialize path
        end
      end
    end
  end
end