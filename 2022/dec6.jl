# Day 6:
# Success! Time elapsed = 4:05

# Text: https://adventofcode.com/2022/day/5

input = readchomp("2022/inputs/dec6-input.txt")

# Part 1
for i in 4:length(input)
    curr_set = input[i-3:i]
    if allunique(curr_set)
        return i
    end
end

# Part 2
for i in 14:length(input)
    curr_set = input[i-13:i]
    if allunique(curr_set)
        return i
    end
end

