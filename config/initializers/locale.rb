I18n.config.available_locales = [ :en, :ja ]
I18n.default_locale = :ja

I18n.load_path += Dir[ Rails.root.join('config', 'locales', '**', '*.{rb,yml}') ]
