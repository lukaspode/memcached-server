
# LUCAS PODESTA - Memcached Server

require 'socket'
require_relative 'petitions'


class Server

    def initialize
      @PORT = 3000
      @server =  TCPServer.new(@PORT)
      @client_petitions = Petitions.new 
      puts "Server running on port: #{@PORT}"
    end
        
    def new_client_connection(new_client)
      new_client.puts "Client connected to localhost: #{@PORT}\r\n"
      new_client.puts 'Waiting for your requests:\r\n'
    end

    def client_desconnection(quit_client)
      quit_client.puts 'Disconnecting from the Server...\r\n'
      sleep(0.6)
      quit_client.printf 'Client disconnected.'
      sleep(0.9)
      quit_client.close
    end

    # Ver si usar patron
    def run
      loop do
        Thread.start(@server.accept) do |client|
          new_client_connection(client)
            while console_input = client.gets
              request = console_input.split[0]
              user_input = console_input.split
              case request
                # <----- Retrieval commands ------>
              when "get"
                answer = @client_petitions.get(user_input)
                client.puts "#{answer.message}"
              when "gets"
                answer = @client_petitions.gets(user_input)
                client.puts "#{answer.message}"
                # <------ Storage commands ------->
              when "set"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.set(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
              when "add"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.add(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
              when "replace"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.replace(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
              when "append"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.append(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
              when "prepend"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.prepend(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
              when "cas"
                data_block = client.gets( "\r\n" ).chomp( "\r\n" )
                user_input.push(data_block)
                answer = @client_petitions.cas(user_input)
                if(!answer.noreply)
                  client.puts "#{answer.message}"
                end
                # <-------- QUIT ----------->
              when "q"                       
                client_desconnection(client)
              else
                client.puts 'ERROR Command not found or supported.\r\n'
              end
            end
        end
      end
    end
  end

memcached_server = Server.new()
memcached_server.run
