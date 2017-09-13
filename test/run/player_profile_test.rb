require 'srl'

class PlayerProfileTests < Minitest::Test
  def test_player_profile
    assert_equal 'https://twitch.tv/Artea_SRL/',
                 SRL.player('Artea').stream
  end

  def test_bad_player_name_dies
    # * or at least until someone sees this and registers the name.
    assert_raises(NameError) { SRL.player('ihatetunafishanddeadbeef') }
  end
end
