if !PLAYLIB then return end

PLAYLIB.Web_API = PLAYLIB.Web_API or {}

function PLAYLIB.Web_API.Trivia(callback)

    http.Fetch("https://opentdb.com/api.php?amount=1&category=15",function(body,len,headers,code) 
        local tbl = util.JSONToTable(body)
        if not callback or not isfunction(callback) then return end
        callback(tbl)
    end,function(error) 
        print("AN ERROR HAS OCCURED")
    end)

end

function PLAYLIB.Web_API.RandomJoke(callback)

    http.Fetch("http://api.icndb.com/jokes/random",function(body,len,headers,code) 
        local tbl = util.JSONToTable(body)
        if not callback or not isfunction(callback) then return end
        callback(tbl)
    end,function(error) 
        print("AN ERROR HAS OCCURED")
    end)

end

function PLAYLIB.Web_API.Geolocation(ip,callback)

    http.Fetch("http://www.geoplugin.net/json.gp?ip="..tostring(ip),function(body,len,headers,code) 
        local tbl = util.JSONToTable(body)
        if not callback or not isfunction(callback) then return end
        callback(tbl)
    end,function(error) 
        print("AN ERROR HAS OCCURED")
    end)
   
end

function PLAYLIB.Web_API.Advice(callback)

    http.Fetch("https://api.adviceslip.com/advice",function(body,len,headers,code) 
        local tbl = util.JSONToTable(body)
        if not callback or not isfunction(callback) then return end
        callback(tbl)
    end,function(error) 
        print("AN ERROR HAS OCCURED")
    end)
   
end

function PLAYLIB.Web_API.ChuckNorris(callback)

    http.Fetch("https://api.chucknorris.io/jokes/random",function(body,len,headers,code) 
        local tbl = util.JSONToTable(body)
        if not callback or not isfunction(callback) then return end
        callback(tbl)
    end,function(error) 
        print("AN ERROR HAS OCCURED")
    end)
   
end