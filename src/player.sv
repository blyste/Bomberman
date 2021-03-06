module player(input logic                clk,
              input logic signed [10:0] spotX,
              input logic signed [10:0] spotY,
              input logic [9:0]         playerX,
              input logic [9:0]         playerY,
              input logic [2:0]         sprite_num,
		      output logic [7:0]        player_color,
              input logic [2:0]         state
              );

   parameter player_num = 1;

   // ROM qui contient les pixels des 8 sprites (64x64 pixels)
   logic [7:0]                           rom[0:8*1024-1];
   logic [12:0]                          rom_addr;
   logic [7:0]                           color_pixel;
   logic [4:0]                           offsetX, offsetY;

   assign offsetX = spotX - playerX+1;
   assign offsetY = spotY - playerY;
   assign rom_addr = {sprite_num, offsetY, offsetX};

   always @(posedge clk)
     color_pixel <= rom[rom_addr];

   initial
     if (player_num==1)
       $readmemh("../sprites/player1.lst", rom);
     else
       $readmemh("../sprites/player2.lst", rom);

   // On n'affiche le contenu de la ROM que si le spot est dans le
   // rectangle du sprite
   always @(*)
     begin
        player_color <= 8'd137;
        if ((spotX>=playerX) && (spotX<(playerX+32)) &&
            (spotY>=playerY) && (spotY<(playerY+32)))
          if (color_pixel != 8'd137)
	        player_color <= color_pixel ^ {state, state};
     end

endmodule // player


























