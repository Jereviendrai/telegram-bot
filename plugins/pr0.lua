-- pr0gramm.com plugin for telegram-bot

--returns: FALSE if any error, TRUE if data sent off
function getPr0Image(msg,id)
    local body,status = http.request("http://pr0gramm.com/api/items/get?id="..id.."&flags=7")
    if status ~= 200 then -- 200 = OK
        return false
    end
    local img_data = json:decode(body)
    
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
function getBenis(fag)
    local url = "http://pr0gramm.com/api/profile/info?name="..fag.."&self=true%20HTTP/1.1"
    local body,status = http.request(url)
    if status ~= 200 then --200 = OK
        return nil 
    end
    
    local user_data = json:decode(body)
    if user_data.error == "notFound" then --User not found
        return nil 
    end
    return user_data.user.score --Benis return
end

function run(msg, matches)   
    if matches[1] == "!benis" then
        score = getBenis(matches[2])
        if score == nil then 
            return "Sorry, der User existiert nicht ;("
        end
        return matches[2].." hat "..score.." Benis"
    else
        if not getPr0Image(msg, matches[1]) then
            return "Sorry, der gewünschte Content existiert nicht ;("        
        end
    end
end

return{
    description = "Man telegramt nicht über das pr0",
    usage = {
        "[pr0 url]: Man pasted nicht über das pr0 in telegram",
        "!benis [fag]: Zeigt benis",
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
        "^(!benis) (.*)$"
    },
    run = run
}
