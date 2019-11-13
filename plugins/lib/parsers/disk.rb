require 'yaml'

# TODO connect client settings with master (version, etc)
# df --output='source,fstype,used,avail,itotal,iused,iavail,target'
module Opstat
module Parsers
  FS_TYPES = ["ext2", "ext3", "ext4", "reiserfs", "xfs", "jfs"]
  class Disk
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      oplogger.debug data
      data['disk_space'].each do |line|
        stats = line.split
        if FS_TYPES.include?(stats[1]) and stats.count == 8
          space_usage_report = get_space_usage_report(stats)
          device = space_usage_report['device']
          disk_io_report = get_disk_io_stats_for_device(device,data['disk_io'])
          reports << space_usage_report.merge(disk_io_report)
        end
      end
      return reports
    end
    def get_space_usage_report(stats)
      {
        'device' => stats[0].delete_prefix('/dev/'),
        :inode_total => stats[4].to_i,
        :inode_used => stats[5].to_i,
        :inode_free => stats[6].to_i,
        :block_total => stats[2].to_i + stats[3].to_i,
        :block_used => stats[2].to_i,
        :block_free => stats[3].to_i,
        :fstype => stats[1],
        :OPSTAT_TAG_mount => stats[7]
      }
    end

    def get_disk_io_stats_for_device(device, data)
      raw_disk_io_line = data.grep(/#{device}/).first
      return {} if raw_disk_io_line.nil?
      raw_disk_io_line.match(/^\s+(?<major_number>\d+)\s+(?<minor_number>\d+)\s+\S+\s+(?<reads_completed>\d+)\s+(?<reads_merged>\d+)\s+(?<sector_read>\d+)\s+(?<time_spent_reading_ms>\d+)\s+(?<writes_completed>\d+)\s+(?<writes_merged>\d+)\s+(?<sectors_written>\d+)\s+(?<time_spent_writing>\d+)\s+(?<io_in_progress>\d+)\s+(?<time_spent_doing_io_ms>\d+)\s+(?<weighted_time_doing_io>\d+)\s+.*/)
      unless $~.nil?
        return $~.names.zip($~.captures).map{|m| [m[0],m[1].to_i]}.to_h
      end
      return {}
    end 
  end
end
end
