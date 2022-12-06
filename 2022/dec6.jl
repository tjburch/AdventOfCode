# Day 6:
# Success! Time elapsed = 4:05

# Text: https://adventofcode.com/2022/day/5

input = readchomp("2022/inputs/dec6-input.txt")

function find_unique_set(set_size, input)

    for i in set_size:length(input)
        curr_set = input[i-(set_size-1):i]
        if allunique(curr_set)
            return i
        end
    end
end

# Part 1
find_unique_set(4, input) |> println

# Part 2
find_unique_set(14, input) |> println