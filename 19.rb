load 'utils.rb'
a = inl('19')
sp, sw = a.partition { |l| l.start_with? '{' }
w = sw.reject(&:empty?).map do |l|
  p l
  n = l[/^([a-z]+)/]
  c = l[/\{([^\}]+)\}/][1..-2]
  z = c.split(',').map { |c2| q, r = c2.split(':'); r.nil? ? [q] : [r, q[0], q[1], q[2..-1].to_i ]}
  [n, z]
end
wh = Hash[w]
pt = sp.map do |l|
  Hash[l[1..-2].split(',').map { |e| q, r = e.split('='); [q, r.to_i] }]
end

sum = 0
pt.each do |p1|
  s = 'in'
  p p1

  until ['A', 'R'].include?(s)
    p s
    w1 = wh[s]
    w1.each do |wst|
      if wst.length == 1
        s = wst.first
        break
      else
        n, pr, op, v = wst
        if op == '>'
          break s = n if p1[pr] > v
        else
          break s = n if p1[pr] < v
        end        
      end
    end
  end

  sum += p1.values.sum if s == 'A'
end
puts sum

H = {'x' => 0, 'm' => 1, 'a' => 2, 's' => 3}

t = [['in', [[0, 4000], [0, 4000], [0, 4000], [0, 4000]]]]
ac = 0
until t.empty?
  t2 = []
  t.each do |s, b|
    w1 = wh[s]
    w1.each do |wst|
      b2 = b.map(&:clone)
      if wst.length == 1
        t2 << [wst.first, b2]
      else
        n, pr, op, v = wst
        if op == '>' && b2[H[pr]][0] < v
          b2[H[pr]][0] = b[H[pr]][1] = v
          t2 << [n, b2]
        elsif op == '<' && b2[H[pr]][1] >= v
          b2[H[pr]][1] = b[H[pr]][0] = v - 1
          t2 << [n, b2]
        end        
      end
    end
  end
  t2.reject! do |s, b|
    if s == 'A'
      ac += b.map { |l, u| l - u }.reduce(1, &:*)
      true
    elsif s == 'R'
      true
    else
      false
    end
  end
  t = t2
end

puts ac
