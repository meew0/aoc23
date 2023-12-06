load 'utils.rb'
times = [61, 67, 75, 71]
distances = [430, 1036, 1307, 1150]

races = times.zip(distances)
def res(t1, t)
  t1 * (t - t1)
end

puts races.map { |t, d| 0.upto(t).count { |e| res(e, t) > d } }.reduce(1, &:*)

t = 61677571
d = 430103613071150

def bs(t, d, b1, b2, &block)
  r1, r2 = res(b1, t), res(b2, t)
  return b2 if b1 + 1 == b2
  c = b1 + (b2 - b1) / 2
  rc = res(c, t)
  p [t, d, b1, b2, c, rc]
  if yield(rc, d)
    b1 = c
  else
    b2 = c
  end

  bs(t, d, b1, b2, &block)
end

a = bs(t, d, 0, t / 2) { |r, d| r <= d }
b = bs(t, d, t / 2, t) { |r, d| r > d }
puts b - a
