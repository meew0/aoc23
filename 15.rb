load 'utils.rb'
a = inl('15').first
is = a.split(',')

def h(s)
  s.chars.reduce(0) { |a, e| ((a + e.ord) * 17) % 256 }
end

puts is.map { |e| h(e) }.sum

b = 256.times.map { [] }
is.map do |e|
  l, o = e.scan(/([a-z]+)(=\d|-)/).first
  bi = h(l)
  if o[0] == '-'
    b[bi].delete_if { |el, ef| el == l }
  elsif o[0] == '='
    f = o[1..-1].to_i
    li = b[bi].index { |el, ef| el == l }
    if li.nil?
      b[bi].push([l, f])
    else
      b[bi][li][1] = f
    end
  end
end

puts b.map.with_index { |bx, bi| bx.map.with_index { |e, li| _, ef = e; (bi + 1) * (li + 1) * ef }.sum }.sum
