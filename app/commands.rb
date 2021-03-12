
require_relative 'hash_t'
require_relative 'validations'
require_relative 'results'

class Commands
    def initialize
        @hash_comm = Hash.new
        @validations = Validate.new
        @token_stored = 0
    end

    #### ------------------------ #### 
    ###  -- Retrieval Commands --  ###
    #### ------------------------ #### 
    
    def get(data)
        data_in = @validations.noreply_correction(data)
        number_keys = data.length
        result = Result.new(false,data_in,"") 
        @validations.remove_expired_keys(@hash_comm)
        for i in 1..number_keys do
            key = data[i]
            if (@hash_comm[key] != nil)
                data_m = "VALUE #{key} #{@hash_comm[key].flag()} #{@hash_comm[key].bytes()}\r\n#{@hash_comm[key].msg()}\r\nEND\r\n"
                result.add_message(data_m)
                result.succ = true
            end
        end
        if result.succ == false
            result.set_message("Not value associated to the key: #{data[1]}\r\n")
        end
        result
    end
    def gets(data)
        data_in = @validations.noreply_correction(data)
        number_keys = data.length
        result = Result.new(false,data_in,"")
        @validations.remove_expired_keys(@hash_comm)
        for i in 1..number_keys do
            key = data[i]
            if (@hash_comm[key] != nil)
                @hash_comm[key].unique_cas_token =  @validations.generate_token(@hash_comm[key],@token_stored)
                data_in[5] = @hash_comm[key].unique_cas_token
                data_m = "VALUE #{key} #{@hash_comm[key].flag()} #{@hash_comm[key].bytes()} #{@hash_comm[key].unique_cas_token()}\r\n#{@hash_comm[key].msg()}\r\nEND\r\n"
                result.add_message(data_m)
                result.succ = true
            end
        end
        if result.succ == false
            result.set_message("Not value associated to the key: #{data[1]}\r\n")
        end
        result
    end

    #### ---------------------- ####
    ###  -- Storage Commands --  ###
    #### ---------------------- #### 

    def set(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"ERROR")
        if @validations.storage_validator(data_in)
            to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]), data_in[4],data_in[5],data_in[6],data_in[7])
            @hash_comm[data_in[1]] = to_store
            result.set_succ(true)
            result.set_message("STORED")
        end
        result
    end
    def add(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"ERROR")
        if @validations.storage_validator(data_in)
            if @hash_comm[data_in[1]] == nil
                to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
                @hash_comm[data_in[1]] = to_store
                result.set_succ(true)
                result.set_message("STORED")
            else
                result.set_message("NOT_STORED")
            end
        end
        result
    end
    def replace(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"ERROR")
        if @validations.storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
                @hash_comm[data_in[1]] = to_store
                result.set_succ(true)
                result.set_message("STORED")
            else
                result.set_message("NOT_STORED")
            end
        end
       result
    end
    #The append and prepend commands do not accept flags or exptime.They update existing data portions, and ignore new flag and exptime settings.
    def append(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"CLIENT_ERROR")
        if @validations.storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                @hash_comm[data_in[1]].msg = @hash_comm[data_in[1]].msg + data_in[7]
                result.set_succ(true)
                result.set_message("STORED")
                result.set_data(data_in)
            else
                result.set_message("NOT_STORED")
            end
        end
        result
    end
    def prepend(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"CLIENT_ERROR")
        if @validations.storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                @hash_comm[data_in[1]].msg = data_in[7] + @hash_comm[data_in[1]].msg
                result.succ = true
                result.set_message("STORED")
            else
                result.set_message("NOT_STORED")
            end
        end
        result
    end
    def cas(data)
        token = data[5].to_i
        data_in = @validations.noreply_correction_cas(data)
        data_in[5] = token
        @validations.remove_expired_keys(@hash_comm)
        result = Result.new(false,data_in,"ERROR")
        if @validations.storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil 
                if @hash_comm[data_in[1]].unique_cas_token.to_i == token
                    to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
                    @hash_comm[data_in[1]] = to_store
                    result.set_succ(true)
                    result.set_message("STORED")
                else
                    result.set_message("EXISTS")
                end
            else
                result.set_message("NOT_FOUND")
            end
        end
        result
    end
    
end