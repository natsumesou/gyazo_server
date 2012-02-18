require 'spec_helper'

describe Image do
  let(:tempfile) do
    tmp = Rack::Test::UploadedFile.new(Padrino.root('spec', 'test.png'), "image/png")
    Image.new(tmp)
  end

  let(:fake_tempfile) do
    tmp = Rack::Test::UploadedFile.new(Padrino.root('spec', 'test.jpg'), "image/jpg")
    Image.new(tmp)
  end

  let(:fake_ext_tempfile) do
    tmp = Rack::Test::UploadedFile.new(Padrino.root('spec', 'fake.png'), "image/png")
    Image.new(tmp)
  end

  let(:null_tempfile) do
    tmp = Rack::Test::UploadedFile.new(Padrino.root('spec', 'null.png'), "image/png")
    Image.new(tmp)
  end

  it 'should save png file' do
    tempfile.save.should be_true
    File.exist?(tempfile.path).should be_true
    tempfile.delete
  end

  it 'should not save other ext image file' do
    fake_tempfile.save.should be_false
  end

  it 'should not save other file' do
    fake_ext_tempfile.save.should be_false
  end

  it 'should not save not image file' do
    null_tempfile.save.should be_false
  end
end
