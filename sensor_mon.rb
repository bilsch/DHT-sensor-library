#!/usr/bin/ruby

require 'serialport'
require 'syslog'
require 'timeout'
require 'json'

debug=true

sp = SerialPort.new "/dev/ttyUSB0", 115200
sp.flow_control=SerialPort::HARD
hostname="raspberrypi"
Syslog.open( 'sensor_mon', Syslog::LOG_PID, Syslog::LOG_DAEMON | Syslog::LOG_DAEMON)

while 1
  begin
    #
    # each metrics event must contain sensor_name as a key. 
    # Any other key is treated as the metric name and is emitted as a gauge
    #
    metrics = Hash.new()
    data = ''
    timeout(15) {
      data = sp.gets.chomp
    }

    begin
      metrics = JSON.parse(data)
    rescue JSON::ParserError
      puts "failed to parse json from #{metrics}"
      next
    end

    msgs = Array.new()
    metrics.keys.each do |metric|
      next if metric == 'sensor_name'

      # special case if we get someting in celcius, create a second metric with farenheit too
      if metric == 'celsius'
        msgs.push("PUTVAL \"#{hostname}/sensor-#{metrics["sensor_name"]}/gauge-#{metric}\" interval=3 N:#{metrics[metric]}")
        msgs.push("PUTVAL \"#{hostname}/sensor-#{metrics["sensor_name"]}/gauge-fahrenheit\" interval=3 N:#{(metrics[metric] * 9 / 5) +32}")
      else
        msgs.push("PUTVAL \"#{hostname}/sensor-#{metrics["sensor_name"]}/gauge-#{metric}\" interval=3 N:#{metrics[metric]}")
      end
    end
    msgs.each do |msg|
      Syslog.log(Syslog::LOG_INFO, msg) if debug
      puts "#{msg}\r\n"
      STDOUT.flush
    end
  rescue => e
    Syslog.log(Syslog::LOG_ERR, "metrics parse failed #{e.message}")
  end
end
