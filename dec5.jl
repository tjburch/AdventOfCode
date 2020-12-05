# Original problem at bottom 
# Read all lines
f = open("inputs/dec5-input.txt");
lines = readlines(f)

ROW_RANGE = (0, 127)
COL_RANGE = (0,7)

function binary_partition(id, range)
    #= Cuts range based on 
    id {bool} - 1 for upper, 0 for lower
    range {(int,int)} - range prior to start
    returns - range cut into upper/lower =#

    # If upper, take upper half of range
    if id == true
        add_to_floor = ceil((range[2]-range[1])/2)
        range = (range[1]+add_to_floor, range[2])
    # If lower, the lower half of the range
    else
        sub_from_ceil = ceil((range[2]-range[1])/2)
        range = (range[1], range[2]-sub_from_ceil)
    end

    return range

end

function parse_string(s_seat, d_map)
    return map((x) -> d_map[x], split(s_seat,""))
end

function get_seat_info(line)
    
    ####### Start with rows
    # Get row string
    row_string = line[1:end-3]
    # Make mapping dictionary
    d_row = Dict("F"=>0, "B"=>1)
    # Parse to binary
    bin_seats = parse_string(row_string, d_row)
    # Find the row number
    range = ROW_RANGE
    for e in bin_seats
        range = binary_partition(e, range)
    end
    row = -1
    if range[1] == range[2]
        row = range[1]
    else
        println("Did not converge! String issue: ", line)
    end

    ###### Next repeat for columns
    # Get row string
    col_string = line[end-2:end]
    # Make mapping dictionary
    d_col = Dict("R"=>1, "L"=>0)
    # Parse to binary
    bin_seats = parse_string(col_string, d_col)
    # Find the row number
    range = COL_RANGE
    for e in bin_seats
        range = binary_partition(e, range)
    end
    col = -1
    if range[1] == range[2]
        col = range[1]
    else
        println("Did not converge! String issue: ", line)
    end    

    id = row*8 + col
    seat_info = Dict("row"=> row, "col"=>col, "ID"=>id)

    return seat_info
end


# Question 1 - what is the highest ID?
all_ids = []
for line in lines
    append!(all_ids, get_seat_info(line)["ID"])
end
println("The highest ID is: ", maximum(all_ids))


# Question 2
start_id = minimum(all_ids)
displaced_id = sort(all_ids.-start_id)
for (i, e) in enumerate(sort(displaced_id))
    if e == displaced_id[end]
        continue
    end
    if (displaced_id[i+1] - e) > 1
        println("Your seat ID: ", e + start_id + 1)
    end
end


#=
--- Day 5: Binary Boarding ---
You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

For example, consider just the first seven characters of FBFBBFFRLR:

Start by considering the whole range, rows 0 through 127.
F means to take the lower half, keeping rows 0 through 63.
B means to take the upper half, keeping rows 32 through 63.
F means to take the lower half, keeping rows 32 through 47.
B means to take the upper half, keeping rows 40 through 47.
B keeps rows 44 through 47.
F keeps rows 44 through 45.
The final F keeps the lower of the two, row 44.
The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

For example, consider just the last 3 characters of FBFBBFFRLR:

Start by considering the whole range, columns 0 through 7.
R means to take the upper half, keeping columns 4 through 7.
L means to take the lower half, keeping columns 4 through 5.
The final R keeps the upper of the two, column 5.
So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

Here are some other boarding passes:

BFFFBBFRRR: row 70, column 7, seat ID 567.
FFFBBBFRRR: row 14, column 7, seat ID 119.
BBFFBBFRLL: row 102, column 4, seat ID 820.
As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?

Your puzzle answer was 994.

--- Part Two ---
Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

What is the ID of your seat?

Your puzzle answer was 741.
=#