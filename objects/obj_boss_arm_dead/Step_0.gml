// Humo mientras cae
if (room_speed % 5 == 0) {
    //instance_create_layer(x, y, "Instances", obj_smoke);
}

// Si toca el suelo (ajusta el 500 a la altura de tu piso)
if (y >= 500) { 
    y = 500;
    vspeed = 0;
    hspeed = 0;
    gravity = 0;
    
    // Un efecto de humo al caer al suelo
    //if (alarm[0] == -1) {
    //    instance_create_layer(x, y, "Instances", obj_smoke);
    //    alarm[0] = 10; // Para que no cree mil humos
    //}
}