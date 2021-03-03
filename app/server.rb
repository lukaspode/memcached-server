
# LUCAS PODESTA First Test

require 'socket'
require_relative 'commands'

PORT = 3000
server =  TCPServer.new(PORT)
puts "Server running on #{PORT}"
command = Comando.new


loop do
  Thread.start(server.accept) do |client|
    client.puts "Client connected to localhost:#{PORT}"
    client.puts "input format: add 10 12 33"

    #request = client.gets
    while client.gets
        user_input = client.gets
        request = user_input.split[0]
        client.puts "#{request}"
        #client.puts "Command entered #{request}"
        case request.chomp
        when "get"                  # <----- Retrieval commands ------>
            client.puts "GET_GET"
        when "gets"
            client.puts "GETS_GETS"
        when "set"
            client.puts "SET_SET"   # <------ Storage commands ------->
        when "add"
            client.puts "ADD_ADD"
        when "replace"
            client.puts "REPLACE_REPLACE"
        when "append"
            client.puts "APPEND_APPEND"
        when "prepend"
            client.puts "PREPEND_PREPEND"
        when "cas"
            client.puts "CAS_CAS"
        when "q"                       # <-------- QUIT ----------->
            client.close
        else
            client.puts "COMMAND_ERROR_"
        end
    end
  end
end
