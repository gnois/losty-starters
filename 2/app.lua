local web = require("losty.web")
local view = require("losty.view")
local w = web.route()

function template(args)
    return html({
        head({
            meta("[charset=UTF-8]")
            , title(args.title)
            , style({".center { text-align: center; }"})
        })
        , body({
            div(".center", {
                h1(args.title), div(args.message)
            })
            , footer({
                hr()
               , div(".center", "&copy" .. args.copyright)
            })
        })
    })
end

function page(args)
    args.copyright = "My website"
    return view(template, args)
end

function not_found()
    return page({title = "404 Not Found", message = "Nothing here"})
end

w.get("/", function(q, r)
    r.status = 200
    r.headers["content-type"] = "text/html"
    return page({title = "Hi", message = "Losty is live!"})
end)

w.get("/:%a+", function(q, r)
    r.status = 200
    r.headers["content-type"] = "text/html"
    return page({title = q.match[1], message = "Match route: " .. q.match[1] or "?"})
end)


local errors = {
    [404] = not_found()
}

return function()
    web.run(errors)
    -- web.run(true)  -- use this to display nginx error_page
end
