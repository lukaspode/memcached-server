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
            request = ["set", "1", "2", "0", "4", "hola"]
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
        end

        it "Set: Simple set with 'noreply'" do
            request = ["set", "juan", "2", "0", "4","noreply","hola"]
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
        end
        
        it "Set: Stored and automatically deleted" do
            request = ["set", "pedro", "2", "-1", "5","noreply","hello"] 
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            final_res = @mem_client.get(["get","#{result.data[1]}"])
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("Not value associated to the key: #{result.data[1]}\r\n")
        end

        it "Set: Expectime expired and then 'get key" do
            request = ["set", "martin", "2", "2", "5","noreply","hello"] 
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            sleep(2.1)
            final_res = @mem_client.get(["get", "#{result.data[1]}"])
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("Not value associated to the key: #{result.data[1]}\r\n")
        end

        it "Set: bytes and data block not matching" do
            request = ["set","pedro","2","350","5","noreply","bye"]
            result = @mem_client.set(request)
            expect(result.succ).to be false
            expect(result.message).to eq("ERROR\r\n")
        end

        it "Set: data block empty" do
            request = ["set","1","2","20","0"]
            result = @mem_client.set(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            final_res = @mem_client.get(["get", "#{result.data[1]}"])
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end

        #############################
        ##        Get-Test         ##
        #############################

        it "Get: clave 'pedro' no almacenada" do
            request = ["get","pedro"]
            result = @mem_client.get(request)
            expect(result.succ).to be false
            expect(result.message).to eq("Not value associated to the key: #{result.data[1]}\r\n")
        end        
        it "Get: clave 'juan' almacenada " do
            to_store = ["set","juan","2","0","5","noreply","lopez"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            request = ["get","#{result.data[1]}"]
            final_res = @mem_client.get(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        it "Get: Multiple keys stored" do
            to_store = ["set","juan","2","0","5","noreply","lopez"]     #First key stored
            result_1 = @mem_client.set(to_store)
            expect(result_1.succ).to be true
            expect(result_1.message).to eq("STORED\r\n")
            to_store = ["set","martin","2","0","5","noreply","lopez"]     #Second key stored
            result_2 = @mem_client.set(to_store)
            expect(result_2.succ).to be true
            expect(result_2.message).to eq("STORED\r\n")
            request = ["get","#{result_1.data[1]}","#{result_2.data[2]}"]
            final_res = @mem_client.get(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        it "Get: Multiple keys. One key stored " do
            to_store = ["set","juan","2","0","5","noreply","lopez"]     #First key stored
            result_1 = @mem_client.set(to_store)
            expect(result_1.succ).to be true
            expect(result_1.message).to eq("STORED\r\n")
            to_store = ["set","martin","2","0","5","noreply","lope"]     #Second key not stored
            result_2 = @mem_client.set(to_store)
            expect(result_2.succ).to be false
            expect(result_2.message).to eq("ERROR\r\n")
            request = ["get","#{result_1.data[1]}","#{result_2.data[2]}"]
            final_res = @mem_client.get(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        
        #############################
        ##        Gets-Test        ##
        #############################

        it "Gets: clave 'john' no almacenada" do
            request = ["gets","john"]
            result = @mem_client.gets(request)
            expect(result.succ).to be false
            expect(result.message).to eq("Not value associated to the key: #{result.data[1]}\r\n")
        end
        it "Gets: key 'john' stored " do
            to_store = ["set","john","20","300","6","lennon"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            request = ["gets","#{result.data[1]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end  
        it "Gets: key 'john' stored with nonreply" do
            to_store = ["set","john","10","0","6","noreply","lennon"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            request = ["gets", "#{result.data[1]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        it "Gets: Multiple keys stored" do
            to_store = ["set","juan","2","0","5","noreply","lopez"]     #First key stored
            result_1 = @mem_client.set(to_store)
            expect(result_1.succ).to be true
            expect(result_1.message).to eq("STORED\r\n")
            to_store = ["set","martin","2","0","5","noreply","lopez"]     #Second key stored
            result_2 = @mem_client.set(to_store)
            expect(result_2.succ).to be true
            expect(result_2.message).to eq("STORED\r\n")
            request = ["gets", "#{result_1.data[1]}","#{result_2.data[2]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        it "Gets: Multiple keys. One stored" do
            to_store = ["set","juan","2","0","5","noreply","lopez"]     #First key stored
            result_1 = @mem_client.set(to_store)
            expect(result_1.succ).to be true
            expect(result_1.message).to eq("STORED\r\n")
            to_store = ["set","martin","2","0","5","noreply","lope"]     #Second key NOT stored
            result_2 = @mem_client.set(to_store)
            expect(result_2.succ).to be false
            expect(result_2.message).to eq("ERROR\r\n")
            request = ["gets", "#{result_1.data[1]}","#{result_2.data[2]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.succ).to be true
            expect(final_res.message.split[0]).to eq("VALUE")
        end
        #############################
        ##       Append-Test       ##
        #############################

        it "Append: key no existente" do
            request = ["append","paul","22","150","9","noreply","mccartney"]
            result = @mem_client.append(request)
            expect(result.succ).to be false
            expect(result.message).to eq("NOT_STORED\r\n")
        end

        it "Append: clave 'paul' almacenada " do
            to_store = ["set","paul","10","0","9","noreply","mccartney"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            request = ["append","#{result.data[1]}","2","430","6","_music"]
            final_res = @mem_client.append(request)
            expect(final_res.succ).to be true
            expect(final_res.message).to eq("STORED\r\n")
        end
        
        #############################
        ##       Prepend-Test      ##
        #############################

        it "Prepend: key no existente" do
            request = ["prepend","paul","12","10","9","mccartney"]
            result = @mem_client.prepend(request)
            expect(result.succ).to be false
            expect(result.message).to eq("NOT_STORED\r\n")
        end

        it "Prepend: clave 'paul' almacenada " do
            to_store = ["set","paul","10","0","9","mccartney"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
            request = ["prepend","#{result.data[1]}","2","430","6","_music"]
            final_res = @mem_client.prepend(request)
            expect(final_res.succ).to be true
            expect(final_res.message).to eq("STORED\r\n")
        end
        #############################
        ##        Add-Test         ##
        #############################

        it "Add: key no existente" do
            request = ["add","lucas","7","120","5","hello"]
            result = @mem_client.add(request)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n")
        end

        it "Add: key almacenada previamente" do
            to_store = ["set","lucas","10","0","9","mccartney"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n") #Set Stored
            request = ["add","lucas","7","120","5","hello"]
            final_res = @mem_client.add(request)
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("NOT_STORED\r\n") #Add not Stored, key already exists
        end

        it "Add: key almacenada previamente, luego expirada" do
            to_store = ["set","lucas","10","1","9","mccartney"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n") #Set Stored
            request = ["add","lucas","7","120","5","hello"]
            final_res = @mem_client.add(request)
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("NOT_STORED\r\n") # Add key already exists
            sleep(1.1)
            request = ["add","lucas","7","120","5","hello"]
            final_res = @mem_client.add(request)
            expect(final_res.succ).to be true
            expect(final_res.message).to eq("STORED\r\n") # Key expired, Add Stored
        end
        
        #############################
        ##       Replace-Test      ##
        #############################

        it "Replace: key no existente" do
            request = ["replace","lucas","7","120","5","hello"]
            result = @mem_client.replace(request)
            expect(result.succ).to be false
            expect(result.message).to eq("NOT_STORED\r\n")
        end

        it "Replace: key almacenada previamente" do
            to_store = ["set","lucas","10","0","9","mccartney"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n") #Set Stored
            request = ["add","lucas","7","120","5","hello"]
            final_res = @mem_client.replace(request)
            expect(final_res.succ).to be true
            expect(final_res.message).to eq("STORED\r\n") #Replace Stored
        end

        #############################
        ##         Cas-Test        ##
        #############################

        it "Cas: key no existente" do
            request = ["cas","kristen","6","110","5","1","hello"]
            result = @mem_client.cas(request)
            expect(result.succ).to be false
            expect(result.message).to eq("NOT_FOUND\r\n")
        end

        it "Cas: key existente token NO generado" do
            to_store = ["set","kristen","10","0","2","hi"]
            result = @mem_client.set(to_store)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n") #Set Stored
            request = ["cas","kristen","6","110","5","1","hello"]
            final_res = @mem_client.cas(request)
            expect(final_res.succ).to be false
            expect(final_res.message).to eq("EXISTS\r\n") #Cas, token doesn't exists
        end

        it "Cas: key existente token generado" do
            to_store_1 = ["set","kristen","10","0","2","hi"]
            result = @mem_client.set(to_store_1)
            expect(result.succ).to be true
            expect(result.message).to eq("STORED\r\n") #Set Stored
            to_store_2 = ["gets","#{result.data[1]}"]
            result_1 = @mem_client.gets(to_store_2)
            expect(result_1.succ).to be true
            expect(result_1.message.split[0]).to eq("VALUE") #Token generated
            request = ["cas","kristen","6","110","5","#{result_1.data[5]}","hello"]
            final_res_1 = @mem_client.cas(request)
            expect(final_res_1.succ).to be true
            expect(final_res_1.message).to eq("STORED\r\n") #Cas Stored
        end
     end

        #############################
        ##       Multiple-Test     ##
        #############################
        
end
