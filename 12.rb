load 'utils.rb'

def process_input(lines)
  lines.map do |line|
    # '?..#?.??#?...??##??? 1,2,2,1,5' -> ['?..#?.??#?...??##???', [1, 2, 2, 1, 5]]
    conds, groups_str = line.split(' ')
    [conds, groups_str.split(',').map(&:to_i)]
  end
end

records, records_min = process_input(inl('12')), process_input(inl('12min'))

def count_arrangements_recursive(
  conds,            # first part of input
  groups,           # second part of input
  possible_springs, # positions in `conds` that might be springs ('#' and '?')
  definite_springs, # positions in `conds` that are definitely springs (only '#')
  ps_start,         # position of first unprocessed index in `possible_springs`
  ds_start,         # position of first unprocessed index in `definite_springs`
  groups_start,     # position of first unprocessed group in `groups`
  index             # index of results of previous function invocations
)
  # Check whether the function has already previously been called with these arguments. In that
  # case, we don't need to calculate the result anew
  indexed = index[[ds_start, ps_start, groups_start]]
  return indexed unless indexed.nil?

  # Within this function, we iterate through all positions at which we can place the next group
  # of springs. For each of these positions, we recursively call the function again to iterate
  # through the potential locations for the next group in turn, and so on, until all groups have
  # been placed. We return the sum of potential positions down the tree.

  # First, calculate the highest index in `possible_springs` above which it would make no sense to
  # place a group of springs, because there would not be enough space for the groups after that.
  # For example, with `possible_springs = [1, 2, 3, 5, 6]` (corresponding to e.g.
  # the input '.???.??') and `groups = [2, 2]`, it would never make sense to place the first
  # remaining group (size 2) at index 2 of `possible_springs` (= index 3 in the input),
  # because then there would never be enough space to fit the second group (also size 2).
  # We would have placed the group like '...#.#?', and there are not enough '?' after the group
  # to be able to place two more '#'.
  # (Note that in this first step, we do not yet consider the fact that the group would in fact
  # cover a '.' and thus would be invalid regardless.)
  # So in this example case, `v` would be 1 (= 1 less than 2)
  v = possible_springs.length
  (groups_start...groups.length).each { |groups_i| v -= groups[groups_i] }

  # Iterate through all values in `possible_springs` from `ps_start` up to and including `v`,
  # that is, iterate through all positions where we *might* be able to place the next spring.
  w = ps_start.upto(v).map do |k|
    # Within the loop, we try to place a group at index `k` (in `possible_springs`),
    # find out whether it is valid to do so, and if that is the case, recursively call this
    # function again.

    # First, create a catch point we can return to, if we find that for one reason or another,
    # it is not valid to place a group at index `k`.
    catch :outer do
      # The last index (in `possible_springs`) that would be covered by the group we are trying to
      # place.
      e = k + groups[groups_start] - 1

      # Determine whether the group we are trying to place is the final one, that is, the last
      # element in (`groups`).
      final = (groups_start == groups.length - 1)

      # If we are placing the final group, but the position of the last spring we would place
      # as part of the group would precede the last definite spring in the input (for example when
      # placing a final group of size 2 at position 0 in the input '??#'), we would never cover
      # that spring in this iteration. So we go back to `:outer` and try again with the next `k`.
      throw :outer, 0 if final && possible_springs[e] < (definite_springs[-1] || 0)
      
      # Check whether the next definite spring to be processed comes before `k`. In that case,
      # we would never cover it in this iteration (in fact, never again in the loop)
      ps_start.upto(k - 1) { |kp| throw :outer, 0 if definite_springs[ds_start] == possible_springs[kp] }

      # Iterate through all indices covered by the potential group
      ds_start_new = ds_start
      l = possible_springs[k] - 1
      k.upto(e) do |kp|
        # Check if the group would cover a '.' gap point, represented as a gap of larger than 1 in
        # `possible_springs`. If this is the case, the group is invalid, and we have to try again
        # with the next `k`
        throw :outer, 0 if (possible_springs[kp] > (l += 1))

        # Keep track of definite springs we passed along the way
        ds_start_new += 1 if definite_springs[ds_start_new] == possible_springs[kp]
      end

      if final
        # If we are the final group, there are no more groups to be placed, so return a value of
        # `1` representing the one possibility presented by this (valid) group
        1
      else
        # If there is a definite spring directly after the final position of the group, the group
        # would become longer than its intended length, so it becomes invalid and we have to try
        # again with another `k`.
        throw :outer, 0 if conds[possible_springs[e] + 1] == '#'

        # Check if there is a '.' gap directly after the end of this group. If not, we need to
        # set the first potential start position of the next group to be 2 indices after the current
        # group's end index, to avoid merging two groups together. If there is such a gap, we can
        # continue with the next index in `possible_springs`
        ps_start_new = (possible_springs[e + 1] - possible_springs[e] == 1) ? (e + 2) : (e + 1)

        count_arrangements_recursive(conds, groups, possible_springs, definite_springs, ps_start_new, ds_start_new, groups_start + 1, index)
      end
    end
  end

  # Calculate the sum of possibilities presented by valid groups, and store it in the index for
  # future invocations
  result = w.sum
  index[[ds_start, ps_start, groups_start]] = result
end

# Simple wrapper function that does some precomputation and then calls the recursive function
def count_arrangements(conds, groups)
  possible_springs = indices(conds.chars) { |c| ['?', '#'].include?(c) }
  definite_springs = indices(conds.chars) { |c| c == '#' }
  count_arrangements_recursive(conds, groups, possible_springs, definite_springs, 0, 0, 0, {})
end

# The “unfolding” step in part 2 of the problem
def unfold(conds, groups)
  [([conds] * 5).join('?'), groups * 5]
end

# Calculate the solution first for the example input from the problem statement...
puts records_min.map { |conds, groups| count_arrangements(conds, groups) }.sum
puts records_min.map { |conds, groups| count_arrangements(*unfold(conds, groups)) }.sum

# ...and then for the real data
puts records.map { |conds, groups| count_arrangements(conds, groups) }.sum
puts records.map { |conds, groups| count_arrangements(*unfold(conds, groups)) }.sum
