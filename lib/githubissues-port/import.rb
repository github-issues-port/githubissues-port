require 'github_api'
require 'creek'

module Githubissues
  module Port   
    class Githubissues::Port::Import
      attr_reader :path, :messages
      def initialize connection, owner, repo, path, options = {}
        @path = path
        fields = (options.has_key? :fields) ? options[:fields] : %w(labels)
        creek = Creek::Book.new path, :check_file_extension => false
        sheet= creek.sheets[0]
        @messages = []
        sheet.rows.each_with_index do |r, i|
          case i
          when 0
            @header = r.invert
          else
            number = r["A#{i+1}"]
            updates = {}
            break if number.nil?

            fields.each do |f|
              if @header.has_key? f
                value = r[@header[f].gsub '1', (i+1).to_s]
                value = value.split(',').map(&:strip) if f.downcase.eql?'labels' and (!value.nil?)
                updates[f.downcase] = value
              end
            end

            issue = connection.issues.edit owner, repo, number, updates
            @messages.push "Issue ##{number} updated: #{updates.inspect}"
          end
        end
        @messages
      end
    end
  end
end