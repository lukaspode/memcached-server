
# LUCAS PODESTA - Memcached Server

require 'socket'
require_relative 'client'
require_relative 'validations'


class Server

    def initialize
        @PORT = 3000
        @server =  TCPServer.new(@PORT)
        @validations = Validate.new
        @clients_connections = []
        puts "Server running on port: #{@PORT}"
    end
        
    def new_client_connection(new_client)
        new_client.puts "Client connected to localhost: #{@PORT}\r\n"
        new_client.puts "Waiting for your requests:\r\n"
        @clients_connections.push(new_client)
        puts "New connection detected! Clients connected: #{@clients_connections.length}"
    end

    def client_desconnection(quit_client)
        quit_client.puts "Disconnecting from the Server...\r\n"
        sleep(0.6)
        quit_client.printf "Client disconnected."
        sleep(0.9)
        @clients_connections.pop
        puts "New connection detected! Clients connected: #{@clients_connections.length}"
        quit_client.close
    end

    # Ver si usar patron
    def run
        loop do
        Thread.start(@server.accept) do |client|
            new_client_connection(client)
            new_client = Client.new 
            while console_input = client.gets
                request = console_input.split[0]
                user_input = console_input.split
                case request #.chomp rompe cuando comando vacio, sin chomp no carga con espacio al final?
                when "get"                                          # <----- Retrieval commands ------>
                    if @validations.check_input_commands_ret(user_input)
                        answer = new_client.get(user_input)
                        client.puts "#{answer.message}"
                    else
                        client.puts "ERROR\r\nWrong number of parameters\r\n"
                    end
                when "gets"
                    if @validations.check_input_commands_ret(user_input)
                        answer = new_client.gets(user_input)
                        client.puts "#{answer.message}"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "set"                                          # <------ Storage commands ------->
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_st(user_input)
                        answer = new_client.set(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "add"
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_st(user_input)
                        answer = new_client.add(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "replace"
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_st(user_input)
                        answer = new_client.replace(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "append"
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_st(user_input)
                        answer = new_client.append(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "prepend"
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_st(user_input)
                        answer = new_client.prepend(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "cas"
                    data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                    user_input.push(data_block)
                    if @validations.check_input_commands_cas(user_input)
                        answer = new_client.cas(user_input)
                        client.puts "#{answer.message}\r\n"
                    else
                        client.puts "ERROR\r\nWrong number of parameters \r\n"
                    end
                when "q"                       # <-------- QUIT ----------->
                    client_desconnection(client)
                else
                    client.puts "ERROR\r\nCommand not found or supported.\r\n"
                end
            end
        end
        end
    end
end

memcached_server = Server.new()
memcached_server.run
