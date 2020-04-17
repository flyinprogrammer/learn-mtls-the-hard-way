verify_incoming = false
verify_outgoing = true
verify_server_hostname = true
ca_file = "consul-agent-ca.pem"
cert_file = "dc1-server-consul-0.pem"
key_file = "dc1-server-consul-0-key.pem"
bootstrap_expect = 1
server = true
ui = true
data_dir = "./data_dir"
ports {
  http = -1
  https = 8501
}
bind_addr = "127.0.0.1"
