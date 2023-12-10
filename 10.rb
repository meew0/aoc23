load 'utils.rb'
a = inl('10')
sy = a.index { |e| e.include? 'S' }
sx = a[sy].chars.index('S')


E = ['-', 'L', 'F', 'S']
W = ['-', 'J', '7', 'S']
N = ['|', 'L', 'J', 'S']
S = ['|', 'F', '7', 'S']

def n(a, x, y)
  w, h = a[0].length, a.length
  res = []
  c = a[y][x]
  res << [x + 1, y] if (x + 1) < w && E.include?(c) && W.include?(a[y][x + 1])
  res << [x - 1, y] if (x - 1) >= 0 && W.include?(c) && E.include?(a[y][x - 1])
  res << [x, y + 1] if (y + 1) < h && S.include?(c) && N.include?(a[y + 1][x])
  res << [x, y - 1] if (x - 1) >= 0 && N.include?(c) && S.include?(a[y - 1][x])
  res
end

def nit(a, pp, cp)
  x, y = cp
  p1, p2 = n(a, x, y)
  pp == p1 ? p2 : p1
end

pp1 = pp2 = [sx, sy]
p1, p2 = n(a, sx, sy)
i = 1
require 'set'
l = Set.new
l << pp1
l << p1
l << p2

loop do
  pp1, pp2, p1, p2 = p1, p2, nit(a, pp1, p1), nit(a, pp2, p2)
  l << p1
  l << p2
  i += 1
  break puts i if p1 == p2
end

# S = L

def c(a, l, x, y)
  return false if l.include?([x, y])
  q = 0

  until x < 0
    if l.include?([x, y])
      c = a[y][x]
      q += 0.5 if ['L', '7', 'S'].include?(c)
      q -= 0.5 if ['F', 'J'].include?(c)
      q += 1 if c == '|'
    end
    x -= 1
  end

  q % 2 != 0
end

a2 = a.map(&:clone)
l.each { |x, y| a2[y][x] = '#' }
w, h = a[0].length, a.length
i = 0
w.times do |x|
  h.times do |y|
    i, a2[y][x] = i + 1, 'I' if c(a, l, x, y)
  end
end
a2.map { |e| puts e }
puts i
