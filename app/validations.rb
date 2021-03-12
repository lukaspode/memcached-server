class Validate
    def is_number?(number)
        true if Integer(number) rescue false 
        #return Integer(number)
    end
    def unsigned_int(number)
        return is_number?(number) && number.to_i>=0        
    end
    def check_input_commands_st(data)       # Check amount of commands - STORAGE
        res1 = data.length == 5
        res2 = data.length == 6
        res3 = data.length == 7
        return res1 || res2 || res3
    end
    def check_input_commands_ret(data)       # Check amount of commands - RETRIEVAL
        res = data.length >= 2
        return res
    end
    def check_input_commands_cas(data)       # Check amount of commands - CAS
        res1 = data.length == 6
        res2 = data.length == 7
        res3 = data.length == 8
        return res1 || res2 || res3
    end

    def key_validator(key)
        return (key.length < 250) ## && (control_character Ver)
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
        return (data == "noreply" || data == "")
    end

    def msg_byte_validator(data)            # Check match between Bytes and DataBlock
        return data[4].to_i  == data[7].length
    end

    def storage_validator(data)             # Check Input requirments
        return key_validator(data[1]) && flag_validator(data[2]) && exptime_validator(data[3]) && bytes_validator(data[4]) && noreply_validator(data[6]) && msg_byte_validator(data)
    end    
    
    def noreply_correction(data)            # User input standar to Array of length 8
        nuevo = [data[0],data[1],data[2],data[3],data[4],"","","" ]
        #           add    key    flag   expectime   bytes   cas norepl datablock
        if data.length == 6
            if data[5] != "noreply"
                nuevo[7] = data[5]
                nuevo[6] = ""
            else
                nuevo[6] = "noreply"
            end
        elsif data.length == 7
            nuevo[6] = data[5]    
            nuevo[7] = data[6]    
        end
        nuevo
    end
    
    def noreply_correction_cas(data)            # Idem but specifically for CAS command
        nuevo = [data[0],data[1],data[2],data[3],data[4],data[5],"","" ]
        #           add   key    flag   expectime  bytes  cas  norep dt-block
        if data.length == 7
            if data[6] != "noreply"
                nuevo[7] = data[6]
                nuevo[6] = ""
            else
                nuevo[6] = "noreply"
            end
        elsif data.length == 8
            nuevo[6] = data[6]    
            nuevo[7] = data[7]    
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

    def remove_expired_keys(hash)
        time_now = Time.now.to_i
        hash.each do |key,data|
            if data.expectime.to_i > 0 || data.expectime.to_i < 0
                if (data.expectime.to_i - time_now) <= 0
                    hash.delete(key)
                end
            end
        end
    end

    def generate_token(data,token_stored)
        token_stored = token_stored + 1
    end
end