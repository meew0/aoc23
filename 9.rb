load 'utils.rb'
a = inl('9')
vs = a.map { |e| e.split(' ').map(&:to_i) }

def rd(v)
  return 0 if v.all? { |e| e == 0 }
  v.last + rd(v.each_cons(2).map { |q, r| r - q })
end

puts vs.map { |v| rd(v) }.sum

def rd2(v)
  return 0 if v.all? { |e| e == 0 }
  v.first + rd2(v.each_cons(2).map { |q, r| q - r })
end

puts vs.map { |v| rd2(v) }.sum
