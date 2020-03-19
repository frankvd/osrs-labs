class OSRS::Labs::Core::SnapshotCollection
  include Enumerable(Snapshot)

  def initialize(@snapshots : Array(Snapshot))
  end

  def each
    @snaphots.each
  end

  def pluck_skill(skill_name)
    @snaphots.map do |snapshot|
      snapshot.skills.get skill_name
    end
  end
end
