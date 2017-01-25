class Importer < ActiveRecord::Base
  include Paperclip::Glue

  STATUS = %w(pending success error).freeze

  serialize :columns, Array

  has_attached_file :attachment
  has_attached_file :attachment_error

  validates_attachment_content_type :attachment, :attachment_error, content_type: ['text/plain', 'text/csv', 'application/vnd.ms-excel']
  validates_inclusion_of :status, in: STATUS
  validates :attachment, attachment_presence: true
  validates :source, presence: true
  validate :check_columns

  belongs_to :importable, polymorphic: true

  before_validation :set_parser

  def source_klass
    return if source.blank?
    source.classify.constantize
  end

  def parser_klass
    parser.classify.constantize
  end

  def importable_columns(name_of_parser = parser)
    source_klass.columns_names(name_of_parser.to_sym)
  end

  private

  def set_parser
    return if source_klass.blank? || parser.present?
    self.parser = source_klass.csv_parser_default_name
  end

  def check_columns
    return if columns.empty?

    headers = columns.clone
    headers.delete('ignore')
    errors.add(:columns, :uniq) if headers.size != headers.uniq.size
    errors.add(:columns, :missing) if headers.uniq.size != importable_columns(parser).size
  end
end
