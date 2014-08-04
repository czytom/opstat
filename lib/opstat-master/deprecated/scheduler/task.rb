class Task
  attr_reader :interval, :next_run

  def initialize(interval)
    @interval = interval
    @next_run = Time.now + @interval
  end
  
  def set_next_run
    @next_run = @next_run + @interval
  end
end
