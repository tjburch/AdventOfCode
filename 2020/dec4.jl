# Problem at bottom 
using DelimitedFiles

ALL_KEYS = ["byr","iyr","eyr","hgt","hcl","ecl","pid","cid"]
NEEDED_KEYS = ["byr","iyr","eyr","hgt","hcl","ecl","pid"]
VALID_EYES = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

# Load file
s = read("inputs/dec4-input.txt", String)
# split into component dictionary proposals
spl = split(s, "\n\n")

function string_to_int(value_str)
    # Check validity
    try
        parse(Int64,value_str)
    catch
        return false
    end
    # return
    return parse(Int64,value_str)
end

function check_height(height_str)
    #hgt (Height) - a number followed by either cm or in:
    #If cm, the number must be at least 150 and at most 193.
    #If in, the number must be at least 59 and at most 76.

    # Check cm or in
    unit = height_str[end-1:end]
    # Get values
    value = parse(Int64, height_str[1:end-2])
    # control flow implement
    if unit == "cm"
        if value >= 150 && value <= 193
            return true
        end
    elseif unit == "in" 
        if value >= 59 && value <= 76
            return true
        end
    else
        return false
    end
    return false
end


function dict_validation(proposal)
    #= Part 2 requirements =#

    #byr (Birth Year) - four digits; at least 1920 and at most 2002.
    byr_local = string_to_int(proposal["byr"])
    if byr_local < 1920 || byr_local > 2002 || length(proposal["byr"]) != 4
        return false
    end
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    iyr_local = string_to_int(proposal["iyr"])
    if iyr_local < 2010 || iyr_local > 2020
        return false
    end

    #eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    eyr_local = string_to_int(proposal["eyr"])
    if eyr_local < 2020 || eyr_local > 2030
        return false
    end

    #hgt (Height) - a number followed by either cm or in:
    #If cm, the number must be at least 150 and at most 193.
    #If in, the number must be at least 59 and at most 76.
    if !check_height(proposal["hgt"])
        return false
    end


    #hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    r = Regex("#[a-f0-9]{6}")
    if typeof(match(r,proposal["hcl"])) == Nothing
        return false
    end

    #ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    if !(proposal["ecl"] in VALID_EYES)
        return false
    end

    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    # cast as int, then back to string for leading zeros
    #print(proposal["pid"])
    try
        if length( proposal["pid"]) != 9
            return false
        end
    catch
        return false
    end
    # cid (Country ID) - ignored, missing or not.

    println(proposal)
    return true
    
end


valid_element_passports = 0
valid_value_passports = 0 
for d in spl
    # clean newlines
    d = replace(d, "\n"=>" ")
    
    # Split by spaces to get key-values
    element_propsals = split(d, " ")
    
    # Populate a dictionary of elements
    this_dict = Dict()
    for element in element_propsals
        components = split(element,":")
        this_dict[components[1]] = components[2]        
    end
    # Count valid elements (Part 1)
    diff = setdiff(NEEDED_KEYS, keys(this_dict))
    if length(diff) == 0
        valid_element_passports += 1
        valid_value_passports += dict_validation(this_dict)
    end
end

println("There are ", valid_element_passports," passports with valid elements")
println("There are ", valid_value_passports," passports with valid values")



#=
The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields. The expected fields are as follows:

byr (Birth Year)
iyr (Issue Year)
eyr (Expiration Year)
hgt (Height)
hcl (Hair Color)
ecl (Eye Color)
pid (Passport ID)
cid (Country ID)
Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.

Here is an example batch file containing four passports:

ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.

According to the above rules, your improved system would report 2 valid passports.

Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?

Your puzzle answer was 182.

--- Part Two ---
The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting through. Better add some data validation, quick!

You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
Your job is to count the passports where all required fields are both present and valid according to the above rules. Here are some example values:

byr valid:   2002
byr invalid: 2003

hgt valid:   60in
hgt valid:   190cm
hgt invalid: 190in
hgt invalid: 190

hcl valid:   #123abc
hcl invalid: #123abz
hcl invalid: 123abc

ecl valid:   brn
ecl invalid: wat

pid valid:   000000001
pid invalid: 0123456789
Here are some invalid passports:

eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
Here are some valid passports:

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?

Your puzzle answer was 109.
=#
