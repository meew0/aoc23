load 'utils.rb'
a = inl('5')
seeds = a[0][7..-1].split(' ').map(&:to_i)
maps = []
a[1..-1].each do |l|
  next if l.empty?
  next (maps << []) unless l[0] =~ /\d/
  maps.last << l.split(' ').map(&:to_i)
end

def map(m, v)
  m.each { |d, s, l| return d + (v-s) if v >= s && v < (s+l) }
  v
end

locations = seeds.map { |s| maps.reduce(s) { |a, e| map(e, a) } }
puts locations.min

def map2_indiv(m, v)
  qs, ql = v
  r1, r2, r3 = nil, [], nil
  m.each do |d, s, l|
    if qs >= s && (qs+ql) <= (s+l)
      return [[d + (qs - s), ql]]
    elsif qs >= s && (qs+ql) > (s+l) && qs < (s+l)
      r1 = [qs, d + (qs - s), l - (qs - s)]
    elsif qs < s && (qs+ql) <= (s+l) && (qs+ql) > s
      r3 = [s, d, l - ((s+l) - (qs+ql))]
    elsif qs < s && (qs+ql) > (s+l)
      r2 << [s, d, l]
    end
  end

  res, z = [], qs
  res << (r1.nil? ? [qs, nil] : r1[1..2])
  r2 << r3 unless r3.nil?
  r2.each do |s, d, l|
    res.last[1] = (s - z) if res.last[1].nil?
    z += res.last[1]
    if s > z
      res << [z, s - z]
      z = s
    end
    res << [d, l]
  end

  if res.last[1].nil?
    return [[qs, ql]]
  elsif (z + res.last[1]) < (qs + ql)
    z += res.last[1]
    res << [z, (qs + ql) - z]
  end

  res
end

def map2(m, vs)
  vs.reduce([]) { |a, v| a + map2_indiv(m, v) }
end
 
locations2 = seeds.each_slice(2).map { |s| maps.reduce([s]) { |a, e| map2(e, a) } }
puts locations2.map { |e| e.map(&:first).min }.min
