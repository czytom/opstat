describe 'FreeswitchFifos' do
  describe 'Parsers' do
    describe 'talks' do
      before :each do
        Opstat::Plugins.load_parser("freeswitch_fifos")
	@parser = Opstat::Parsers::FreeswitchFifos.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_freeswitch_1.txt').join
        result_expected = [{:OPSTAT_TAG_fifo_name=>"csd_on_duty", :waiting_calls=>0, :outbound_per_cycle=>1, :operators=>2, :active_calls=>0, :queue_max_waiting_time=>0}, {:OPSTAT_TAG_fifo_name=>"ifirma_rozliczenia_z_operatorem", :waiting_calls=>0, :outbound_per_cycle=>0, :operators=>0, :active_calls=>0, :queue_max_waiting_time=>0}, {:OPSTAT_TAG_fifo_name=>"ifirma_kadry_place_zus", :waiting_calls=>1, :outbound_per_cycle=>3, :operators=>3, :active_calls=>1, :queue_max_waiting_time=>717}, {:OPSTAT_TAG_fifo_name=>"ifirma_ceidg_vat_r", :waiting_calls=>0, :outbound_per_cycle=>1, :operators=>1, :active_calls=>0, :queue_max_waiting_time=>0}, {:OPSTAT_TAG_fifo_name=>"ifirma_rozliczenia_podatkowe", :waiting_calls=>3, :outbound_per_cycle=>10, :operators=>10, :active_calls=>2, :queue_max_waiting_time=>60}]
        time = Time.parse('2020-01-07 11:09:07')
        expect(@parser.parse_data(data: data, time: time)).to eq result_expected
      end
    end
  end

end
