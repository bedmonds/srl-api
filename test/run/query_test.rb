require 'srl'

class QueryTests < Minitest::Test
  def test_leaderboard
    assert SRL.leaderboard('alttphacks')
  end
end
