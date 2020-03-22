module OSRS::Labs::Persistence
  abstract class AccountRepository
    abstract def find(username)
    abstract def find_next_to_update()
    abstract def search(username)
    abstract def save(account)
  end

  class SQLAccountRepository < AccountRepository

    def initialize(@dsn : String)
    end

    def with_transaction(&block : DB::Transaction -> _)
      DB.open @dsn do |db|
        db.transaction &block
      end
    end

    def find(username)
      result = nil
      with_transaction do |tx|
        result = tx.connection.query_one?("SELECT username, next_scheduled_update FROM accounts WHERE username = ?", username, as: {username: String, next_scheduled_update: Int64})
      end
      return nil if result.nil?

      Account.new(result[:username], Time.unix(result[:next_scheduled_update]))
    end

    def find_next_to_update
      result = nil
      with_transaction do |tx|
        result = tx.connection.query_one?("SELECT username, next_scheduled_update FROM accounts WHERE next_scheduled_update < ? OR next_scheduled_update = 0 ORDER BY next_scheduled_update ASC LIMIT 1", Time.utc.to_unix, as: {username: String, next_scheduled_update: Int64})
      end
      return nil if result.nil?
      row = result.as({username: String, next_scheduled_update: Int64})
      Account.new(row[:username], Time.unix(row[:next_scheduled_update]))
    end

    def search(username)
      result = [] of {username: String, next_scheduled_update: Int64}
      with_transaction do |tx|
        result = tx.connection.query_all("SELECT username, next_scheduled_update FROM accounts WHERE username LIKE ?", "%#{username}%", as: {username: String, next_scheduled_update: Int64})
      end
      result.map do |row|
        Account.new(row[:username], Time.unix(row[:next_scheduled_update]))
      end
    end

    def save(account)
      with_transaction do |tx|
        tx.connection.exec(
          "INSERT INTO accounts(username, next_scheduled_update) VALUES(?, ?) ON CONFLICT(username) DO UPDATE SET next_scheduled_update = ?",
          account.username,
          account.next_scheduled_update.to_unix,
          account.next_scheduled_update.to_unix
        )
      end
    end
  end
end
