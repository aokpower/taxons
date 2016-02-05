require 'tree'

class Taxonomies
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

  def add_ids(id_map, delimiter = nil)
    return id_map.map {|name, id| find_name(name)[0].id = id } unless delimiter
    id_map.map {|path, id| self[path.split(delimiter)].id = id }
  end

  def [](params)
    return @taxonomies[params] unless params.is_a? Array
    params.inject(@taxonomies) {|store, key| store[key] }
  end

  def values_at(*paths)
    # A convenience method for using #[] more than once.
    #paths.map(&:[])
    paths.map { |path| self[path] }
  end

  def with_id
    all.flat_map(&:with_id)
  end

  def without_id
    all.flat_map(&:without_id)
  end

  def find_id(id)
    all.flat_map {|taxon| taxon.find_id id }.reject(&:nil?)
  end

  def find_name(name)
    # This is called #find_yield or #map_detect in facets/enumerables
    # except that this isn't lazy, and returns an array instead of the first match
    all.flat_map {|taxon| taxon.find_name name }.reject(&:nil?)
  end

  def add_path(path_arr)
    taxonomy, *path_arr = path_arr
    self[taxonomy].nil? ? taxonomy = add_new(taxonomy) : taxonomy = self[taxonomy]

    taxonomy.add_path(path_arr)
  end

  def all
    @taxonomies.each_value
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

    def add_ids(id_map)
      id_map.map do |name, id|
        find_name(name).first.id = id
      end
    end

    def add_path(path_arr)
      path_arr.inject(self) do |parent, new| # new would be 'next', but that's reserved
        parent[new].nil? ? parent.add_new(new) : parent[new]
      end
    end

    def find_name(name)
      find {|taxon| taxon.name == name }
    end

    def with_id
      select(&:id).flatten
    end

    def without_id
      reject(&:id).flatten
    end

    def find_id(id)
      find {|taxon| taxon.id == id }
    end

    def id
      content[:id]
    end

    def id= value
      content[:id] = value
    end
  end
end
