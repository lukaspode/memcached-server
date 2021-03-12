class Result
    attr_accessor :succ, :data, :message
    def initialize(succ,data,message)
        @succ = succ
        @data = data        
        @message = message
    end
    def set_succ(succ)
        @succ = succ        
    end
    def set_data(data)
        @data = data        
    end
    def set_message(message)
        @message = message        
    end
    def get_succ
        @succ        
    end
    def get_data
        @data     
    end
    def get_message
        @message     
    end
    def add_message(data)           # used for multiple keys on get/gets command
        @message = @message + data
    end
end