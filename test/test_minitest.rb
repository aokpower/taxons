require 'test_helper'
require_relative '../lib/taxons'

class TestTaxons < Minitest::Test
  def setup 
    @taxons = Taxons.new
    @taxons.add_new('^00')
    @taxons.add_new('^01')
    @taxons['^00'].add_new('^10')
    @taxons['^01'].add_new('^11')
  end

  def test_crash
    #fix = @taxons['^00']['^10'] # when this is uncommented, no crash.
    refute_nil fix
    assert_equal fix, @taxons['^00/^10'.split('/')]
  end
end
