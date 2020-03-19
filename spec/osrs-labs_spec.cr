require "./spec_helper"

describe OSRS::Labs do
  it "has skill definitions" do
    woodcutting = OSRS::Labs::Core::Skills::Woodcutting.new(40100)

    woodcutting.level.should eq(40)
    woodcutting.name.should eq("Woodcutting")

    attack = OSRS::Labs::Core::Skills::Attack.new(40100)

    attack.level.should eq(40)
    attack.name.should eq("Attack")
  end

  it "has a skill overview" do
    skills = OSRS::Labs::Core::Skills::SkillOverview.new

    skills.attack.should be_a(OSRS::Labs::Core::Skills::Attack)
    skills.to_a.should be_a(Array(OSRS::Labs::Core::Skills::Skill))
  end
end
