include OSRS::Labs::Core
include OSRS::Labs::Persistence

class OSRS::Labs::CLI::Commands::ListSnapshots < Clide::Command
  name "list-snapshots"

  def initialize(@snapshot_repository : SnapshotRepository)
  end

  def execute(input : Clide::Input, output : Clide::Output)
    snapshots = @snapshot_repository.find Account.new ARGV[1]

    snapshots.each do |snapshot|
      puts "#{snapshot.datetime} - Total level #{snapshot.skills.overall.level} (#{snapshot.skills.overall.xp.humanize} XP)"
    end
  end
end
