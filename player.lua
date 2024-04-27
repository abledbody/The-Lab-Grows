--[[pod_format="raw",created="2024-04-18 23:56:10",modified="2024-04-23 22:47:18",revision=1734]]
local utils = require"utils"
local animation = require"animation"

local player = {}
local walk_speed = 2.6
local run_speed = 3.8

local state = "idle"
local anim
local spr_flip = false
local frame

local queued_interact = nil

local floor_plane
local walk_loc = 214
local player_x = 214
local player_y = 0
local animation_locked = false
local animations = {}

-- Animation states

local function set_state(_state,reset_frame)
	if _state == state then return false end
	state = _state
	anim,frame = animation.play(animations[_state])
	return true
end

local function start_walk_animation()
	spr_flip = (player_x > walk_loc) or (not (player_x < walk_loc) and spr_flip)
	if player_x == walk_loc then return end
	set_state"walking"
end

local function stop_walk_animation()
	if queued_interact and queued_interact.verb == "take" then
		set_state"grab_forward"
	else
		set_state"idle"
	end
end

-- Animation callbacks --

local function play_footstep_sound()
	note(nil,1,32,nil,nil,9)
end

local function walk_frame()
	player_x = utils.move_towards(player_x,walk_loc,walk_speed)
end

local function finish_animation()
	animation_locked = false
	if player_x ~= walk_loc then
		start_walk_animation()
	else
		set_state"idle"
	end
end

local function lock_animation()
	animation_locked = true
end

local function interact_with_queued()
	if not queued_interact then return end
	queued_interact.interactable:interact(queued_interact.verb)
	queued_interact = nil
	note(nil,2,32,nil,nil,9)
end

-- Animations --

animations.idle = animation.sprite_string(0,12,0.15)

animations.walking = animation.sprite_string(12,16,0.05)
animations.walking.every_frame = walk_frame
animations.walking[1].on_enter = play_footstep_sound
animations.walking[9].on_enter = play_footstep_sound

animations.grab_forward = animation.sprite_string(28,16,0.05)
animations.grab_forward.on_enter = lock_animation
animations.grab_forward.on_end = finish_animation
animations.grab_forward[5].on_enter = interact_with_queued

anim = animation.play(animations.idle)

function player.update()
	anim(dt)
	frame = anim.anim[anim.f]
	if player_x == walk_loc and not animation_locked then
		stop_walk_animation()
	end
end

function player.draw()
	spr(frame.spr,player_x-32+(spr_flip and 8 or -8),player_y-62,spr_flip)
end

function player.set_dest(x)
	queued_interact = nil
	walk_loc = mid(floor_plane.l,x,floor_plane.r)
	if animation_locked then return end
	start_walk_animation()
end

function player.enter_room(plane,x)
	floor_plane = plane
	player_x = x
	player_y = floor_plane.y
end

function player.interact(interaction)
	local interactable_rect = interaction.interactable.rect
	if interaction.verb ~= "look" then
		player.set_dest(interactable_rect.pos[1]+interactable_rect.size[1]/2)
	end
	queued_interact = interaction
end

return player