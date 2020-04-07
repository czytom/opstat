describe 'Memory' do
  describe 'Parsers' do
    describe 'memory parser' do
      before :each do
        Opstat::Plugins.load_parser("memory")
	@parser = Opstat::Parsers::Memory.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_memory.txt')
        time = Time.now
        result_expected = [{:time =>  time, :values => {:total=>4110504, :free=>202828, :used=>378472, :cached=>3202196, :buffers=>327008, :swap_total=>0, :swap_free=>0, :swap_used=>0}}]
        expect(@parser.parse_data(data: data, time: time)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = File.readlines('./spec/fixtures/parser_memory_corrupted.txt')
        time = Time.now
        expect(@parser.parse_data(data: data, time: time)).to eq []
      end
    end
  end
end
