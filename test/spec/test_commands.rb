#require_relative '../../app/server'
require_relative '../../app/commands'


RSpec.describe Commands do
    describe "Memory storage" do
        before(:each) do 
            #@mem_server = Server.new
            @mem_client = Commands.new
        end

        #############################
        ##        Set-Test         ##
        #############################

        it "Set: Simple set without 'noreply'" do
            request = "set 1 2 0 4 hola"
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED")
        end

        it "Set: Simple set with 'noreply'" do
            request = "set juan 2 0 4 noreply hola"
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED")
        end
        
        it "Set: Stored and automatically deleted" do
            request = "set pedro 2 -1 5 noreply hello"
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED")
            final_res = @mem_client.get("get #{result.data[1]}")
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("Not value associated to the key: #{result.data[1]}")
        end

        it "Set: Expectime expired and then 'get key" do
            request = "set martin 2 2 5 noreply hello"
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED")
            sleep(2.1)
            final_res = @mem_client.get("get #{result.data[1]}")
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("Not value associated to the key: #{result.data[1]}")
        end

        it "Set: bytes and data block not matching" do
            request = "set pedro 2 350 5 noreply bye"
            result = @mem_client.set(request)
            expect(result.succ).to be false
            expect(result.message).to eq("ERROR")
        end

        #############################
        ##        Get-Test         ##
        #############################

        it "Get clave 'pedro' no almacenada" do
            request = "get pedro"
            result = @mem_client.get(request)
            expect(result.succ).to be false
            expect(result.message).to eq("Not value associated to the key: #{result.data[1]}")
        end        
        it "Get clave 'juan' almacenada " do
            to_store = "set juan 2 0 4 noreply jojo"
            expect = @mem_client.set(to_store)
            request = "get #{expect.data[1]}"
            result = @mem_client.get(request)
            expect(result.succ).to be true
            expect(result.message.split[0]).to eq("VALUE")
        end

        #############################
        ##        Gets-Test        ##
        #############################





        #############################
        ##       Append-Test       ##
        #############################

        #############################
        ##       Prepend-Test      ##
        #############################
     end
end
