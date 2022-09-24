def apply_boolfunction(boolfunction, A, B):
    result = {
        0 : lambda x, y: ~x,
        1 : lambda x, y: ~(x & y),
        2 : lambda x, y: (~x) | y,
        3 : lambda x, y: ~0,
        4 : lambda x, y: ~(x | y),
        5 : lambda x, y: ~y,
        6 : lambda x, y: ~x^y,
        7 : lambda x, y: x & (~y),
        8 : lambda x, y: (~x) & y,
        9 : lambda x, y: x^y,
        10 : lambda x, y: y,
        11 : lambda x, y: x | y,
        12 : lambda x, y: 0,
        13 : lambda x, y: x & (~y),
        14 : lambda x, y: x & y,
        15 : lambda x, y: x
    }[boolfunction](A,B)
    return result

f = open("expected.txt", "w")

# M = 0
for C_in in range(2):
    for S in range(16):
        S = (S ^ 0b0011) # shuffle function selection for arithmetic mode
        for A in range(16):
            A = ~A & 0b1111 # active-low logic, A_L -> A_H
            for B in range(16):
                B = ~B & 0b1111 # active-low logic, B_L -> B_H
                F_L = ~(A + apply_boolfunction(S, A, B) + C_in) & 0b1111
                if F_L == 0b1111:
                    A_equals_B = 1
                else:
                    A_equals_B = 0
                P_i = [0] * 4
                G_i = [0] * 4
                C_i = [0] * 4
                for i in range(4):
                    P_i[i] = ((A | B) >> i) & 0b1
                    G_i[i] = ((A & B) >> i) & 0b1
                P_L = ~(P_i[0] & P_i[1] & P_i[2] & P_i[3]) & 0b1
                G_L = ~(G_i[3]
                        | (G_i[2] & P_i[3])
                        | (G_i[1] & P_i[3] & P_i[2])
                        | (G_i[0] & P_i[3] & P_i[2] & P_i[1])
                        ) & 0b1
                C_i[0] = C_in
                for i in range(3):
                    C_i[i+1] = (G_i[i] | (P_i[i] & C_i[i])) & 0b1    
                C_out = C_i[3]
                f.write(f"{F_L:04b}" + f"{A_equals_B:01b}" + f"{P_L:01b}"
                    + f"{G_L:01b}" + f"{C_out:01b}" + "\n")

# M = 1
for C_in in range(2):
    for S in range(16): # no shuffling in logic mode
        for A in range(16):
            A = ~A & 0b1111 # active-low logic, A_L -> A_H
            for B in range(16):
                B = ~B & 0b1111 # active-low logic, B_L -> B_H
                F_L = ~(apply_boolfunction(S, A, B)) & 0b1111
                if F_L == 0b1111:
                    A_equals_B = 1
                else:
                    A_equals_B = 0
                P_i = [0] * 4
                G_i = [0] * 4
                C_i = [0] * 4
                for i in range(4):
                    P_i[i] = ((A | B) >> i) & 0b1
                    G_i[i] = ((A & B) >> i) & 0b1
                P_L = ~(P_i[0] & P_i[1] & P_i[2] & P_i[3]) & 0b1
                G_L = ~(G_i[3]
                        | (G_i[2] & P_i[3])
                        | (G_i[1] & P_i[3] & P_i[2])
                        | (G_i[0] & P_i[3] & P_i[2] & P_i[1])
                        ) & 0b1
                C_i[0] = C_in
                for i in range(3):
                    C_i[i+1] = G_i[i] | (P_i[i] & C_i[i])
                C_out = C_i[3]
                f.write(f"{F_L:04b}" + f"{A_equals_B:01b}" + f"{P_L:01b}"
                    + f"{G_L:01b}" + f"{C_out:01b}" + "\n")
                
f.close()

