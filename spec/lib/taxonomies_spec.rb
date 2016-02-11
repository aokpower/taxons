require_relative '../../lib/taxonomies'

RSpec.describe 'Taxonomies' do
  describe Taxonomies do
    before do
      @t = Taxonomies.new
    end

    it 'can add and retrieve taxonomies' do
      @t.add_new('0')
        expect(@t['0']).to be_kind_of(Taxonomies::Taxon)
    end
  end
end
