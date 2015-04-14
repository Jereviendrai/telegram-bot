--Idea: sgitkene

local slaps = {
    "Consider yourself slapped, /!", 
    "/ lies on the floor crying.",
    "I slapped / for you.", 
    "Poor / has been slapped.", 
    "The floor trembles as / hits the floor, slapped!",
    "BRB slapping /", "SMACK! Slapping time!", 
    "/ has been knocked out.",
    "I slapped / on behalf of -", 
    "- told me to slap / but I don't want to. JK SMACK!",
    "/ was like yo but then I slapped dat bitch.", 
    "I'm tired of slapping /! JK SMACK!"
}

function run(msg, matches)
    rng = slaps[math.random(#slaps)]
    answer = string.gsub(rng, "/", matches[1])
    answer = string.gsub(answer, "-", get_name(msg))
    return answer
end

return {
  description = "Slaps a person.",
  usage = "!slap [name]: slaps [name]",
  patterns = {
    "^!slap (.+)$"
  }, 
  run = run 
}
