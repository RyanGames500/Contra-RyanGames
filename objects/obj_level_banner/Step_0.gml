timer++;

switch(state) {
    case "entrada":
        alpha = lerp(alpha, 1, 0.1);
        x_offset = lerp(x_offset, 0, 0.1);
        if (timer > 120) state = "salida"; // Se queda 2 segundos y se va
    break;
    
    case "salida":
        alpha = lerp(alpha, 0, 0.1);
        x_offset = lerp(x_offset, -100, 0.1); // Se va hacia la izquierda
        if (alpha < 0.05) instance_destroy();
    break;
}