
if os_type=os_android or os_type=os_windows{
global.inicx=display_get_width()
global.inicy=display_get_height()
}else{
global.inicx=1280//display_get_width()
global.inicy=720//display_get_height()	
	
}
global.razx=1;
aspect_ratio=global.inicx/global.inicy
window_set_size(global.inicx,global.inicy)
if aspect_ratio<(1/0.65){aspect_ratio=1/0.65}
if aspect_ratio>(1/0.45){aspect_ratio=1/0.45}
global.razx=(720*aspect_ratio)/1280; 

surface_resize(application_surface,720*aspect_ratio,720)
camera_set_view_size(view_camera[0],225*aspect_ratio,225)
device_mouse_dbclick_enable(false)

act=0;






//CONTINUES----------
// En el evento Create de oControl_resolution (o tu controlador)
global.game_over_desplegado = false; // La inicializamos en falso para que el Draw sepa que existe
global.game_mode = "single"; //coop
global.creditos = 3;
global.esperando_continue = false;
global.p2_ya_entro = false;
global.p1_lives = 3;
global.p2_lives = 3;
global.Score=0;
//Sonido
global.music=true;
global.sfx=true;

//CODIGO KONAMI
konami_code = [vk_up, vk_up, vk_down, vk_down, vk_left, vk_right, vk_left, vk_right, ord("A"), ord("Z")];
konami_index = 0; 


