class Hash_t
    attr_accessor :flag , :expectime,:bytes, :noreply, :msg  #VER
    def initialize(flag,expectime,bytes,noreply,msg)
        @flag = flag
        @expectime = expectime
        @bytes = bytes
        @noreply = noreply
        @msg = msg
    end
    def flag
        @flag
    end
    def expectime
        @expectime
    end
    def bytes
        @bytes
    end
    def noreply
        @noreply
    end
    def msg
        @msg
    end
end
