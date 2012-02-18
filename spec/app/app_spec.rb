require 'spec_helper'

describe Nyazo do
  let(:tmp) do
    Padrino.root('tmp')
  end

  let(:filename) do
    'nyazo.com'
  end

  let(:tempfile) do
    Rack::Test::UploadedFile.new(Padrino.root('spec', 'test.png'), "image/png")
  end

  let(:fake_tempfile) do
    Rack::Test::UploadedFile.new(Padrino.root('spec', 'test.jpg'), "image/jpg")
  end

  let(:fake_ext_tempfile) do
    Rack::Test::UploadedFile.new(Padrino.root('spec', 'fake.png'), "image/png")
  end

  let(:params) do
    {"id"=>"740a3cbbed7c9c8f328aa0587c5d01e1", "imagedata"=> tempfile}
  end

  let(:fake_params) do
    {"id"=>"740a3cbbed7c9c8f328aa0587c5d01e1", "imagedata"=>fake_tempfile}
  end

  let(:fake_ext_params) do
    {"id"=>"740a3cbbed7c9c8f328aa0587c5d01e1", "imagedata"=>fake_ext_tempfile}
  end

  URL_REGEX = /http:\/\/#{NyazoEnv::App[:host]}:#{NyazoEnv::App[:port]}\/([a-zA-Z0-9]+\.png)/i

  context 'index controller' do
    it "should be return 200" do
      get '/'
      last_response.ok?.should be_true
    end
  end

  context 'upload controller' do
    it 'should be return false' do
      get 'upload'
      last_response.ok?.should be_false
    end

    it 'should be return 200 with post method' do
      post 'upload', params
      last_response.ok?.should be_true
    end

    it 'should be response png file url' do
      post 'upload', params
      last_response.ok?.should be_true
      last_response.body.should match URL_REGEX
    end

    it 'should return 403 when post other ext file' do
      post 'upload', fake_params
      last_response.status.should == 403
    end

    it 'should return 403 when post other file' do
      post 'upload', fake_ext_params
      last_response.status.should == 403
    end
  end
end
