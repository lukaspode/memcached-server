class Result
    attr_accessor :succ, :data, :message, :noreply
    def initialize(succ,data,message,noreply)
      @succ = succ
      @data = data        
      @message = message
      @noreply = noreply
    end

    # used for multiple keys on get/gets command
    def add_message(data)
      @message = @message + "\r\n" + data
    end
end