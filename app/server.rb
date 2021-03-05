
# LUCAS PODESTA First Test

require 'socket'
require_relative 'commands'

PORT = 3000
server =  TCPServer.new(PORT)
puts "Server running on #{PORT}"
command = Commands.new


loop do
  Thread.start(server.accept) do |client|
    client.puts "Client connected to localhost:#{PORT}"
    client.puts "input format: add 10 12 33"

    #request = client.gets
    while user_input = client.gets
        request = user_input.split[0]
        client.puts "#{request}"
        #client.puts "Command entered #{request}"
        if (request.chomp == "get" || request.chomp == "gets")
            control = command.check_input_commands_ret(user_input)
        else
            control = command.check_input_commands_st(user_input)
        end
        if control
            case request.chomp
            when "get"                   # <----- Retrieval commands ------>
                if command.check_input_commands_ret(user_input)
                    answer = command.get(user_input.split[1])
                    client.puts "#{answer}"
                else
                    client.puts "ERROR\r\n"
                end
            when "gets"
                if command.check_input_commands_ret(user_input)
                    client.puts "GETS_GETS"
                else
                    client.puts "ERROR\r\n"
                end
            when "set"                    # <------ Storage commands ------->
                if command.check_input_commands_st(user_input)
                    command.set(user_input.split[1],user_input.split[2],user_input.split[3],user_input.split[4],user_input.split[5],user_input.split[6])
                else
                    client.puts "ERROR\r\n"
                end
            when "add"
                if command.check_input_commands_st(user_input)
                    command.add(user_input.split[1],user_input.split[2],user_input.split[3],user_input.split[4],user_input.split[5],user_input.split[6])
                else
                    client.puts "ERROR\r\n"
                end
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
                client.puts "ERROR\r\n"
            end
        else
            client.puts "ERROR\r\n"
        end
    end
  end
end
