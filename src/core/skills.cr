require "./abstract_skill"
require "./skill_macros"
require "./overall"

module OSRS::Labs::Core::Skills
  def_skills [
    :Attack,
    :Defence,
    :Strength,
    :Hitpoints,
    :Ranged,
    :Prayer,
    :Magic,
    :Cooking,
    :Woodcutting,
    :Fletching,
    :Fishing,
    :Firemaking,
    :Crafting,
    :Smithing,
    :Mining,
    :Herblore,
    :Agility,
    :Thieving,
    :Slayer,
    :Farming,
    :Runecraft,
    :Hunter,
    :Construction,
  ]
end
