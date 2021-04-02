#require_relative '../../app/server'
require_relative '../../app/logical/validate'
require_relative '../../app/messages'


    RSpec.describe Validate do
      describe "Validations" do
        before(:each) do 
          #@mem_server = Server.new
          @validations = Validate.new
        end
        #set
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
        #noreply
        subject(:noreply_true) {["append", "john", "2", "1", "4","noreply","haha"]}
        subject(:noreply_not) {["append", "john", "2", "1", "4","haha"]}
        subject(:noreply_wrong) {["append", "john", "2", "1", "4","norely","haha"]}

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
        it "Storage: Arg length 7, true" do
          result = @validations.check_input_length(set_true)
          expect(result).to eq(true)
        end
        it "Storage: Arg length 4, false" do
          result = @validations.check_input_length(set_false)
          expect(result).to eq(false)
        end

            #Cas
        it "Storage-Cas: Arg length 8, true" do
          result = @validations.check_input_length(cas_true)
          expect(result).to eq(true)
        end
        it "Storage-Cas: Arg length 8, false" do
            result = @validations.check_input_length(cas_false)
            expect(result).to eq(false)
        end

            #Get-Gets
        it "Ret-Get: Arg length 2, true" do
          result = @validations.check_input_length(get_true)
          expect(result).to eq(true)
        end
        it "Ret-Get: Arg length 1, false" do
          result = @validations.check_input_length(get_false)
          expect(result).to eq(false)
        end
        it "Ret-Gets: Arg length 2, true" do
          result = @validations.check_input_length(gets_true)
          expect(result).to eq(true)
        end
        it "Ret-Gets: Arg length 1, false" do
          result = @validations.check_input_length(gets_false)
          expect(result).to eq(false)
        end

        #############################
        ##   Argument validations  ##
        #############################

          #key
        it "key is a string: true" do
          result = @validations.key_validator(set_true[1])
          expect(result).to eq(true)
        end
        it "key is a number,  true" do
          request = '12'
          result = @validations.key_validator(request)
          expect(result).to eq(true)
        end

          #flag
        it "flag is a number, true" do
          request = '26'
          result = @validations.flag_validator(request)
          expect(result).to eq(true)
        end
        it "flag is a negative number, false" do
          request = '-26'
          result = @validations.flag_validator(request)
          expect(result).to eq(false)
        end
        it "flag positive number but length exceeded, false" do
          request = '41453214568723125'
          result = @validations.flag_validator(request)
          expect(result).to eq(false)
        end

          #expectime
        it "Is a positive number, true" do
          request = '6'
          result = @validations.exptime_validator(request)
          expect(result).to eq(true)
        end
        it "Is a negative number, true" do
          request = '-2'
          result = @validations.exptime_validator(request)
          expect(result).to eq(true)
        end
        it "Is 0, true" do
          request = '0'
          result = @validations.exptime_validator(request)
          expect(result).to eq(true)
        end
        it "Is a string, false" do
          request = 'hello'
          result = @validations.bytes_validator(request)
          expect(result).to eq(false)
        end
      
        #byte_validator
        it "Is a string, false" do
          request = 'hello'
          result = @validations.bytes_validator(request)
          expect(result).to eq(false)
        end
        it "Is a number but larger than 256, false" do
          request = '2546'
          result = @validations.bytes_validator(request)
          expect(result).to eq(false)
        end
        it "Is a number, true" do
          request = '5'
          result = @validations.bytes_validator(request)
          expect(result).to eq(true)
        end
        #datablock
        it "larger than 256, false" do
          request = 'Memcached_is_an_open_source,_high-performance,_distributed_memory__object_caching_system._This_tutorial_provides__a_basic__understanding_of_all_the_relevant_concepts_of_Memcached_needed_to__create_and_deploy_a__highly_scalable_and_performance-oriented_system.'
          result = @validations.datablock_validator(request)
          expect(result).to eq(false)
        end
        it "smaller than 256, true" do
          request = '_hello'
          result = @validations.datablock_validator(request)
          expect(result).to eq(true)
        end
        #noreply_validator noreply_correction
        it "'noreply' included, true" do
          request = @validations.noreply_correction(noreply_true,false)
          result = @validations.noreply_validator(request)
          expect(result).to eq(true)
        end
        it "'noreply' not included, true" do
          request = @validations.noreply_correction(noreply_not,false)
          result = @validations.noreply_validator(request)
          expect(result).to eq(true)
        end
        it "'noreply' misspelled, false" do
          request = @validations.noreply_correction(noreply_wrong,false)
          result = @validations.noreply_validator(request)
          expect(result).to eq(false)
        end
        #msg-byte - noreply_correction
        it "msg and byte matching, true" do
          request = @validations.noreply_correction(set_true,false)
          result = @validations.msg_byte_validator(request)
          expect(result).to eq(true)
        end
        it "msg and byte matching, true" do
          request = @validations.noreply_correction(['set', 'olivia', '22', '3', '3','hola'],false)
          result = @validations.msg_byte_validator(request)
          expect(result).to eq(false)
        end
      end
    end
