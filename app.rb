require "dotenv/load"
require "json"
require "sinatra"
require "sinatra/reloader" if development?
require_relative "config/database"
require_relative "models/todo"

set :views, File.join(__dir__, "views")
set :port, 3212

get "/" do
  @todos = Todo.all
  erb :index
end

post "/todos" do
  title = params[:title].to_s.strip
  Todo.create(title) unless title.empty?
  redirect "/"
end

post "/todos/reorder" do
  ids = JSON.parse(request.body.read)["ids"].map(&:to_i)
  Todo.reorder(ids)
  200
end

post "/todos/:id/toggle" do
  Todo.toggle(params[:id])
  redirect "/"
end

post "/todos/:id/delete" do
  Todo.delete(params[:id])
  redirect "/"
end
