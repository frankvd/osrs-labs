class OSRS::Labs::Core::Account
  property :username
  property :next_scheduled_update

  def initialize(@username : String)
  end

  def equals(other : Account)
    username == other.username
  end
end
