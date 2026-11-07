// 1. SEGUIMIENTO (Asegúrate de que el offset y + 35 sea el correcto para tu sprite)
if (instance_exists(owner)) {
    x = owner.x;
    y = owner.y + 7; 
} else { instance_destroy(); exit; }
if(owner.hp<=0){state="muerto";}
// 2. DETECCIÓN DE BRAZOS (Simplificada)
// Contamos cuántos brazos NO están muertos
var _brazos_vivos = 0;
with(obj_boss_arm) {
    if (state != "muerto") _brazos_vivos++;
}

// 3. MÁQUINA DE ESTADOS DEL OJO
    timer_ojo++;
    switch(estado_ojo) {
        case "cerrado":
            puedo_recibir_danio = false;
            image_index = 0; 
            if (timer_ojo > 60) { // Ahora solo espera 1 segundo (60 frames)
                estado_ojo = "abriendo";
                timer_ojo = 0;
            }
        break;

        case "abriendo":
            image_index = 1; // Frame intermedio
            if (timer_ojo > 10) { // Abre rápido
                estado_ojo = "abierto";
                timer_ojo = 0;
            }
        break;

        case "abierto":
            puedo_recibir_danio = true;
            image_index = 2; // Ojo expuesto
            if (timer_ojo > 150) { // Se queda abierto 2 segundos
                estado_ojo = "cerrando";
                timer_ojo = 0;
            }
        break;

        case "cerrando":
            puedo_recibir_danio = false;
            image_index = 1; 
            if (timer_ojo > 10) {
                estado_ojo = "cerrado";
                timer_ojo = 0;
            }
        break;
    }


// 4. EFECTO DE DAÑO
if (hit) {
    image_blend = c_red;
    hit = false;
} else if (puedo_recibir_danio) {
    image_blend = c_white;
}

if(owner.hp<=0)
{
	estado_ojo = "cerrado";	
}