# frozen_string_literal: true

# Conformance test client for the MCP Ruby SDK.
# Invoked by the conformance runner:
#   MCP_CONFORMANCE_SCENARIO=<scenario> bundle exec ruby conformance/client.rb <server-url>
#
# The server URL is passed as the last positional argument.
# The scenario name is read from the MCP_CONFORMANCE_SCENARIO environment variable,
# which is set automatically by the conformance test runner.

require_relative "../lib/mcp"

scenario = ENV["MCP_CONFORMANCE_SCENARIO"]
server_url = ARGV.last

unless scenario && server_url
  abort("Usage: MCP_CONFORMANCE_SCENARIO=<scenario> ruby conformance/client.rb <server-url>")
end

transport = MCP::Client::HTTP.new(url: server_url)
client = MCP::Client.new(transport: transport)
client.connect(client_info: { name: "ruby-sdk-conformance-client", version: MCP::VERSION })

case scenario
when "initialize"
  client.tools
when "tools_call"
  tools = client.tools
  add_numbers = tools.find { |t| t.name == "add_numbers" }
  abort("Tool add_numbers not found") unless add_numbers
  client.call_tool(tool: add_numbers, arguments: { a: 1, b: 2 })
else
  abort("Unknown or unsupported scenario: #{scenario}")
end
