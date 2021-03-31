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
end
