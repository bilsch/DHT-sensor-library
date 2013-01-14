#!/usr/bin/ruby

require 'serialport'
require 'syslog'

debug=false

sp = SerialPort.new "/dev/ttyUSB1", 115200
hostname="raspberrypi"
Syslog.open( 'dht2302_serial', Syslog::LOG_PID, Syslog::LOG_DAEMON | Syslog::LOG_DAEMON)

while 1
  stats = sp.gets.chomp.split()
  if stats.size > 1
    temp_c   = stats[2]
    temp_f   = ( temp_c.to_f * 9 / 5 ) + 32
    humidity = stats[1]
    location = stats[0]

    puts "PUTVAL \"#{hostname}/sensor-#{location}/gauge-tempc\" interval=1 N:#{temp_c}"
    puts "PUTVAL \"#{hostname}/sensor-#{location}/gauge-tempf\" interval=1 N:#{temp_f}"
    puts "PUTVAL \"#{hostname}/sensor-#{location}/gauge-humidity\" interval=1 N:#{humidity}"
    STDOUT.flush
    if debug 
      Syslog.log(Syslog::LOG_INFO, "temp_f: #{temp_f} temp_c: #{temp_c} humidity: #{humidity}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-#{location}/gauge-tempc\" interval=1 N:#{temp_c}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-#{location}/gauge-tempf\" interval=1 N:#{temp_f}")
      Syslog.log(Syslog::LOG_INFO, "PUTVAL \"#{hostname}/sensor-#{location}/gauge-humidity\" interval=1 N:#{humidity}")
    end
  else
    Syslog.log(Syslog::LOG_ERR, "Odd input - #{stats.to_s}")
  end
end
