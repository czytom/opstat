describe 'Vpn' do
  describe 'Parsers' do
    before :each do
      Opstat::Plugins.load_parser("vpn")
      @parser = Opstat::Parsers::Vpn.new
    end

    it 'zero connected clients - returns correct data report with all parsed params when input data are correct' do
      data = File.readlines('./spec/fixtures/parser_vpn_zero_clients_correct.txt')
      time = Time.parse('Tue Apr  7 23:02:14 2020')
      result_expected = [
      ]
      sent_time = Time.now
      expect(@parser.parse_data(time: sent_time, data: data)).to eq result_expected
    end
    it 'returns correct data report with all parsed params when input data are correct' do
      data = File.readlines('./spec/fixtures/parser_vpn_correct.txt')
      time = Time.parse('Tue Apr  7 23:02:14 2020')
      result_expected = [
        {:time => time, :tags => {:client => 'test1@power.com.pl' }, :values => {:bytes_received => 664913234, :bytes_sent => 2156244572}},
        {:time => time, :tags => {:client => 'test23@power.com.pl' }, :values => {:bytes_received => 557809, :bytes_sent => 1049575 }},
        {:time => time, :tags => {:client => 'test4@power.com.pl' }, :values => {:bytes_received => 32422907, :bytes_sent => 168046250 }},
        {:time => time, :tags => {:client => 'test6@power.com.pl' }, :values => {:bytes_received => 26116017, :bytes_sent => 51707971 }}
      ]
      sent_time = Time.now
      expect(@parser.parse_data(time: sent_time, data: data)).to eq result_expected
    end
  end
end
