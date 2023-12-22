load 'utils.rb'

def process(a)
  a.map { |e| e.split(' ') }.map { |rl, rg| [rl, rg.split(',').map(&:to_i)] }
end

b, bmin = process(inl('12')), process(inl('12min'))

def i2(rl, rg, qs, bs, bsp, u, rg_start, index)
  indexed = index[[bsp, u, rg_start]]
  return indexed unless indexed.nil?

  v = qs.length
  (rg_start...rg.length).each { |rg_i| v -= rg[rg_i] }
  w = u.upto(v).map do |k|
    catch :outer do
      e = k + rg[rg_start] - 1
      final = (rg_start == rg.length - 1)
      if final && qs[e] < (bs[-1] || 0)
        throw :outer, 0 
      end
      u.upto(k - 1) { |kp| throw :outer, 0 if bs[bsp] == qs[kp] }
      bspn = bsp
      l = qs[k] - 1
      k.upto(e) do |kp|
        throw :outer, 0 if (qs[kp] > (l += 1))
        bspn += 1 if bs[bspn] == qs[kp]
      end
      if final
        1
      else
        throw :outer, 0 if rl[qs[e] + 1] == '#'
        i2(rl, rg, qs, bs, bspn, (qs[e + 1] - qs[e] == 1) ? (e + 2) : (e + 1), rg_start + 1, index)
      end
    end
  end
  result = w.sum
  index[[bsp, u, rg_start]] = result
end

def i2w(rl, rg)
  qs = indices(rl.chars) { |c| ['?', '#'].include?(c) }
  bs = indices(rl.chars) { |c| c == '#' }
  i2(rl, rg, qs, bs, 0, 0, 0, {})
end

puts bmin.map { |rl, rg| i2w(rl, rg) }.sum
puts bmin.map { |rl, rg| i2w(([rl] * 5).join('?'), rg * 5) }.sum

puts b.map { |rl, rg| i2w(rl, rg) }.sum
puts b.map { |rl, rg| i2w(([rl] * 5).join('?'), rg * 5) }.sum
