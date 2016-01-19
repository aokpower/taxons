require 'tree'

class Taxons
  # include Enumerable

  attr_reader :taxonomies

  def initialize(taxonomies = [])
    @taxonomies = {}
    taxonomies.to_a.each(&method(:add))
  end

  def add(taxon)
    fail "#{taxon} is not a Taxon!" unless taxon.is_a? Taxon
    @taxonomies[taxon.name] = taxon
  end

  def add_new(name, content = { id: nil })
    add(Taxon.new(name, content))
  end

  def [](params)
    return @taxonomies[params] unless params.is_a? Array # for path accessing
    params.inject(self) {|store, key| store[key] }
  end

  def with_id
    all.flat_map(&:with_id)
  end

  def without_id
    all.flat_map(&:without_id)
  end

  def find_id(id)
    all.flat_map {|taxon| taxon.find_id id }
  end

  def all
    @taxonomies.each_value.each
  end

  class Taxon < Tree::TreeNode
    def initialize(name, content = { id: nil })
      super(name, content)
    end

    def add(taxon)
      fail "#{taxon} is not a Taxon!" unless taxon.is_a? Taxon
      super(taxon)
    end

    def add_new(name, content = { id: nil })
      add(self.class.new(name, content))
    end

    def with_id
      select(&:id).flatten
    end

    def without_id
      reject(&:id).flatten
    end

    def find_id(id)
      select {|taxon| taxon.id == id }.flatten
    end

    def id
      content[:id]
    end

    def id= value
      content[:id] = value
    end
  end
end
