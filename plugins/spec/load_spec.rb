describe 'Load' do
  describe 'Parsers' do
    describe 'load parser' do
      before :each do
        Opstat::Plugins.load_parser("load")
	@parser = Opstat::Parsers::Load.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_load.txt')
        time = Time.now
        result_expected = [{:time => time, :values => {:load_1m=>0.0, :load_5m=>0.01, :load_15m=>0.05, :threads_running=>1, :threads=>167}}]
        expect(@parser.parse_data(data: data, time: time)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = File.readlines('./spec/fixtures/parser_load_corrupted.txt')
        time = Time.now
        expect(@parser.parse_data(data: data, time: time)).to eq []
      end
    end
  end
end
