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

function manhattan_distance(x::Union{Int, Float64}, y::Union{Int, Float64})
    return(abs(x) + abs(y))
end

#f = open("inputs/dec8-input.txt")
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



