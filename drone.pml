#define N 4

typedef array {
    /*loc[0] - altitude; loc[1] - latitude; loc[2] - longitude*/
    byte loc[3]
}


/* receiver */
active proctype drone()
{   bit in_mission, arm, disarm;
    byte i, j;
    /*altitude, latitude, longitude*/
    short alt, lat, lon;
    /*waypoints, add the original point*/
    array waypoints[N+1];


MANUAL:
    atomic{
        alt = 0;
        lat = 100;
        lon = 100;
        waypoints[0].loc[0] = 0;
        waypoints[0].loc[1] = 100;
        waypoints[0].loc[2] = 100;
        waypoints[1].loc[0] = 50;
        waypoints[1].loc[1] = 120;
        waypoints[1].loc[2] = 100;
        waypoints[2].loc[0] = 50;
        waypoints[2].loc[1] = 120;
        waypoints[2].loc[2] = 120;
        waypoints[3].loc[0] = 50;
        waypoints[3].loc[1] = 100;
        waypoints[3].loc[2] = 120;
        waypoints[4].loc[0] = 0;
        waypoints[4].loc[1] = 100;
        waypoints[4].loc[2] = 100;
        in_mission = 1;
    };
    if
    :: (in_mission == 1) -> goto ARMING
    fi;

ARMING: 
    arm = 1;
    if
    :: (arm ==1 ) -> goto TAKEOFF
    fi;

TAKEOFF:
    alt++;
    if
    :: (alt >= waypoints[1].loc[0]) -> goto MISSION;
    :: else -> goto TAKEOFF;
    fi;
    
MISSION:
    i++;
    if
        :: (i<(N+1)) -> goto FLYING_ALT;
        :: else -> goto LAND;
    fi;

FLYING_ALT:
    do
        :: true ->
            if
            :: (waypoints[i-1].loc[0] < waypoints[i].loc[0]) -> waypoints[i-1].loc[0]++;
            :: (waypoints[i-1].loc[0] > waypoints[i].loc[0]) -> waypoints[i-1].loc[0]--;
            :: else -> goto FLYING_LAT;
            fi;
    od;

FLYING_LAT:
    do
        :: true ->
            if
            :: (waypoints[i-1].loc[1] < waypoints[i].loc[1]) -> waypoints[i-1].loc[1]++;
            :: (waypoints[i-1].loc[1] > waypoints[i].loc[1]) -> waypoints[i-1].loc[1]--;
            :: else -> goto FLYING_LON;
            fi;
    od;

FLYING_LON:
    do
        :: true ->
            if
            :: (waypoints[i-1].loc[2] < waypoints[i].loc[2]) -> waypoints[i-1].loc[2]++;
            :: (waypoints[i-1].loc[2] > waypoints[i].loc[2]) -> waypoints[i-1].loc[2]--;
            :: else -> goto MISSION;
            fi;
    od;


LAND:
    disarm = 1 -> goto MANUAL

}

ltl p1 { always eventually (drone@LAND) } 