express = require("express")
passport = require("passport")
RdioStrategy = require("passport-rdio").Strategy

port = process.env.PORT or 7000
app = express()

##
## OAuth Bullshit
##

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

rdioSettings = 
  consumerKey: process.env.RDIO_API_KEY
  consumerSecret: process.env.RDIO_SHARED_SECRET
  callbackURL: "http://localhost:" + port + "/auth/rdio/callback"

passport.use new RdioStrategy(rdioSettings, (token, tokenSecret, profile, done) ->
  process.nextTick ->
    done null, profile

app.configure ->
  app.set "views", __dirname + "/dist"
  app.use express.cookieParser(process.env.RPH_COOKIE_SECRET or "keyboard cat")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieSession()
  app.use express.session(secret: "password")
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.engine "html", require("ejs").renderFile
  app.use express.static(__dirname + "/dist")

ensureAuthenticated = (req, res, next) ->
  return next()  if req.isAuthenticated()
  res.redirect "/login"

app.get "/account", ensureAuthenticated, (req, res) ->
  res.render "account",
    user: req.user

app.get "/login", (req, res) ->
  res.render "login",
    user: req.user

app.get "/auth/rdio", passport.authenticate("rdio"), (req, res) ->

app.get "/auth/rdio/callback", passport.authenticate("rdio", failureRedirect: "/login"), (req, res) -> res.redirect "/"

app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"


##
## Actual Routes
##

app.get "/", (request, response) ->
  console.log(request.session)
  response.render("index.html")
  

##
## Startup
##

app.listen port, ->
  console.log "Listening on " + port
