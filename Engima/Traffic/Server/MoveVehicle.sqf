ENGIMA_TRAFFIC_MoveVehicle = {
	params ["_currentInstanceIndex", "_vehicle", ["_firstDestinationPos", []], ["_debug", false]];

    private ["_speed", "_roadSegments", "_destinationSegment"];
    private ["_destinationPos"];
    private ["_waypoint", "_fuel"];
    
    // Set fuel to something in between 0.3 and 0.9.
    _fuel = 0.3 + random (0.9 - 0.3);
    _vehicle setFuel _fuel;
    
    if (count _firstDestinationPos > 0) then {
        _destinationPos = +_firstDestinationPos;
    }
    else {
    	player sideChat (vehicleVarName _vehicle) + " framme!";
    	_vehicle setVariable ["MarkerColor", "ColorRed"];
		_roadSegments = ENGIMA_TRAFFIC_roadSegments select _currentInstanceIndex;
		
        _destinationSegment = selectRandom _roadSegments;
        _destinationPos = getPos _destinationSegment;
        
        if (isNil "ENGIMA_TRAFFIC_MarkerNo") then { ENGIMA_TRAFFIC_MarkerNo = 1 };
        private _marker = createMarker ["ENGIMA_TRAFFIC_Marker_" + str ENGIMA_TRAFFIC_MarkerNo, _destinationPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "hd_dot";
        _marker setMarkerColor "ColorRed";
        ENGIMA_TRAFFIC_MarkerNo = ENGIMA_TRAFFIC_MarkerNo + 1;
    };
    
    _speed = "NORMAL";
    if (_vehicle distance _destinationPos < 500) then {
        _speed = "LIMITED";
    };
    
    private _group = group _vehicle;
    [_group] call ENGIMA_TRAFFIC_DeleteAllWaypointsFromGroup;
    
    _waypoint = _group addWaypoint [_destinationPos, 0];
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointSpeed _speed;
    _waypoint setWaypointCompletionRadius 10;
    _waypoint setWaypointStatements ["true", "_nil = [" + str _currentInstanceIndex + ", " + vehicleVarName _vehicle + ", [], " + str _debug + "] spawn ENGIMA_TRAFFIC_MoveVehicle;"];
    _group setBehaviour "SAFE";
};