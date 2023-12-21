load 'utils.rb'
require 'set'
ah = inl('20').map do |l|
  n, d = l.split(' -> ')
  [n[1..-1], [n[0]] + d.split(', ')]
end
mo = Hash[ah]

fm = Set.new(mo.select { |_, v| v[0] == '%' }.map(&:first))
cm = Set.new(mo.select { |_, v| v[0] == '&' }.map(&:first))
fs = Hash[fm.map { |k| [k, false] }]
cs = Hash[cm.map { |k| [k, Hash[mo.select { |_, v| v[1..-1].include?(k) }.map { |k, _| [k, false] }]]}]
c = { false => 0, true => 0 }

1000.times do |e|
  t = [[nil, 'roadcaster', false]]
  until t.empty?
    t2 = []
    t.each do |ss, ds, lv|
      # puts "#{ss} -#{lv ? 'high' : 'low'}> #{ds}"
      c[lv] += 1
      mt, *co = mo[ds]
      case mt
      when 'b'
        t2 += co.map { |e| [ds, e, lv] }
      when '%'
        unless lv
          fs[ds] = !fs[ds]
          t2 += co.map { |e| [ds, e, fs[ds]] }
        end
      when '&'
        cs[ds][ss] = lv
        n = !cs[ds].values.all? { |e| e }
        t2 += co.map { |e| [ds, e, n] }
      end
    end
    t = t2
  end
end
puts "// #{c[false] * c[true]}"

fs = Hash[fm.map { |k| [k, false] }]
cs = Hash[cm.map { |k| [k, Hash[mo.select { |_, v| v[1..-1].include?(k) }.map { |k, _| [k, false] }]]}]
c = {}

A = ['hn', 'mp', 'xf', 'fz']
10000.times do |e|
  t = [[nil, 'roadcaster', false]]
  until t.empty?
    t2 = []
    t.each do |ss, ds, lv|
      c[ss] ||= e + 1 if A.include?(ss) && lv
      mt, *co = mo[ds]
      case mt
      when 'b'
        t2 += co.map { |e| [ds, e, lv] }
      when '%'
        unless lv
          fs[ds] = !fs[ds]
          t2 += co.map { |e| [ds, e, fs[ds]] }
        end
      when '&'
        cs[ds][ss] = lv
        n = !cs[ds].values.all? { |e| e }
        t2 += co.map { |e| [ds, e, n] }
      end
    end
    t = t2
  end
end

puts "// #{c.values.reduce(1, &:lcm)}"

=begin
puts '#[derive(Clone)]'
puts "enum S {"
puts 'N,'
puts 'S_rx(bool),'
mo.each { |k, v| puts "S_#{k}(bool#{v[0] == '&' ? ', usize' : ''}),"}
puts "}"

puts "pub fn run(){"
fs.map { |k, _| puts "let mut f_#{k} = false;" }
ci = Hash[cs.map { |k, v| [k, Hash[v.keys.each_with_index.to_a]]}]
ci.map do |k, v|
  puts "let mut c_#{k} = [false; #{v.length}];"
end

def msend(mo, ci, ss, ds, lv)
  # puts "if #{lv} { hi += 1; } else { lo += 1; }"
  n = ((mo[ds] || [])[0] == '&') ? "S::S_#{ds}(#{lv}, #{ci[ds][ss]})" : "S::S_#{ds}(#{lv})"
  puts "s[s_end] = #{n};"
  puts "s_end = (s_end + 1) % MAX;"
  puts 'if s_end == s_ptr { panic!("{bc}"); }'
end

puts 'const MAX: usize = 1048576;'
puts 'let mut s = vec![S::N; MAX];'
puts 'let mut s_ptr = 0_usize;'
puts 'let mut s_end = 0_usize;'

# puts 'let mut hi = 0;'
# puts 'let mut lo = 0;'

puts 'let mut bc = 0_u64;'
puts 'loop {'
puts '  s[s_ptr] = S::S_roadcaster(false);'
puts '  s_end = (s_end + 1) % MAX;'
# puts '  lo += 1;'
puts '  bc += 1;'
puts '  if bc % 10000000 == 0 { println!("~ {bc}"); }'
puts "  'i: loop {"
puts "    if s_ptr == s_end { break 'i; }"
puts '    match s[s_ptr] {'
puts "      S::N => {}"
puts '      S::S_rx(true) => {}'
puts '      S::S_rx(false) => { println!("{bc}"); return; }'
mo.each do |k, v|
  mt, *co = v
  puts "S::S_#{k}(lv#{mo[k][0] == '&' ? ', src' : ''}) => {"
  case mt
  when 'b'
    co.each { |e| msend(mo, ci, k, e, 'lv') }
  when '%'
    puts 'if !lv {'
    puts "f_#{k} = !f_#{k};"
    co.each { |e| msend(mo, ci, k, e, "f_#{k}") }
    puts '}'
  when '&'
    puts "c_#{k}[src] = lv;"
    puts "let n = !c_#{k}.iter().all(|e| *e);"
    co.each { |e| msend(mo, ci, k, e, 'n') }
  end
  puts "}"
end
puts '    }'
puts '    s_ptr = (s_ptr + 1) % MAX;'
puts '  }'
# puts '  if bc == 1000 { println!("1: {hi} {lo} {}", hi * lo); }'
puts '}'
puts '}'
=end
