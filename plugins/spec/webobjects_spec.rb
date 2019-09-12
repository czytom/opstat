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
  expect(@parser.parse_data(data_in)).to eq result_expected
end

it 'returns report for one app with many configured instances' do
  data_in = File.read('./spec/fixtures/parser_webobjects_one_app_many_instances.txt')
  result_expected = YAML::load_file('./spec/fixtures/parser_webobjects_one_app_many_instances.result.yml')
  expect(@parser.parse_data(data_in)).to eq result_expected
end

#it 'return empty array where input data are corrupted' do
#   haproxy_data = File.read('./spec/fixtures/parser_haproxy_corrupted.txt')
#   empty = Hash.new
#   expect(@haproxy_parser.parse_data(haproxy_data)).to eq empty = []
#end
    end
  end
end
