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

  # context 'localized field names with callback' do
  #   DataMapper::Validations::I18n.translate_field_name_with do |field_name|
  #     assert_equal field_name, 'foo'
  #   end
  # end
  # context 'localized field names with rails I18n.t' do
  #   # mock I18n.t(field, "dm-validation")
  #   DataMapper::Validations::I18n.translate_field_name_with :rails
  # end

  context 'DataMapper::Validations::ValidationErrors.default_error_message' do
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
