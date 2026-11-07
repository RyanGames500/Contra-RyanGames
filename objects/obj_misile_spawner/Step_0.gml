// Solo spawnea si el jugador está cerca de esta zona de rieles
if (distance_to_object(obj_player) < 400) {
    if (irandom(100) == 1) { // 1% de probabilidad por frame (ajusta para más o menos misiles)
        instance_create_layer(x + random_range(-50, 50), room_height + 50, "Instances", obj_evil_misile);
    }
}