require 'spec_helper'
describe 'Cpu' do
  describe 'Parsers' do
    describe 'Single core cpu' do
      before :each do
        Opstat::Plugins.load_parser("cpu")
	@cpu_parser = Opstat::Parsers::Cpu.new
        @time = Time.now
        @hostname = 'test'
      end

      it 'returns report with all parsed params when input data are correct' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_single_core.txt')
        params = {
                   :plugin => { :type => 'cpu'},
                   :host => { :hostname => @hostname},
                   :data => cpu_data,
                   :time => @time
                 }
        result_expected = [{ :plugin_type => "cpu", :time => @time, :values => { :user=>1250728, :nice=>0, :system=>12334059, :idle=>1072246656, :iowait=>2258392, :irq=>1882, :softirq=>16720396}, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu" }},
                           { :plugin_type => "cpu", :time => @time, :values => { :user=>1250728, :nice=>0, :system=>12334059, :idle=>1072246656, :iowait=>2258392, :irq=>1882, :softirq=>16720396 }, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu0" }},
                           { :plugin_type => "cpu.system", :time => @time, :values => {:context_switches=>28076998076, :processes=>46027160, :processes_blocked=>0, :processes_running=>1}, :tags => { :hostname => @hostname }}]
        expect(@cpu_parser.parse_data(params)).to eq result_expected
      end
      
      it 'returns only system meta_type data where cpu input data are corrupted' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_single_core_corrupted.txt')
        params = {
                   :plugin => { :type => 'cpu'},
                   :host => { :hostname => @hostname},
                   :data => cpu_data,
                   :time => @time
                 }
        expect(@cpu_parser.parse_data(params)).to eq [{:plugin_type=>"cpu.system",
          :time => @time,
          :values=>
            {
              :context_switches=>28076998076,
              :processes=>46027160,
              :processes_blocked=>0,
              :processes_running=>1
            },
            :tags => { :hostname => @hostname }
          }]
      end
    end
    describe '16 core cpu' do
      before :each do
        Opstat::Plugins.load_parser("cpu")
	@cpu_parser = Opstat::Parsers::Cpu.new
        @time = Time.now
      end

      it 'returns report with all parsed params when input data are correct' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_16_core.txt')
        params = {
                   :plugin => { :type => 'cpu'},
                   :host => { :hostname => @hostname},
                   :data => cpu_data,
                   :time => @time
                 }
        result_expected = [
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu" }, :values=>{ :user=>343892052, :nice=>391591, :system=>179686992, :idle=>8255449896, :iowait=>176732547, :irq=>2779, :softirq=>11746154}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu0" }, :values=>{ :user=>94360332, :nice=>13194, :system=>25311161, :idle=>427954242, :iowait=>978710, :irq=>2763, :softirq=>10162361}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu1" }, :values=>{ :user=>19935742, :nice=>41131, :system=>9993729, :idle=>522847312, :iowait=>7471141, :irq=>0, :softirq=>76227}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu2" }, :values=>{ :user=>17431399, :nice=>19328, :system=>14027854, :idle=>516211416, :iowait=>12705909, :irq=>2, :softirq=>273247}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu3" }, :values=>{ :user=>19038390, :nice=>27211, :system=>10018441, :idle=>520554583, :iowait=>10788150, :irq=>2, :softirq=>33547}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu4" }, :values=>{ :user=>15210833, :nice=>21154, :system=>11990063, :idle=>517126821, :iowait=>16467095, :irq=>1, :softirq=>234627}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu5" }, :values=>{ :user=>18045912, :nice=>20675, :system=>9443090, :idle=>525876198, :iowait=>7063354, :irq=>0, :softirq=>33500}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu6" }, :values=>{ :user=>12909877, :nice=>16220, :system=>11508389, :idle=>516537343, :iowait=>19837969, :irq=>4, :softirq=>194260}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu7" }, :values=>{ :user=>16407672, :nice=>27254, :system=>9052205, :idle=>528906318, :iowait=>6309171, :irq=>0, :softirq=>34728}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu8" }, :values=>{ :user=>18507758, :nice=>41695, :system=>10483060, :idle=>515592285, :iowait=>15762144, :irq=>3, :softirq=>124925}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu9" }, :values=>{ :user=>17172074, :nice=>27679, :system=>9711178, :idle=>526408234, :iowait=>7228540, :irq=>0, :softirq=>50753}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu10" }, :values=>{ :user=>17662446, :nice=>16685, :system=>10462168, :idle=>513984988, :iowait=>18241095, :irq=>0, :softirq=>124343}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu11" }, :values=>{ :user=>15999291, :nice=>25596, :system=>9703005, :idle=>524560628, :iowait=>10247820, :irq=>2, :softirq=>50592}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu12" }, :values=>{ :user=>16366487, :nice=>24498, :system=>9901209, :idle=>518913461, :iowait=>15164664, :irq=>0, :softirq=>124311}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu13" }, :values=>{ :user=>14705950, :nice=>17703, :system=>9216785, :idle=>529464299, :iowait=>7107057, :irq=>0, :softirq=>51000}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu14" }, :values=>{ :user=>15866777, :nice=>25752, :system=>9765441, :idle=>520015817, :iowait=>14723151, :irq=>2, :softirq=>125789}},
                            { :plugin_type => 'cpu', :time => @time, :tags => { :hostname => @hostname, :OPSTAT_TAG_cpu_id=>"cpu15" }, :values=>{ :user=>14271112, :nice=>25816, :system=>9099214, :idle=>530495951, :iowait=>6636577, :irq=>0, :softirq=>51944}},
                            { :plugin_type => 'cpu.system', :time => @time, :tags => { :hostname => @hostname }, :values=>{:context_switches=>41618507553, :processes=>102914327, :processes_running=>4, :processes_blocked=>1}}]
        expect(@cpu_parser.parse_data(params)).to eq result_expected
      end
      
      it 'returns only meta_type data when cpu input data are corrupted' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_16_core_corrupted.txt')
        expect(@cpu_parser.parse_data(data: cpu_data, time: @time)).to eq [{:values=>{:context_switches=>41618507553, :processes=>102914327, :processes_running=>4, :processes_blocked=>1}, :time=>@time, :meta_type=>"system"}]
      end
    end
  end

end
