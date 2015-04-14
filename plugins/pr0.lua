-- pr0gramm.com plugin for telegram-bot

--returns: FALSE if any error, TRUE if data sent off
local function get_Pr0_image(msg,id)
    local b,status = http.request("http://pr0gramm.com/api/items/get?id="..id.."&flags=7")
    if status ~= 200 then -- 200 = OK
        return false
    end
    local img_data = json:decode(b)
    
    if img_data.error == "notFound" then --IMG not found
        return false
    end

    local img_url = "http://img.pr0gramm.com/"..img_data.items[1].image
    if(string.find(img_url, ".jpg") or string.find(img_url, ".png")) then -- JPG/PNG
        send_photo_from_url(get_receiver(msg), img_url) --from utils.lua
        return true
    else --WEBM/GIF
        send_document_from_url(get_receiver(msg), img_url) --from utils.lua
        return true
    end
end

--Calls api, returns number(benis)
local function get_benis(user)
    local url = "http://pr0gramm.com/api/profile/info?name="..user.."&self=true%20HTTP/1.1"
    local b,status = http.request(url)
    if status ~= 200 then --200 = OK
        return nil 
    end
    
    local user_data = json:decode(b)
    if user_data.error == "notFound" then --User not found
        return nil 
    end
    return user_data.user.score --Benis return
end

local function get_random_image(msg, filter)
    local url = "http://pr0gramm.com/api/items/get?promoted=1"
    if filter == "sfw" then
        url = url.."&flags=1"
    elseif filter == "nsfw" then
        url = url.."&flags=2"
    elseif filter == "nsfl" then
        url = url.."&flags=4"   
    else --tag search
        tag=URL.escape(filter)
        url = "http://pr0gramm.com/api/items/get?promoted=1&tags="..tag.."&flags=7"
    end 

    local b,status = http.request(url)
    if status ~= 200 then --200 = OK
        return false
    end
    
    local img_data = json:decode(b)    
    while true do
        i = math.random(#img_data.items)
        if(string.find(img_data.items[i].image,".jpg") or
            string.find(img_data.items[i].image,".png")) then
            break
        end
    end
    local img_url = "http://img.pr0gramm.com/"..img_data.items[i].image
    send_photo_from_url(get_receiver(msg), img_url)
    return true
end

function run(msg, matches)   
    if matches[1] == "!benis" then
        score = get_benis(matches[2])
        if score == nil then 
            return "Sorry, der User existiert nicht."
        end
        return matches[2].." hat "..score.." Benis"
    elseif matches[1] == "!pr0" then
        if not get_random_image(msg, matches[2]) then
            return "Ungültiger filter."
        end
    else
        if not get_Pr0_image(msg, matches[2]) then
            return "Sorry, der gewünschte Content existiert nicht."        
        end
    end
end

local function encode_for_url(str)
    string.gsub(str, " ", "%20")
    string.gsub(str, "!", "%20")
    string.gsub(str, "$", "%20")
    string.gsub(str, "%", "%20")
end

return{
    description = "Man telegramt nicht über das pr0",
    usage = {
        "[pr0 url]: Man pasted nicht über das pr0 in telegram",
        "!benis [fag]: Zeigt benis",
        "!pr0 [tag]: Zufälliges Bild aus [sfw, nsfw, nsfl, tag]"
    },
    patterns = {
        -- Urls, second block include search keywords
        "^pr0gramm.com/top/(%w+)$",
        "^pr0gramm.com/new/(%w+)$",
        "^http://pr0gramm.com/top/(%w+)$",
        "^http://pr0gramm.com/new/(%w+)$",   
        "^pr0gramm.com/top/[%w%s%d%l%u%%]+/(%w+)$", 
        "^pr0gramm.com/new/[%w%s%d%l%u%%]+/(%w+)$",
        "^http://pr0gramm.com/top/[%w%s%d%l%u%%]+/(%w+)$",
        "^http://pr0gramm.com/new/[%w%s%d%l%u%%]+/(%w+)$",   
        "^(!benis) (.+)$",
        "^(!pr0) (.+)$"
    },
    run = run
}
