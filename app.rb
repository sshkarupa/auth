require 'sinatra'
require 'slim'
require 'sass'

get('/styles.css'){ sass :styles, :style => :compressed, :views => './views/sass' }

set :username,'Bond'
set :token,'shakenN0tstirr3d'
set :password,'007'

helpers do
  def admin?
    request.cookies[settings.username] == settings.token
  end
  def protected!
    halt [ 401, 'Not Authorized' ] unless admin?
  end
end


get '/' do
  slim :index
end

get '/admin' do
  slim :admin
end

post '/login' do
  if params['username']==settings.username&&params['password']==settings.password
    response.set_cookie(settings.username,settings.token)
    redirect '/'
  else
    "Username or Password incorrect"
  end
end

get '/logout' do
  response.set_cookie(settings.username, false)
  redirect '/'
end

get '/public' do
  slim :public
end

get '/private' do
  protected!
  slim :protected
end
