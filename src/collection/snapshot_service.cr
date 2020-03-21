class OSRS::Labs::Collection::SnapshotService
  property :account_repository
  property :snapshot_repository
  property :hiscore_parser
  property :hiscore_downloader

  def initialize(
    @account_repository : AccountRepository,
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

    account.next_scheduled_update = new_snapshot.datetime + 4.hours
    account_repository.save account

    new_snapshot
  end

  def create_next_snapshot(force_save = false)
    account = account_repository.find_next_to_update
    return nil if account.nil?

    create_snapshot account, force_save
  end

  def create_next_snapshots(n, force_save = false)
    n.times do
      create_next_snapshot force_save
    end
  end
end
