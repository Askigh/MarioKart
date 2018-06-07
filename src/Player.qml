import QtQuick 2.0
import Cellulo 1.0

Item {

    property MarioKartManager globalManager : null
    property CelluloRobot robot : robot
    property double speed : 30
    property double xPos : 0
    property double yPos : 0
    property vector2d lastCheckPoint : window.mapChoosing.selected.spawn
    property bool isReachingCheckPoint : false

    visible: false

    CelluloRobot {

        // connectionStatus is a variable from CelluloRobot file -> enum { Disconnected, TryingToConnect, Connected
        id: robot

        onConnectionStatusChanged: {



            if(connectionStatus === CelluloBluetoothEnums.ConnectionStatusConnected) {
                robot.reset()
                console.log("Connected !")
                globalManager.robotConnected()
                window.mapChoosing.selected.zoneEngine.addNewClient(robot);

            }
        }

        onZoneValueChanged : {

            console.log("ZONE VALUE HAS CHANGED")
            robot.setGoalPose(lastCheckPoint.x, lastCheckPoint.y, 1,60,10)
            isReachingCheckPoint = true

        }

        onTrackingGoalReached: {

            setCasualBackdriveAssistEnabled(true);
            clearTracking();
            //console.log("CheckPoint reached ! Cellulo is now able to be moved")
            isReachingCheckPoint = false
        }

        onPoseChanged : {

            testWin()
            updateCheckPoints()
            //console.log(window.mapChoosing.selected.zoneEngine.getAllZoneNames())
            console.log(player.robot.x+" / "+player.robot.y)
        }

    }

    function updateCheckPoints() {

        if(globalManager.gameTimer.running == false)
            return

        var currentMap = window.mapChoosing.selected

        for(var i = 0; i < currentMap.checkPoints.length; i++) {

            var vec2 = currentMap.checkPoints[i]

            var distanceX = (vec2.x) - (robot.x)
            var distanceY = (vec2.y) - (robot.y)

            var distanceSquared = distanceX * distanceX + distanceY * distanceY

            if(Math.sqrt(distanceSquared) < 20) {

                currentMap.spawn = vec2;
            }
        }
    }

    function testWin() {

        if(globalManager.gameTimer.running == false)
            return

        var currentMap = window.mapChoosing.selected
        var endPoint = currentMap.endLocation

        var distanceX = (endPoint.x) - (robot.x)
        var distanceY = (endPoint.y) - (robot.y)
        var distanceSquared = distanceX * distanceX + distanceY * distanceY

        if(Math.sqrt(distanceSquared) < 15) {

            robot.setGoalPose(endPoint.x, endPoint.y, 1,60,10)
            globalManager.endReached()
        }
    }

    function init() {

        console.log(robot.connectionStatus)

        robot.setGoalOrientation(25, 100)

        resetColor()

    }

    function resetColor() {

        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "green", 1);
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "green", 2);
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "green", 3);
    }

    function warn() {

        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "red", 1);
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "red", 2);
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "red", 3);
    }






}