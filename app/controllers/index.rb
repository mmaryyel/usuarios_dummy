#si desde raíz se desea ingresar a la página mostrará el mensage "Necesitas hacer log in"
get '/' do
  @notlog = params[:notlog]
  erb :index
end

get '/login' do
  erb :login
end

get '/signup' do
  erb :signup
end

#Envía al usuario a la página(redirect to)si su informacion es correcta
#si intenta escribir el url desde el buscador este lo enviara a la vista principal
#y le solicitará iniciar sesión o crear una cuenta.
before '/users/:id' do
 if session[:id] == nil
    notlog = true
    redirect to ("/?notlog=#{notlog}")
  end
end

#Obtiene un usuario y lo busca por su id y le muestra la vista de la página secreta
get '/users/:id' do
    @user = User.find(params[:id])
    erb :secret
end

#Se utilixa un post(ya que se va a obtener información)
# se asigna a una variable la instancia de la tabla User.new, la cual debe cumplir con todos los campos
#si cumple con los campos de la tabla entonces se guarda y se envía a raíz '/'
#si falla(no cumple con los campos) te envía a la vista signup
post '/signup' do
  @user = User.new(name: params[:name], email: params[:email], password: params[:password])
  if @user.save
    @falla = false
  redirect to ("/")
  else
    @falla = true
    erb :signup
  end
end

#Se obtiene información desde la vista signup y se crea una cuenta y te envia a la vista login

post '/signup' do
erb :login
end

#a la variable user se le asigna como valor la instancia de la tabla User.authenticate(que comprueba que el usuario y contraseñas correspondan al mismo) 
#si la información es correcta te envía a la vista login
#si el usuario no corresponde a la contraseña se envía el mensaje de "usuario no encontrado"

post '/login' do
  user = User.authenticate(params[:email], params[:password])
  p user
  puts " SESSION ID ANTES #{session[:id]}"
  if user != nil
    session[:id] = user.id
    redirect to ("/users/#{user.id}")
  else
    @falla = true
    erb :login
  end
end

#Si el usuario presiona el boton  logout este cierra su sesión y te envía nuevamente a la página principal.
post '/logout' do
  session.clear
  erb :index
end


