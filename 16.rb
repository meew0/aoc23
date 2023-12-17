load 'utils.rb'
require 'set'
a = inl('16').map(&:chars)

def n(a, en, b)
  x, y, dx, dy = b
  return [] if x < 0 || y < 0 || x >= a[0].length || y >= a.length
  return [] if en[y][x].include?([dx, dy])
  en[y][x] << [dx, dy]
  case a[y][x]
  when '.'
    [[x + dx, y + dy, dx, dy]]
  when '/'
    [[x - dy, y - dx, -dy, -dx]]
  when '\\'
    [[x + dy, y + dx, dy, dx]]
  when '|'
    if dx != 0
      [[x, y + 1, 0, 1], [x, y - 1, 0, -1]]
    else
      [[x, y + dy, dx, dy]]
    end
  when '-'
    if dy != 0
      [[x + 1, y, 1, 0], [x - 1, y, -1, 0]]
    else
      [[x + dx, y, dx, dy]]
    end
  end
end

def it(a, b)
  bs = [b]
  en = a.map { |e| e.map { Set.new } }
  
  until bs.empty?
    bs2 = []
    bs.each { |b| bs2 += n(a, en, b) }
    bs = bs2
  end

  en.map { |e| e.count { |v| !v.empty? } }.sum
end

puts it(a, [0, 0, 1, 0])

ec = []
l = a.length
z = l - 1
l.times do |i|
  ec << it(a, [0, i, 1, 0])
  ec << it(a, [i, 0, 0, 1])
  ec << it(a, [z, i, -1, 0])
  ec << it(a, [i, z, 0, -1])
end
puts ec.max
