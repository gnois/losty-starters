## Example 3


#### Highlights
- nginx.conf with static html page, and Lua fallback for dynamic pages, and redirection between them
- view template with external stylesheet and conditions
- accessing [userid](http://nginx.org/en/docs/http/ngx_http_userid_module.html) from Lua
- form submission
- handlers chaining with content.html helper and content.form body parser 
- app.lua compiled from app.lt


#### Run with
```
nginx -p . -c nginx.conf
```

#### Optional
- [Luaty](https://github.com/gnois/luaty)