
require_relative 'hash_t'
require_relative 'results'

class Commands
    def initialize
        @hash_comm = Hash.new
        #@keys_stored = {}
    end

    #### ------------------------ #### 
    #### -- Retrieval Commands -- ####
    #### ------------------------ #### 

    def get(key)
        result = Result.new(false,"Not value associated to the key: #{key}") #no es creada el Answer corregir (error pero secudnario, no requerido)
        remove_expired_keys()
        if (@hash_comm[key] != nil)
            data = "VALUE #{key} #{@hash_comm[key].flag()} #{@hash_comm[key].bytes()}\r\n #{@hash_comm[key].msg()}\r\n END\r\n"
            result.data = data
            result.succ = true
        end
        result
    end
    def gets(key)
        ## -----   FALTA   --------
    end

    #### ---------------------- ####
    #### -- Storage Commands -- ####
    #### ---------------------- #### 

    def set(data)                           # FUNCIONA 
        data_in = noreply_correction(data)
        remove_expired_keys()
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            to_store = Hash_t.new(data_in[2],expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6])
            @hash_comm[data_in[1]] = to_store
            result.set_succ(true)
            result.set_data("STORED")
        end
        result
    end
    def add(data)                           # FUNCIONA 
        data_in = noreply_correction(data)
        remove_expired_keys()
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] == nil
                to_store = Hash_t.new(data_in[2],expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6])
                @hash_comm[data_in[1]] = to_store
                result.set_succ(true)
                result.set_data("STORED")
            else
                result.set_data("NOT_STORED")
            end
        end
        result
    end
    #The append and prepend commands do not accept flags or exptime.They update existing data portions, and ignore new flag and exptime settings.
    def append(data)
        data_in = noreply_correction(data)
        remove_expired_keys()
        result = Result.new(false,"CLIENT_ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                @hash_comm[data_in[1]].msg = @hash_comm[data_in[1]].msg + data_in[6]
                result.set_succ(true)
                result.set_data("STORED")
            else
                result.set_data("NOT_STORED")
            end
        end
        result
    end
    def prepend(data)
        data_in = noreply_correction(data)
        remove_expired_keys()
        result = Result.new(false,"CLIENT_ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                @hash_comm[data_in[1]].msg = data_in[6] + @hash_comm[data_in[1]].msg
                result.succ = true
                result.set_data("STORED")
            else
                result.set_data("NOT_STORED")
            end
        end
        result
    end
    def replace(data)
        data_in = noreply_correction(data)
        remove_expired_keys()
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                to_store = Hash_t.new(data_in[2],expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6])
                @hash_comm[data_in[1]] = to_store
                puts "#{@hash_comm[data_in[1]].flag}"
                result.set_succ(true)
                result.set_data("STORED")
            else
                result.set_data("NOT_STORED")
            end
        end
       result
    end
    def cas(data)
        ## -----   FALTA   --------
    end

    #### ------------------------ #### 
    ## --- Validation functions --- ##
    #### ------------------------ #### 
    def is_number?(number)
        true if Integer(number) rescue false 
        #return Integer(number)
    end
    def unsigned_int(number)
        return is_number?(number) && number.to_i>=0        
    end
    def check_input_commands_st(data)       # Check amount of commands - STORAGE
        res1 = data.split.length == 5
        res2 = data.split.length == 6
        res3 = data.split.length == 7
        return res1 || res2 || res3
    end
    def check_input_commands_ret(data)       # Check amount of commands - RETRIEVAL
        res = data.split.length == 2
        return res
    end
    def check_input_commands_cas(data)       # Check amount of commands - CAS
        res1 = data.split.length == 5
        res2 = data.split.length == 6
        res3 = data.split.length == 7
        res4 = data.split.length == 8
        return res1 || res2 || res3 || res4
    end

    def key_validator(key)
        return (key.length < 250) ## && (control_character FALTA)
    end
    def flag_validator(flag)
        return (flag.length <= 16) && (unsigned_int(flag))
    end
    def exptime_validator(data)
        return is_number?(data)
    end
    def bytes_validator(bytes)
        return (bytes.length <= 8) && (is_number?(bytes))
    end
    def datablock_validator(data)
        return (data.length <= 8)
    end
    def noreply_validator(data)
        return (data == "noreply" || data == nil)
    end

    def msg_byte_validator(data)            # Check match between Bytes and DataBlock
        return data[4].to_i  == data[6].length
    end

    def storage_validator(data)             # Check Input requirments
        return key_validator(data[1]) && flag_validator(data[2]) && exptime_validator(data[3]) && bytes_validator(data[4]) && msg_byte_validator(data)
    end    
    
    def noreply_correction(data)            # User input standar to Array of length 7
        nuevo = [data.split[0], data.split[1], data.split[2], data.split[3], data.split[4], "", ""]
        if data.split.length == 6
            if data.split[5] != "noreply"
                nuevo[6] = data.split[5]
                nuevo[5] = ""
            else
                nuevo[5] = "noreply"
            end
        elsif data.split.length == 7
            nuevo[5] = data.split[5]    
            nuevo[6] = data.split[6]    
        end
        nuevo
    end
    
    def expectime_correction(data)          # Expectime input converted 
        max_time = 60*60*24*30
        time_now = Time.now.to_i
        result = 0
        if 0 < data.to_i && data.to_i <= max_time
            result = data.to_i + time_now
        elsif data.to_i> max_time || data.to_i < 0
            result = data
        else data.to_i == 0
            result = data.to_i
        end
        result
    end

    def remove_expired_keys()
        time_now = Time.now.to_i
        @hash_comm.each do |key,data|
            if data.expectime.to_i > 0 || data.expectime.to_i < 0
                if (data.expectime.to_i - time_now) <= 0
                    @hash_comm.delete(key)
                end
            end
        end
    end
end