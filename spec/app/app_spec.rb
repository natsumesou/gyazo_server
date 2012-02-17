require 'spec_helper'

describe Nyazo do
  it "should be return 200" do
    get :index
    last_response.status.should be_ok
  end
end
