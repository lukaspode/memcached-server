
# LUCAS PODESTA First Test

require 'socket'
require_relative 'commands'

PORT = 3000
server =  TCPServer.new(PORT)
puts "Server running on #{PORT}"
command = Commands.new


loop do
  Thread.start(server.accept) do |client|
    client.puts "Client connected to localhost:#{PORT}\r\n"
    client.puts "input format: add 10 12 33 0101 noreply hola\r\n\r\n"
    puts "New client conected"

    #request = client.gets
    while user_input = client.gets
        request = user_input.split[0]
        client.puts "Command entered: #{request}\r\n"
       # if (request.chomp == "get" || request.chomp == "gets")
        #    control = command.check_input_commands_ret(user_input)
       # else
       #     control = command.check_input_commands_st(user_input)
        #end
       # if control
            case request.chomp
            when "get"                                          # <----- Retrieval commands ------>
                if command.check_input_commands_ret(user_input)
                    answer = command.get(user_input.split[1])
                    if answer.succ
                        client.puts "#{answer.data}"
                    end
                else
                    client.puts "ERROR\r\n"
                end
            when "gets"
                if command.check_input_commands_ret(user_input)
                    client.puts "GETS_GETS"
                else
                    client.puts "ERROR\r\n"
                end
            when "set"                                          # <------ Storage commands ------->
                if command.check_input_commands_st(user_input)
                    command.set(user_input)
                    client.puts "STORED\r\n"
                else
                    client.puts "ERROR\r\n"
                end
            when "add"
                if command.check_input_commands_st(user_input)
                    answer = command.add(user_input)
                    if answer.succ
                        client.puts "STORED\r\n"                        
                    else
                        client.puts "NOT_STORED\r\n"                        
                    end
                else
                    client.puts "ERROR\r\n"
                end
            when "replace"
                client.puts "REPLACE_REPLACE"
            when "append"
                if command.check_input_commands_st(user_input)
                    answer = command.append(user_input)
                    if answer.succ
                        client.puts "STORED\r\n"                        
                    else
                        client.puts "NOT_STORED\r\n"                        
                    end
                else
                    client.puts "ERROR\r\n"
                end
            when "prepend"
                if command.check_input_commands_st(user_input)
                    answer = command.prepend(user_input)
                    if answer.succ
                        client.puts "STORED\r\n"                        
                    else
                        client.puts "NOT_STORED\r\n"                        
                    end
                else
                    client.puts "ERROR\r\n"
                end
            when "cas"
                client.puts "CAS_CAS"
            when "q"                       # <-------- QUIT ----------->
                client.close
            else
                client.puts "ERROR\r\n"
            end
        #else
        #    client.puts "ERROR\r\n"
        #end
    end
  end
end
