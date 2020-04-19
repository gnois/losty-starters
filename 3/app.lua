--
-- Generated from app.lt
--
local content = require("losty.content")
local server = require("losty.web")
local view = require("losty.view")
local tbl = require("losty.tbl")
local web = server()
local w = web.route()
local Contact = "/contact"
local template = function(args)
    return html({head({meta("[charset=UTF-8]"), title(args.title), link({rel = "stylesheet", href = "index.css"})}), body({div(".center", {h1(args.title), div(args.message), args.form and form({submit = Contact, method = "POST"}, {input("[name=info][type=text][min=3][required]"), div(button("[type=submit]", "Submit"))}) or span()}), footer({hr(), div(".center", "&copy" .. args.copyright)})})})
end
local page = function(args)
    args.copyright = "My website"
    return view(template, args)
end
w.get("/", function(q, r)
    print("Browser id: " .. q.id)
    r.redirect("/index")
end)
w.get("/:%a+", function(q, r)
    r.status = 200
    r.headers["content-type"] = "text/plain"
    return "Found anything at /" .. q.match[1] .. "?"
end)
w.get(Contact, function(q, r)
    r.status = 200
    r.headers["content-type"] = "text/html"
    return page({title = "Contact", message = "Message me:", form = true})
end)
w.post(Contact, content.form, function(q, r, body)
    r.status = 204
    tbl.show(body)
end)
local errors = {[404] = function()
    return page({title = "404 Not Found", message = "Nothing here"})
end}
return function()
    web.run(errors)
end
