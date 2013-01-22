require "rubygems"
require "sequel"

@DB = Sequel.sqlite()
@DB.create_table(:api_keys){
  String :key
  String :user
  Fixnum :access
  String :description
  String :updated_at
}

@DB[:api_keys].insert(
  :key => '00ea1ae3bd1fef315ba91d2ad8a125ad', 
  :user => 'unit_test_cancelled', 
  :access => 0, 
  :description => 'Test key: exists but no access', 
  :updated_at => '2012-08-09 20:10:25'
)
@DB[:api_keys].insert(
  :key => 'ed3c63916af176b3af878f98156e07f4', 
  :user => 'unit_test_good', 
  :access => 17, 
  :description => 'Test key: valid', 
  :updated_at => '2012-08-09 21:37:06'
)

require 'gugg-web_api-access'

describe Gugg::WebApi::Access do
  before :all do
    # Should not exist in the access DB
    @bad_key = '82d309784cadc54b3381828ae38cef78'
    # Should exist but have no access
    @cancelled_key = '00ea1ae3bd1fef315ba91d2ad8a125ad'
    # Should exist and have access
    @good_key = 'ed3c63916af176b3af878f98156e07f4'
  end

	describe "#get" do
    context 'with non-existent key' do
      it "should return nil" do
        Gugg::WebApi::Access::get(@bad_key).should eq(nil)
      end
    end

    context 'with cancelled key' do
      it 'should return nil' do
        Gugg::WebApi::Access::get(@cancelled_key).should eq(nil)
      end
    end

    context 'with good key' do
      before :all do
        @good_acc = Gugg::WebApi::Access::get(@good_key)
      end

      it "should return an AccessLevel object" do
        @good_acc.should be_an_instance_of(Gugg::WebApi::Access::AccessLevel)
      end
    end
  end

  describe "#allow?" do
    context 'with good key' do
      before :all do
        @good_acc = Gugg::WebApi::Access::get(@good_key)
      end

      it 'should allow user level TEST to read' do
        perms = Gugg::WebApi::Access::A_READ | Gugg::WebApi::Access::U_TEST
        access = Gugg::WebApi::Access::allow?(@good_acc, perms)
        access.should eq(true)
      end

      it 'should not allow user level TEST to write' do
        perms = Gugg::WebApi::Access::A_WRITE | Gugg::WebApi::Access::U_TEST
        access = Gugg::WebApi::Access::allow?(@good_acc, perms)
        access.should eq(false)
      end
    end

    context 'with bad key' do
      before :all do
        @bad_acc = Gugg::WebApi::Access::get(@bad_key)
      end

      it 'should not allow read access' do
        perms = Gugg::WebApi::Access::A_READ | Gugg::WebApi::Access::U_ANY
        access = Gugg::WebApi::Access::allow?(@bad_acc, perms)
        access.should eq(false)
      end

      it 'should not allow write access' do
        perms = Gugg::WebApi::Access::A_WRITE | Gugg::WebApi::Access::U_ANY
        access = Gugg::WebApi::Access::allow?(@bad_acc, perms)
        access.should eq(false)
      end
    end
  end
end