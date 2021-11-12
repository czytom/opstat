class Webobjects
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  index({timestamp: 1, host_id: 1, plugin_id: 1},{background: true})
  store_in collection: "opstat.reports"

  def self.chart_data(options = {})
    charts = []
    charts = self.all_applications_charts(options)
    return charts
  end

  def self.all_sensors_applications_charts(options = {})
    charts = []
    Webobjects.where(:timestamp.gte => options[:start]).
               where(:timestamp.lt => options[:end]).
	       where(:plugin_type => 'webobjects').
	       order_by(timestamp: :asc).group_by{|u| u.name}.each_pair do |app, stats|
      charts << self.application_charts(app,stats)
    end
    return charts.flatten
  end

  def self.all_applications_charts(options = {})
    charts = []
    Webobjects.where(:timestamp.gte => options[:start]).
               where(:timestamp.lt => options[:end])
	       where(:host_id => options[:host_id]).
	       where(:plugin_id => options[:plugin_id]).
	       order_by(timestamp: :asc).group_by{|u| u.name}.each_pair do |app, stats|
      charts << self.application_charts(app,stats)
    end
    return charts.flatten
  end

  def self.application_charts(app,app_stats)
    chart = self.chart_structure({:title => "Number of sessions - #{app} application", :value_axis => { :title => "Number of sessions"}})
    prev = nil
    instances = Hash.new
    app_stats.group_by {|s| s.timestamp}.each do |timestamp, stats|
      temp = {:timestamp => timestamp}
      stats.each do |stat|
      #<Webobjects _id: 201, created_at: nil, updated_at: nil, name: "ifirma", host: "ifirmaapp01", port: "2201", state: "ALIVE", deaths: "0", refusingNewSessions: false, scheduled: false, schedulingHourlyStartTime: 3, schedulingDailyStartTime: 3, schedulingWeeklyStartTime: 3, schedulingType: "DAILY", schedulingStartDay: 1, schedulingInterval: 12, transactions: "284487", activeSessions: "41", averageIdlePeriod: "0.646", avgTransactionTime: "0.054", autoRecover: "true", timestamp: 2018-10-17 06:16:31 UTC, host_id: BSON::ObjectId('5bc6d3bf7327d40cb44d9ad6'), plugin_id: BSON::ObjectId('5bc6d3c07327d40cb44d9af7'), plugin_type: "webobjects"
        instances[stat[:instance_id]] ||= true
        temp[stat[:instance_id]] = stat[:activeSessions].to_i
      end
      chart[:graph_data] << temp 
    end
    instances.keys.each do |graph|
      chart[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
    end

#    tps = self.tps_graph(app)
#    instances.keys.each do |graph|
#      tps[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph.to_s,  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
#    end
    
#    sessions = sessions_graph(app)
#    instances.keys.each do |graph|
#      sessions[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
#    end
#    sessions[:graph_data] = chart_data[:sessions]
#    tps[:graph_data] = chart_data[:tps]
#    chart[:graph_data] = chart_data[:sessions]
    p chart
    return chart
  end
    
  def self.tps_graph(app)
    return self.chart_structure({:title => "Transactions per second - #{app} application", :value_axis => { :title => "Transactions/sec"}})
  end

  def self.graphs
    {
      :sessions => { :line_color => '#0033FF' },
    }
  end
  def self.sessions_graph(app)
    return self.chart_structure({:title => "Number of sessions - #{app} application", :value_axis => { :title => "Number of sessions"}})
  end
end
