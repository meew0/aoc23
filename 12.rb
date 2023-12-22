load 'utils.rb'

def process(a)
  a.map { |e| e.split(' ') }.map { |rl, rg| [rl, rg.split(',').map(&:to_i)] }
end

b, bmin = process(inl('12')), process(inl('12min'))

def i2(rl, rg, qs, rlo, rgo, bs, bsp, u)
  v = qs.length - rg.sum
  # p [rl, rg, qs, rlo, rgo, bs, bsp, u, v]
  w = u.upto(v).map do |k|
    catch :outer do
      e = k + rg[0] - 1
      # p [rg.length, qs[e], bs[-1]]
      if rg.length == 1 && qs[e] < (bs[-1] || 0)
        throw :outer, 0 
      end
      u.upto(k - 1) { |kp| throw :outer, 0 if bs[bsp] == qs[kp] }
      bspn = bsp
      l = qs[k] - 1
      k.upto(e) do |kp|
        throw :outer, 0 if (qs[kp] > (l += 1))
        bspn += 1 if bs[bspn] == qs[kp]
      end
      if rg.length == 1
        1
      else
        throw :outer, 0 if rlo[qs[e] + 1] == '#'
        i2(rl, rg[1..-1], qs, rlo, rgo, bs, bspn, (qs[e + 1] - qs[e] == 1) ? (e + 2) : (e + 1))
      end
    end
  end
  w.sum
end

def i2w(rl, rg)
  qs = indices(rl.chars) { |c| ['?', '#'].include?(c) }
  bs = indices(rl.chars) { |c| c == '#' }
  i2(rl.clone, rg.clone, qs, rl, rg, bs, 0, 0)
end

puts bmin.map { |rl, rg| i2w(rl, rg) }.sum
puts bmin.map { |rl, rg| i2w(([rl] * 5).join('?'), rg * 5) }.sum

puts b.map { |rl, rg| i2w(rl, rg) }.sum
# puts b.map { |rl, rg| i2w(([rl] * 5).join('?'), rg * 5) }.sum
