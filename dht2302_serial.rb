#!/usr/bin/ruby

require 'serialport'
require 'syslog'

debug=true

sp = SerialPort.new "/dev/ttyAMA0", 115200
hostname="raspberrypi"
Syslog.open( 'dht2302_serial', Syslog::LOG_PID, Syslog::LOG_DAEMON | Syslog::LOG_DAEMON)

while 1
  stats = sp.gets.chomp.split()
  if stats.size > 1
    temp_c   = stats[1]
    temp_f   = ( temp_c.to_f * 9 / 5 ) + 32
    humidity = stats[0]

    puts "PUTVAL \"#{hostname}/sensor-basement/gauge-tempc\" interval=10 N:#{temp_c}"
    puts "PUTVAL \"#{hostname}/sensor-basement/gauge-tempf\" interval=10 N:#{temp_f}"
    puts "PUTVAL \"#{hostname}/sensor-basement/gauge-humidity\" interval=10 N:#{humidity}"
    STDOUT.flush
    if debug 
      Syslog.log(Syslog::LOG_INFO, "temp_f: #{temp_f} temp_c: #{temp_c} humidity: #{humidity}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-basement/gauge-tempc\" interval=10 N:#{temp_c}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-basement/gauge-tempf\" interval=10 N:#{temp_f}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-basement/gauge-humidity\" interval=10 N:#{humidity}")
    end
  else
    Syslog.log(Syslog::LOG_ERR, "Odd input - #{stats.to_s}")
  end
end
