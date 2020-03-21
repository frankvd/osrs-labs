module OSRS::Labs::Persistence
  abstract class SnapshotRepository
    abstract def find(account)
    abstract def recent(limit)
    abstract def save(snapshot)
  end

  class SQLSnapshotRepository < SnapshotRepository
    def initialize(@dsn : String)
    end

    def with_transaction(&block : DB::Transaction -> _)
      DB.open @dsn do |db|
        db.transaction &block
      end
    end

    def find(account)
      snapshots = {} of Int32 => Core::Snapshot
      with_transaction do |tx|
        rows = tx.connection.query_all(
          "SELECT s.id, overall_level, overall_xp, overall_rank, datetime, username, next_scheduled_update FROM snapshots s JOIN accounts a on a.id = s.account_id WHERE a.username = ? ORDER BY datetime DESC",
          account.username,
          as: {id: Int32, overall_level: Int32, overall_xp: Int32, overall_rank: Int32, datetime: Int64, username: String, next_scheduled_update: Int64}
        )

        fill_snapshots tx, snapshots, rows
      end

      snapshots.values
    end

    protected def fill_snapshots(tx, snapshots, rows)
      rows.each do |r|
        snapshots[r[:id]] = Core::Snapshot.new  Account.new(r[:username], Time.unix(r[:next_scheduled_update])), Time.unix(r[:datetime])
        snapshots[r[:id]].skills.overall.level = r[:overall_level]
        snapshots[r[:id]].skills.overall.xp = r[:overall_xp]
        snapshots[r[:id]].skills.overall.rank = r[:overall_rank]
      end

      ids = rows.map(&.[] :id).join(",")
      skills = tx.connection.query_all(
        "SELECT snapshot_id, skill_name, xp, rank FROM snapshot_skills ss JOIN skills s on s.id = ss.skill_id WHERE snapshot_id IN(" + ids + ")",
        as: {snapshot_id: Int32, skill: String, xp: Int32, rank: Int32}
      )

      skills.each do |skill|
        snapshots[skill[:snapshot_id]].skills.to_h[skill[:skill]].xp = skill[:xp]
        snapshots[skill[:snapshot_id]].skills.to_h[skill[:skill]].rank = skill[:rank]
      end
    end

    def recent(limit = 10)
      snapshots = {} of Int32 => Core::Snapshot
      with_transaction do |tx|
        rows = tx.connection.query_all(
          "SELECT s.id, overall_level, overall_xp, overall_rank, datetime, username, next_scheduled_update FROM snapshots s JOIN accounts a on a.id = s.account_id ORDER BY datetime DESC LIMIT ?",
          limit,
          as: {id: Int32, overall_level: Int32, overall_xp: Int32, overall_rank: Int32, datetime: Int64, username: String, next_scheduled_update: Int64}
        )

        fill_snapshots tx, snapshots, rows
      end

      snapshots.values
    end

    def save(snapshot)
      with_transaction do |tx|
        tx.connection.exec(
          "INSERT INTO accounts(username) VALUES(?) ON CONFLICT(username) DO NOTHING",
          snapshot.account.username
        )
        tx.connection.exec(
          "INSERT INTO snapshots(account_id, overall_level, overall_xp, overall_rank, datetime) VALUES((SELECT id FROM accounts WHERE username = ?), ?, ?, ?, ?) ON CONFLICT(account_id, datetime) DO UPDATE SET overall_level = ?, overall_xp = ?, overall_rank = ?",
          snapshot.account.username,
          snapshot.skills.overall.level,
          snapshot.skills.overall.xp,
          snapshot.skills.overall.rank,
          snapshot.datetime.to_unix,
          snapshot.skills.overall.level,
          snapshot.skills.overall.xp,
          snapshot.skills.overall.rank
        )

        snapshot.skills.to_a.each do |skill|
          tx.connection.exec(
            "INSERT INTO snapshot_skills(snapshot_id, skill_id, xp, rank)
            VALUES(
              (SELECT id FROM snapshots WHERE account_id = (SELECT id FROM accounts WHERE username = ?) AND datetime = ?),
              (SELECT id FROM skills WHERE skill_name = ?),
              ?,
              ?
            )
            ON CONFLICT(snapshot_id, skill_id) DO UPDATE SET xp = ?, rank = ?",
            snapshot.account.username,
            snapshot.datetime.to_unix,
            skill.name,
            skill.xp,
            skill.rank,
            skill.xp,
            skill.rank
          )
        end
      end
    end
  end
end
