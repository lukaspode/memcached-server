
# LUCAS PODESTA - Memcached Server

require 'socket'
require_relative 'commands'

PORT = 3000
server =  TCPServer.new(PORT)
puts "Server running on #{PORT}"

loop do
  Thread.start(server.accept) do |client|
    client.puts "Client connected to localhost:#{PORT}\r\n"
    command = Commands.new # Ver si ponerlo dentro del Loop cuando se conecta el cliente en el Server o fuera (Mismo Hash para todos)
    puts "New client connected"
    while user_input = client.gets
        request = user_input.split[0]
        case request #.chomp rompe cuando comando vacio, sin chomp no carga con espacio al final?
        when "get"                                          # <----- Retrieval commands ------>
            if command.check_input_commands_ret(user_input)
                answer = command.get(user_input.split[1])
                client.puts "#{answer.data}\r\n"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "gets"
            if command.check_input_commands_ret(user_input)
                client.puts "GETS_GETS"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "set"                                          # <------ Storage commands ------->
            if command.check_input_commands_st(user_input)
                answer = command.set(user_input)
                client.puts "#{answer.data}\r\n"
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "add"
            if command.check_input_commands_st(user_input)
                answer = command.add(user_input)
                if answer.succ
                    client.puts "#{answer.data}\r\n"                        
                else
                    client.puts "#{answer.data}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "replace"
            if command.check_input_commands_st(user_input)
                answer = command.replace(user_input)
                if answer.succ
                    client.puts "#{answer.data}\r\n"                        
                else
                    client.puts "#{answer.data}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "append"
            if command.check_input_commands_st(user_input)
                answer = command.append(user_input)
                if answer.succ
                    client.puts "#{answer.data}\r\n"                        
                else
                    client.puts "#{answer.data}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "prepend"
            if command.check_input_commands_st(user_input)
                answer = command.prepend(user_input)
                if answer.succ
                    client.puts "#{answer.data}\r\n"                        
                else
                    client.puts "#{answer.data}\r\n"                        
                end
            else
                client.puts "ERROR\r\n"
                client.puts "Wrong number of parameters \r\n"
            end
        when "cas"
            if command.check_input_commands_cas(user_input)
                client.puts "CAS_CAS"
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
