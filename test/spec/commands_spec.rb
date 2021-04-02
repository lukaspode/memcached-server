#require_relative '../../app/server'
require_relative '../../app/logical/commands'
require_relative '../../app/messages'


RSpec.describe Commands do
    describe "Memory storage" do
        before(:each) do 
            #@mem_server = Server.new
            @mem_client = Commands.new
        end
        # set
        subject(:set_martin) {["set", "martin", "2", "1", "4","noreply","hola"]}
        subject(:set_kristen) {["set", "kristen", "0", "2", "5","noreply","hello"]}
        subject(:set_john_not) {["set", "john", "0", "2", "3","hello"]}
        #append
        subject(:append_kristen) {["append","kristen","22","150","6","_bello"]}
        #prepend
        subject(:prepend_martin) {["prepend", "martin", "2", "2", "5","_chau"]}
        #add
        subject(:add_martin) {["add","martin","3","1","4","_bye"]}
        subject(:add_kristen) {["add","kristen","7","120","5","hello"]}
        #replace
        subject(:replace_martin) {["replace","martin","32","10","5","steve"]}
        #cas
        subject(:cas_kristen) {["cas", "kristen", "22", "2", "4","1","_bye"]}
        subject(:cas_martin) {["cas", "martin", "31", "2", "4","2","ciao"]}
        # retrivals
        subject(:get_1) {["get", "martin"]}
        subject(:gets_1) {["gets", "kristen"]}

        #############################
        ##        Set-Test         ##
        #############################

        it "Set: Simple set without 'noreply'" do
            request = ["set", "1", "2", "0", "4", "hola"]
            result = @mem_client.set(request)
            expect(result.message).to eq(STORED + LN_BREAK)
        end

        it "Set: Simple set with 'noreply'" do
            result = @mem_client.set(set_martin)
            expect(result.message).to eq(EMPTY + LN_BREAK)
        end

        it "Set: Stored and automatically deleted" do
            result = @mem_client.set(["set", "juan", "2", "-1", "4","hola"])
            final_res = @mem_client.get(["get","#{result.data[1]}"])
            expect(final_res.message).to eq(NOT_ASOCIATED + "#{result.data[1]}" + LN_BREAK)
        end

        it "Set: Expectime expired and then 'get key" do
            result = @mem_client.set(set_martin)
            sleep(1.1)
            final_res = @mem_client.get(["get", "#{result.data[1]}"])
            expect(final_res.message).to eq(NOT_ASOCIATED + "#{result.data[1]}" + LN_BREAK)
        end

        it "Set: bytes and data block not matching" do
            result = @mem_client.set(set_john_not)
            expect(result.message).to eq(ERROR + LN_BREAK)
        end

        it "Set: data block empty" do
            request = ["set","1","2","20","0"]
            result = @mem_client.set(request)
            expect(result.message).to eq(STORED + LN_BREAK)
        end

        #############################
        ##        Get-Test         ##
        #############################

        it "Get: clave 'martin' no almacenada" do
            result = @mem_client.get(get_1)
            expect(result.message).to eq(NOT_ASOCIATED + "#{result.data[1]}" + LN_BREAK)
        end        
        it "Get: clave 'martin' almacenada " do
            result = @mem_client.set(set_martin)
            final_res = @mem_client.get(get_1)
            expect(final_res.message.split[0]).to eq('VALUE')
        end
        it "Get: Multiple keys stored" do
            #First key stored
            result_1 = @mem_client.set(set_martin)
            #Second key stored
            result_2 = @mem_client.set(set_kristen)
            request = ["get","#{result_1.data[1]}","#{result_2.data[1]}"]
            final_res = @mem_client.get(request)
            expect(final_res.message.split[0] && final_res.message.split[6]).to eq('VALUE')
        end
        it "Get: Multiple keys. One key stored " do
            #First key stored
            result_1 = @mem_client.set(set_martin)
            #Second key not stored
            result_2 = @mem_client.set(set_john_not)
            request = ["get","#{result_1.data[1]}","#{result_2.data[1]}"]
            final_res = @mem_client.get(request)
            expect(final_res.message.split.length).to eq(6)
        end
        
        #############################
        ##        Gets-Test        ##
        #############################

        it "Gets: clave 'kristen' no almacenada" do
            result = @mem_client.gets(gets_1)
            expect(result.message).to eq(NOT_ASOCIATED + "#{result.data[1]}" + LN_BREAK)
        end
        it "Gets: key 'kristen' stored " do
            result = @mem_client.set(set_kristen)
            final_res = @mem_client.gets(gets_1)
            expect(final_res.message.split[5]).to eq(result.data[7])
        end
        it "Gets: Multiple keys stored" do
            #First key stored
            result_1 = @mem_client.set(set_kristen)
            #Second key stored
            result_2 = @mem_client.set(set_martin)
            request = ["gets", "#{result_1.data[1]}","#{result_2.data[2]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.message.split[0] && final_res.message.split[0]).to eq('VALUE')
        end
        it "Gets: Multiple keys. One stored" do
            #First key stored
            result_1 = @mem_client.set(set_martin)
             #Second key NOT stored
            result_2 = @mem_client.set(set_john_not)
            request = ["gets", "#{result_1.data[1]}","#{result_2.data[1]}"]
            final_res = @mem_client.gets(request)
            expect(final_res.message.split.length).to eq(7)
        end
        #############################
        ##       Append-Test       ##
        #############################

        it "Append: non-existent key" do
            result = @mem_client.append(append_kristen)
            expect(result.message).to eq(NOT_STORED + LN_BREAK)
        end

        it "Append: key 'kristen' stored " do
            result = @mem_client.set(set_kristen)
            final_res = @mem_client.append(append_kristen)
            expect(final_res.message).to eq(STORED + LN_BREAK)
        end
        
        #############################
        ##       Prepend-Test      ##
        #############################

        it "Prepend: non-existent key" do
            result = @mem_client.prepend(prepend_martin)
            expect(result.message).to eq(NOT_STORED + LN_BREAK)
        end

        it "Prepend: clave 'paul' almacenada " do
            result = @mem_client.set(set_martin)
            final_res = @mem_client.prepend(prepend_martin)
            expect(final_res.message).to eq(STORED + LN_BREAK)
        end
        #############################
        ##        Add-Test         ##
        #############################

        it "Add: non-existent key" do
            result = @mem_client.add(add_kristen)
            expect(result.succ).to be true
            expect(result.message).to eq(STORED + LN_BREAK)
        end

        it "Add: key previously stored" do
            #Key Stored
            result = @mem_client.set(set_kristen)
            final_res = @mem_client.add(add_kristen)
            expect(final_res.message).to eq(NOT_STORED + LN_BREAK)
        end

        it "Add: key almacenada previamente, luego expirada" do
            #Key Stored
            result = @mem_client.set(set_martin)
            final_res = @mem_client.add(add_martin)
            # Add existent key
            expect(final_res.message).to eq(NOT_STORED + LN_BREAK) 
            sleep(1.1)
            # Key expired
            final_res = @mem_client.add(add_martin)
            expect(final_res.message).to eq(STORED + LN_BREAK) 
        end
        
        #############################
        ##       Replace-Test      ##
        #############################

        it "Replace: non-existent" do
            result = @mem_client.replace(replace_martin)
            expect(result.message).to eq(NOT_STORED + LN_BREAK)
        end

        it "Replace: key previously stored" do
            result = @mem_client.set(set_martin)
            final_res = @mem_client.replace(replace_martin)
            expect(final_res.message).to eq(STORED + LN_BREAK)
        end

        #############################
        ##         Cas-Test        ##
        #############################

        it "Cas: non-existent" do
            result = @mem_client.cas(cas_kristen)
            expect(result.message).to eq(NOT_FOUND + LN_BREAK)
        end

        it "Cas: existent key but without token generated" do
            #Set Stored
            result = @mem_client.set(set_kristen)
            final_res = @mem_client.cas(cas_kristen)
            #Cas, token doesn't exists
            expect(final_res.message).to eq(EXISTS + LN_BREAK)
        end

        it "Cas: key existente token generado" do
            result = @mem_client.set(set_kristen)
            result_1 = @mem_client.gets(gets_1)
            #Token generated
            final_res_1 = @mem_client.cas(cas_kristen)
            expect(final_res_1.message).to eq(STORED + LN_BREAK)
        end

        #############################
        ##       Multiple-Test     ##
        #############################
        
        it "Two keys stored, token generated and then 'cas'" do
            #First key stored
            result_1 = @mem_client.set(set_kristen)
            #Second key stored
            result_2 = @mem_client.set(set_martin)
            #token
            request = ["gets", "#{result_1.data[1]}","#{result_2.data[1]}"]
            @mem_client.gets(request)
            #cas
            final_res_1 = @mem_client.cas(cas_kristen)
            final_res_2 = @mem_client.cas(cas_martin)
            expect(final_res_1.message && final_res_2.message).to eq(STORED + LN_BREAK)
        end
      end
    end
