require 'dm-validations'
require 'yaml'

module DataMapper
  module Validations
    module I18n
      class << self
        def localize!(locale)
          data = {}
          load_locale(locale).each do |key, value|
            data[key.to_sym] = value
          end
          DataMapper::Validations::ValidationErrors.default_error_messages = data
        end

        def load_locale(locale)
          load_yml File.join(File.dirname(__FILE__), '..', 'locale', "#{locale}.yml")
        end

        def load_yml(filename)
          YAML::load IO.read(filename)
        end
      end
    end
  end
end
