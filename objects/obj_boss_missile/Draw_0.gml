// Si le queda menos de 1.5 segundos, parpadea en rojo
if (tiempo_de_vida < 90 && (tiempo_de_vida % 10 < 5)) {
    gpu_set_fog(true, c_red, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_self();
}