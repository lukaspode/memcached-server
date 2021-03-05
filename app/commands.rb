
require_relative 'hash_t'

class Commands
    def initialize
        @hash_comm = Hash.new
    end

    def check_input_commands_st(data)       # Cehck amount of commands - STORAGE
        if data.split.length != 7
            result = false            
        else
            result = true
        end
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
        if (@hash_comm[key] != nil)
            result = "VALUE #{key} #{@hash_comm[key].flag()} #{@hash_comm[key].bytes()}\r\n #{@hash_comm[key].msg()}\r\n END\r\n"
        end
    end

    def gets(key)
        ### FALTA
    end

    #### -- Storage Commands -- ### 

    def set(key,flag,expectime,bytes,noreply,msg)
        to_store = Hash_t.new(flag,expectime,bytes,noreply,msg)
        @hash_comm[key] = to_store
    end
    def add(key,flag,expectime,bytes,noreply,msg)
       if @hash_comm[key] == nil
        to_store = Hash_t.new(flag,expectime,bytes,noreply,msg)
        @hash_comm[key] = to_store
       end
    end
    def append(key,data)
        if @hash_comm[key] != nil
                        
        end
        
    end
    def prepend(key,data)
        
    end
    def replace(key,data)
        
    end
    def cas(key,data)
        
    end
end