using Makie

mutable struct Ship
    orientation::Int
    position::Array
end

""" If orientation outside of 0-360, fit to that frame """
function reduce_orientation(ship::Ship)
    if ship.orientation > 360
        ship.orientation -= 360
    elseif ship.orientation < 0
        ship.orientation += 360
    end
end

function issue_instruction(instruction::Char, value::Int, ship::Ship)

    if instruction == 'N'
        ship.position[2] += value
    elseif instruction == 'S'
        ship.position[2] -= value
    elseif instruction == 'E'
        ship.position[1] += value
    elseif instruction == 'W'
        ship.position[1] -= value
    elseif instruction == 'L'
        ship.orientation += value
    elseif instruction == 'R'
        ship.orientation -= value
    elseif instruction == 'F'
        ship.position[1] += cosd(ship.orientation) * value
        ship.position[2] += sind(ship.orientation) * value
    end

    reduce_orientation(ship)
end


"""
Movement for angles on part 2. Consider the ship the new origin.
    First get the differential between waypoint location and ship location as vector components
    Then rotate through angle θ via:
    x2 = x1 * cosθ - y2 * sinθ
    y2 = x1 * sinθ + y2 cosθ
    Last recover absolute location by adding back the original center
"""
function waypoint_rotation(instruction::Char, value::Int, ship:Ship, waypoint::Ship)

    # Get distance between waypoint and ship
    delta_x = waypoint.position[1] - ship.position[1]
    delta_y = waypoint.position[2] - ship.position[2]

    # Get relative rotation
    relative_position = [0,0]
    relative_position[1] = delta_x * cosd(value) - delta_y * sind(value)
    relative_position[2] = delta_x * cosd(value) - delta_y * sind(value)
    # Flip sign if right
    if instruction == 'R'
        relative_position = -relative_position
    end

    # Return center plus relative
    return (waypoint.position .+ relative_position)

end

function manhattan_distance(x::Union{Int, Float64}, y::Union{Int, Float64})
    return(abs(x) + abs(y))
end

function solution1()

    ship = Ship(0, [0,0])
    positions = []
    for line in readlines("inputs/dec12-input.txt")
        # Track location
        push!(positions, deepcopy(ship.position))

        # Update loaction
        instruction = line[1]
        value = parse(Int,line[2:end])
        issue_instruction(instruction, value, ship)
    end
    # Save final location and output result
    println("The Manhattan Distance is ", manhattan_distance(ship.position[1], ship.position[2]))

    # Generate positions gif
    points = Node(Point2f0[(0,0)]) # inital location
    scene = scatter(points, limits = FRect((-400,-700), (1900, 1700)), colormap=:winter, color=1:length(positions))
    record(scene, "outputs/dec12-1.gif", 1:length(positions), framerate = 16) do i
        point = Point2f0(positions[i][1], positions[i][2])
        points[] = push!(points[], point)
    end
    
end


function solution2()

    ship = Ship(0, [0,0])
    waypoint = Ship(0, [10, 1])
    ship_positions = []
    wp_positions = []
    for line in readlines("inputs/dec12-input.txt")
        # Track location
        #push!(positions, deepcopy(ship.position))

        # Update loaction
        instruction = line[1]
        value = parse(Int,line[2:end])

        if instruction ∈ ['N', 'S', 'E', 'W']
            issue_instruction(instruction, value, waypoint)

        elseif instruction ∈ ['R', 'L']
            waypoint_rotation(instruction, value, ship, waypoint)
            
        elseif instruction == 'F'
            issue_instruction(instruction, value, ship)
        end
    
    end
    # Save final location and output result
    println("The Manhattan Distance is ", manhattan_distance(ship.position[1], ship.position[2]))

    # Generate positions gif
    points = Node(Point2f0[(0,0)]) # inital location
    scene = scatter(points, limits = FRect((-400,-700), (1900, 1700)), colormap=:winter, color=1:length(positions))
    record(scene, "outputs/dec12-1.gif", 1:length(positions), framerate = 16) do i
        point = Point2f0(positions[i][1], positions[i][2])
        points[] = push!(points[], point)
    end
    
end

#solution1()




