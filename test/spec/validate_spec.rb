#require_relative '../../app/server'
require_relative '../../app/logical/validate'
require_relative '../../app/messages'


    RSpec.describe Validate do
      describe "Validations" do
        before(:each) do 
          #@mem_server = Server.new
          @validations = Validate.new
        end
        subject(:set_true) {["set", "john", "2", "1", "4","noreply","hola"]}
        subject(:set_false) {["set", "natalie", "0","hello"]}
        #Cas
        subject(:cas_true) {["cas", "john", "12", "1", "4","1","noreply","hola"]}
        subject(:cas_false) {["cas", "natalie", "2", "1","hola"]}
        #Ret
        subject(:get_true) {["get", "john"]}
        subject(:get_false) {["get"]}
        subject(:gets_true) {["gets", "natlaie"]}
        subject(:gets_false) {["gets"]}


        #############################
        ##        is number?       ##
        #############################

        it "is number? true" do
          request = 12
          result = @validations.is_number?(request)
          expect(result).to eq(true)
        end
        it "is number? string true" do
          request = '32'
          result = @validations.is_number?(request)
          expect(result).to eq(true)
        end
        it "is number? letter" do
          request = 'hola'
          result = @validations.is_number?(request)
          expect(result).to eq(false)
        end
        
        #############################
        ##       unsigend int      ##
        #############################
        it "unsigned number true" do
          request = 32
          result = @validations.unsigned_int(request)
          expect(result).to eq(true)
        end
        it "unsigned string true" do
          request = '32'
          result = @validations.unsigned_int(request)
          expect(result).to eq(true)
        end
        it "unsigned number false" do
            request = -32
            result = @validations.unsigned_int(request)
            expect(result).to eq(false)
        end
        it "unsigned string false" do
          request = '-32'
          result = @validations.unsigned_int(request)
          expect(result).to eq(false)
        end
        it "unsigned word false" do
          request = 'hola'
          result = @validations.unsigned_int(request)
          expect(result).to eq(false)
        end
        #############################
        ##    check input length   ##
        #############################

            #Set
        it "Storage-Set: length 7, true" do
          result = @validations.check_input_commands_st(set_true)
          expect(result).to eq(true)
        end
        it "Storage-Set: length 4, false" do
          result = @validations.check_input_commands_st(set_false)
          expect(result).to eq(false)
        end

            #Cas
        it "Storage-Cas: length 8, true" do
          result = @validations.check_input_commands_cas(cas_true)
          expect(result).to eq(true)
        end
        it "Storage-Cas: length 8, false" do
            result = @validations.check_input_commands_cas(cas_false)
            expect(result).to eq(false)
        end

            #Get-Gets
        it "Storage-Get: length 2, true" do
          result = @validations.check_input_commands_ret(get_true)
          expect(result).to eq(true)
        end
        it "Storage-Get: length 1, false" do
          result = @validations.check_input_commands_ret(get_false)
          expect(result).to eq(false)
        end
        it "Storage-Gets: length 2, true" do
          result = @validations.check_input_commands_ret(gets_true)
          expect(result).to eq(true)
        end
        it "Storage-Gets: length 1, false" do
          result = @validations.check_input_commands_ret(gets_false)
          expect(result).to eq(false)
        end
      end
    end
