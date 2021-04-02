
require_relative 'hash_t'
require_relative 'validate'
require_relative 'result'
require_relative '../messages'

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
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS + LN_BREAK,false)
      if @validations.check_input_length(data)
        number_keys = data.length
        result.data = data
        result.message = ''
        for i in 1..number_keys do
          @validations.remove_expired_keys(@hash_comm,data[i])
          key = data[i]
          if (@hash_comm[key] != nil)
            data_m = "VALUE #{key} #{@hash_comm[key].flag} #{@hash_comm[key].bytes}\r\n#{@hash_comm[key].msg}\r\nEND\r\n"
            result.add_message(data_m)
            result.succ = true
          end
        end
        if result.succ == false
          result.message = NOT_ASOCIATED + data[1] + LN_BREAK
        end
      end
      result
    end
    def gets(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS + LN_BREAK,false)
      if @validations.check_input_length(data)
        number_keys = data.length
        result.data = data
        result.message = ''
        for i in 1..number_keys do
          @validations.remove_expired_keys(@hash_comm,data[i])
          key = data[i]
          if (@hash_comm[key] != nil)
            @token_stored = @validations.generate_token(@hash_comm[key],@token_stored)
            @hash_comm[key].unique_cas_token =  @token_stored
            data[5] = @hash_comm[key].unique_cas_token
            data_m = "VALUE #{key} #{@hash_comm[key].flag} #{@hash_comm[key].bytes} #{@hash_comm[key].unique_cas_token}\r\n#{@hash_comm[key].msg}\r\nEND\r\n"
            result.add_message(data_m)
            result.succ = true
          end
        end
        if result.succ == false
          result.message = NOT_ASOCIATED + data[1] + LN_BREAK
        end
      end
      result
    end

    #### ---------------------- ####
    ###  -- Storage Commands --  ###
    #### ---------------------- #### 
    def set(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
          data_in = update_input_st(data,false)
          result.data = data_in
          result.message = ERROR
          if @validations.storage_validator(data_in)
            result.noreply = data_in[6]
            store(data_in,result)
          end
        end
      result.message += LN_BREAK
      result
    end
    def add(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
        data_in = update_input_st(data,false)
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          result.noreply = data_in[6]
          if @hash_comm[data_in[1]] == nil
            store(data_in,result)
          else
            result.message = NOT_STORED
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def replace(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
        data_in = update_input_st(data,false)
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          result.noreply = data_in[6]
          if @hash_comm[data_in[1]] != nil
            store(data_in,result)
          else
            result.message = NOT_STORED
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    #The append and prepend commands do not accept flags or exptime.They update existing data portions, and ignore new flag and exptime settings.
    def append(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
        data_in = update_input_st(data,false)
        result.data = data_in
        result.message = CLIENT_ERROR
        if @validations.storage_validator(data_in)
          result.noreply = data_in[6]
          if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = @hash_comm[data_in[1]].msg + data_in[7]
            result.succ = true
            result.message = STORED
            result.data = data_in
          else
            result.message = NOT_STORED
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def prepend(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
        data_in = update_input_st(data,false)
        result.data = data_in
        result.message = CLIENT_ERROR
        if @validations.storage_validator(data_in)
          result.noreply = data_in[6]
          if @hash_comm[data_in[1]] != nil
            @hash_comm[data_in[1]].msg = data_in[7] + @hash_comm[data_in[1]].msg
            result.succ = true
            result.message = STORED
          else
            result.message= NOT_STORED
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def cas(data)
      result = Result.new(false,data,ERROR + ' ' + WRONG_PARAMETERS,false)
      if @validations.check_input_length(data)
        token = data[5].to_i
        data_in = update_input_st(data,true)
        data_in[5] = token
        result.data = data_in
        result.message = ERROR
        if @validations.storage_validator(data_in)
          result.noreply = data_in[6]
          if @hash_comm[data_in[1]] != nil 
            if @hash_comm[data_in[1]].unique_cas_token.to_i == token
              store(data_in,result)
            else
              result.message = EXISTS
            end
          else
            result.message = NOT_FOUND
          end
        end
      end
      result.message += LN_BREAK
      result
    end
    def help
      HELP_MENU
    end

    
    #### ---------------------- ####
    ### -- Auxiliar Functions -- ###
    #### ---------------------- #### 
    def store(data,result)
      @hash_comm[data[1]] = Hash_t.new(data[2],@validations.expectime_correction(data[3]),data[4],data[5],data[6],data[7])
      result.succ = true
      if result.noreply
        result.message = EMPTY
      else
        result.message = STORED
      end
    end
    def update_input_st(data,cas)
      @validations.remove_expired_keys(@hash_comm,data[1])
      return @validations.noreply_correction(data,cas)
    end
end