var express = require("express");
var passport = require("passport");
var RdioStrategy = require("passport-rdio").Strategy;

var port = process.env.PORT || 7000;
var app = express();

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});

// Configuration

passport.use(new RdioStrategy({
  consumerKey: process.env.RDIO_API_KEY,
  consumerSecret: process.env.RDIO_SHARED_SECRET,
  callbackURL: "http://localhost:" + port + "/auth/rdio/callback"
}, function(token, tokenSecret, profile, done) {
  // asynchronous verification, for effect...
  process.nextTick(function() {

    // To keep the example simple, the user's Rdio profile is returned to
    // represent the logged-in user.  In a typical application, you would want
    // to associate the Rdio account with a user record in your database,
    // and return that user instead.
    return done(null, profile);
  });
}));

app.configure(function(){
  app.set('views', __dirname + '/dist');
  //app.set('view engine', 'jade');
  app.use(express.cookieParser(process.env.RPH_COOKIE_SECRET || "keyboard cat"));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieSession());
  app.use(express.session({ secret: "password" }));

  app.use(passport.initialize());
  app.use(passport.session());

  app.use(app.router);
  app.engine('html', require('ejs').renderFile);

  app.use(express.static(__dirname + '/dist'));
});

app.get('/', function(request, response) {
  console.log(request.session),
  response.render('index.html')
});

app.get('/account', ensureAuthenticated, function(req, res) {
  res.render('account', {
    user: req.user
  });
});

app.get('/login', function(req, res) {
  res.render('login', {
    user: req.user
  });
});

// GET /auth/rdio
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  The first step in Rdio authentication will involve redirecting
//   the user to rdio.com.  After authorization, Rdio will redirect the user
//   back to this application at /auth/rdio/callback
app.get('/auth/rdio', passport.authenticate('rdio'), function(req, res) {
  // The request will be redirected to Rdio for authentication, so this
  // function will not be called.
});

// GET /auth/rdio/callback
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.
app.get('/auth/rdio/callback', passport.authenticate('rdio', {
  failureRedirect: '/login'
}), function(req, res) {
  res.redirect('/');
});

app.get('/logout', function(req, res) {
  req.logout();
  res.redirect('/');
});

app.listen(port, function() {
  console.log("Listening on " + port);
});

// Simple route middleware to ensure user is authenticated.
//   Use this route middleware on any resource that needs to be protected.  If
//   the request is authenticated (typically via a persistent login session),
//   the request will proceed.  Otherwise, the user will be redirected to the
//   login page.
function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  }
  res.redirect('/login')
}
