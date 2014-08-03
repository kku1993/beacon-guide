var express = require('express'),
    logger = require('morgan'),
    bodyParser = require('body-parser');

var DB = require('./db'),
    pathFinder = require('./path_finder');

function startServer() {
  var db = new DB();

  var app = express();

  // set up middlware
  app.use(logger('dev'));
  app.use(bodyParser.json());
  
  app.post('/api/getBeaconBuilding', function(req, res) {
    db.getBeaconBuilding(req.body.beacon, function(err, building) {
      if(err) {
        res.status(404).end();
        console.error(err);
        return;
      }
      res.json(building);
    });
  });
  app.post('/api/getPath', function(req, res) {
    if(!req.body.startBeaconID || !req.body.endBeaconID || 
      !req.body.buildingID) {
      res.status(400).end();
      return;
    }
    
    db.getBuildingByID(req.body.buildingID, function(err, building) {
      if(err) {
        res.status(500).end();
        return;
      }
      var path = pathFinder.findPath(building, req.body.startBeaconID, 
        req.body.endBeaconID, function(err, path) {
        if(err) {
          res.status(500).end();
          return;
        }
        res.json(path);
      });
    });
  });
  app.post('/api', function(req, res) {
    res.write('Beacon Guide API v0.1');
  });

  app.listen(80, function() {
    console.log('Server started on port 80');
  });
}

startServer();
