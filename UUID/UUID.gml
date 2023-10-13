/*
by		: BAHAMAGAMES / rickky
GMail	: bahamagames@gmail.com 
Discord	: rickky#1696
GitHub	: https://github.com/BahamaGames/UUID
*/

// feather ignore all

gml_pragma("global", "global.__uuid = new UUID(); global.__uuidv4 = method(global.__uuid, global.__uuid.v4);");

#macro UUIDV4				global.__uuidv4
#macro UUID_TIMEOUT			0
#macro UUID_MAX_POOL_SIZE	100

function UUID()		constructor
{
	/// Returns a v4 unique universal id string
	/// @context UUID
	/// @function v4
	static v4		= function()
	{
		if(--_pool_size <= 0) fill();
		var ___uuid	= _pool[| 0];
		ds_list_delete(_pool, 0);
		return ___uuid;
	}
	
	/// @description Generates x amount of v4 unique universal id strings appending it to internal pool list.
	/// @param {Real} n
	/// @context UUID
	/// @function fill(n)
	static fill		= function(n = UUID_MAX_POOL_SIZE)
	{
		repeat(min(UUID_MAX_POOL_SIZE - _pool_size, n))
		{
			ds_list_add(_pool, 
				string_set_byte_at(string_set_byte_at(md5_string_utf8($"{guid}{date_current_datetime()}{random(1000000)}"), 13, ord("4")), 17, ord(choose("8", "9", "a", "b")))
			);
			_pool_size++;
		}
		
		return self;
	}
	
	static cleanup	= function()
	{
		call_cancel(_time_source);
		ds_list_destroy(_pool);
	}
	
	_pool			= ds_list_create();
	_pool_size		= 0;
	_time_source	= call_later(UUID_TIMEOUT, time_source_units_seconds, function(){if(_pool_size < UUID_MAX_POOL_SIZE * .5) fill();}, true); 
	
	fill();
	
	static _init	= false;
	static guid		= "";
	
	if(!_init)
	{
		var m		= os_get_info();
		guid		= $"{m[? "guid"]}{m[? "video_adapter_subsysid"]}";
		ds_map_destroy(m);
	}
}