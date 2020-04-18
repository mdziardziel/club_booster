class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def self.trans(path, person = nil)
    I18nForPerson.t(path, person)
  end
end
