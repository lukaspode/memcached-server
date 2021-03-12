
require_relative 'commands'

class Petitions
    def initialize
        @validations = Validate.new
        @commands = Commands.new
    end

    ###  -- Retrieval Commands --  ###

    def get(data)
        return @commands.get(data)
    end
    def gets(data)
        return @commands.gets(data)
    end

    ###  -- Storage Commands --  ###

    def set(data)
        return @commands.set(data)
    end
    def add(data)
        return @commands.add(data)
    end
    def append(data)
        return @commands.append(data)
    end
    def prepend(data)
        return @commands.prepend(data)
    end
    def replace(data)
        return @commands.replace(data)
    end
    def cas(data)
        return @commands.cas(data)
    end
end