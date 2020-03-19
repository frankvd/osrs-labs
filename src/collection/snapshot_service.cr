class OSRS::Labs::Collection::SnapshotService
  property :snapshot_repository
  property :hiscore_parser
  property :hiscore_downloader

  def initialize(
    @snapshot_repository : SnapshotRepository,
    @hiscore_parser : HiscoreParser,
    @hiscore_downloader : HiscoreDownloader
  )
  end

  def create_snapshot(account, force_save = false)
    skill_overview = hiscore_parser.parse(hiscore_downloader.download(account.username))
    new_snapshot = Snapshot.new account
    new_snapshot.skills = skill_overview

    last_snapshot = snapshot_repository.find(account).first?
    if new_snapshot.differs_from(last_snapshot) || force_save
      snapshot_repository.save new_snapshot
    end

    new_snapshot
  end
end
