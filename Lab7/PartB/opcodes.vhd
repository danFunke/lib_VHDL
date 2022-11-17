library IEEE;
use IEEE.std_logic_1164.all;

package opcodes is
    subtype opcode is std_logic_vector(15 downto 0);
    -- Data stack instructions --Forth WORDS
    constant nop: opcode := X"0000"; -- NOP
    constant dup: opcode := X"0001"; -- DUP
    constant swap: opcode := X"0002"; -- SWAP
    constant drop: opcode := X"0003"; -- DROP
    constant over: opcode := X"0004"; -- OVER
    constant rot: opcode := X"0005"; -- ROT
    constant mrot: opcode := X"0006"; -- -ROT
    constant nip: opcode := X"0007"; -- NIP
    constant tuck: opcode := X"0008"; -- TUCK
    constant rot_drop: opcode := X"0009"; -- ROT_DROP
    constant rot_drop_swap: opcode := X"000A"; -- ROT_DROP_SWAP

    -- Function Unit instructions
    constant plus: opcode := X"0010"; -- +
    constant minus: opcode := X"0011"; -- -
    constant plus1: opcode := X"0012"; -- 1+
    constant minus1: opcode := X"0013"; -- 1-
    constant invert: opcode := X"0014"; -- INVERT
    constant andd: opcode := X"0015"; -- AND
    constant orr: opcode := X"0016"; -- OR
    constant xorr: opcode := X"0017"; -- XOR
    constant twotimes: opcode := X"0018"; -- 2*
    constant u2slash: opcode := X"0019"; -- U2/
    constant twoslash: opcode := X"001A"; -- 2/
    constant rshift: opcode := X"001B"; -- RSHIFT
    constant lshift: opcode := X"001C"; -- LSHIFT
    constant mpp: opcode := X"001D"; -- mpp
    constant shldc: opcode := X"001E"; -- shldc
    constant ones: opcode := X"0020"; -- TRUE
    constant zeros: opcode := X"0021"; -- FALSE
    constant zeroequal: opcode := X"0022"; -- 0=
    constant zeroless: opcode := X"0023"; -- 0<
    constant ugt: opcode := X"0024"; -- U>
    constant ult: opcode := X"0025"; -- U<
    constant eq: opcode := X"0026"; -- =
    constant ugte: opcode := X"0027"; -- U>=
    constant ulte: opcode := X"0028"; -- U<=
    constant neq: opcode := X"0029"; -- <>
    constant gt: opcode := X"002A"; -- >
    constant lt: opcode := X"002B"; -- <
    constant gte: opcode := X"002C"; -- >=
    constant lte: opcode := X"002D"; -- <= 

    -- Return Stack, Memory Access, and I/O instructions
    constant tor: opcode := X"0030"; -- >R
    constant rfrom: opcode := X"0031"; -- R>
    constant rfetch: opcode := X"0032"; -- R@
    constant rfromdrop: opcode := X"0033"; -- R>DROP
    constant romfetch: opcode := X"0036"; -- ROM@
    constant sfetch: opcode := X"0037"; -- S@
    constant digstore: opcode := X"0038"; -- DIG!
    constant ldstore: opcode := X"0039"; -- LD!
    constant rxfetch: opcode := X"003C"; -- RX@
    constant totx: opcode := X"003D"; -- >tx

    -- Literal, Transfer, multi-cycle instructions
    constant lit: opcode := X"0100"; -- LIT
    constant jmp: opcode := X"0101"; -- ELSE, THEN
    constant jz: opcode := X"0102"; -- IF, WHILE
    constant drjne: opcode := X"0103"; -- NEXT
    constant call: opcode := X"0104"; -- :
    constant ret: opcode := X"0105"; -- ;
    constant jb0LO: opcode := X"0106"; -- waitBx
    constant jb1LO: opcode := X"0107";
    constant jb2LO: opcode := X"0108";
    constant jb3LO: opcode := X"0109";
    constant jb0HI: opcode := X"010A";
    constant jb1HI: opcode := X"010B";
    constant jb2HI: opcode := X"010C";
    constant jb3HI: opcode := X"010D";

end opcodes;