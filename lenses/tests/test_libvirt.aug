(*
Module: Test_Libvirt
  Provides unit tests and examples for the <Libvirt> lens.
*)

module Test_Libvirt =

let libvirt_standard_entry = "listen_tls = 0\n"
test Libvirt.lns get libvirt_standard_entry =
{ "listen_tls" = "0" }

let libvirt_dquoted_entry = "tcp_port = \"16509\"\n"
test Libvirt.lns get libvirt_dquoted_entry =
{ "tcp_port" = "16509" }

let libvirt_squoted_entry = "tcp_port = '16509'\n"
test Libvirt.lns get libvirt_squoted_entry =
{ "tcp_port" = "16509" }

let libvirt_entry_with_comment = "mdns_adv = 0 # disable mdns\n"
test Libvirt.lns get libvirt_entry_with_comment =
{ "mdns_adv" = "0"
  { "#comment" = "disable mdns" }
}

let libvirt_entry_with_extra_spaces = "   mdns_adv   =   0   \n"
test Libvirt.lns get libvirt_entry_with_extra_spaces =
{ "mdns_adv" = "0" }

let libvirt_entry_with_no_spaces = "mdns_adv=0\n"
test Libvirt.lns get libvirt_entry_with_no_spaces =
{ "mdns_adv" = "0" }

test Libvirt.lns put "" after
  set "mdns_adv" "1" = "mdns_adv = 1\n"

test Libvirt.lns put "mdns_adv = '0'\n" after
  set "mdns_adv" "1" = "mdns_adv = '1'\n"

test Libvirt.lns put "mdns_adv = \"0\"\n" after
  set "mdns_adv" "1" = "mdns_adv = \"1\"\n"

test Libvirt.lns put "" after
  set "tcp_port" "16509" = "tcp_port = 16509\n"

test Libvirt.lns put "tcp_port = '123'\n" after
  set "tcp_port" "16509" = "tcp_port = '16509'\n"

test Libvirt.lns put "tcp_port = \"123\"\n" after
  set "tcp_port" "16509" = "tcp_port = \"16509\"\n"

test Libvirt.lns put "" after
  set "unix_sock_group" "libvirt" = "unix_sock_group = \"libvirt\"\n"

let libvirt_list_entry = "tls_allowed_dn_list = [\"DN1\", \"DN2\"]\n"
test Libvirt.lns get libvirt_list_entry =
{ "tls_allowed_dn_list"
  { "item" = "DN1" }
  { "item" = "DN2" }
}

let libvirt_multiline_list_entry = "sasl_allowed_username_list = [
  \"joe@EXAMPLE.COM\",
  \"fred@EXAMPLE.COM\"
]\n"
test Libvirt.lns get libvirt_multiline_list_entry =
{ "sasl_allowed_username_list"
  { "item" = "joe@EXAMPLE.COM" }
  { "item" = "fred@EXAMPLE.COM" }
}

let libvirt_conf = "# This is disabled by default, uncomment this to enable it.
listen_tcp = 1

# Override the default configuration which binds to all network
# interfaces. This can be a numeric IPv4/6 address, or hostname
#
listen_addr = \"192.168.0.1\"

cgroup_device_acl = [
    \"/dev/null\", \"/dev/full\", \"/dev/zero\",
    \"/dev/random\", \"/dev/urandom\",
    \"/dev/ptmx\", \"/dev/kvm\", \"/dev/kqemu\",
    \"/dev/rtc\", \"/dev/hpet\",
]

# The maximum number of concurrent client connections to allow
# over all sockets combined.
max_clients = 20
"

test Libvirt.lns get libvirt_conf = {
  { "#comment" = "This is disabled by default, uncomment this to enable it." }
  { }
  { "listen_tcp" = "1" }
  { "#comment" = "Override the default configuration which binds to all network" }
  { "#comment" = "interfaces. This can be a numeric IPv4/6 address, or hostname" }
  { "#comment" = "" }
  { "listen_addr" = "192.168.0.1" }
  { }
  { "cgroup_device_acl"
    { "item" = "/dev/null" }
    { "item" = "/dev/full" }
    { "item" = "/dev/zero" }
    { "item" = "/dev/random" }
    { "item" = "/dev/urandom" }
    { "item" = "/dev/ptmx" }
    { "item" = "/dev/kvm" }
    { "item" = "/dev/kqemu" }
    { "item" = "/dev/rtc" }
    { "item" = "/dev/hpet" }
  }
  { }
  { "#comment" = "The maximum number of concurrent client connections to allow" }
  { "#comment" = "over all sockets combined." }
  { "max_clients" = "20" }
  { }
}
