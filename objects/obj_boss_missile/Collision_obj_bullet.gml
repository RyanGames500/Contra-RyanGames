tiempo_de_vida-=200;
part_particles_create(global.ps, x, y, global.pt_spark, 10);
instance_destroy(self);