class I18nForPerson
  PERSONED_LANGUAGES = %i(pl)

  def self.t(path, person)
    fallback = I18n.t(path)
    current_locale = I18n.locale
    return fallback if PERSONED_LANGUAGES.exclude?(current_locale)

    I18n.t("#{person}.#{path}", default: fallback)
  end
end