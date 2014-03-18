require 'github_api'
require 'axlsx'

module Githubissues
  module Port   
    class Githubissues::Port::Export

      attr_reader :connection, :owner, :repo, :path ,:params

      DEFAULT_FIELDS = %w(Number Title Body Labels Assignee  State Milestone Created_at Updated_at Closed_at Type Priority Module Status) 
      
      def initialize connection, owner, repo, path, options = {},params
        @path, @connection, @owner, @repo = path, connection, owner, repo
        @fields = (options.has_key? :fields) ? options[:fields] : DEFAULT_FIELDS
        @params =params
        generate_excel
      end

      def generate_excel
        Axlsx::Package.new do |excel|
          if @params[:params][:state]=='open'
            generate_sheet excel, 'open'
          elsif @params[:params][:state]=='closed'
            generate_sheet excel, 'closed'
          else
            generate_sheet excel, 'open'
            generate_sheet excel, 'closed'
          end
          excel.serialize path
        end
      end
      

      def generate_params(state,labels)
         params=({:user=>@owner,:repo=>@repo,:filter=>'all',:auto_pagination=>true,:state=>state})
         params=params.merge({:milestone=>@params[:params]['milestone']}) unless @params[:params]['milestone'].blank?
         params=params.merge({:assignee=>@params[:params]['assignee']}) unless @params[:params]['assignee'].blank?
         params=params.merge({:creator=>@params[:params]['creator']}) unless @params[:params]['creator'].blank?
         params=params.merge({:mentioned=>@params[:params]['mentioned']}) unless @params[:params]['mentioned'].blank?
         params=params.merge({:since=>@params[:params]['datepicker'].to_time.utc.iso8601.split('+')[0]}) unless @params[:params]['datepicker'].blank?
         params=params.merge({:labels=>labels}) unless labels.blank?
         params

      end

      def generate_sheet excel, state
        excel.workbook.add_worksheet(:name => state) do |sheet|
          heading = sheet.styles.add_style sz: 12,b:true, fg_color: "0C65D1"
          sheet.add_row @fields  ,style:heading
          issues=[]
          @params[:params]['labels'].each do |labels|
             issues=issues + (connection.issues.list self.generate_params(state,labels))
          end

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
            when 'updated_at'
              DateTime.parse issue.updated_at unless issue.updated_at.nil?
            when 'closed_at'
              DateTime.parse issue.closed_at unless issue.closed_at.nil?
            when 'type'
              labels.filter_by_category('type').join(', ').split('type - ')[1]
            when 'priority'
               labels.filter_by_category('priority').join(', ').split('priority - ')[1]
            when 'module'
              labels.filter_by_category('module').join(', ').split('module - ')[1]
            when 'status'
              labels.filter_by_category('status').join(', ').split('status - ')[1]
            else
              issue.send field.downcase
          end
        end
      end
    end
  end
end
