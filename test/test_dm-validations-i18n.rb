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
end
