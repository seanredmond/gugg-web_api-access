require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('access_spec.yml')
db = cfg['db']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

require 'gugg-web_api-access'

describe Gugg::WebApi::Access do
  before :all do
    cfg = YAML.load_file('access_spec.yml')
    @bad_key = cfg['keys']['bad']
    @cancelled_key = cfg['keys']['cancelled']
    @good_key = cfg['keys']['good']
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
end