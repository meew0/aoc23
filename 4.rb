load 'utils.rb'
a = inl('4')

cards = a.map do |e|
  p, q = e.split(' | ')
  r, s = p.split(': ')
  [r[/\d+/].to_i, s.split(/ +/).reject(&:empty?).map(&:to_i), q.split(/ +/).reject(&:empty?).map(&:to_i)]
end

rs = cards.map { |k, n1, n2| n2.length - (n2 - n1).length }

puts cards.map { |k, n1, n2| r = rs[k - 1]; r > 0 ? (2 ** (r-1)) : 0 }.sum

res = {}
cards.each do |k, n1, n2|
  r = rs[k - 1]
  res[k] ||= 1
  ima = res[k]
  [*(k+1)..(k+r)].each { |e| puts "#{e}->#{ima}"; res[e] ||= 1; res[e] += ima }
end

p res

puts res.values.sum
