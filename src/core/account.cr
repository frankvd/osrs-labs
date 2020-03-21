class OSRS::Labs::Core::Account
  property :username
  property :next_scheduled_update

  def initialize(@username : String)
    @next_scheduled_update = Time.unix 0
  end

  def initialize(@username : String, @next_scheduled_update : Time)
  end

  def equals(other : Account)
    username == other.username
  end
end
