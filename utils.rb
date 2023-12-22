def inl(key)
  File.read("input/#{key}.txt").lines.map(&:chomp)
end

def indices(enum)
  enum.each_with_index.filter_map { |e, i| i if yield(e) }
end
