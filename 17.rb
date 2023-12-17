load 'utils.rb'
a = inl('17').map(&:chars).map { |e| e.map(&:to_i) }

v = a.map { |e| e.map { {} } }
t = [[0, 0, 1, 0, 0, 1], [0, 0, 0, 1, 0, 1]]

def ap(t, a, v, x, y, dx, dy, h, ns)
  return if x < 0 || y < 0 || x >= a[0].length || y >= a.length
  h += a[y][x]
  oh = v[y][x][[dx, dy, ns]]
  if oh.nil? || h < oh
    v[y][x][[dx, dy, ns]] = h
    t << [x, y, dx, dy, h, ns]
  end
end

until t.empty?
  t2 = []
  t.each do |x, y, dx, dy, h, s|
    if s < 3
      ap(t2, a, v, x + dx, y + dy, dx, dy, h, s + 1)
    end

    ap(t2, a, v, x - dy, y - dx, -dy, -dx, h, 1)
    ap(t2, a, v, x + dy, y + dx, dy, dx, h, 1)
  end
  t = t2
end

puts v[a.length - 1][a[0].length - 1].values.min

v = a.map { |e| e.map { {} } }
t = [[0, 0, 1, 0, 0, 1], [0, 0, 0, 1, 0, 1]]
until t.empty?
  t2 = []
  t.each do |x, y, dx, dy, h, s|
    if s < 10
      ap(t2, a, v, x + dx, y + dy, dx, dy, h, s + 1)
    end

    if s >= 4
      ap(t2, a, v, x - dy, y - dx, -dy, -dx, h, 1)
      ap(t2, a, v, x + dy, y + dx, dy, dx, h, 1)
    end
  end
  t = t2
end

puts v[a.length - 1][a[0].length - 1].select { |k, v| k.last >= 4 }.map(&:last).min
