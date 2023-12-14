load 'utils.rb'
a = File.read("input/13.txt").split("\n\n").map { |e| e.lines.map(&:chomp).map(&:chars) }

def rv(pt)
  cy = pt.each_cons(2).with_index.filter_map { |e, y| y if e[0] == e[1] }
  cy.each do |y|
    return y + 1 if [y, pt.length - y - 2].min.times.all? { |yp| pt[y - yp - 1] == pt[y + yp + 2] }
  end
  nil
end

def r(pt)
  rv(pt.transpose) || (rv(pt) * 100)
end

puts a.map { |pt| r(pt) }.sum

def c2(l1, l2)
  l1.each_with_index.count { |e, i| e != l2[i] }
end

def rv2(pt)
  cy = pt.each_cons(2).with_index.filter_map { |e, y| c = c2(e[0], e[1]); [y, c] if c <= 1 }
  cy.each do |y, c|
    return y + 1 if ([c] + [y, pt.length - y - 2].min.times.map { |yp| c2(pt[y - yp - 1], pt[y + yp + 2]) }).sum == 1
  end
  nil
end

def r2(pt)
  rv2(pt.transpose) || (rv2(pt) * 100)
end

puts a.map { |pt| r2(pt) }.sum
