def length_of_longest_substring(s)
  return 0 if s.empty?
  seen = {}
  sofar = 0

  i = 0
  j = 0

  until j == s.length
    if seen[s[j]]
      i = [seen[s[j]], i].max
    end
    sofar = [sofar, j - i + 1].max
    seen[s[j]] = j + 1
    j += 1
  end
  sofar
end

length_of_longest_substring("pwwkew")
