class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def self.trans(path, person)
    I18nForPerson.t(path, person)
  end
end
