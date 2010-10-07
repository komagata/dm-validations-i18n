require 'dm-validations'
require 'yaml'

module DataMapper
  module Validations
    module I18n
      class << self
        cattr_accessor :locale
        cattr_accessor :field_name_translator

        def localize!(locale)
          self.locale = locale

          data = {}
          load_locale(locale).each do |key, value|
            data[key.to_sym] = value
          end
          DataMapper::Validations::ValidationErrors.default_error_messages = data
        end

        def translate_field_name_with(x = nil, &cb)
          self.field_name_translator =
            if (!x && cb)
              FieldNameTranslator::Callback.new(self, &cb)
            elsif (x.is_a? Hash)
              FieldNameTranslator::Hash.new(self, x)
            elsif (x == :rails)
              FieldNameTranslator::Rails.new(self)
            end
        end

        def load_locale(locale)
          load_yml File.join(File.dirname(__FILE__), '..', 'locale', "#{locale}.yml")
        end

        def load_yml(filename)
          YAML::load IO.read(filename)
        end
      end
    end

    module FieldNameTranslator
      class Callback
        attr_accessor :context, :callback

        def initialize(context, &cb)
          self.context  = context
          self.callback = cb
        end

        def translate(field)
          self.callback.call(field)
        end
      end

      class Hash < Callback
        def initialize(context, x)
          dict = x[context.locale]

          self.context = context
          self.callback = lambda do |field|
            dict[field.to_s] || field
          end
        end
      end

      class Rails < Callback
        def initialize(context)
          self.context = context
          self.callback = lambda do |field|
            ::I18n.t(field)
          end
        end
      end
    end
  end
end

class DataMapper::Validations::ValidationErrors
  class << self
    def default_error_message_with_localized_field_name(key, field, *values)
      translator = DataMapper::Validations::I18n.field_name_translator

      if translator
        field = translator.translate(field)
      end

      @@default_error_messages[key] % [field, *values].flatten
    end

    alias :default_error_message_without_localized_field_name :default_error_message
    alias :default_error_message :default_error_message_with_localized_field_name
  end
end

