actions :create

attribute :dhcp, :equal_to => [true, false], :default => true
attribute :onboot, :equal_to => [true, false], :default => true
attribute :hwaddr, :equal_to => [true, false], :default => false
attribute :uuid, :equal_to => [true, false], :default => false
attribute :broadcast, :kind_of => String
attribute :ipaddr, :kind_of => String
attribute :network, :kind_of => String
attribute :gateway, :kind_of => String
attribute :nm_controlled, :equal_to => [true, false], :default => false
attribute :bridge, :default => false
