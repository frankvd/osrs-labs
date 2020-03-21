require "clide"
require "db"
require "sqlite3"
require "option_parser"
require "../osrs-labs"
require "./commands/*"

STDOUT.sync = true

include OSRS::Labs::CLI::Commands
include OSRS::Labs::Persistence
include OSRS::Labs::Collection

db_file = __DIR__ + "/../../var/storage/osrs.db"
OptionParser.parse! do |opts|
  opts.on("-d FILE", "--database FILE", "sqlite database file") do |opt|
    db_file = opt.to_s
  end
end

account_repository = SQLAccountRepository.new "sqlite3://" + db_file
snapshot_repository = SQLSnapshotRepository.new "sqlite3://" + db_file
snapshot_service = SnapshotService.new(account_repository, snapshot_repository, HiscoreParser.new, HiscoreDownloader.new)
app = Clide::Application.new Clide::Input.new, Clide::Output.new
app.register CreateSnapshot.new snapshot_service
app.register ListSnapshots.new snapshot_repository

app.run
