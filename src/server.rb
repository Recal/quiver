require 'eventmachine'
require_relative 'workbench/helper'
require 'logger'
require 'colorize'


$logger = Logger.new STDOUT
$logger.formatter = proc do |severity, datetime, _, msg|
    def get_color severity
        case severity 
        when "DEBUG"
            :blue
        when "INFO"
            :yellow
        when "ERROR"
            :red
        else 
            :white
        end 
    end 

    def text_color severity
        case severity 
        when "DEBUG"
            :light_blue
        when "INFO"
            :light_yellow
        when "ERROR"
            :light_red
        else 
            :white
        end 
    end 

    text_color = text_color severity
    severity_color = get_color severity

    <<~MSG
        #{severity.colorize(severity_color)} #{datetime.to_s.colorize(text_color)} #{"::".colorize(:light_black).bold} #{msg.colorize :white}
    MSG
end

module Quiver 
    module Networking
        class Client < EM::Connection 
            def receive_data data 
                $logger.info data
            end 
        end

        def self.start_server port
            fork do
                begin 
                EventMachine.run do 
                    EventMachine.start_server("0.0.0.0", port, self::Client) {
                        $logger.info "Running..."
                    }
                end
                rescue => e
                    $logger.error "#{e}"
                end
            end
        end 
    end
end

Quiver::Networking.start_server 25565
