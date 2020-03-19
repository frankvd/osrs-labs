require "../spec_helper"

include OSRS::Labs::Core
include OSRS::Labs::Collection

describe OSRS::Labs::Collection::HiscoreParser do
  it "parses the csv into a skill overview" do
    csv_string = "729587,1291,8079567
    931920,70,740232
    902343,65,466790
    1082379,70,746693
    1028333,71,898765
    992113,71,881970
    1066793,47,79573
    1054259,66,530168
    827945,66,529273
    1313533,55,174537
    1345924,33,19378
    1042304,57,217710
    979817,51,114236
    508027,68,617664
    426136,70,737653
    589091,64,445878
    729727,46,73754
    908958,53,142350
    628432,53,145841
    726512,62,335658
    750526,36,24925
    406287,50,109131
    744466,40,37364
    979760,27,10024
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    -1,-1
    "
    parser = HiscoreParser.new
    skill_overview = parser.parse csv_string
    skill_overview.attack.level.should eq(70)
    skill_overview.construction.level.should eq(27)
    skill_overview.overall.xp.should eq(8079567)
    skill_overview.runecraft.rank.should eq(406287)
  end
end
