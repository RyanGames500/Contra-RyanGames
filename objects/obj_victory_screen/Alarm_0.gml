	var _banner = instance_create_layer(0, 0, "Instances", obj_level_banner);
	_banner.texto_grande = "MISSION COMPLETE";
	_banner.texto_pequeno = "PUNTAJE: " + string(global.Score);
	_banner.color_tema = c_lime; // Color verde para victoria
	
	no_screen=true;
	
	alarm[1]=90;