--League of Legends telegram-bot plugin
--Author: ltobler and sgitkene

-- WORK IN PROGRESS
local region_table={"br","eune","euw","kr","lan","las","na","oce","ru","tr"}
local region="euw"
local api_key=""
local news_amount=5

local function get_id(summoner_name) --TODO
    local url="https://"..region..".api.pvp.net/api/lol/"..region..\
        "/v1.4/summoner/by-name/"..summoner_name.."?api_key="..api_key 
    local b,status = http.request(url)
    if status ~= 200 then --200 = OK
        return nil 
    end
    local data = json:decode(b)
    return data.summoner_name.id
end

local function get_elo(summoner_name)
    local id = get_id(summoner_name)
    local url = "/api/lol/"..region"/v2.5/league/by-summoner/"..id.."/entry"
    local b, status = http.request(url)
    if status ~= 200 then
        return nil
    end
    local data = json:decode(b)
    return data[1].tier.." "..data[1].entries.division
end

local function get_status(summoner_name) --TODO
    local id = get_id(summoner_name)
end

local function get_news() --TODO  
end

local function is_region(r)
    for i,k in pairs(region_table) do
        if k==r then
            return true
        end   
    end
    return false
end

function run(msg, matches)
    if(matches[1]=="!elo") then
        elo = get_elo[2]
        if(elo==nil) then
            return "Summoner not found"        
        end
        return matches[2]..": "..elo
    elseif(matches[1]=="!lolstatus") then
        status = get_status(matches[2])
        if(status==nil) then
            return "Summoner not found"
        end
        return matches[2].." is currently "..status
    elseif(matches[1]=="!lolnews") then
        news_batch = get_news()
        if (news_batch==nil)
            return "Error fetching news"        
        end
        receiver=get_receiver(msg) --????
        for i,message in pairs(news_batch) do
            send_msg(receiver, message, ok_cb, false)
        end
        return nil
    elseif(matches[1]=="change_amount") then
        n = matches[2] --Automatic type conversion ftw!
        if(n>0 and n<=30) then
            news_amount=num
            return "New news feed amount: "..num
        else
            return "ERROR: Invalid amount"
        end
    elseif(matches[1]=="region") then
        if is_regtion(matches[1]) then
            region = matches[1]
        end   
    end
end

return{
    description="League of Legends features!",
    usage={
        "!elo [summoner]: Shows current division",
        "!lolstatus [summoner]: Current status of summoner",
        "!lolnews: latest League of Legends Esports news"
        "!lolnews change_amount [amount]: Changes number of returned articles(default is 5, \
            0 < amount <= 30)",
        "!lol region [region]: Sets region[euw, na](default is euw)"
    },
    patterns={
        "^(!elo) (.+)$",
        "^(!lolstatus) (.+)$",
        "^!lolnews$",
        "^!lolnews (change_amount) (%w+)$",
        "^!lol (region) (.+)$"
    },
    run = run
}
