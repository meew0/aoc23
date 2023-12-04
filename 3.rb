load 'utils.rb'
a = inl('3')
grid = a.map(&:chars) # y×x
symbol_pos = []
gears = []
grid.each_with_index do |e, y|
  e.each_with_index do |char, x|
    symbol_pos << [y, x] if char =~ /[^0-9\.]/
    gears << [y, x] if char == '*'
  end
end

part_numbers = []
gear_adj = {}
a.each_with_index do |e, y|
  e2 = e.to_enum(:scan, /\d+/).map {e = Regexp.last_match; [e.begin(0), e.to_s]}
  e2.each do |idx, ns|
    pots = [*(y-1)..(y+1)].product([*(idx - 1)..(idx + ns.length)])
    if pots.any? { |e3| symbol_pos.include?(e3) }
      part_numbers << ns.to_i
    end
    gear2 = pots.filter { |e3| gears.include?(e3) }
    gear2.each do |y, x|
      p = [y, x]
      gear_adj[p] ||= []
      gear_adj[p] << ns.to_i
    end 
  end
end

puts part_numbers.sum
puts gear_adj.filter { |k, v| v.length == 2 }.map { |k, v| v.first * v.last }.sum
