class <%= file_path.camelize %>Parser
  include ::CSVImporter

  model <%= file_path.camelize %>

  # will update_or_create via :<%= options[:columns].first %>
  identifier :<%= options[:columns].first %>

  # Examples of columns declaration
  # column :<%= options[:columns].first %>, to: ->(<%= options[:columns].first %>) { <%= options[:columns].first %>.downcase }, required: true
  # column :<%= options[:columns].first %>, as: [ /first.?name/i, /pr(é|e)nom/i ]
  # column :<%= options[:columns].first %>,  as: [ /last.?name/i, "nom" ]
  # column :<%= options[:columns].first %>,  to: ->(<%= options[:columns].first %>, record) { record.<%= options[:columns].first %> = <%= options[:columns].first %> ?  'a' : 'b' }
<% options[:columns].map do |column| %>
  column :<%= column.to_sym %>, required: true
<% end %>
  # or :abort
  #  when_invalid :skip
end
