load 'utils.rb'
a = inl('1')
b = a.map do |e|
  c = e.scan(/\d/)
  (c.first + c.last).to_i
end
puts b.sum

DIGITS = {
  "one" => '1',
  "two" => '2',
  "three" => '3',
  "four" => '4',
  "five" => '5',
  "six" => '6',
  "seven" => '7',
  "eight" => '8',
  "nine" => '9',
}

d = a.map do |e|
  c = e.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).map(&:first)
  p c
  ((DIGITS[c.first] || c.first) + (DIGITS[c.last] || c.last)).to_i
end
puts d.sum
