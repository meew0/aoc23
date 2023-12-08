load 'utils.rb'
a = inl('8')

ins = a[0]
ro = a[2..-1].map { |e| q, r, s = e.scan(/[A-Z]{3}/); [q, [r, s]] }
ro = Hash[ro]
p ro

i = 0
cur = "AAA"
Z = { 'L' => 0, 'R' => 1 }
loop do
  s = ins[i % ins.length]
  cur = ro[cur][Z[s]]
  i += 1
  break if cur == "ZZZ"
end

puts i

def follow(ro, ins, cur)
  i = 0
  loop do
    s = ins[i % ins.length]
    cur = ro[cur][Z[s]]
    i += 1
    break if cur[2] == "Z"
  end
  i
end

a_nodes = ro.keys.select { |e| e[2] == "A" }
res = a_nodes.map { |cur| follow(ro, ins, cur) }
puts res.reduce(1, &:lcm)
