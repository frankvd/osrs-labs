class OSRS::Labs::Collection::HiscoreDownloader
  getter url : String = "https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player=%s"

  def download(username)
    username = URI.encode username
    response = HTTP::Client.get sprintf(url, username)
    raise "Unexpected response" if response.status_code != 200

    response.body
  end
end
