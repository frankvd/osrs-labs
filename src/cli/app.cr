require "clide"
require "db"
require "sqlite3"
require "../osrs-labs"
require "./commands/*"

include OSRS::Labs::CLI::Commands
include OSRS::Labs::Persistence
include OSRS::Labs::Collection

snapshot_repository = SQLSnapshotRepository.new "sqlite3://" + __DIR__ + "/../../var/storage/osrs.db"
snapshot_service = SnapshotService.new(snapshot_repository, HiscoreParser.new, HiscoreDownloader.new)
app = Clide::Application.new Clide::Input.new, Clide::Output.new
app.register CreateSnapshot.new snapshot_service
app.register ListSnapshots.new snapshot_repository

app.run
