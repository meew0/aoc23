load 'utils.rb'
an = inl('14').map(&:chars)
a = an.transpose
b = a.map do |e|
  f = e.join.split('#').map { |e| e.chars.sort.reverse.join }.join('#').chars
  f += ['#'] * (e.length - f.length)
end
c = b.transpose
l = c.length
puts c.map.with_index { |e, i| e.count('O') * (l - i) }.sum

def s(an, d)
  t = [:n, :s].include?(d)
  r = [:n, :w].include?(d)
  a = t ? an.transpose : an
  b = a.map do |e|
    f = e.join.split('#').map { |e| s = e.chars.sort; (r ? s.reverse : s).join }.join('#').chars
    f += ['#'] * (e.length - f.length)
  end
  t ? b.transpose : b
end

def sc(an, n)
  n.times { an = s(s(s(s(an, :n), :w), :s), :e) }
  an
end

sr = sc(an, 500)
o = sr.map(&:clone)
aa = {}
100.times do
  sr = sc(sr, 1)
  sr.each_with_index do |l, y|
    l.each_with_index do |c, x|
      aa[[x, y]] = [] unless c == o[y][x]
    end
  end
end

100.times do
  sr = sc(sr, 1)
  aa.each do |k, v|
    x, y = k
    v << sr[y][x]
  end
end

N = 999999300

aa.each do |k, v|
  x, y = k
  j = v.join.split(/(?<=\.O)/)
  xa, xb, xc = j.first, j[1], j.last
  q = xb.length - xc.length
  rp = (N - q) % xb.length
  c = xb[rp - 1]
  sr[y][x] = c
end

puts sr.map.with_index { |e, i| e.count('O') * (l - i) }.sum
