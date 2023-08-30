machine Main {
    reg pc[@pc];
    reg X0[<=];
    reg X1[<=];
    reg Y0[<=];
    reg Y1[<=];
    reg Z[<=];
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
    }

    instr jmpz X0, l: label { pc' = X0IsZero * l + (1 - X0IsZero) * (pc + 1) }
    instr jmp l: label { pc' = l }
    instr dec_CNT { CNT' = CNT - 1 }
    instr assert_zero X0 { X0IsZero = 1 }

    instr dot X0, X1, Y0, Y1 -> Z {
        Z = X0 * Y0 + X1 * Y1
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