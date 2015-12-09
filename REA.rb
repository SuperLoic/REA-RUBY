class Robot
  attr_accessor :x, :y, :direction
  def initialize (x = 0, y = 0, direction = "NORTH")
    @x = x
    @y = y
    @direction= direction
  end
end

class Tabletop
  attr_accessor :unitX, :unitY
  def initialize (unitX = 5, unitY = 5)
    @unitX = unitX
    @unitY = unitY
  end
end

class Response
  attr_accessor :status, :message
  def intialize (status, message)
    @status = status
    @message = message
  end
end

class Command
  def initialize (robot = Robot.new, tabletop = Tabletop.new)
    @robot = robot
    @tabletop = tabletop
  end
  def exec (command, *args)
    puts command
    case command
    when /^PLACE\s\d,\d,(NORTH|SOUTH|WEST|EAST)$/ then
      split= command.chomp.split(/\s|,/)
      @robot.x = split[1].to_i
      @robot.y = split[2].to_i
      @robot.direction = split[3]
    when "MOVE" then
      case @robot.direction
      when "NORTH" then 
        @robot.y  == @tabletop.unitY - 1 ? @tabletop.unitY : @robot.y += 1
      when "SOUTH" then
        @robot.y  == 0 ? 0 : @robot.y -= 1
      when "WEST" then
        @robot.x  == 0 ? 0 : @robot.x -= 1
      when "EAST" then
        @robot.x  == @tabletop.unitX - 1 ? @tabletop.unitX : @robot.x += 1
      end
    when "LEFT" then @robot.direction = rotate(-1)
    when "RIGHT" then @robot.direction = rotate(1)
    when "REPORT" then puts "\nExpected output: \n\n #{@robot.x},#{@robot.y},#{@robot.direction}"
    end
    @robot
  end
  
  def rotate(offset)
    direction = {"NORTH"=>0,"EAST"=>1,"SOUTH"=>2,"WEST"=>3,0=>"NORTH",1=>"EAST",2=>"SOUTH",3=>"WEST"}
    index = @robot.direction
    if direction[index] + offset < 0 then pointer = direction[3]
    elsif direction[index] + offset > 3 then pointer = direction[0]
    else pointer = direction[direction[index] + offset]
    end
    pointer
  end
end

command = Command.new
f = File.open("command.txt","r")
f.each do |line|
  command.exec(line.chomp)
end
f.close







