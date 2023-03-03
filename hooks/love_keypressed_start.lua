local key = ...

if (in_astate("future", 0) or in_astate("future", 1)) and (key == "escape" or key == "return") then
    tostate(1, true)
end
