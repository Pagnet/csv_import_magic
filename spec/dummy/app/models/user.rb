class User < ActiveRecord::Base
  has_many :importers, as: :importable
  has_many :companies
end
