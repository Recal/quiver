require 'stringio'

class StringIO
    
    alias :byte :readbyte 

    def varint 
        value = 0
        position = 0
        byte = nil

        while true do
            byte = self.byte
            value |= (byte & 0x7F) << position

            if ((byte & 0x80) == 0) then break end 
            position += 7 
            if (position >= 32) then raise "" end 
        end

        value
    end

    def string 
        self.read self.varint
    end 

    def short 
        result = 0 
        result |= (self.byte & 0xFF) << 8 
        result |= (self.byte & 0xFF)
        result
    end

    def long 
        result = 0
        result |= (self.byte & 0xFF) << 56
        result |= (self.byte & 0xFF) << 48
        result |= (self.byte & 0xFF) << 40
        result |= (self.byte & 0xFF) << 32
        result |= (self.byte & 0xFF) << 24
        result |= (self.byte & 0xFF) << 16
        result |= (self.byte & 0xFF) << 8
        result |= (self.byte & 0xFF)
        result
    end 

    def bool 
        self.byte == 1 ? true : false 
    end 
end 
