class <%= file_path.camelize %>Parser
  include ::CSVImporter

  model <%= file_path.camelize %>

  # will update_or_create via :email
  # identifier :email

  # column :email, to: ->(email) { email.downcase }, required: true
  # column :first_name, as: [ /first.?name/i, /pr(é|e)nom/i ]
  # column :last_name,  as: [ /last.?name/i, "nom" ]
  # column :published,  to: ->(published, user) { user.published_at = published ? Time.now : nil }

  # or :abort
  #  when_invalid :skip
end
