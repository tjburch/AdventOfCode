# Day 3:
# Success! Time elapsed = 22:07

# Text: https://adventofcode.com/2022/day/3

input = readlines("2022/inputs/dec3-input.txt")

split_string(s) = s[1:Int(length(s) / 2)], s[Int(length(s) / 2)+1:end]
shared_letter(s_tuple) = intersect(s_tuple[1], s_tuple[2])[1]
# Characters have values in julia. need a = 1 and 'A' = 27
lowercase_comp_value = Int('a') - 1
uppercase_comp_value = Int('A') - 27
char_to_priority(c) = islowercase(c) ? Int(c) - lowercase_comp_value : Int(c) - uppercase_comp_value

# Part 1:
split_strings = split_string.(input)
shared_letters = shared_letter.(split_strings)
priorities = char_to_priority.(shared_letters)
println(sum(priorities))

# Part 2:
s = 0 
for lineset in Iterators.partition(input,3)
    letter = intersect(lineset...)[1]
    print(letter)
    priority = char_to_priority(letter)
    s+=priority
end
println(s)

