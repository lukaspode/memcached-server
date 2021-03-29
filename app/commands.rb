
require_relative 'hash_t'
require_relative 'validate'
require_relative 'result'
require_relative 'messages'

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
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_ret(data)
        data_in = @validations.noreply_correction(data)
        number_keys = data.length
        result.data = data_in
        result.message = ''
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        for i in 1..number_keys do
          key = data[i]
          if (@hash_comm[key] != nil)
            data_m = "VALUE #{key} #{@hash_comm[key].flag} #{@hash_comm[key].bytes}\r\n#{@hash_comm[key].msg}\r\nEND"
            result.add_message(data_m)
            result.succ = true
          end
        end
        if result.succ == false
          result.message = NOT_ASOCIATED + data[1]
        end
      end
      result.message += LN_BREAK
      result
    end
    def gets(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_ret(data)
        data_in = @validations.noreply_correction(data)
        number_keys = data.length
        result.data = data_in
        result.message = ''
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        for i in 1..number_keys do
          key = data[i]
          if (@hash_comm[key] != nil)
            @hash_comm[key].unique_cas_token =  @validations.generate_token(@hash_comm[key],@token_stored)
            data_in[5] = @hash_comm[key].unique_cas_token
            data_m = "VALUE #{key} #{@hash_comm[key].flag} #{@hash_comm[key].bytes} #{@hash_comm[key].unique_cas_token}\r\n#{@hash_comm[key].msg}\r\nEND"
            result.add_message(data_m)
            result.succ = true
          end
        end
        if result.succ == false
          result.message = NOT_ASOCIATED + data[1]
        end
      end
      result.message += LN_BREAK
      result
    end

    #### ---------------------- ####
    ###  -- Storage Commands --  ###
    #### ---------------------- #### 

    def set(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
          data_in = @validations.noreply_correction(data)
          @validations.remove_expired_keys(@hash_comm,data_in[1])
          result.data = data_in
          result.message = ERROR
          if @validations.storage_validator(data_in)
            to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]), data_in[4],data_in[5],data_in[6],data_in[7])
            @hash_comm[data_in[1]] = to_store
            if(data_in[6] === 'noreply')
              result.noreply = true
            end
            result.succ = true
            result.message = STORED
          end
        end
      result.message += LN_BREAK
      result
    end
    def add(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          if @hash_comm[data_in[1]] == nil
            to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
            @hash_comm[data_in[1]] = to_store
            result.succ = true
            result.message = STORED
          else
            result.message = NOT_STORED
          end
          if(data_in[6] === 'noreply')
            result.noreply = true
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def replace(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          if @hash_comm[data_in[1]] != nil
            to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
            @hash_comm[data_in[1]] = to_store
            result.succ = true
            result.message = STORED
          else
            result.message = NOT_STORED
          end
          if(data_in[6] === 'noreply')
            result.noreply = true
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    #The append and prepend commands do not accept flags or exptime.They update existing data portions, and ignore new flag and exptime settings.
    def append(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        result.data = data_in
        result.message = CLIENT_ERROR
        if @validations.storage_validator(data_in)
          if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = @hash_comm[data_in[1]].msg + data_in[7]
            result.succ = true
            result.message = STORED
            result.data = data_in
          else
            result.message = NOT_STORED
          end
          if(data_in[6] === 'noreply')
            result.noreply = true
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def prepend(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
        data_in = @validations.noreply_correction(data)
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        result.data = data_in
        result.message = CLIENT_ERROR
        if @validations.storage_validator(data_in)
          if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = data_in[7] + @hash_comm[data_in[1]].msg
            result.succ = true
            result.message = STORED
          else
            result.message= NOT_STORED
          end
          if(data_in[6] === 'noreply')
            result.noreply = true
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def cas(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_commands_st(data)
        token = data[5].to_i
        data_in = @validations.noreply_correction_cas(data)
        data_in[5] = token
        @validations.remove_expired_keys(@hash_comm,data_in[1])
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          if @hash_comm[data_in[1]] != nil 
            if @hash_comm[data_in[1]].unique_cas_token.to_i == token
              to_store = Hash_t.new(data_in[2],@validations.expectime_correction(data_in[3]),data_in[4],data_in[5],data_in[6],data_in[7])
              @hash_comm[data_in[1]] = to_store
              result.succ = true
              result.message = STORED
            else
              result.message = EXISTS
            end
          else
            result.message = NOT_FOUND
          end
          if(data_in[6] === 'noreply')
            result.noreply = true
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    
end