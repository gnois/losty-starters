--
-- Generated from app.lt
--
local content = require("losty.content")
local view = require("losty.view")
local web = require("losty.web")()
local cred = require("credential")
local sess = require("losty.sess")("sessy", cred.session.secret, cred.session.key)
local csrf = require("losty.csrf")(cred.csrf)
local w = web.route()
local Sess = "/sess"
local template = function(args)
    return html({head({meta("[charset=UTF-8]"), title(args.title), style([=[
				.center { text-align: center; }
				input, button {
				  margin: 1rem;
				  padding: 0.5rem;
				  border: 1px solid black
				}
			]=])}), body({div(".center", {h1(args.title), div(args.message), br(), args.token and form({submit = Sess, method = "POST"}, {input({type = "hidden", name = "token", value = args.token}), input("[name=data][type=text][min=1][required]"), div(button("[type=submit]", "Submit"))}) or a({href = "/sess"}, "Set session data")}), footer({hr(), div(".center", "&copy" .. args.copyright)})})})
end
local page = function(args)
    args.copyright = "My website"
    return view(template, args)
end
w.get("/", content.html, function(q, r)
    r.status = 200
    local s = sess.read(q)
    return page({title = "Session", message = s and s.data or "No data yet"})
end)
w.get(Sess, content.html, function(q, r)
    r.status = 200
    return page({title = "Session demo", message = "Session data:", token = "ana"})
end)
local prepost = function(...)
    return content.form, function(q, r, body)
        if csrf.check(q, r, body.token) then
            return q.next()
        end
        r.status = 403
    end, ...
end
w.post(Sess, prepost(function(q, r, body)
    local s = sess.create(q, r, 24 * 3600 * 1)
    s.data = body.data
    r.redirect("/")
end))
return function()
    web.run()
end
