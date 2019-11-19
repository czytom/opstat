module Opstat
  class Config
    include Singleton
    def get(x)
      {'log_level' => 'INFO'}
    end
  end
end

describe 'Disk' do
  describe 'Parsers' do
    describe 'load parser' do
      before :each do
        Opstat::Plugins.load_parser("disk")
        @parser = Opstat::Parsers::Disk.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = JSON.parse(File.readlines('./spec/fixtures/parser_disk_3_mounts.txt').join)
        result_expected = [{"device"=>"xvda1", :inode_total=>1966080, :inode_used=>451532, :inode_free=>1514548, :block_total=>29243300, :block_used=>10779808, :block_free=>18463492, :fstype=>"ext4", :OPSTAT_TAG_mount=>"/", "major_number"=>202, "minor_number"=>1, "reads_completed"=>280919, "reads_merged"=>5, "sector_read"=>3761964, "time_spent_reading_ms"=>1475496, "writes_completed"=>2292754, "writes_merged"=>9526738, "sectors_written"=>95942448, "time_spent_writing"=>29457462, "io_in_progress"=>0, "time_spent_doing_io_ms"=>1306380, "weighted_time_doing_io"=>27352710}, {"device"=>"xvda2", :inode_total=>983040, :inode_used=>54067, :inode_free=>928973, :block_total=>14613448, :block_used=>2950384, :block_free=>11663064, :fstype=>"ext4", :OPSTAT_TAG_mount=>"/var", "major_number"=>202, "minor_number"=>2, "reads_completed"=>10039, "reads_merged"=>1, "sector_read"=>1233234, "time_spent_reading_ms"=>51497, "writes_completed"=>2187480, "writes_merged"=>3613483, "sectors_written"=>55301440, "time_spent_writing"=>1632060, "io_in_progress"=>0, "time_spent_doing_io_ms"=>9217660, "weighted_time_doing_io"=>467580}, {"device"=>"xvda3", :inode_total=>244195328, :inode_used=>294, :inode_free=>244195034, :block_total=>3649273304, :block_used=>3377568604, :block_free=>271704700, :fstype=>"ext4", :OPSTAT_TAG_mount=>"/var/lib/mongodb", "major_number"=>202, "minor_number"=>3, "reads_completed"=>439571, "reads_merged"=>0, "sector_read"=>87283759, "time_spent_reading_ms"=>315165, "writes_completed"=>22945864, "writes_merged"=>6445536, "sectors_written"=>2647656609, "time_spent_writing"=>24503476, "io_in_progress"=>0, "time_spent_doing_io_ms"=>25969240, "weighted_time_doing_io"=>1220}]
        time = Time.now
        expect(@parser.parse_data(data: data, time: time)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = JSON.parse(File.readlines('./spec/fixtures/parser_disk_corrupted.txt').join)
        time = Time.now
        expect(@parser.parse_data(data: data, time: time)).to eq []
      end
    end
  end
end

