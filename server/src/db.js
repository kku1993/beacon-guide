/*
 *  db.js
 *  Currently returns mock data
 */

exports = module.exports = DB;

var _ = require('lodash');

var mockBuilding = require('../mock_data/building');
var mockBeacons = require('../mock_data/beacons');

function DB() {
}

//  get building in which the beacon belongs
//  callback(err, building)
DB.prototype.getBeaconBuilding = function(beaconData, callback) {
  var beacon = _.filter(mockBeacons, function(b) {
    return b.UUID === beaconData.UUID && 
      b.majorNumber === beaconData.majorNumber &&
      b.minorNumber === beaconData.minorNumber;
  }).pop();

  if(!beacon) {
    callback(new Error('No such beacon.'), null);
    return;
  }

  var building = mockBuilding;

  // add beacon details to the building's info
  building.beaconDetails = building.beacons.map(function(bID) {
    return mockBeacons[bID];
  });

  callback(null, building);
};

DB.prototype.getBeaconByBeaconData = function(beaconData, callback) {
  var beacon = _.filter(mockBeacons, function(b) {
    return b.UUID === beaconData.UUID && 
      b.majorNumber === beaconData.majorNumber &&
      b.minorNumber === beaconData.minorNumber;
  }).pop();

  callback(null, beacon);
};

DB.prototype.getBuildingByID = function(buildingID, callback) {
  callback(null, mockBuilding);
};
