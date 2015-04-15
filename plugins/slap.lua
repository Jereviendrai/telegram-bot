--Idea: sgitkene

local slaps = {
    "Consider yourself slapped, /!", 
    "/ lies on the floor crying.",
    "I slapped / for you.", 
    "Poor / has been slapped.", 
    "The floor trembles as / hits the floor, slapped!",
    "BRB slapping /", 
    "SMACK! Slapping time!", 
    "/ has been knocked out.",
    "I slapped / on behalf of -", 
    "- told me to slap / but I don't want to. JK SMACK!",
    "/ was like yo but then I slapped dat bitch.", 
    "I'm tired of slapping /! JK SMACK!", 
    "- breaks a bottle on /'s head.",
    "- hits / with his copy of Touch of Class.",
    "- slaps / with a Windows Update.",
    "- slaps / around the kitchen table with tomorrow's newspaper.",
    "- throws a PC monitor at /.",
    "- hits / with a small interstellar spaceship.",
    "I do not slap little girls!",
    "- slaps / with an elevator.",
    "I slapped / with an alarm clock.",
    "Look, I found /'s picture at uglypeople.com!",
    "- burned /'s house down. Hey, that's mean!",
    "Ueli Maurer slaps / with the halting problem.",
    "- slaps / around a bit with a large trout.",
    "- hits / with a Surface Pro.",
    "- differenciated /.",
    "- burned /'s calculus notes.",
    "eelslap.com",
    "- hit / with Aline's fan.",
    "- stabs / with a key.",
    "- puts / into a perl script.",
    "- runs / in Eiffel Studio.",
    "- spams /'s mail address.",
    "- encrypts / with RSA and destroys the private key.",
    "/ was bitten by a donkey.",
    "/ was thrown in an infinite loop.",
    "/ pinched his fingers in his laptop.",
    "- breaks a coconut open on /'s head.",
    "I fed / to a whale.",
    "I slapped / with a tuna. Still in the can.",
    "- yells at / with a megaphone.",
    "- hit / with a plug strip.",
    "- throws his phone at /.",
    "- slaps / with his DnA assignment.",
    "- strangles / with a power cable.",
    "- shoots / with a paintball gun.",
    "- replaces all of /'s music with Justin Bieber songs.",
    "Slaps for / coming right up.",
    "- hits / with lukebot. Hey, wait!",
    "- slaps / with a figurine of /.",
    "- slaps / with a figurine of - slapping /.",
    "/ slaps himself. Why would you do that?",
    "/ slaps - around a bit with a... ooh, I screwed that one up.",
    "/ tried to swim in lava.",
    "/ hit the ground too hard.",
    "/ fell out of the world.",
    "I developped an algorithm that slaps / in O(1).",
    "I smacked / so hard he won't pass the basis exam.",
    "- slaps / with the largest prime number.",
    "I threw / in a room full of spiders.",
    "I slapped - for trying to hurt weaker people.",
    "- tried to slap / but fell on his nose.",
    "- tried to slap / but / ran for it. Coward!",
    "- hits / with a typo.",
    "- slaps / with his favourite Linux distro.",
    "- slaps / with pure nothing.",
    "DON'T TELL ME WHAT TO DO! *slaps -*"
    
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
