module maze (input logic         clk,
             input logic signed [10:0]  spotX,
             input logic signed [10:0]  spotY,
             output logic [9:0] wall_centerX,
             output logic [9:0] wall_centerY,
             output logic [3:0]  wall_num
             );

   // taille de la partie active, fonction de la résolution
   localparam integer           VACTIVE = 600;
   localparam integer           HACTIVE = 800;
   localparam integer           MAZEX = 25;
   localparam integer           MAZEY = 17;


   // ROM qui contient le plan du labyrinthe(25X17 --> 32x32)
   logic [3:0]                  rom[0:32*32-1];
   logic [9:0]                  rom_addr;

   // On définit les coins (en haut à gauche)des sprites à afficher
   // spotX : un numéro de carré sur 5 bits + une offset dans le carré sur 5 bits
   logic [4:0] offsetX;
   logic [4:0] num_carreX;
   logic [4:0] offsetY;
   logic [4:0] num_carreY;

   assign {num_carreX, offsetX} = spotX;
   assign {num_carreY, offsetY} = spotY;

   always @(*)
     begin
        // XXX : TODO : modier le python pour la génération du maze pour prendre
        // en compte que les lignes sont alignées sur des frontières de 32 mots.
        rom_addr <= {num_carreY, num_carreX};
     end

   // On charge le plan du jeu dans la ROM
   initial
     $readmemh("../maze/maze2.lst", rom);

   always @(posedge clk)
     // Si on est en dehors du labyrinthe, on affiche du vide
     if ((spotX > (24*32+31)) || (spotX < 0) || (spotY > (16*32+31)) || (spotY < 0))
       wall_num <= 0;
     else
       wall_num <= rom[rom_addr];

   // Génération de la position du mur sur lequel se trouve le spot
   assign wall_centerX = num_carreX*32;
   assign wall_centerY = num_carreY*32;

endmodule // maze