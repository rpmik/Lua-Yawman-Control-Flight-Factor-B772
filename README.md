# More Aircraft Scripts for the Yawman Arrow Controller
* [Full and Most Up To Date Aircraft Script List](https://www.distortions.net/yawman-arrow-controller-xplane/#:~:text=All%20the%20Scripts%20(Github%20Downloads)) (at distortions.net)

# Requirements
* [X-Plane 12](https://www.x-plane.com/) as I'm not testing this in X-Plane 11
* [Flight Factor 777-200 for X-Plane 12](https://store.x-plane.org/777-200ER-v2-Ultimate_p_1883.html)
* [FlyWithLua 2.8 for X-Plane 12](https://forums.x-plane.org/index.php?/files/file/82888-flywithlua-ng-next-generation-plus-edition-for-x-plane-12-win-lin-mac/)
* [Yawman Arrow Controller](https://yawmanflight.com/)

# Installation
Note that the current script does not modify your axes. You'll need to set up your Yawman Arrow's axes as you like.

The Flight Factor 777-200 is not officially released (but it is no longer under NDA). This script could break at any time because of changes during the aircraft's development.

Save _FF B772 Yawman Multipress.lua_ to /X-Plane 12/Resources/plugins/FlyWithLua/Scripts

Assignments closely matches Yawman's PMDG 777 mappings. See their [discord](https://discord.gg/dcpTc5KP).

# Assignments are In Work!
Sixpack 1, 2, 3, 4, 5, and 6 are referred to as SP1, SP2, SP3 etc. These are the two rows of three buttons, where the upper-most left button is 1 and the lower-most right button is 6.

Some Yawman documentation refer to these as MF 1L (SP1), MF 1C (SP2), MF 1R (SP3), MF 2L (SP4), MF 2C (SP5), MF 2R (SP6)

* DPAD Left = Zoom Out
* DPAD Right = Zoom In
* DPAD Center = Chase or Aircraft's Default View
* Sixpack #2 (SP2) = brakes regular hold
* POV Up = Pitch Trim Up
* POV Down = Pitch Trim Down		
* POV Left = Glance Left
* POV Right = Glance Right
* Right Bumper = Auto Pilot Engage (On/Off)

* SP1 plus
	* DPAD Up = AT Speed Up
	* DPAD Down = AT Speed Down
	* DPAD Right = AT Engage Button
	* Right Bumper = FLCH Button
* SP 2 plus
	* DPAD Down = Approach Button
	* DPAD Left = Localizer Button
	* DPAD Right = LNAV Button
	* SP5 = Red Flash Light
* SP3 plus
	* DPAD Up = AP Alt Select Up
	* DPAD Down = AP Alt Select Down
	* Right Bumper = Alt Hold button
	* SP6 = Landing Lights Toggle and Turnoff Lights Toggle
* SP5 plus
	* DPAD Up = Hdg up
	* DPAD Down = Hdg Down
	* Right Bumper = Hdg Button
* SP6 plus
	* DPAD Left = Captain's HSI Barometer Decrease
	* DPAD Right = Captain's HSI Barometer Increase
	* DPAD Center = Captain's HSI Barometer Standard
	* DPAD Up = VS Down
	* DPAD Down = VS Up
	* Right Bumper = VS Button
* LEFT Bumper then
	* Wheel Up/Down = Brakes Max (Parking Brake)
	* SP1 = View, Glareshield
	* SP2 = View, Radios; Radar; EPR
	* SP3 = Nav computer
	* SP4 = Overhead panel
	* SP5 = Throttles, Speed Brake, Fuel etc
	* SP6 = Circuit Breaker Panel
	* Right Bumper = MCP Captain's AP Disconnect
	
* DPAD Up plus
	* Wheel Up = Flaps Up
	* Wheel Down = Flaps Down
	* POV Left = Glance Left
	* POV Right = Glance Right
	* POV Up = Straight Up
	* POV Down = Straight Down
	* DPAD Left = View, Pilot's View
	* DPAD Right = View, Co-Pilot's View
	* Right Bumper = TOGA/Auto-Throttle Toggle

* DPAD Down plus
	* Right Bumper = AT Disconnect (on throttles)

# TODO
* Finish 777 assignments. Original script was for the Felis 747-200.
* ~~Reassign cockpit views~~
* Implement radio tuning
