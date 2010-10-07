require 'helper'

class TestDmValidationsI18n < Test::Unit::TestCase
  context 'load_locale' do
    should "return locale data" do
      assert_equal '%s must be absent', DataMapper::Validations::I18n.load_locale('en')['absent']
      assert_equal '%sがありません。', DataMapper::Validations::I18n.load_locale('ja')['absent']
    end
  end

  context 'locale!' do
    should "set to default_error_messages" do
      class Foo < DataMapper::Validations::ValidationErrors
        cattr_reader :default_error_messages
      end

      DataMapper::Validations::I18n.localize!('ja')

      assert_equal '%sがありません。', Foo.default_error_messages[:absent]
    end
  end

  context 'DataMapper::Validations::ValidationErrors.default_error_message' do
    should "not localize field names if not asked to" do
      # manually set to nil, beacuse this test might not be the first to run.
      DataMapper::Validations::I18n.field_name_translator = nil

      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal("height 無效", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))
    end

    should "localize field names with Rails way: I18n.t is used." do
      # mock I18n.t
      class ::I18n
        def self.t(x)
          "Dummy I18n.t"
        end
      end

      DataMapper::Validations::I18n.localize!('zh-TW')
      DataMapper::Validations::I18n.translate_field_name_with :rails

      assert_equal("Dummy I18n.t 無效", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))
    end

    should "localize field names with callback" do
      DataMapper::Validations::I18n.localize!('zh-TW')
      DataMapper::Validations::I18n.translate_field_name_with do |field|
        "Dummy"
      end
      assert_equal 'Dummy 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
    end

    should "localize field names with hash" do
      DataMapper::Validations::I18n.localize!('zh-TW')
      DataMapper::Validations::I18n.translate_field_name_with({'zh-TW' => { "height" => "高度", "weight" => "重量" }})

      assert_equal '%s 無效', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:invalid]

      assert_equal '高度 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal '重量 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)

      assert_equal 'length 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
    end

    should "localize field names with hash, even with diffenert setup order." do
      DataMapper::Validations::I18n.translate_field_name_with({'zh-TW' => { "height" => "高度", "weight" => "重量" }})
      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal '高度 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal 'length 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
    end
  end
end
