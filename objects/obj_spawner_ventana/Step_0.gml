if (!activado && instance_exists(obj_player)) {
    // Si el jugador está cerca en el eje X
    if (abs(obj_player.x - x) < rango_activacion) {
        var _nene = instance_create_layer(x, y, "Instances", obj_enemy_aereo);
        _nene.state = "aparicion"; // Le damos un estado especial de entrada
        activado = true;
    }
}