load 'utils.rb'
a = inl('2')
games = a.map do |e|
  head, tail = e.split(': ')
  rounds = tail.split('; ').map do |round|
    blocks = round.split(', ')
    Hash[blocks.map { |e2| x, y = e2.split(' '); [y.to_sym, x.to_i] }]
  end
  num = head[/\d+/].to_i
  [num, rounds]
end
compare = {
  red: 12,
  green: 13,
  blue: 14,
}
possible = games.filter do |num, rounds|
  rounds.all? { |e| compare.all? { |k, v| (e[k] || 0) <= v }}
end
puts possible.map(&:first).sum

puts games.map { |num, rounds|
  rounds.reduce({}) { |a, e|
    a.merge(e) { |k, o, n| [o, n].max }
  }.values.reduce(1, &:*)
}.sum
