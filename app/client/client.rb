require 'socket'

client_connection = TCPSocket.open('localhost', 3000)

client = client_connection.gets("\n").chomp("\n")
puts "message #{client}"

#welcome
line = client_connection.gets
puts "#{line}"

#set key and then get it
client_connection.puts( "set kristen 2 1 5\r\nhello\r\n")
response = client_connection.gets( "\n" ).chomp( "\n" )
puts "Received by the client: #{response}"
client_connection.puts( "get kristen\r\n")
puts "Received by the client:"
line = client_connection.gets
puts "#{line}"
line = client_connection.gets
puts "#{line}"
line = client_connection.gets
puts "#{line}"

#key expires
sleep(1.1)

#not stored
client_connection.puts( "set kristen 2 1 3\r\n_hola\r\n")
response = client_connection.gets( "\n" ).chomp( "\n" )
puts "Received by the client:#{response}"

#not value associated
client_connection.puts( "get kristen\r\n")
puts "Received by the client:"
line = client_connection.gets
puts "#{line}"

#disconnection
client_connection.puts( "q\r\n")
puts "Received by the client:"
line = client_connection.gets
puts "#{line}"
line = client_connection.gets
puts "#{line}"

client_connection.close