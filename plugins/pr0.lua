-- pr0gramm.com plugin for telegram-bot
-- Man programmiert nicht über das Pr0gramm!

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

local function get_random_image(msg, f, t) --filter, tag
    local tag = ""
    local flag = "&flags="
    local f_set = false
    
    if f=="sfw" then       --SFW
        flag = flag.."1"
        f_set = true
    elseif f=="nsfw" then  --NSFW
        flag = flag.."2"
        f_set = true
    elseif f=="nsfl" then  --NFSL
        flag = flag.."4"
        f_set = true 
    else                   --ALL
        flag = flag.."7"
    end
    
    if f_set then
        if t~=nil then
            tag = "&tags="..URL.escape(t)
        end --else tag stays empty
    else --f becomes tag
        if f~=nil then
            tag = "&tags="..URL.escape(f) 
        end --else tag stays empty 
    end

    local url = "http://pr0gramm.com/api/items/get?promoted=1"..tag..flag
    local b,status = http.request(url)
    if status ~= 200 then --200 = OK
        return 2
    end
    
    local img_data = json:decode(b)
    while true do
        if #img_data.items == 0 then
            return 1   
        end  

        i = math.random(#img_data.items)
        if(string.find(img_data.items[i].image,".jpg") or
            string.find(img_data.items[i].image,".png")) then
            break
        end
        table.remove(img_data.items, i)
    end
    local img_url = "http://img.pr0gramm.com/"..img_data.items[i].image
    send_photo_from_url(get_receiver(msg), img_url)
    return 0 
end

function run(msg, matches)   
    if matches[1] == "!benis" then
        score = get_benis(matches[2])
        if score == nil then 
            return "Sorry, der User existiert nicht."
        end
        return matches[2].." hat "..score.." Benis"
    
    elseif matches[1] == "!pr0" then
        ret_val = get_random_image(msg, matches[2], matches[3])
        if ret_val == 0 then
            return nil
        elseif ret_val == 1 then
            return "Keine Bilder gefunden."
        elseif ret_val == 2 then
            return "Interner Error"        
        end
    
    else
        if not get_Pr0_image(msg, matches[2]) then
            return "Sorry, der gewünschte Content existiert nicht."        
        end
    end
end

return{
    description = "Man telegramt nicht über das pr0",
    usage = {
        "[pr0 url]: Man pasted nicht über das pr0 in telegram",
        "!benis [fag]: Zeigt benis",
        "!pr0 [filter] [tag]: Zufälliges Bild mit Filter [sfw, nsfw, nsfl], \
        kein Filter -> [all], Tag optional", 
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
        "^(!pr0) (sfw) (.+)$",
        "^(!pr0) (nsfw) (.+)$",
        "^(!pr0) (nsfl) (.+)$",
        "^(!pr0) (.*)$",
        "^(!pr0)$",
    },
    run = run
}
