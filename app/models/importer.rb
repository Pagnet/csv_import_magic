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
  validate :uniqueness_columns
  validate :required_columns, on: :update

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

  def required_columns
    required_columns = parser_klass.new(content: nil).config.column_definitions.map do |column|
      next unless column.required
      column.name.to_s
    end.compact

    sameness = (columns & required_columns)
    return if sameness == required_columns

    columns_to_translate = required_columns - sameness
    return if columns_to_translate.blank?

    transalated_name_of_columns = columns_to_translate.map do |column|
      source_klass.human_attribute_name(column)
    end.to_sentence

    errors.add(:columns, I18n.t('errors.messages.missing', count: columns_to_translate.size, columns: transalated_name_of_columns))
  end

  def uniqueness_columns
    return if columns.empty?

    headers = columns.clone
    headers.delete('ignore')
    duplicate_headers = headers.find_all { |element| headers.count(element) > 1 }

    return if duplicate_headers.blank?

    headers_to_translate = duplicate_headers.uniq
    headers_transalated = headers_to_translate.map do |header|
      source_klass.human_attribute_name(header)
    end.to_sentence

    errors.add(:columns, I18n.t('errors.messages.uniq', count: headers_to_translate.size, columns: headers_transalated))
  end
end
