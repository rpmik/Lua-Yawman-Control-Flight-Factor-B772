--[[
 Flight Factor B772 mapping for the Yawman Arrow By Ryan Mikulovsky, CC0 1.0.
 
 Inspired by Yawman's mapping for the MSFS PMDG 777.
 Thanks for Thomas Nield for suggesting looking into Lua for better controller support in XP12. Button numbers and variable names came from Thomas.
 
 See Thomas' video and access example Lua scripts at https://www.youtube.com/watch?v=x8SMg33RRQ4
 
 Repository at https://github.com/rpmik/Lua-Yawman-Control-Flight-Factor-B772
]]
-- use local to prevent other unknown Lua scripts from overwriting variables (or vice versa)
local STICK_X = 0 
local STICK_Y = 1
local POLE_RIGHT = 2 
local POLE_LEFT = 3
local RUDDER = 4
local SLIDER_LEFT = 5
local SLIDER_RIGHT = 6 
local POV_UP = 0
local POV_RIGHT = 2
local POV_DOWN = 4
local POV_LEFT = 6
local THUMBSTICK_CLK = 8
local SIXPACK_1 = 9
local SIXPACK_2 = 10
local SIXPACK_3 = 11
local SIXPACK_4 = 12
local SIXPACK_5 = 13
local SIXPACK_6 = 14
local POV_CENTER = 15
local RIGHT_BUMPER = 16
local DPAD_CENTER = 17
local LEFT_BUMPER = 18
local WHEEL_DOWN = 19
local WHEEL_UP = 20
local DPAD_UP = 21
local DPAD_LEFT = 22
local DPAD_DOWN = 23
local DPAD_RIGHT = 24

-- Logic states to keep button assignments sane
local PAUSE_STATE = false
local STILL_PRESSED = false -- track presses for everything
local MULTI_SIXPACK_PRESSED = false -- track presses for only the six pack where there's multiple six pack buttons involved
local DPAD_PRESSED = false

local CHASE_VIEW = false

function multipressFFB772_buttons() 
    -- if aircraft is Boeing 777-200 then procede
    if PLANE_ICAO == "B772" then 
                
		

		-- Base Config buttons that should almost always get reassigned except during a press
        if not STILL_PRESSED then -- avoid overwriting assignments during other activity
			set_button_assignment(DPAD_UP,"sim/none/none")
			set_button_assignment(DPAD_DOWN,"sim/none/none")
			set_button_assignment(DPAD_LEFT,"sim/general/zoom_out_fast")
			set_button_assignment(DPAD_RIGHT,"sim/general/zoom_in_fast")
			set_button_assignment(WHEEL_UP, "sim/none/none")
			set_button_assignment(WHEEL_DOWN, "sim/none/none")
			set_button_assignment(LEFT_BUMPER, "sim/none/none") -- multifunction
			set_button_assignment(RIGHT_BUMPER, "sim/none/none") -- multifunction
			set_button_assignment(SIXPACK_1,"sim/none/none")
			set_button_assignment(SIXPACK_2,"sim/flight_controls/brakes_regular")
			set_button_assignment(SIXPACK_3,"sim/none/none")		
			set_button_assignment(SIXPACK_4,"sim/none/none")
			set_button_assignment(SIXPACK_5,"sim/none/none")
			set_button_assignment(SIXPACK_6,"sim/none/none")			
			set_button_assignment(POV_UP,"sim/flight_controls/pitch_trim_up")
			set_button_assignment(POV_DOWN,"sim/flight_controls/pitch_trim_down")
			set_button_assignment(POV_LEFT,"sim/view/glance_left")
			set_button_assignment(POV_RIGHT,"sim/view/glance_right")
			set_button_assignment(POV_CENTER,"sim/view/default_view")

        end 
        
        -- Get button status
    
        right_bumper_pressed = button(RIGHT_BUMPER)
        left_bumper_pressed = button(LEFT_BUMPER)
        
        sp1_pressed = button(SIXPACK_1)
        sp2_pressed = button(SIXPACK_2)
        sp3_pressed = button(SIXPACK_3)
		sp4_pressed = button(SIXPACK_4)
		sp5_pressed = button(SIXPACK_5)
		sp6_pressed = button(SIXPACK_6)
		
		pov_up_pressed = button(POV_UP)
		pov_down_pressed = button(POV_DOWN)
		
		dpad_up_pressed = button(DPAD_UP)
		dpad_center_pressed = button(DPAD_CENTER)
		dpad_down_pressed = button(DPAD_DOWN)
		dpad_left_pressed = button(DPAD_LEFT)
		dpad_right_pressed = button(DPAD_RIGHT)
		
		--need to figure out how to do nothing for duration of buttons being pressed

-- Start expanded control logic

		if dpad_center_pressed and not CHASE_VIEW and not STILL_PRESSED then
			command_once("sim/view/chase")
			CHASE_VIEW = true
			STILL_PRESSED = true
		end
	
		if dpad_center_pressed and CHASE_VIEW and not STILL_PRESSED then
			command_once("sim/view/default_view")
			CHASE_VIEW = false
			STILL_PRESSED = true
		end

-- Auto pilot engage A 
		
		if right_bumper_pressed and not dpad_up_pressed and not STILL_PRESSED then
			command_once("1-sim/command/mcpApLButton_button")
			STILL_PRESSED = true
		
		end
		
-- autopilot control
	
		if sp1_pressed then
			if not STILL_PRESSED then -- Do not constantly set the button assignment every frame
				set_button_assignment(DPAD_UP,"1-sim/command/mcpSpdRotary_rotary+")
				set_button_assignment(DPAD_DOWN,"1-sim/command/mcpSpdRotary_rotary-")
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/mcpAtButton_button")
				set_button_assignment(DPAD_RIGHT,"1-sim/command/mcpFlchButton_button")
			end

		-- Pause Simulation
			if sp2_pressed and sp3_pressed and not MULTI_SIXPACK_PRESSED then
				command_once("sim/operation/pause_toggle")
				MULTI_SIXPACK_PRESSED = true
			else
				STILL_PRESSED = true
			end
		end
		
		if sp2_pressed then
			-- Flight director isn't very useful on the B742, just command bars, so will make this roll mode INS, which is basically the real flight directory.
			if not STILL_PRESSED then -- Do not constantly set the button assignment every frame
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/mcpFdLSwitch_trigger")
				--set_button_assignment(DPAD_LEFT,"1-sim/command/mcpHdgCelButton_button")
				set_button_assignment(DPAD_RIGHT,"1-sim/command/mcpLnavButton_button")
				set_button_assignment(DPAD_LEFT,"1-sim/command/mcpLocButton_button")
				set_button_assignment(DPAD_DOWN,"1-sim/command/mcpAppButton_button")
				--set_button_assignment(DPAD_DOWN,"B742/command/AP_nav_select_LAND")
			end
					
			-- Flash Light
			if sp5_pressed and not MULTI_SIXPACK_PRESSED then
				command_once("sim/view/flashlight_red")
				MULTI_SIXPACK_PRESSED = true
			else
				STILL_PRESSED = true
			end
		
		end

		if sp3_pressed then
			if not STILL_PRESSED then
				set_button_assignment(DPAD_UP,"1-sim/command/mcpAltRotary_rotary+")
				set_button_assignment(DPAD_DOWN,"1-sim/command/mcpAltRotary_rotary-")
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/mcpAltHoldButton_button")
				--set_button_assignment(LEFT_BUMPER,"1-sim/command/mcpAltHoldButton_button")
			end
			
				-- Landing Lights - not available in the felis, unfortunately.
			if sp6_pressed and not MULTI_SIXPACK_PRESSED then
				command_once("1-sim/command/landingLightLeftSwitch_trigger")
				command_once("1-sim/command/landingLightNoseSwitch_trigger")
				command_once("1-sim/command/landingLightRightSwitch_trigger")
				MULTI_SIXPACK_PRESSED = true
			else
				STILL_PRESSED = true
			end
		end
		
		if sp5_pressed then
			if not STILL_PRESSED then
				set_button_assignment(DPAD_UP,"1-sim/command/mcpHdgRotary_rotary+")
				set_button_assignment(DPAD_DOWN,"1-sim/command/mcpHdgRotary_rotary-")
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/mcpHdgTrkButton_button")
			end
			STILL_PRESSED = true
		end
		
		if sp6_pressed then
			if not STILL_PRESSED then
				set_button_assignment(DPAD_UP,"1-sim/command/mcpVsRotary_rotary-")
				set_button_assignment(DPAD_DOWN,"1-sim/command/mcpVsRotary_rotary+")
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/mcpVsButton_button")
			end
			STILL_PRESSED = true
		end

-- parking brake			
		if left_bumper_pressed then
			if not STILL_PRESSED then
				set_button_assignment(WHEEL_UP,"sim/flight_controls/brakes_toggle_max")
				set_button_assignment(WHEEL_DOWN,"sim/flight_controls/brakes_toggle_max")
			end
				-- Cockpit camera height not implemented as it deals with the rudder axes.....
			if sp1_pressed and not MULTI_SIXPACK_PRESSED then
				if dpad_up_pressed then
					-- EFB but this doesn't quite work. 777
					set_pilots_head(-0.756343,1.648857,-27.463831,327.1875,-38.166687)
				else
					-- Glareshield 777
					set_pilots_head(-0.024326,1.778529,-27.437494,0.375000,-7.333365)
				end
				MULTI_SIXPACK_PRESSED = true
			elseif sp2_pressed and not MULTI_SIXPACK_PRESSED then
				-- Nav, CDU, Transponder, etc 777
				set_pilots_head(-0.039730,1.654469,-27.160631,0.375001,-69.333466)
				MULTI_SIXPACK_PRESSED = true
			elseif sp3_pressed and not MULTI_SIXPACK_PRESSED then
				-- FMS 777
				set_pilots_head(-0.294509,1.626397,-27.513678,31.500002,-37.127251)
				MULTI_SIXPACK_PRESSED = true
			elseif sp4_pressed and not MULTI_SIXPACK_PRESSED then
				-- Overhead panel 777
				set_pilots_head(0.064213,1.609928,-27.090744,360.000000,57.166637)
				MULTI_SIXPACK_PRESSED = true
			elseif sp5_pressed and not MULTI_SIXPACK_PRESSED then
				-- Throttles, flaps, speed brake, pitch trim, fuel cutoffs 
				set_pilots_head(-0.015778,1.763360,-27.522243,0.187500,-63.333344)
				MULTI_SIXPACK_PRESSED = true
			elseif sp6_pressed and not MULTI_SIXPACK_PRESSED then
				-- CB Panel 777
				set_pilots_head(0.065356,1.808160,-26.749197,359.437500,64.999985)
				MULTI_SIXPACK_PRESSED = true
			end
			
			STILL_PRESSED = true
		end
				

-- DPAD_up mode
		if dpad_up_pressed then
			if not STILL_PRESSED then
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/togaLeftButton_button") -- there's only a toggle (Will investigate later)
				set_button_assignment(WHEEL_UP,"sim/flight_controls/flaps_down")
				set_button_assignment(WHEEL_DOWN,"sim/flight_controls/flaps_up")
				set_button_assignment(POV_LEFT,"sim/view/glance_left")
				set_button_assignment(POV_RIGHT,"sim/view/glance_right")
				set_button_assignment(POV_UP,"sim/view/straight_up")
				set_button_assignment(POV_DOWN,"sim/view/straight_down")
		
				set_button_assignment(DPAD_LEFT,"sim/none/none")
				set_button_assignment(DPAD_RIGHT,"sim/none/none")
			end
			
			-- logic is off, does not work, gotta fix this...
			if dpad_left_pressed then
				-- Pilot's seat 777
				set_pilots_head(-0.533400,1.870000,-27.118057,0.000000,-5.000000)

			elseif dpad_right_pressed then
				-- Copilot's seat 777
				set_pilots_head(0.574006,1.870000,-27.118057,0.000000,-5.000000)

			end
			STILL_PRESSED = true

		end
		
-- DPAD_down mode
		if dpad_down_pressed then
			if not STILL_PRESSED then
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/apDiscLeftButton_button") -- there's only a toggle (Will investigate later)
			end
			
			STILL_PRESSED = true
		end

-- All buttons need to be released to end STILL_PRESSED phase
		if not sp1_pressed and not sp2_pressed and not sp3_pressed and not sp4_pressed and not sp5_pressed and not sp6_pressed and not right_bumper_pressed and not left_bumper_pressed and not dpad_center_pressed and not dpad_down_pressed then
			STILL_PRESSED = false
		end

		if not sp1_pressed and not sp2_pressed and not sp3_pressed and not sp4_pressed and not sp5_pressed and not sp6_pressed then
			MULTI_SIXPACK_PRESSED = false
		end 
		
		if not dpad_up_pressed and not dpad_left_pressed and not dpad_right_pressed and not dpad_down_pressed then
			DPAD_PRESSED = false
		end

    end 
end

-- Don't mess with other configurations
if PLANE_ICAO == "B772" then 
	clear_all_button_assignments()

--[[
set_axis_assignment(STICK_X, "roll", "normal" )
set_axis_assignment(STICK_Y, "pitch", "normal" )
set_axis_assignment(POLE_RIGHT, "reverse", "reverse")
set_axis_assignment(POLE_RIGHT, "speedbrakes", "reverse")
set_axis_assignment(RUDDER, "yaw", "normal" )
]]

	do_every_frame("multipressFFB772_buttons()")
end
