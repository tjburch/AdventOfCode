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
