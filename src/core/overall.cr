class OSRS::Labs::Core::Skills::Overall
  property xp : Int32 = 0
  property level : Int32 = 0
  property rank : Int32 = 0

  def equals(other : Overall)
    xp == other.xp
  end

  def to_s(io)
    io << "Overall      lvl#{level.to_s.ljust 2} #{xp.humanize}"
  end
end
