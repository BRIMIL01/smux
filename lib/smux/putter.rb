module Smux
  module Putter
    def self.error(message)
      puts message
    end

    def self.exception(e)
      puts e.message
      puts e.backtrace.join("\n")
    end
  end
end
