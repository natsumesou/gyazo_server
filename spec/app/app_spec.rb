require 'spec_helper'

describe Nyazo do
  it "should be return 200" do
    get '/'
    last_response.ok?.should be_true
  end
end
