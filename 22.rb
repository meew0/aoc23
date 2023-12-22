load 'utils.rb'
require 'set'
a = inl('22').map { |e| q, r = e.split('~'); [q.split(',').map(&:to_i), r.split(',').map(&:to_i)]}
ai = a.each_with_index.to_a

def it(e)
  c1, c2 = e
  x1, y1, _ = c1
  x2, y2, _ = c2
  (x1..x2).each { |x| (y1..y2).each { |y| yield [x, y] }}
end

def settle(ai)
  su = {}
  lz, hz = ai.map { |e, _| e.first.last }, ai.map { |e, _| e.last.last }
  lo = 10.times.map { 10.times.map { [] }}
  ai.each { |e, i| it(e) { |x, y| lo[y][x] << i } }
  loop do
    any, u = false, Set.new
    ai.sort_by { |e, i| lz[i] }.each do |e, i|
      next if su.key?(i)
      any, oz = true, lz[i]
      next su[i] = [:g] if oz == 0

      co = Set.new
      it(e) { |x, y| co += lo[y][x] }
      b = co.filter { |ci| hz[ci] == oz - 1 }
      next u << i if b.empty?
      su[i] = b if b.all? { |ci| su.key?(ci) }
    end

    u.each { |i| lz[i] -= 1; hz[i] -= 1 }
    break unless any
  end

  su
end

su = settle(ai)
sui = {}
su.each { |k, v| v.each { |e| (sui[e] ||= []) << k } }

def se(d, su, i2)
  su[i2].any? { |i3| !d.include?(i3) }
end

ok = ai.select { |_, i| (sui[i] || []).all? { |i2| se([i], su, i2) } }
puts ok.length

cr = {}
def crc(d, su, sui, i)
  d << i
  o = (sui[i] || []).reject { |i2| se(d, su, i2) }
  o.each { |i2| d << i2 }
  o.each { |i2| crc(d, su, sui, i2) }
end
ai.each { |e, i| crc(cr[i] = Set.new, su, sui, i) }

puts cr.values.map(&:length).sum - cr.length
