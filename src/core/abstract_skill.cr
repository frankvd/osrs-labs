abstract class OSRS::Labs::Core::Skills::Skill
  property xp : Int32 = 0
  property rank : Int32 = 0

  def initialize(@xp = 0)
  end

  abstract def name

  def xp_needed(level)
    ((level - 1) + 300 * 2**((level - 1) / 7)).floor / 4
  end

  def total_xp_needed(level)
    ((2..level).map {|l| xp_needed l}).sum.floor
  end

  def level
    level_at_xp @xp
  end

  def equals(other : Skill)
    name == other.name && xp == other.xp
  end

  def level_at_xp(xp)
    lvl = 1
    (2..99).reduce(0) do |acc, i|
      acc += xp_needed(i)
      break if xp < acc.floor
      lvl += 1
      acc
    end

    lvl
  end

  def to_s(io)
    io << "#{name.ljust 12} lvl#{level.to_s.ljust 2} #{xp.humanize}"
  end
end
