describe 'Webobjects' do
  describe 'Parsers' do
    describe 'webobjects parser' do
      before :each do
        Opstat::Plugins.load_parser("webobjects")
          @parser = Opstat::Parsers::Webobjects.new
      end

it 'returns report for many apps with many configured instances' do
  data_in = File.read('./spec/fixtures/parser_webobjects_many_apps_many_instances.txt')
  result_expected = YAML::load_file('./spec/fixtures/parser_webobjects_many_apps_many_instances.result.yml')
  time = Time.new(2020, 04, 04, 12, 2, 2, "+02:00")
  expect(@parser.parse_data(data: data_in, time: time)).to eq result_expected
end

it 'returns report for one app with many configured instances' do
  data_in = File.read('./spec/fixtures/parser_webobjects_one_app_many_instances.txt')
  result_expected = YAML::load_file('./spec/fixtures/parser_webobjects_one_app_many_instances.result.yml')
  time = Time.new(2020, 04, 04, 12, 2, 2, "+02:00")
  expect(@parser.parse_data(data: data_in, time: time)).to match_array result_expected
end
    end
  end
end
