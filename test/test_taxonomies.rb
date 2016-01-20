require 'test_helper'
require_relative '../lib/taxonomies'

class TestTaxonomies < Minitest::Test
  context 'given a new Taxonomies object' do
    setup { @taxons = Taxonomies.new }

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

    context 'with 3 taxons' do
      setup do
        @path = ['top', 'second', 'third']
        @taxons.add_path(@path)
      end

      should 'have those taxons' do
        assert_equal 'third', @taxons[@path].name
        assert_equal 3, @taxons.without_id.size
      end

      context 'when trying to add the same taxons' do
        should 'return it as if it were called with :[]' do
          assert_equal @taxons[@path], @taxons.add_path(@path)
        end

        should 'have the same number of taxons' do
          assert_equal 3, @taxons.without_id.size
        end
      end

      context 'and two more taxons' do
        setup do
          @taxons.add_path ['top', 'fourth']
          @taxons.add_path ['top', 'second', 'third', 'fifth']
        end

        should 'have 5 taxons' do
          assert_equal 5, @taxons.without_id.size
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

      context 'and no ids' do
        context 'when looking for taxons without ids' do
          should 'return taxon(s,onomies) without an id' do
            assert_equal 4, @taxons.without_id.size
            @taxons.without_id.each do |taxon|
              assert_kind_of Taxonomies::Taxon, taxon
            end
          end
        end

        context 'when looking for taxons by name' do
          should 'find the right taxon' do
            assert_equal '^11', @taxons.find_name('^11')[0].name
          end
        end

        context 'when you add ids' do
          context 'with names' do
            setup { @taxons.add_ids({ '^11' => 1, '^01' => 2, '^00' => 3 }) }

            should 'have the right number with ids' do
              assert_equal 3, @taxons.with_id.size
            end
          end

          context 'with paths' do
            setup { @taxons.add_ids({ '^01/^11' => 1, '^00' => 2 }, '/') }

            should 'have the right number with ids' do
              assert_equal 2, @taxons.with_id.size
            end
          end
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

      context 'when looking up by path' do
        should 'return the right taxon' do
          fix = @taxons['^00']['^10'] # comment this line to crash ruby
          refute_nil fix
          assert_equal fix, @taxons['^00/^10'.split('/')]
        end
      end
    end
  end
end
