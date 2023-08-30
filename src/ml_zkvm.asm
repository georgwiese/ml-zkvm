machine Main {
    reg pc[@pc];
    reg X0[<=];
    reg X1[<=];
    reg Y0[<=];
    reg Y1[<=];
    reg Z0[<=];
    reg Z1[<=];
    reg A0;
    reg A1;
    reg B0;
    reg B1;
    reg C0;
    reg C1;
    reg D0;
    reg D1;
    reg CNT;

    constraints {
        col witness X0Inv;
        col witness X0IsZero;
        X0IsZero  = 1 - X0 * X0Inv;
        X0IsZero * X0 = 0;
        X0IsZero * (1 - X0IsZero) = 0;

        col fixed BYTES(i) { i % 256 };
        col witness X0Byte;
        col witness X1Byte;

        X0Byte in BYTES;
        X1Byte in BYTES;

        col witness X0IsPositive;
        X0IsPositive * (1 - X0IsPositive) = 0;
        // Works for X in [-255, 256]
        X0 + 256 - 1 = X0Byte + X0IsPositive * 256;
        
        col witness X1IsPositive;
        X1IsPositive * (1 - X1IsPositive) = 0;
        X1 + 256 - 1 = X1Byte + X1IsPositive * 256;
    }

    instr jmpz X0, l: label { pc' = X0IsZero * l + (1 - X0IsZero) * (pc + 1) }
    instr jmp l: label { pc' = l }
    instr dec_CNT { CNT' = CNT - 1 }
    instr assert_zero X0 { X0IsZero = 1 }

    instr dot X0, X1, Y0, Y1 -> Z0 {
        Z0 = X0 * Y0 + X1 * Y1
    }

    instr relu X0, X1 -> Z0, Z1 {
        Z0 = X0IsPositive * X0,
        Z1 = X1IsPositive * X1
    }

    // Loads a given matrix into [[A0, A1], [B0, B1]] and right-multiplies it with [[1, 2], [3, 4]]
    function main {

        A0 <=X0= ${ ("input", 0) };
        A1 <=X0= ${ ("input", 1) };
        B0 <=X0= ${ ("input", 2) };
        B1 <=X0= ${ ("input", 3) };

        C0 <== dot(A0, A1, 1, 3);
        C1 <== dot(A0, A1, 2, 4);
        D0 <== dot(B0, B1, 1, 3);
        D1 <== dot(B0, B1, 2, 4);

        return;
    }
}