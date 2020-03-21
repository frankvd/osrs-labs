module OSRS::Labs::Web
  class HomeView < View
    parent __DIR__ + "/../parent.ecr"
    template __DIR__ + "/template.ecr"

    property :recent_snapshots

    def initialize(@recent_snapshots : Array(Snapshot))
    end
  end
end
