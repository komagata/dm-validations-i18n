require 'helper'

class TestDmValidationsI18n < Test::Unit::TestCase
  context 'load_locale' do
    should "return locale data" do
      assert_equal '%s must be absent', DataMapper::Validations::I18n.load_locale('en')['absent']
      assert_equal '%s non deve essere presente', DataMapper::Validations::I18n.load_locale('it')['absent']
      assert_equal '%sがありません。', DataMapper::Validations::I18n.load_locale('ja')['absent']
      assert_equal '%s 必须留空', DataMapper::Validations::I18n.load_locale('zh-CN')['absent']
      assert_equal '%s 必須留空', DataMapper::Validations::I18n.load_locale('zh-TW')['absent']
    end
  end

  context 'locale!' do
    should "set to default_error_messages" do
      DataMapper::Validations::I18n.localize!('en')
      assert_equal '%s must be absent', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:absent]

      DataMapper::Validations::I18n.localize!('ja')
      assert_equal '%sがありません。', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:absent]

      DataMapper::Validations::I18n.localize!('it')
      assert_equal '%s non deve essere presente', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:absent]

      DataMapper::Validations::I18n.localize!('zh-CN')
      assert_equal '%s 必须留空', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:absent]

      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal '%s 必須留空', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:absent]
    end
  end

  context 'DataMapper::Validations::ValidationErrors.default_error_message' do
    should "not localize field names if not asked to" do
      # manually set to nil, beacuse this test might not be the first to run.
      DataMapper::Validations::I18n.field_name_translator = nil

      DataMapper::Validations::I18n.localize!('en')
      assert_equal("height has an invalid format", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('it')
      assert_equal("height ha un formato non valido", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('ja')
      assert_equal("heightは不正な値です。", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('zh-CN')
      assert_equal("height 无效", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

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

      DataMapper::Validations::I18n.translate_field_name_with :rails

      DataMapper::Validations::I18n.localize!('en')
      assert_equal("Dummy I18n.t has an invalid format", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('it')
      assert_equal("Dummy I18n.t ha un formato non valido", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('ja')
      assert_equal("Dummy I18n.tは不正な値です。", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('zh-CN')
      assert_equal("Dummy I18n.t 无效", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))

      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal("Dummy I18n.t 無效", DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height))
    end

    should "localize field names with callback" do
      DataMapper::Validations::I18n.translate_field_name_with {|field| "Dummy" }

      DataMapper::Validations::I18n.localize!('en')
      assert_equal 'Dummy has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)

      DataMapper::Validations::I18n.localize!('it')
      assert_equal 'Dummy ha un formato non valido', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)

      DataMapper::Validations::I18n.localize!('ja')
      assert_equal 'Dummyは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)

      DataMapper::Validations::I18n.localize!('zh-CN')
      assert_equal 'Dummy 无效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)

      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal 'Dummy 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
    end

    should "localize field names with hash" do
      DataMapper::Validations::I18n.localize!('en')
      DataMapper::Validations::I18n.translate_field_name_with({'en' => { "height" => "height", "weight" => "weight" }})
      assert_equal '%s has an invalid format', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:invalid]
      assert_equal 'height has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal 'weight has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)
      assert_equal 'length has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."

      # TODO: for it

      DataMapper::Validations::I18n.localize!('ja')
      DataMapper::Validations::I18n.translate_field_name_with({'ja' => { "height" => "高さ", "weight" => "重さ" }})
      assert_equal '%sは不正な値です。', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:invalid]
      assert_equal '高さは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal '重さは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)
      assert_equal 'lengthは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."

      # TODO: for zh-CN

      DataMapper::Validations::I18n.localize!('zh-TW')
      DataMapper::Validations::I18n.translate_field_name_with({'zh-TW' => { "height" => "高度", "weight" => "重量" }})
      assert_equal '%s 無效', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:invalid]
      assert_equal '高度 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal '重量 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)
      assert_equal 'length 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
    end

    should "localize field names with hash, even with diffenert setup order." do
=begin
      DataMapper::Validations::I18n.translate_field_name_with({'en' => { "height" => "height", "weight" => "weight" }})
      DataMapper::Validations::I18n.localize!('en')
      assert_equal '%s has an invalid format', DataMapper::Validations::ValidationErrors.send(:class_variable_get, '@@default_error_messages')[:invalid]
      assert_equal 'height has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal 'weight has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)
      assert_equal 'length has an invalid format', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
=end

      # TODO: for it

=begin
      DataMapper::Validations::I18n.translate_field_name_with({'ja' => { "height" => "高さ", "weight" => "重さ" }})
      DataMapper::Validations::I18n.localize!('ja')
      assert_equal '高さは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal '重さは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :weight)
      assert_equal 'lengthは不正な値です。', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
=end

      # TODO: for zh-CN

      DataMapper::Validations::I18n.translate_field_name_with({'zh-TW' => { "height" => "高度", "weight" => "重量" }})
      DataMapper::Validations::I18n.localize!('zh-TW')
      assert_equal '高度 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :height)
      assert_equal 'length 無效', DataMapper::Validations::ValidationErrors.default_error_message(:invalid, :length), "Fallback to original field name if missing the translated version."
    end
  end
end
