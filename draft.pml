do
    :: if
        :: (alt <= waypoints[1].loc[0]) -> alt = alt+1
        :: (alt >= waypoints[1].loc[0]) -> goto MISSION
       fi;
od


i = 0; /* index for waypoints. max=3*/
    j = 0 /* index for locations. max=2*/
    do
    :: (i<N) ->
        do
        :: if
            :: (waypoints[i].loc[0] < waypoints[i+1].loc[0]) -> waypoints[i].loc[0]++;
            :: (waypoints[i].loc[0] > waypoints[i+1].loc[0]) -> waypoints[i].loc[0]--;
            :: (waypoints[i].loc[1] < waypoints[i+1].loc[1]) -> waypoints[i].loc[1]++;
            :: (waypoints[i].loc[1] > waypoints[i+1].loc[1]) -> waypoints[i].loc[1]--;
            :: (waypoints[i].loc[2] < waypoints[i+1].loc[2]) -> waypoints[i].loc[2]++;
            :: (waypoints[i].loc[2] > waypoints[i+1].loc[2]) -> waypoints[i].loc[2]--;
            :: else -> break
            fi;
        od
    :: (i==N) -> goto LAND
    od