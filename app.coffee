express = require ('express')
routes = require('./routes')
config = require('./config')
http = require('http')
path = require('path')
assets = require('connect-assets')



app = express()

unless process.env.NODE_ENV 
  process.env.NODE_ENV = 'development'

node_env = process.env.NODE_ENV



app.configure ->
  app.set 'port', process.env.PORT or config.port
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  # Set the public folder as static assets
  app.use express.static(process.cwd() + '/public')
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  # app.use express.cookieParser(config.cookieSecret)
  # app.use express.session()
  app.use app.router

  # Compress with Gzip
  app.use express.compress
    filter: (req, res) -> return /json|text|javascript|css/.test(res.getHeader('Content-Type'));
    level: 9

app.configure 'development', ->
  app.use express.errorHandler()
  app.use assets
    build: true
    compress: false
    minifyBuilds: false
    buildDir: '/public'

app.configure 'production', ->
  app.use assets
    build: true
    compress: true
    minifyBuilds: true
    # detectChanges: true
    buildDir: '/public'

app.get '/', routes.index

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'} in NODE_ENV[#{node_env}]"
