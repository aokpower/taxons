require 'test_helper'
require_relative '../lib/taxons'

class TestTaxons < Minitest::Test
  context 'given a new Taxons object' do
    setup { @taxons = Taxons.new }

    context 'with a taxonomy' do
      setup { @taxons.add_new('ROOT1') }

      should 'have 1 taxonomy' do
        assert_equal 1, @taxons.taxonomies.length
      end

      context 'and a taxon' do
        setup { @taxons['ROOT1'].add_new('^1') }

        should 'have the \'^1\' taxon below ROOT1' do
          assert @taxons['ROOT1']['^1']
        end
      end
    end

    context 'with 2 taxonomies, with taxons' do
      setup do
        @taxons.add_new('^00')
        @taxons.add_new('^01')
        @taxons['^00'].add_new('^10')
        @taxons['^01'].add_new('^11')
      end

      context 'when asking for taxons without ids' do
        should 'return taxon(s,onomies) without an id' do
          assert_equal 4, @taxons.without_id.size
          @taxons.without_id.each do |taxon|
            assert_kind_of Taxons::Taxon, taxon
          end
        end

        context 'and one has an id' do
          setup { @taxons['^00']['^10'].id = 1 }

          should 'have 3 without ids' do
            assert_equal 3, @taxons.without_id.size
          end

          should 'have ^00/^10 with id' do
            assert_equal '^10', @taxons.with_id[0].name
            assert_equal 1, @taxons.with_id.size
          end

          context 'when looking up by id' do
            setup { @lookup = @taxons.find_id 1 }
            should 'return the correct taxon' do
              assert_equal '^10', @taxons.find_id(1)[0].name
            end
          end
        end
      end

      context 'when looking up by path' do
        should 'return the right taxon' do
          fix = @taxons['^00']['^10'] # comment this line to crash ruby
          refute_nil fix
          assert_equal fix, @taxons['^00/^10'.split('/')]
        end
      end

    end

  context 'when you look for an id'
  context 'when you look for a name'
  context 'when you add multiple ids'
  end
end
