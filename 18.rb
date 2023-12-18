load 'utils.rb'
a = inl('18')
is = a.map { |e| q, r, s = e.split(' '); [q, r.to_i, s[2..-2].to_i(16)]}

def area2(z)
  v = []
  x, y, l = 0, 0, 0
  z.each_with_index do |e, i|
    d, s = e
    d2, _ = (z[i + 1] || z[0])
    case d
    when 0 # r
      x = x + s
    when 1 # d
      y = y + s
    when 2 # l
      x = x - s
    when 3 # u
      y = y - s
    end
    v << [x, y]
    l += s
  end
  a = v.each_cons(2).map { |e1, e2| e1[0] * e2[1] - e1[1] * e2[0] }.sum / 2 + l / 2 + 1
end

def dc(c)
  [c & 3, c >> 4]
end

puts area2(is.map { |dp, s, _| [{ 'R' => 0, 'D' => 1, 'L' => 2, 'U' => 3 }[dp], s] })
puts area2(is.map { |_, _, c| dc(c) })
