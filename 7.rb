load 'utils.rb'
a = inl('7')

R = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'J' => 10,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1,
}

def g1(h)
  a = h.chars.sort
  b = a.uniq
  l = b.length
  c = a.group_by { |e| a.count(e) }
  if l == 1
    10
  elsif l == 2 && c.key?(4)
    9
  elsif l == 2 && c.key?(3)
    8
  elsif l == 3 && c.key?(3)
    7
  elsif l == 3 && (c[2] || []).length == 4
    6
  elsif l == 4
    5
  else
    0
  end
end

def g2(h)
  h.chars.reduce(0) { |a, e| (a * 15) + R[e] }
end

def cmp(h1, h2)
  a = g1(h1) <=> g1(h2)
  a == 0 ? (g2(h1) <=> g2(h2)) : a
end

b = a.map { |e| q, r = e.split(' '); [q, r.to_i] }
c = b.sort { |x, y| cmp(x[0], y[0]) }
puts c.map.with_index { |e, i| e[1] * (i + 1) }.sum

R2 = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1,
  'J' => 0,
}

NO_J = [
  'A',
  'K',
  'Q',
  'T',
  '9',
  '8',
  '7',
  '6',
  '5',
  '4',
  '3',
  '2',
]

def g1_2(h)
  j_indices = h.chars.map.with_index { |e, i| i }.select { |i| h[i] == 'J' }
  return g1(h) if j_indices.empty?
  g1_2_recursive(h.clone, j_indices)
end

def g1_2_recursive(h, ji)
  r = NO_J.map do |e|
    h[ji[0]] = e
    if ji.length == 1
      g1(h)
    else
      g1_2_recursive(h, ji[1..-1])
    end
  end
  r.max
end

def g2_2(h)
  h.chars.reduce(0) { |a, e| (a * 15) + R2[e] }
end

def cmp_2(h1, h2)
  a = g1_2(h1) <=> g1_2(h2)
  a == 0 ? (g2_2(h1) <=> g2_2(h2)) : a
end

c2 = b.sort { |x, y| cmp_2(x[0], y[0]) }
puts c2.map.with_index { |e, i| e[1] * (i + 1) }.sum
