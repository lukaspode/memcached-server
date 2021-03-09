class Hash_t
    attr_accessor :flag , :expectime,:bytes,:unique_cas_token, :noreply, :msg  
    def initialize(flag,expectime,bytes,unique_cas_token,noreply,msg)
        @flag = flag
        @expectime = expectime
        @bytes = bytes
        @unique_cas_token = unique_cas_token
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
    def unique_cas_token
        @unique_cas_token
    end
    def noreply
        @noreply
    end
    def msg
        @msg
    end
end
