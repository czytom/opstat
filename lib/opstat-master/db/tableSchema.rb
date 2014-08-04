def init_table_datab
puts "jest w tableschema"
ActiveRecord::Schema.define do
  create_table :xen, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :machine
    table.float :cpu
    table.integer :memory, :limit => 8
    table.integer :memory_max, :limit => 8
    table.integer :nettx, :limit => 8
    table.integer :netrx, :limit => 8
    table.integer :vbd_oo, :limit => 8
    table.integer :vbd_rd, :limit => 8
    table.integer :vbd_wr, :limit => 8
    table.integer :vbd_wsect, :limit => 8
    table.integer :vbd_rsect, :limit => 8

    table.timestamps
  end
  add_index :xen, :timestamp, { :name => 'xen_timestamp_index' }
  add_index :xen, :hostname, { :name => 'xen_hostname_index' }
  add_index :xen, :ip_address, { :name => 'xen_ip_address_index' }
  add_index :xen, :machine, { :name => 'xen_machine_index' }

  create_table :fpm, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :pool
    table.integer :accepted_connections, :limit => 8
    table.integer :listen_queue_max
    table.integer :listen_queue_length
    table.integer :listen_queue
    table.integer :processes_idle
    table.integer :processes_active
    table.integer :processes_active_max
    table.integer :children_max

    table.timestamps
  end
  add_index :fpm, :timestamp, { :name => 'fpm_timestamp_index' }
  add_index :fpm, :hostname, { :name => 'fpm_hostname_index' }
  add_index :fpm, :ip_address, { :name => 'fpm_ip_address_index' }
  add_index :fpm, :pool, { :name => 'fpm_pool_index' }

  create_table :apache2, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.integer :status
    table.integer :bytes_sent, :limit => 8
    table.integer :requests, :limit => 8
    table.string :vhost

    table.timestamps
  end
  add_index :apache2, :timestamp, { :name => 'apache2_timestamp_index' }
  add_index :apache2, :hostname, { :name => 'apache2_hostname_index' }
  add_index :apache2, :ip_address, { :name => 'apache2_ip_address_index' }
  add_index :apache2, :vhost, { :name => 'apache2_vhost_index' }

  create_table :temper, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.float :temperature

    table.timestamps
  end
  add_index :temper, :timestamp, { :name => 'temper_timestamp_index' }
  add_index :temper, :hostname, { :name => 'temper_hostname_index' }
  add_index :temper, :ip_address, { :name => 'temper_ip_address_index' }

  create_table :oracle_sessions, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.integer :used, :limit => 8
    table.integer :free, :limit => 8

    table.timestamps
  end
  add_index :oracle_sessions, :timestamp, { :name => 'oracle_sessions_timestamp_index' }
  add_index :oracle_sessions, :hostname, { :name => 'oracle_sessions_hostname_index' }
  add_index :oracle_sessions, :ip_address, { :name => 'oracle_sessions_ip_address_index' }

  create_table :oracle_tablespaces_sizes, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :name
    table.integer :total, :limit => 8
    table.integer :used, :limit => 8
    table.integer :free, :limit => 8

    table.timestamps
  end
  add_index :oracle_tablespaces_sizes, :timestamp, { :name => 'oracle_tablespaces_sizes_timestamp_index' }
  add_index :oracle_tablespaces_sizes, :hostname, { :name => 'oracle_tablespaces_sizes_hostname_index' }
  add_index :oracle_tablespaces_sizes, :ip_address, { :name => 'oracle_tablespaces_sizes_ip_address_index' }
  add_index :oracle_tablespaces_sizes, :ip_address, { :name => 'oracle_tablespaces_sizes_name_index' }

  create_table :facts, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :name
    table.string :value

    table.timestamps
  end
  add_index :facts, :timestamp, { :name => 'facts_timestamp_index' }
  add_index :facts, :hostname, { :name => 'facts_hostname_index' }
  add_index :facts, :ip_address, { :name => 'facts_ip_address_index' }
  add_index :facts, :ip_address, { :name => 'facts_name_index' }
  add_index :facts, :ip_address, { :name => 'facts_value_index' }

  create_table :nagios, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.integer :services_total
    table.integer :hosts_total
    table.integer :services_checked
    table.integer :hosts_checked
    table.integer :services_ok
    table.integer :services_warning
    table.integer :services_critical
    table.integer :services_unknown
    table.integer :hosts_up
    table.integer :hosts_down
    table.integer :hosts_unreachable
   
    table.timestamps
  end
  add_index :nagios, :timestamp, { :name => 'nagios_timestamp_index' }
  add_index :nagios, :hostname, { :name => 'nagios_hostname_index' }
  add_index :nagios, :ip_address, { :name => 'nagios_ip_address_index' }

  create_table :network, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :interface
    table.integer :bytes_receive, :limit => 8
    table.integer :packets_receive, :limit => 8
    table.integer :errors_receive, :limit => 8
    table.integer :drop_receive, :limit => 8
    table.integer :fifo_receive, :limit => 8
    table.integer :frame_receive, :limit => 8
    table.integer :compressed_receive, :limit => 8
    table.integer :multicast_receive, :limit => 8
    table.integer :bytes_transmit, :limit => 8
    table.integer :packets_transmit, :limit => 8
    table.integer :errors_transmit, :limit => 8
    table.integer :drop_transmit, :limit => 8
    table.integer :fifo_transmit, :limit => 8
    table.integer :frame_transmit, :limit => 8
    table.integer :compressed_transmit, :limit => 8
    table.integer :multicast_transmit, :limit => 8

    table.timestamps
  end
  add_index :network, :timestamp, { :name => 'network_timestamp_index' }
  add_index :network, :hostname, { :name => 'network_hostname_index' }
  add_index :network, :ip_address, { :name => 'network_ip_address_index' }
  add_index :network, :ip_address, { :name => 'network_interface_index' }

  create_table :disk, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :device
    table.string :mount
    table.string :fstype
    table.integer :block_total, :limit => 8
    table.integer :block_used, :limit => 8
    table.integer :block_free, :limit => 8
    table.integer :inode_total, :limit => 8
    table.integer :inode_used, :limit => 8
    table.integer :inode_free, :limit => 8

    table.timestamps
  end
  add_index :disk, :timestamp, { :name => 'disk_timestamp_index' }
  add_index :disk, :hostname, { :name => 'disk_hostname_index' }
  add_index :disk, :ip_address, { :name => 'disk_ip_address_index' }
  add_index :disk, :ip_address, { :name => 'disk_device_index' }

  create_table :memory, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.integer :total, :limit => 8
    table.integer :free, :limit => 8
    table.integer :used, :limit => 8
    table.integer :cached, :limit => 8
    table.integer :buffers, :limit => 8
    table.integer :swap_total, :limit => 8
    table.integer :swap_free, :limit => 8
    table.integer :swap_used, :limit => 8

    table.timestamps
  end
  add_index :memory, :timestamp, { :name => 'memory_timestamp_index' }
  add_index :memory, :hostname, { :name => 'memory_hostname_index' }
  add_index :memory, :ip_address, { :name => 'memory_ip_address_index' }

  create_table :plugins, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.string :plugin
   
    table.timestamps
  end
  add_index :plugins, :created_at, { :name => 'plugins_created_at_index' }
  add_index :plugins, :updated_at, { :name => 'plugins_updated_at_index' }
  add_index :plugins, :hostname, { :name => 'plugins_hostname_index' }
  add_index :plugins, :ip_address, { :name => 'plugins_ip_address_index' }


  create_table :bsdnet, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :interface
    table.integer :bytes_in_v4, :limit => 8
    table.integer :bytes_out_v4, :limit => 8
    table.integer :packets_passed_in_v4, :limit => 8
    table.integer :packets_passed_out_v4, :limit => 8
    table.integer :packets_blocked_in_v4, :limit => 8
    table.integer :packets_blocked_out_v4, :limit => 8
   
    table.timestamps
  end
  add_index :bsdnet, :interface, { :name => 'bsdnet_interface_index' }
  add_index :bsdnet, :timestamp, { :name => 'bsdnet_timestamp_index' }
  add_index :bsdnet, :hostname, { :name => 'bsdnet_hostname_index' }
  add_index :bsdnet, :ip_address, { :name => 'bsdnet_ip_address_index' }

  create_table :load, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.float :load_1m
    table.float :load_5m
    table.float :load_15m
    table.integer :threads_running
    table.integer :threads
   
    table.timestamps
  end
  add_index :load, :timestamp, { :name => 'load_timestamp_index' }
  add_index :load, :hostname, { :name => 'load_hostname_index' }
  add_index :load, :ip_address, { :name => 'load_ip_address_index' }

  create_table :cpu, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :cpu_id
    table.integer :user, :limit => 8
    table.integer :nice, :limit => 8
    table.integer :system, :limit => 8
    table.integer :idle, :limit => 8
    table.integer :iowait, :limit => 8
    table.integer :irq, :limit => 8
    table.integer :softirq, :limit => 8
   
    table.timestamps
  end
  add_index :cpu, :timestamp, { :name => 'cpu_timestamp_index' }
  add_index :cpu, :hostname, { :name => 'cpu_hostname_index' }
  add_index :cpu, :ip_address, { :name => 'cpu_ip_address_index' }
  add_index :cpu, :ip_address, { :name => 'cpu_cpu_id_index' }

  create_table :webobjects, :options => 'DEFAULT CHARSET=UTF8' do |table| 
    table.string :ip_address
    table.string :hostname
    table.datetime :timestamp
    table.string :application_name
    table.integer :instance
    table.integer :sessions
    table.integer :transactions
   
    table.timestamps
  end
  add_index :webobjects, :timestamp, { :name => 'webobjects_timestamp_index' }
  add_index :webobjects, :hostname, { :name => 'webobjects_hostname_index' }
  add_index :webobjects, :ip_address, { :name => 'webobjects_ip_address_index' }
  add_index :webobjects, :ip_address, { :name => 'webobjects_instance_index' }
  add_index :webobjects, :ip_address, { :name => 'webobjects_application_name_index' }


end
end
