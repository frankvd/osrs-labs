include OSRS::Labs::Core
include OSRS::Labs::Persistence

class OSRS::Labs::CLI::Commands::CreateSnapshot < Clide::Command
  name "create-snapshot"

  def initialize(@snapshot_service : SnapshotService)
  end

  def execute(input : Clide::Input, output : Clide::Output)
    snapshot = @snapshot_service.create_snapshot(Account.new ARGV[1])
    puts snapshot.skills
  end
end
