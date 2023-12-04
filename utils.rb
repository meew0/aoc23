def inl(key)
  File.read("input/#{key}.txt").lines.map(&:chomp)
end
