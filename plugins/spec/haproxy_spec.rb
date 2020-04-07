describe 'Haproxy' do
  describe 'Parsers' do
    describe 'haproxy parser' do
      before :each do
        Opstat::Plugins.load_parser("haproxy")
          @haproxy_parser = Opstat::Parsers::Haproxy.new
      end

it 'returns report for many frontend and many backend with one svname' do
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_many_frontend_many_backend.txt')
  expected_file = './spec/fixtures/parser_haproxy_many_frontend_many_backend.txt.expected'
  time = Time.new(2020, 04, 04, 12, 2, 2, "+02:00")
  result_expected = YAML.load_file(expected_file)

  expect(@haproxy_parser.parse_data(data: haproxy_data, time: time)).to eq result_expected
end

it 'returns report for single frontend and single backend with one svname' do 
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_single_frontend_single_backend_with_single_svname.txt')
  time = Time.new(2020, 04, 04, 12, 2, 2, "+02:00")
  result_expected = [{:time => time, :values => {:scur=>0, :smax=>3, :slim=>1000, :stot=>1117, :bin=>234633, :bout=>28452829, :dreq=>0, :dresp=>0, :ereq=>2, :status=>"OPEN", :pid=>1, :iid=>2, :sid=>0, :type=>0, :rate=>0, :rate_lim=>0, :rate_max=>2, :hrsp_1xx=>0, :hrsp_2xx=>2, :hrsp_3xx=>57, :hrsp_4xx=>2, :hrsp_5xx=>0, :hrsp_other=>0, :req_rate=>0, :req_rate_max=>4, :req_tot=>61, :comp_in=>0, :comp_out=>0, :comp_byp=>0, :comp_rsp=>0, :mode=>"http", :conn_rate=>0, :conn_rate_max=>2, :conn_tot=>22, :intercepted=>0, :dcon=>0, :dses=>0}, :tags => {"OPSTAT_TAG_svname" => "FRONTEND", "OPSTAT_TAG_pxname" => "frontend-http"}}, {:time => time, :values => {:qcur=>0, :qmax=>0, :scur=>0, :smax=>2, :stot=>1149, :bin=>507182, :bout=>4138662, :dresp=>0, :econ=>0, :eresp=>0, :wretr=>0, :wredis=>0, :status=>"UP", :weight=>1, :act=>1, :bck=>0, :chkfail=>1, :chkdown=>0, :lastchg=>1130529, :downtime=>0, :pid=>1, :iid=>4, :sid=>2, :lbtot=>1149, :type=>2, :rate=>0, :rate_max=>7, :check_status=>"L7OK", :check_code=>200, :check_duration=>1, :hrsp_1xx=>0, :hrsp_2xx=>541, :hrsp_3xx=>31, :hrsp_4xx=>577, :hrsp_5xx=>0, :hrsp_other=>0, :cli_abrt=>0, :srv_abrt=>0, :lastsess=>42, :last_chk=>2, :last_agt=>3, :qtime=>4, :agent_duration=>"http"}, :tags => {"OPSTAT_TAG_svname" => "varnishpm02-staging", "OPSTAT_TAG_pxname" => "backend-varnish-ifirma"}}]
  expect(@haproxy_parser.parse_data(data: haproxy_data, time: time)).to eq result_expected 
end

it 'returns report for correct data' do 
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_correct.txt')
  time = Time.new(2020, 04, 04, 12, 2, 2, "+02:00")
  result_expected = [{:time => time, :values => {:qcur=>0, :qmax=>0, :scur=>0, :smax=>4, :slim=>500, :stot=>2301, :bin=>1041031, :bout=>8319027, :dreq=>0, :dresp=>0, :econ=>0, :eresp=>0, :wretr=>0, :wredis=>0, :status=>"UP", :weight=>2, :act=>2, :bck=>0, :chkdown=>0, :lastchg=>1130529, :downtime=>0, :pid=>1, :iid=>4, :sid=>0, :lbtot=>2301, :type=>1, :rate=>0, :rate_max=>15, :hrsp_1xx=>0, :hrsp_2xx=>1096, :hrsp_3xx=>58, :hrsp_4xx=>1147, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>2301, :cli_abrt=>0, :srv_abrt=>0, :comp_in=>2732938, :comp_out=>612264, :comp_byp=>0, :comp_rsp=>372, :lastsess=>42, :qtime=>0, :ctime=>0, :rtime=>14, :ttime=>463, :mode=>"http"}, :tags => { "OPSTAT_TAG_svname" => "BACKEND", "OPSTAT_TAG_pxname" => "backend-varnish"}}]
  expect(@haproxy_parser.parse_data(data: haproxy_data, time: time)).to eq result_expected 
end 

    end
  end
end 

