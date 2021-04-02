class Validate
    def is_number?(number)
      true if Integer(number) rescue false 
      #return Integer(number)
    end
    def unsigned_int(number)
      return is_number?(number) && number.to_i>=0        
    end

    # Check amount of commands - STORAGE
    def check_input_commands_st(data)
      res1 = data.length == 5
      res2 = data.length == 6
      res3 = data.length == 7
      return res1 || res2 || res3
    end

    # Check amount of commands - RETRIEVAL
    def check_input_commands_ret(data)
      res = data.length >= 2
      return res
    end

    # Check amount of commands - CAS
    def check_input_commands_cas(data)
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
      return (bytes.to_i <= 256) && (is_number?(bytes))
    end
    def datablock_validator(data)
      return (data.length <= 256)
    end
    def noreply_validator(data)
      res = (data[6] == "noreply" || data[6] == "")
      data[6] = (data[6] == "noreply")
      return res
    end

    # Check match between Bytes and DataBlock
    def msg_byte_validator(data)
      return data[4].to_i  == data[7].length
    end

    # Check Input requirments
    def storage_validator(data)
      return key_validator(data[1]) && flag_validator(data[2]) && exptime_validator(data[3]) && bytes_validator(data[4]) && noreply_validator(data) && msg_byte_validator(data)
    end    

    # User input standar to Array of length 8
    def noreply_correction(data,cas)
      nuevo = [data[0],data[1],data[2],data[3],data[4],"","","" ]
      #           add    key    flag   expectime   bytes   cas norepl datablock
      if (cas == false)
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
      else
        nuevo[5] = data[5]
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
      end
      nuevo
    end

    # Expectime input converted 
    def expectime_correction(data)
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

    def remove_expired_keys(hash,key)
      if hash[key] != nil
        time_now = Time.now.to_i
        if hash[key].expectime.to_i > 0 || hash[key].expectime.to_i < 0
          if (hash[key].expectime.to_i - time_now) <= 0
            hash.delete(key)
          end
        end
      end
    end

    def generate_token(data,token_stored)
      token_stored = token_stored + 1
    end
end