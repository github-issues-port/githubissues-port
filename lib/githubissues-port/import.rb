require 'github_api'
require 'creek'

module Githubissues
  module Port   
    class Githubissues::Port::Import
      attr_reader :connection, :owner, :repo, :path, :messages, :header

      DEFAULT_FIELDS = %w(title labels) 

      def initialize connection, owner, repo, path, options = {}
        @path, @connection, @owner, @repo = path, connection, owner, repo
        @fields = (options.has_key? :fields) ? options[:fields] :  DEFAULT_FIELDS 
        @messages = []
        parse_excel
        @messages
      end

      def parse_excel
        creek = Creek::Book.new path, :check_file_extension => false
        sheet= creek.sheets[0]
        raise " Or Large Number of Issues to import" if sheet.rows.count>500     
        sheet.rows.each_with_index do |row, row_index|
          break if row.first.nil? and row[1].nil?
          row_number = row_index + 1
          case row_number
          when 1          
            parse_header row, row_number
          else
            parse_row row, row_number
          end
        end
      end

      def parse_header row, row_number
        @header = row.invert
        @header.each{|k, v| @header[k] = v.gsub('1', '')}
      end

      def extract_updates row, row_number
        updates = {}
        @fields.each do |field|
          if @header.has_key? field
            value = row["#{@header[field]}#{row_number}"]
            value = value.split(',').map(&:strip) if field.downcase.eql?'labels' and (!value.nil?)
            updates[field.downcase] = value
          end
        end
        updates
      end

      def update_existing_issue number, updates
        issue = @connection.issues.edit @owner, @repo, number, updates
        @messages.push "Issue ##{issue.number} updated: #{updates.inspect}" 
      end

      def create_new_issue number, updates
        @connection.user = @owner
        @connection.repo = @repo          
        issue = @connection.issues.create updates
        @messages.push "Issue ##{issue.number} created: #{updates.inspect}"
      end

      def parse_row row, row_number
        number = row["A#{row_number}"]
        updates = extract_updates row, row_number
        unless number.nil?
          update_existing_issue number, updates
        else
          create_new_issue number, updates
        end
      end
    end
  end
end