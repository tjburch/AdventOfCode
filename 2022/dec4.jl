# Day 4:
# Success! Time elapsed = 13:30
## Note - after seeing part 2, I rewrote part 1 with the get_ranges function so I could reuse that for part 2

# Text: https://adventofcode.com/2022/day/4

input = readlines("2022/inputs/dec4-input.txt")

function get_ranges(line)
    str_ranges = split(line, ",")
    low1, high1 = split(str_ranges[1], "-")
    low2, high2 = split(str_ranges[2], "-")
    set_to_range(l, h) = parse(Int, l):parse(Int, h)
    range1 = set_to_range(low1, high1)
    range2 = set_to_range(low2, high2)
    return range1, range2
end

# Part 1
get_contained(range1, range2) = length(setdiff(range1, range2)) == 0 || length(setdiff(range2, range1)) == 0 |> Int
function part_one_perline(line)
    range1, range2 = get_ranges(line)
    get_contained(range1, range2)
end
part_one_perline.(input) |> sum |> println


# Part 2
get_any_overlap(range1, range2) = length(intersect(range1, range2)) > 0
function part_two_perline(line)
    range1, range2 = get_ranges(line)
    get_any_overlap(range1, range2)
end
part_two_perline.(input) |> sum |> println
