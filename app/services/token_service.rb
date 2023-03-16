class TokenService
    SECRET = 'wallet api secret'
  
    def self.encode(payload, exp = 4.hours.from_now.to_i)
      payload[:exp] = exp
      JWT.encode(payload, SECRET)
    end
  
    def self.decode(token)
      return JWT.decode(token, SECRET, true)
    end
end

