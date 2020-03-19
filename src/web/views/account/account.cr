module OSRS::Labs::Web
  class AccountView < View
    parent __DIR__ + "/../parent.ecr"
    template __DIR__ + "/template.ecr"

    property :account
    property :snapshots

    def initialize(@account : Account, @snapshots : Array(Snapshot))
    end

    def render_skill(__io__, skill_name)
      partial __DIR__ + "/../partials/skill.ecr"
    end

    def last_snapshot
      @snapshots[0]
    end
  end
end
