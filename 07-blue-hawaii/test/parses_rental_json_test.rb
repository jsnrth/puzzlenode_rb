require 'minitest_helper'
require 'rentals'

class ParsesJsonTest < Minitest::Test

  @@data_file = File.expand_path('./test_rentals.json', File.dirname(__FILE__))

  def rentals
    @@rentals ||= Rentals::ParsesData.new.parse_json(File.read(@@data_file))
  end

  def test_there_are_three_rentals
    assert_equal 3, rentals.length
  end

  def test_parses_fern_grove_lodge
    fern_grove_lodge = rentals.find { |r| r.name == 'Fern Grove Lodge' }

    assert_equal 2, fern_grove_lodge.seasons.length

    season_one = fern_grove_lodge.seasons.find { |s| s.name == 'one' }
    assert_equal [5, 1], [season_one.start.month, season_one.start.day]
    assert_equal [5, 13], [season_one.end.month, season_one.end.day]
    assert_equal BigDecimal('137'), season_one.rate

    season_two = fern_grove_lodge.seasons.find { |s| s.name == 'two' }
    assert_equal [5, 14], [season_two.start.month, season_two.start.day]
    assert_equal [4, 30], [season_two.end.month, season_two.end.day]
    assert_equal BigDecimal('220'), season_two.rate

    assert_equal :varies, fern_grove_lodge.rate

    assert_equal BigDecimal('98'), fern_grove_lodge.cleaning_fee
  end

  def test_parses_paradise_inn
    paradise_inn = rentals.find { |r| r.name == 'Paradise Inn' }
    assert_empty paradise_inn.seasons
    assert_equal BigDecimal('250'), paradise_inn.rate
    assert_equal BigDecimal('120'), paradise_inn.cleaning_fee
  end

  def test_honus_hideaway
    honus_hideaway = rentals.find { |r| r.name == "Honu's Hideaway" }

    assert_equal 2, honus_hideaway.seasons.length

    season_one = honus_hideaway.seasons.find { |s| s.name == 'one' }
    assert_equal [2, 1], [season_one.start.month, season_one.start.day]
    assert_equal [7, 31], [season_one.end.month, season_one.end.day]
    assert_equal BigDecimal('165'), season_one.rate

    season_two = honus_hideaway.seasons.find { |s| s.name == 'two' }
    assert_equal [8, 1], [season_two.start.month, season_two.start.day]
    assert_equal [1, 31], [season_two.end.month, season_two.end.day]
    assert_equal BigDecimal('187'), season_two.rate

    assert_equal :none, honus_hideaway.cleaning_fee
  end
end
