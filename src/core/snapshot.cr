class OSRS::Labs::Core::Snapshot
  property :datetime
  property :account
  property :skills

  def initialize(@account : Account)
    @skills = Skills::SkillOverview.new
    @datetime = Time.utc
  end

  def initialize(@account : Account, @datetime : Time)
    @skills = Skills::SkillOverview.new
  end

  def equals(other : Snapshot)
    account.equals(other.account) && skills.equals(other.skills)
  end

  def differs_from(other : Snapshot)
    !equals(other)
  end

  def differs_from(other : Nil)
    true
  end
end
