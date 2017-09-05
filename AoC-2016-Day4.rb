require 'rubygems'
require 'bundler'

Bundler.setup(:default)

class NDGProcess

  def initialize()
    @total = 0
  end

  def run
    File.readlines('./rooms.txt').each do |line|
      check_real_room(line)
    end

    puts @total
  end

  def check_real_room(room_name)
    encrypted_name, sector_id, checksum = room_name.match(/\A(.*)(\d{3})\[([a-z]{5})\]\Z/).captures

    calculated_checksum = encrypted_name.gsub('-', '').chars.inject({}) do |h, char| 
      h[char].nil? ?  h[char] = 0 : h[char] += 1
      h
    end.sort { |a, b| [b[1], a[0]] <=> [a[1], b[0]] }.to_h.keys.slice(0, 5).join

    @total += sector_id.to_i if checksum == calculated_checksum
  end

end



process = NDGProcess.new
process.run
