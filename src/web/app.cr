require "http/server"
require "ecr"
require "db"
require "sqlite3"
require "rikki"
require "option_parser"
require "../osrs-labs"
require "./view"
require "./views/account"
require "./views/home"

STDOUT.sync = true

include OSRS::Labs::Persistence
include OSRS::Labs::Core
include OSRS::Labs::Web

db_file = __DIR__ + "/../../var/storage/osrs.db"
asset_root = __DIR__ + "/../../assets"
port = 8080
OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
  opts.on("-d FILE", "--database FILE", "sqlite database file") do |opt|
    db_file = opt.to_s
  end
  opts.on("-a DIR", "--asset-root DIR", "asset directory") do |opt|
    asset_root = opt.to_s
  end
end

snapshot_repository = SQLSnapshotRepository.new "sqlite3://" + db_file

router = Rikki::Router.new

router.with [HTTP::ErrorHandler.new, HTTP::LogHandler.new] do
  get "/" do |context|
    snapshots = snapshot_repository.recent
    context.response.content_type = "text/html"
    context.response.print HomeView.new(snapshots)
  end

  get "/account/:username" do |context, params|
    account = Account.new URI.decode(params["username"])
    snapshots = snapshot_repository.find account

    context.response.content_type = "text/html"
    context.response.print AccountView.new(account, snapshots)
  end
end

print router

server = HTTP::Server.new [ HTTP::StaticFileHandler.new(asset_root, true, false), Rikki::RouterHandler.new(router)]

addr = server.bind_tcp "0.0.0.0", port
puts "Listening on http://#{addr}"
server.listen
