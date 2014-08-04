require 'singleton'
require 'rubygems'
require 'algorithms'
require "scheduler/task.rb"


#Default PQ is sorted by highest priorities first - we need lowest ones
#TODO kiedys popatzyc z fareserm
module Opstat
module Scheduler
class OPQueue
  include Singleton

  def initialize
    @pq = Containers::PriorityQueue.new {|x, y| (x <=> y) == -1 }
  end

  def add(task)
    @pq.push(task, task.next_run)
  end

  def pop
    @pq.pop
  end

  def size
    @pq.size
  end
end

end
end
