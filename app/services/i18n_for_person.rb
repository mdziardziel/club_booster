class I18nForPerson
  def self.t(path, person = :neuter)
    I18n.t("#{person}.#{path}", default: I18n.t(path))
  end
end