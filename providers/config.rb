# Generally I don't believe in commenting code
# And if code requires comments it probably needs to be refactored
# So consider this a TODO ...

# Get the MAC address of a named NIC
def get_hwaddr(nic)
  ipll = %x[ip -o link list dev #{nic}]
  ipll.match(/ether (([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2})/)[1]
end


# Generate a random UUID for an interface config file
def generate_uuid
  %x[uuidgen].chomp
end

# This provider can only create a RHEL-style interface snippet

action :create do

# The template reads entries from a Hash

  template_vars = Hash.new

  # If we're not using DHCP, we need to set IP, Gateway, Broadcast and Network 
  # So we populate the Hash with the values from the resource

  if new_resource.dhcp == false
    # These are the keys for the Hash
    static_keys = [:ipaddr, :gateway, :broadcast, :network]
    # We get the values from the resource - they are Strings
    static_values = [
                     new_resource.ipaddr, 
                     new_resource.gateway, 
                     new_resource.broadcast,  
                     new_resource.network
                    ]

    # The config won't work if one of IP, Gateway, Broadcast or Network is missing
    if static_values.include? nil
      raise "Static IP configuration requires ipaddr, gateway, broadcast and network" unless new_resource.bridge != false
    end

    
    # Populate the Hash with the static keys and values
    # If we have no static keys and values, nothing happens
    template_vars = Hash[static_keys.zip(static_values)]
    Chef::Log.info(template_vars)
  end

  # The crux of the config is whether we want to configure a bridge
  # There are three options for an interface
  # 1) Nothing to do with bridging at all
  # 2) The interface is a bridge
  # 3) The interface is a member of a bridge

  # If the interface is not a bridge, and has nothing to do with bridging
  # Then the value from the resource will be "false"
  # And we will pass in "false" to the templaye

  # If the interface *is* a bridge
  # Then the value from the resource will be "bridge"
  # The bridge needs a name, which will be the same as the interface name
  # And we will pass in "bridge" to the template
  
  # If the interface is a *member* of a bridge
  # Then the value from the resource will the name of the bridge it belongs to
  # The bridge needs a name, which will be the name of the bridge it belongs to
  # And we will pass in "member" to the template

  if new_resource.bridge == false
    bridge = false
    bridgename = false
  elsif new_resource.bridge == true
    bridge = true
    bridgename = new_resource.name
  else
    bridge = "member"
    bridgename = new_resource.bridge
  end

  # Now we have some logic to decide whether to create UUIDs and MAC Addresses

  uuid = new_resource.uuid ? generate_uuid : false

  unless new_resource.bridge == "bridge"
    hwaddr = new_resource.hwaddr ? get_hwaddr(new_resource.name) : false 
  end

  # The network config uses "yes" and "no" rather than "true" and "false"
  # This simply converts it

  nm_controlled = new_resource.nm_controlled ? "yes" : "no" 
  onboot = new_resource.onboot ? "yes" : "no" 

  # Now let's render the template

  template "/etc/sysconfig/network-scripts/ifcfg-#{new_resource.name}" do
    source "ifcfg-nic.erb"
    cookbook "network"
    # The merge handles the static values, if needed
    template_vars.merge!({
                           :interface => new_resource.name,
                           :dhcp => new_resource.dhcp,
                           :onboot => onboot,
                           :nm_controlled => nm_controlled,
                           :hwaddr => hwaddr,
                           :uuid => uuid,
                           :bridge => bridge,
                           :bridgename => bridgename
                         })
    variables(template_vars)
    notifies :restart, "service[network]", :delayed
  end

end
