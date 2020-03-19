module OSRS::Labs::Persistence
  abstract class AccountRepository
    abstract def find(username)
    abstract def search(username)
  end

  class SQLAccountRepository < AccountRepository

    def initialize(@db : DB::Database | DB::Connection)

    def find(username)
      result = @db.query_one?("SELECT username FROM accounts WHERE username = ?", username, as: {username: String})
      return nil if result.nil?

      Account.new(result.username)
    end

    def search(username)
      result = @db.query_all("SELECT username FROM accounts WHERE username LIKE ?", "%#{username}%", as: {username: String})

      result.map do |row|
        Account.new(row.username)
      end
    end
  end
end
