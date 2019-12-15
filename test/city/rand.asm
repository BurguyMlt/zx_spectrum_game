rand:   LD    A, R
rand_1: ADD   0
        LD    (rand_2 + 1), A
        ADD   A
        ADD   A
rand_2: ADD   0
        INC   A
        LD    (rand_1 + 1), A
        RET
