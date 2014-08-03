var express = require('express'),
    logger = require('morgan'),
    bodyParser = require('body-parser');

var mockBuilding = require('../mock_data/building');
var mockBeacons = require('../mock_data/beacons');

function isValidBeacon(data) {
  return (data.UUID && data.majorNumber && data.minorNumber);
}

function startServer() {
  var app = express();

  // set up middlware
  app.use(logger('dev'));
  app.use(bodyParser.json());
  
  app.post('/api/getBuilding', function(req, res) {
    if(!isValidBeacon(req.body.beacon)) {
      res.status(400).end();
      return;
    }
    res.json(mockBuilding);
  });
  app.post('/api/navigate', function(req, res) {
    if(!req.body.startBeacon || !req.body.endBeacon) {
      res.status(400).end();
      return;
    }

    var start = req.body.startBeacon;
    var end = req.body.endBeacon;

    if(!isValidBeacon(start) || !isValidBeacon(end)) {
      res.status(400).end();
      return;
    }

    //var path = pathPlanner(start, end);
    res.status(200).end();
  });
  app.post('/api', function(req, res) {
    res.write('Beacon Guide API v0.1');
  });

  app.listen(80, function() {
    console.log('Server started on port 80');
  });
}

startServer();
