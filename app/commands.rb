
require_relative 'hash_t'
require_relative 'results'

class Commands
    def initialize
        @hash_comm = Hash.new
    end

    def check_input_commands_st(data)       # Cehck amount of commands - STORAGE
        data.split.length == 7
    end
    def check_input_commands_ret(data)       # Cehck amount of commands - RETRIEVAL
        if data.split.length != 2
            result = false            
        else
            result = true
        end
    end

    ### -- Retrieval Commands -- ###

    def get(key)
        result = Result.new(false,"valor no encontrado")
        if (@hash_comm[key] != nil)
            data = "VALUE #{key} #{@hash_comm[key].flag()} #{@hash_comm[key].bytes()}\r\n #{@hash_comm[key].msg()}\r\n END\r\n"
            result.data = data
            result.succ = true
        end
        result
    end

    def gets(key)
        ### FALTA
    end

    #### -- Storage Commands -- ### 

    def set(data)
        data_in = data.split
        to_store = Hash_t.new(data_in[2],data_in[3],data_in[4],data_in[5],data_in[6])
        @hash_comm[data_in[1]] = to_store
    end
    def add(data)
        result = Result.new(false," ")
        data_in = data.split
       if @hash_comm[data_in[1]] == nil
            to_store = Hash_t.new(data_in[2],data_in[3],data_in[4],data_in[5],data_in[6])
            @hash_comm[data_in[1]] = to_store
            result.succ = true
       end
       result
    end
    def append(data)
        result = Result.new(false," ")
        data_in = data.split
        if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = @hash_comm[data_in[1]].msg + data.split[6]
            result.succ = true
        end
        result
    end
    def prepend(data)
        result = Result.new(false," ")
        data_in = data.split
        if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = data.split[6] + @hash_comm[data_in[1]].msg
            result.succ = true
        end
        result
    end
    def replace(key,data)
        
    end
    def cas(key,data)
        
    end
end