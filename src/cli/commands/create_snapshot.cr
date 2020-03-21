include OSRS::Labs::Core
include OSRS::Labs::Persistence

class OSRS::Labs::CLI::Commands::CreateSnapshot < Clide::Command
  name "create-snapshot"

  def initialize(@snapshot_service : SnapshotService)
  end

  def execute(input : Clide::Input, output : Clide::Output)
    if ARGV.size > 1
      snapshot = @snapshot_service.create_snapshot(Account.new ARGV[1])
    else
      snapshot = @snapshot_service.create_next_snapshot
    end
    unless snapshot.nil?
      puts snapshot.account.username
      puts snapshot.skills
    end
  end
end
