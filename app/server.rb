
# LUCAS PODESTA - Memcached Server

require 'socket'
require_relative 'commands'

PORT = 3000
server =  TCPServer.new(PORT)
puts "Server running on port: #{PORT}"

# Ver si usar patron factory y singleton para el server

loop do
  Thread.start(server.accept) do |client|
    client.puts "Client connected to localhost: #{PORT}\r\n"
    command = Commands.new 
    puts "New client connected"
    while console_input = client.gets
        request = console_input.split[0]
        user_input = console_input.split
        case request #.chomp rompe cuando comando vacio, sin chomp no carga con espacio al final?
        when "get"                                          # <----- Retrieval commands ------>
            if command.check_input_commands_ret(user_input)
                answer = command.get(user_input)
                client.puts "#{answer.message}\r\n"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "gets"
            if command.check_input_commands_ret(user_input)
                answer = command.gets(user_input)
                client.puts "#{answer.message}\r\n"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "set"                                          # <------ Storage commands ------->
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_st(user_input)
                answer = command.set(user_input)
                client.puts "#{answer.message}\r\n"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "add"
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_st(user_input)
                answer = command.add(user_input)
                if answer.succ
                    client.puts "#{answer.message}\r\n"                        
                else
                    client.puts "#{answer.message}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "replace"
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_st(user_input)
                answer = command.replace(user_input)
                if answer.succ
                    client.puts "#{answer.message}\r\n"                        
                else
                    client.puts "#{answer.message}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "append"
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_st(user_input)
                answer = command.append(user_input)
                if answer.succ
                    client.puts "#{answer.message}\r\n"                        
                else
                    client.puts "#{answer.message}\r\n"                        
                end
            else
                client.puts "CLIENT_ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "prepend"
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_st(user_input)
                answer = command.prepend(user_input)
                if answer.succ
                    client.puts "#{answer.message}\r\n"                        
                else
                    client.puts "#{answer.message}\r\n"                        
                end
            else
                client.puts "CLIENT_ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "cas"
            data_block = client.gets( "\r\n" ).chomp( "\r\n" )
            user_input.push(data_block)
            if command.check_input_commands_cas(user_input)
                answer = command.cas(user_input)
                client.puts "#{answer.message}\r\n"
            else
                client.puts "ERROR\r\n"       
                client.puts "Wrong number of parameters \r\n"
            end
        when "q"                       # <-------- QUIT ----------->
            client.puts "Disconnecting from the Server...\r\n"
            sleep(0.6)
            client.printf "Client disconnected."
            sleep(0.9)
            client.close
        else
            client.puts "ERROR\r\n"
            client.puts "Command not found or supported.\r\n"
        end
    end
  end
end
