require 'test_helper'
require_relative '../lib/taxons'

class TestTaxons < Minitest::Test
  context 'given a new Taxons object' do
    setup { @taxons = Taxons.new }

    context 'with 2 taxonomies, with taxons' do
      setup do
        @taxons.add_new('^00')
        @taxons.add_new('^01')
        @taxons['^00'].add_new('^10')
        @taxons['^01'].add_new('^11')
      end


      context 'when looking up by path' do
        should 'return the right taxon' do
          #fix = @taxons['^00']['^10'] # when this is uncommented, no crash.
          refute_nil fix
          assert_equal fix, @taxons['^00/^10'.split('/')]
        end
      end
    end
  end
end
