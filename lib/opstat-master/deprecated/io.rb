STAT = "/proc/diskstats"
prev_rkB = nil
prev_wkB = nil

loop do

io = File.open(STAT)
stat = io.readlines
io.close
rep = stat[-2].split
p rep
#TODO some consts
read_kB = rep[5].to_i / 2
p read_kB
exit
write_kB = rep[9].to_i * 512 /1024
if prev_rkB.nil?
  prev_rkB = read_kB
  prev_wkB = write_kB
else
  puts (write_kB -  prev_wkB)
  prev_rkB = read_kB
  prev_wkB = write_kB
end


sleep 5
end
