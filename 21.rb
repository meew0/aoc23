load 'utils.rb'
require 'set'
ah = inl('21').map(&:chars)
SX = 65
SY = 65

def a(t, ah, x, y)
  return if ah[y % ah.length][x % ah[0].length] == '#'
  t << [x, y]
end

def s(t, ah, x, y)
  a(t, ah, x + 1, y)
  a(t, ah, x - 1, y)
  a(t, ah, x, y + 1)
  a(t, ah, x, y - 1)
end

t = Set.new([[SX, SY]])
64.times do |e|
  t2 = Set.new
  t.each { |x, y| s(t2, ah, x, y) }
  t = t2
end

puts t.length

t = Set.new([[SX, SY]])
K = 26501365
KP = K / 131

(262 + (K % 131)).times do |e|
  t2 = Set.new
  t.each { |x, y| s(t2, ah, x, y) }
  t = t2
end

u = 12.times.map { ([0] * 12) }
12.times.each do |yy|
  ylo = (yy - 6) * ah.length
  yhi = ylo + ah.length
  12.times.each do |xx|
    xlo = (xx - 6) * ah[0].length
    xhi = xlo + ah.length
    t.each do |x, y|
      u[yy][xx] += 1 if x >= xlo && x < xhi && y >= ylo && y < yhi
    end
  end
end
#u.each { |e| puts e.map { |e2| e2.to_s.rjust(6, ' ') }.join }

vc = u[4][6] + u[6][4] + u[8][6] + u[6][8]
veo = KP * (u[4][5] + u[4][7] + u[8][5] + u[8][7])
vei = (KP - 1) * (u[5][5] + u[5][7] + u[7][5] + u[7][7])
we, wo = u[6][6], u[6][7]

v = vc + veo + vei
KP.times do |e|
  v += ((e % 2 == 0) ? we : wo) * ((e == 0) ? 1 : (e * 4))
end
puts v
