Beacon Guide
============

# Beacon Guide API v0.1

## POST /api/getBeaconBuilding
- Request

```
{
  "beacon": {
    "UUID": "...",
    "majorNumber": 1,
    "minorNumber": 2
  }
}
```

- Response

```
{
  "buildingID": "b1",
  "name": "YC Building",
  "updateDate": 1407039110.205,
  "beacons": [
    "1",
    "2",
    "3"
  ],
  "beaconGraph": {
    "1": [ "2" ],
    "2": [ "1", "2" ],
    "3": [ "2" ]
  },
  "beaconDetails": [
    {
      "beaconID": "1",
      "UUID": "123",
      "majorNumber": 1,
      "minorNumber": 1,
      "description": "Art 1",
      "buildingID": "b1",
      "position": {
        "lng": 123.456,
        "lat": 23.234
      }
    },
    {
      ...
    },
    {
      ...
    }
  ]
}
```

## POST /api/getPath
- Request

```
{
  startBeaconID: "...",
  endBeaconID: "...",
  buildingID: "..."
}
```

- Response 

```
[
  "1",
  "2",
  "3"
]
```
