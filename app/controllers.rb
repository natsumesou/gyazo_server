Nyazo.controllers  do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index do
    File.read(Padrino.root('public', 'index.html'))
  end

  post :upload do
    tempfile = params[:imagedata][:tempfile]
    image = Image.new(tempfile)
    if image.save
      File.join('http://', "#{NyazoEnv::App[:host]}:#{NyazoEnv::App[:port]}", image.filename)
    else
      halt 403
    end
  end
end
