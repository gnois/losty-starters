--
-- Generated from app.lt
--
local content = require("losty.content")
local web = require("losty.web")()
local view = require("losty.view")
local sess = require("losty.sess")("sessy", "This IS secret", "this is key")
local w = web.route()
local template = function(args)
    return html({head({meta("[charset=UTF-8]"), title(args.title), style([=[
				.center { text-align: center; }
				input, button {
				  margin: 1rem;
				  padding: 0.5rem;
				  border: 1px solid black
				}
			]=])}), body({div(".center", {h1(args.title), div(args.message), br(), args.home and a({href = "/sess"}, "Set session data") or form({submit = Contact, method = "POST"}, {input("[name=data][type=text][min=1][required]"), div(button("[type=submit]", "Submit"))})}), footer({hr(), div(".center", "&copy" .. args.copyright)})})})
end
local page = function(args)
    args.copyright = "My website"
    return view(template, args)
end
w.get("/", content.html, function(q, r)
    r.status = 200
    local s = sess.read(q)
    return page({title = "Session", message = s and s.data or "No data yet", home = true})
end)
w.get("/sess", content.html, function(q, r)
    r.status = 200
    return page({title = "Session demo", message = "Session data:", home = false})
end)
w.post("/sess", content.form, function(q, r, body)
    local s = sess.create(q, r, 24 * 3600 * 1)
    s.data = body.data
    r.redirect("/")
end)
return function()
    web.run()
end
