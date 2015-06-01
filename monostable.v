/* Copyright (c) 2015, William Breathitt Gray
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
module monostable(
        input clk,
        input reset,
        input trigger,
        output reg pulse = 0
);
        parameter PULSE_WIDTH = 0;

        reg [4:0] count = 0;

        wire count_rst = reset | (count == PULSE_WIDTH);

        always @ (posedge trigger, posedge count_rst) begin
                if (count_rst) begin
                        pulse <= 1'b0;
                end else begin
                        pulse <= 1'b1;
                end
        end

        always @ (posedge clk, posedge count_rst) begin
                if(count_rst) begin
                        count <= 0;
                end else begin
                        if(pulse) begin
                                count <= count + 1'b1;
                        end
                end
        end
endmodule

module delayed_monostable(
        input clk,
        input reset,
        input trigger,
        output pulse
);
        parameter DELAY_WIDTH = 0;
        parameter SIGNAL_WIDTH = 0;

        wire dly;
        monostable #(.PULSE_WIDTH(DELAY_WIDTH)) delay(
                .clk(clk),
                .reset(reset),
                .trigger(trigger),
                .pulse(dly)
        );
        wire trig = ~dly;
        monostable #(.PULSE_WIDTH(SIGNAL_WIDTH)) signal(
                .clk(clk),
                .reset(reset),
                .trigger(trig),
                .pulse(pulse)
        );
endmodule
