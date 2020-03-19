include OSRS::Labs::Core
include OSRS::Labs::Core::Skills

class OSRS::Labs::Collection::HiscoreParser
  def order
    [
      overall,
      skill("Attack"),
      skill("Defence"),
      skill("Strength"),
      skill("Hitpoints"),
      skill("Ranged"),
      skill("Prayer"),
      skill("Magic"),
      skill("Cooking"),
      skill("Woodcutting"),
      skill("Fletching"),
      skill("Fishing"),
      skill("Firemaking"),
      skill("Crafting"),
      skill("Smithing"),
      skill("Mining"),
      skill("Herblore"),
      skill("Agility"),
      skill("Thieving"),
      skill("Slayer"),
      skill("Farming"),
      skill("Runecraft"),
      skill("Hunter"),
      skill("Construction")
  ]
  end

  def parse(string_or_io : String | IO)
    csv = CSV.new string_or_io
    skill_overview = SkillOverview.new
    order.each do |proc|
      csv.next
      proc.call(skill_overview, csv)
    end

    skill_overview
  end

  def skill(skill_name)
    ->(skill_overview : SkillOverview, csv : CSV) {
      skill = skill_overview.get(skill_name)
      skill.rank = csv[0].to_i
      skill.xp = csv[2].to_i
      raise "Unexpected #{skill_name} level" if csv[1].to_i != skill.level
    }
  end

  def overall
    ->(skill_overview : SkillOverview, csv : CSV) {
      overall = skill_overview.overall
      overall.rank = csv[0].to_i
      overall.level = csv[1].to_i
      overall.xp = csv[2].to_i
    }
  end
end
