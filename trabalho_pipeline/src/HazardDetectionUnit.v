module HazardDetectionUnit (
    input [4:0] idex_rs1,
    input [4:0] idex_rs2,
    input [4:0] exmem_rd,

    input [6:0] idex_op,
    input [6:0] exmem_op,

    output reg stall
);

    localparam LW    = 7'b000_0011;
    localparam SW    = 7'b010_0011;
    localparam BEQ   = 7'b110_0011;
    localparam ALUop = 7'b001_0011;

    always @(*) begin
        stall = 1'b0;

        // Load-use hazard:
        // Se a instrução no estágio EX/MEM for um LOAD (LW) e a instrução no estágio ID/EX
        // usar o registrador de destino do LOAD como operando, o pipeline deve estagnar (stall) por um ciclo.
        // Isso ocorre porque o dado do LOAD só está disponível no final do estágio MEM.
        
        if (exmem_op == LW) begin
            // Verifica se a instrução atual (em ID/EX) usa o registrador que o LW está carregando
            if ((idex_rs1 == exmem_rd && idex_rs1 != 5'd0) || 
                (idex_rs2 == exmem_rd && idex_rs2 != 5'd0)) begin
                stall = 1'b1;
            end
        end
    end

endmodule
