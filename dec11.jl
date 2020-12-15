using StatsBase
using Makie

MAKE_GIF = false

function get_dims(state)
    dims = CartesianIndices(state)[end]
    nrows = dims[1]
    ncols = dims[2]
    return nrows, ncols
end

function in_bounds(r, c, nrows, ncols, current)
    if  (r < 1 || c < 1) || # Cover lower bounds
        (r > nrows || c > ncols) || # cover upper bounds
        (r == current[1] && c == current[2]) # ignore current idx
        return false
    else
        return true
    end
end

"""
Builds a scanning window over previous and next indices, counts number seated
Arguments
- idx: Current seat index
- state: Full seated state
- distance: How far to count
"""
function seated_neighbors(idx, state)

    nrows, ncols = get_dims(state)

    # Make a rolling window
    ct = 0
    for r in collect(idx[1]-1:idx[1]+1)
        for c in collect(idx[2]-1:idx[2]+1)
            if !in_bounds(r, c,  nrows, ncols, idx)
                continue
            end

            if state[r,c] == 1
                ct += 1
            end
        end
    end
    return ct
end


function visible_seats(idx, state)

    nrows, ncols = get_dims(state)

    # Make a rolling window
    ct = 0
    for r in collect(idx[1]-1:idx[1]+1)
        for c in collect(idx[2]-1:idx[2]+1)
            if !in_bounds(r,c, nrows, ncols, idx)
                continue
            end

            # deltas for direction
            d_row = idx[1] - r
            d_col = idx[2] - c

            # create indices to actually evaluate
            r_eval = r
            c_eval = c
            add_to = true
            # If it's a floor, add to the value

            while state[r_eval,c_eval] == -1
                r_eval -= d_row
                c_eval -= d_col   

                if !in_bounds(r_eval, c_eval, nrows, ncols, idx)
                    add_to = false
                    break
                end
             
            end

            if add_to
                if state[r_eval,c_eval] == 1
                    ct += 1
                end
            end
        end
    end
    return ct
end
"""
If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
Otherwise, the seat's state does not change.
"""
function run_iteration(start_state, tipping_count, counting_function)
    updated_state = deepcopy(start_state)
    
    for idx in CartesianIndices(start_state)
        seat_state = start_state[idx[1],idx[2]]
        seated_count = counting_function(idx, start_state)

        if seated_count == 0 && seat_state == 0
            updated_state[idx[1],idx[2]] = 1
        # If full and 4 adjacent are also full, empty
        elseif seated_count >= tipping_count && seat_state == 1
            updated_state[idx[1],idx[2]] = 0
        else
            updated_state[idx[1],idx[2]] = seat_state
        end
    end
    return updated_state
end


function main()
    # Read in lines as a 2D array
    lines = map(collect, readlines("inputs/dec11-input.txt"))
    init_state = hcat(lines...) |> permutedims
    encoder = Dict('L'=>0, '#'=>1, '.'=>-1)

    ### Part 1 - 
    start_state = [encoder[i] for i in init_state]
    terminate = false
    c = 0
    bufs = []
    while !terminate
        # Plot initial state
        push!(bufs, start_state)
        next_iter = run_iteration(start_state, 4, seated_neighbors)
        if next_iter == start_state
            terminate = true
        else
            start_state = next_iter
        end
        c +=1         

    end

    if MAKE_GIF
        nrows, ncols = get_dims(start_state)
        scene = Makie.heatmap(
            collect(1:nrows),
            collect(1:ncols),
            bufs[1],
            padding = (0,0),
            colorrange = (0,1),
            axis = (names = ( axisnames = ("",""),),),
            #colormap=:default		
            )    


        record(scene, "outputs/dec11-1.gif", 1:c, framerate = 6) do i
            Makie.heatmap!(
                scene, 
                collect(1:nrows),
                collect(1:ncols),
                bufs[i],
                #colormap=:default
                )
            yield()
        end
        sc_t = title(scene, "test")
    end


    # count up 1s
    ct = 0
    for idx in CartesianIndices(start_state)
        if start_state[idx[1],idx[2]] == 1
            ct +=1
        end
    end
    print("Problem 1 sum: ", ct)



    ### Part 2 - 
    start_state = [encoder[i] for i in init_state]
    terminate = false
    i = 0
    c = 0
    while !terminate
        println(" Now doing iter ", c)
        next_iter = run_iteration(start_state, 5, visible_seats)
        if next_iter == start_state
            terminate = true
        else
            start_state = next_iter
        end
        i += 1

        c +=1 
    end

    # count up 1s
    ct = 0
    for idx in CartesianIndices(start_state)
        if start_state[idx[1],idx[2]] == 1
            ct +=1
        end
    end
    print("Problem 2 sum: ", ct)
 

end

main() 