class User < ActiveRecord::Base
  has_many :importers, as: :importable
end
