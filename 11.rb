load 'utils.rb'
a = inl('11').map(&:chars)

def d(a)
  b = []
  a.each { |e| b += e.all? { |c| c == '.' } ? [e, e] : [e] }
  b
end

b = d(d(a).transpose).transpose

g = []
b.each_with_index do |l, y|
  l.each_with_index do |c, x|
    g << [x, y] if c == '#'
  end
end

s = 0
g.product(g).each do |g1, g2|
  x1, y1 = g1
  x2, y2 = g2
  s += (y2 - y1).abs + (x2 - x1).abs
end

puts s / 2

yl = a.each_with_index.filter_map { |e, i| i if e.all? { |c| c == '.' }}
xl = a.transpose.each_with_index.filter_map { |e, i| i if e.all? { |c| c == '.' }}

def m(n, l)
  r = {}
  c = 0
  n.times do |i|
    r[i] = c
    c += (l.include?(i) ? 1000000 : 1)
  end
  r
end

ym = m(a.length, yl)
xm = m(a[0].length, xl)

g2 = []
a.each_with_index do |l, y|
  l.each_with_index do |c, x|
    g2 << [xm[x], ym[y]] if c == '#'
  end
end

s2 = 0
g2.product(g2).each do |g_1, g_2|
  x1, y1 = g_1
  x2, y2 = g_2
  s2 += (y2 - y1).abs + (x2 - x1).abs
end

puts s2 / 2
