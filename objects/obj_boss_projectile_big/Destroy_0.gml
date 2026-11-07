// Explosión al chocar o salir de pantalla
repeat(10) {
    var _dir = irandom(360);
    var _dist = irandom(10);
    part_particles_create(global.ps, x + lengthdir_x(_dist, _dir), y + lengthdir_y(_dist, _dir), global.pt_smoke, 1);
}