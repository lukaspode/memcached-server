
require_relative 'hash_t'
require_relative 'results'

class Commands
    def initialize
        @hash_comm = Hash.new
    end

    ### -- Retrieval Commands -- ###

    def get(key)
        result = Result.new(false,"Not value asocieted to the key:#{key}") #no es creada el Answer corregir (error pero secudnario, no requerido)
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

    #### -- Storage Commands -- ### 

    def set(data)                           # FUNCIONA FALTA EXPECTIME
        data_in = noreply_correction(data)
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            to_store = Hash_t.new(data_in[2],data_in[3],data_in[4],data_in[5],data_in[6])
            @hash_comm[data_in[1]] = to_store
            result.set_succ(true)
            result.set_data("STORED")
        end
        result
    end
    def add(data)                           # FUNCIONA FALTA EXPECTIME
        data_in = noreply_correction(data)
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] == nil
                to_store = Hash_t.new(data_in[2],data_in[3],data_in[4],data_in[5],data_in[6])
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
        result = Result.new(false,"ERROR")
        if storage_validator(data_in)
            if @hash_comm[data_in[1]] != nil
                    to_store = Hash_t.new(data_in[2],data_in[3],data_in[4],data_in[5],data_in[6])
                    @hash_comm[data_in[1]] = to_store
                    result.succ = true
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

    ### -- Validation functions -- ###
    def is_number?(number)
        true if Integer(number) rescue false 
        #return Integer(number)
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

    def key_validator(key)
        return (key.length < 250) ## && (control_character FALTA)
    end
    def flag_validator(flag)
        return (flag.length <= 16) && (is_number?(flag))
    end
    def exptime_validator(data)
        max_time = 60*60*24*30      # FALTA
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

    def msg_byte_validator(data)
        return data[4].to_i  == data[6].length
    end

    def storage_validator(data)
        return key_validator(data[1]) && flag_validator(data[2]) && bytes_validator(data[4]) && msg_byte_validator(data)
    end    
    #VER
    def noreply_correction(data)
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
end