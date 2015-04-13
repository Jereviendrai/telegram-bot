--League of Legends telegram-bot plugin
--Author: ltobler (Jkoer in LoL!) and sgitkene

-- WORK IN PROGRESS

local news_amount=5

local function getID(summonerName) --TODO
    local url="https://euw.api.pvp.net/api/lol/euw/v1.4/summoner/by-name/SUMMONERNAME_TOKEN?api_key=55eab29b-52e9-48ba-8fe7-41e57f98a395"
    url = string.gsub(url, "SUMMONERNAME_TOKEN", summonderName)
    local res,status = http.request()
    if status ~= 200 then return nil end -- status 200 means everything ok, other thatn that means not ok. retrying is discouraged as there exists a rate limit.
    summonerID = -- TODO get it out of res string...
end

local function getElo(summonerID) --TODO
end

local function getStatus(summonerID) --TODO
end

local function getNews() --TODO
end

function run(msg, matches)
    if(matches[1]=="!elo") then
        elo = getElo[2]
        if(elo==nil) then
            return "Summoner not found"        
        end
        return matches[2]..": "..elo
    elseif(matches[1]=="!lolstatus") then
        status = getStatus(matches[2])
        if(status==nil) then
            return "Summoner not found"
        end
        return matches[2].." is currently "..status
    elseif(matches[1]=="!lolnews") then
        news_batch = getNews()
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
    end
end

return{
    description="League of Legends features!",
    usage={
        "!elo [summoner]: Shows current division",
        "!lolstatus [summoner]: Current status of summoner",
        "!lolnews: latest League of Legends Esports news"
        "!lolnews change_amount [amount]: Changes number of returned articles(default is 5, \
            0 < amount <= 30)"
    },
    patterns={
        "^(!elo) (.+)$",
        "^(!lolstatus) (.+)$",
        "^!lolnews$",
        "^!lolnews (change_amount) (%w+)$"
    },
    run = run
}
