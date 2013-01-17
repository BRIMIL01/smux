require 'smux/putter'
require 'smux/errors'

module Smux
  class Application
    def initialize(smux_rb_path = nil)
      @dot_smux_rb_path = smux_rb_path
    end

    def run
      if @dot_smux_rb_path.nil?
        @dot_smux_rb_path = find_smux_rb
        if @dot_smux_rb_path.nil?
          Smux::Putter.error("Failed to find a .smux.rb file!")
          return Smux::Errors::FAILED_TO_FIND_SMUXRB
        end
      end

      begin
        load_smux_rb(@dot_smux_rb_path)
        return Smux::Errors::SUCCESS
      rescue Exception => e
        Smux::Putter.error('Failed to load .smux.rb file!')
        Smux::Putter.exception(e)
        return Smux::Errors::LOAD_SMUXRB_FAILED
      end
    end

    private

    def find_smux_rb
      cwd = Dir.getwd
      smux_rb_path = File.join(cwd, '.smux.rb')
      return smux_rb_path if File.exists?(smux_rb_path)
      return nil
    end

    def load_smux_rb(smux_rb_path)
    end
  end
end
