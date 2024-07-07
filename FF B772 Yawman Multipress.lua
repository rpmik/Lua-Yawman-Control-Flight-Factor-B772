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
			--DataRef("AP_ENGAGED","1-sim/command/mcpApLButton_button","readonly")
--[[
			if AP_ENGAGED == 0 then
				-- No one ever goes into just Manual mode, right? So skip straight to Command mode.
				command_once("B742/command/AP_A_engage_up") -- Manual Mode
				command_once("B742/command/AP_A_engage_up") -- Command Mode
			elseif AP_ENGAGED == 2 then
				command_once("B742/command/AP_A_engage_down") -- Manual Mode
				command_once("B742/command/AP_A_engage_down") -- Off
			end
]]
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
		--[[	--We can use this for standard single landing light:
				--command_once("sim/lights/landing_lights_toggle")
				-- Or for aircraft with multiple landing light toggles. Lua is fine casting ints and strs in Print (...)
				for i = 1, 9 do
					command_once("sim/lights/landing_0" .. i .. "_light_tog")
				end
				for i = 10, 16 do
					command_once("sim/lights/landing_" .. i .. "_light_tog")
				end
		]]
				-- The Felis B742 does not have standard landing light commands. We must use writable datarefs.
				-- For these DataRefs: 0 is Off, 1 is On
				-- Would be nice to try these in a Lua table?
				-- Modern FlyWithLua 2.3 way of doing things; do not use Set
--[[
				DataRef("Inbd_Left","B742/ext_light/landing_inbd_L_sw","writable")
				DataRef("Inbd_Right","B742/ext_light/landing_inbd_R_sw","writable")
				DataRef("Outbd_Left","B742/ext_light/landing_outbd_L_sw","writable")
				DataRef("Outbd_Right","B742/ext_light/landing_outbd_R_sw","writable")

				if Inbd_Left == 0 and Outbd_Left == 0 then
					Inbd_Left = 1
					Inbd_Right = 1
					Outbd_Left = 1
					Outbd_Right = 1
				elseif Inbd_Left == 1 and Outbd_Left == 1 then
					Inbd_Left = 0
					Inbd_Right = 0
					Outbd_Left = 0
					Outbd_Right = 0
				end
]]
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
					-- EFB but this doesn't quite work.
					set_pilots_head(-0.192615,5.761881,-26.331472,292.994873,-21.840799)
				else
					-- Glareshield
					set_pilots_head(-0.006319,5.692539,-26.430994,0.0,-34.339977)
				end
				MULTI_SIXPACK_PRESSED = true
			elseif sp2_pressed and not MULTI_SIXPACK_PRESSED then
				-- Radios, Radar, EPR
				set_pilots_head(0.004310,5.604949,-26.181566,0.1875,-85.935745)
				MULTI_SIXPACK_PRESSED = true
			elseif sp3_pressed and not MULTI_SIXPACK_PRESSED then
				-- FMS
				set_pilots_head(-0.257584,5.381901,-26.629328,15.519982,-52.581673)
				MULTI_SIXPACK_PRESSED = true
			elseif sp4_pressed and not MULTI_SIXPACK_PRESSED then
				-- Overhead panel
				set_pilots_head(-0.001256,5.326951,-26.096092,359.625,65.174461)
				MULTI_SIXPACK_PRESSED = true
			elseif sp5_pressed and not MULTI_SIXPACK_PRESSED then
				-- FE upper
				set_pilots_head(-0.178310,5.691501,-25.147821,89.836227,14.740208)
				MULTI_SIXPACK_PRESSED = true
			elseif sp6_pressed and not MULTI_SIXPACK_PRESSED then
				-- FE lower
				set_pilots_head(-0.178310,5.691501,-25.147821,90.398727,-13.926468)
				MULTI_SIXPACK_PRESSED = true
			end
			
			STILL_PRESSED = true
		end
				

-- DPAD_up mode
		if dpad_up_pressed then
			if not STILL_PRESSED then
				set_button_assignment(RIGHT_BUMPER,"1-sim/command/togaLeftButton_button") -- there's only a toggle (Will investigate later)
				set_button_assignment(WHEEL_UP,"sim/flight_controls/flaps_up")
				set_button_assignment(WHEEL_DOWN,"sim/flight_controls/flaps_down")
				set_button_assignment(POV_LEFT,"sim/view/glance_left")
				set_button_assignment(POV_RIGHT,"sim/view/glance_right")
				set_button_assignment(POV_UP,"sim/view/straight_up")
				set_button_assignment(POV_DOWN,"sim/view/straight_down")
		
				set_button_assignment(DPAD_LEFT,"sim/none/none")
				set_button_assignment(DPAD_RIGHT,"sim/none/none")
			end
			
			-- logic is off, does not work, gotta fix this...
			if dpad_left_pressed then
				-- Pilot's seat
				set_pilots_head(-0.497226,5.741722,-26.197409,0.0,-12.625139)

			elseif dpad_right_pressed then
				-- Copilot's seat
				set_pilots_head(0.541737,5.741722,-26.197409,0.0,-12.625139)


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