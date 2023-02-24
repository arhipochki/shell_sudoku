#!/bin/bash

size=9
swaps=100
col_swaps=10
row_swaps=10
square_swaps=5
# BASE GRID / MAIN RULE OF SUDOKU
arr=(
    1 2 3 4 5 6 7 8 9
    4 5 6 7 8 9 1 2 3
    7 8 9 1 2 3 4 5 6
    2 3 4 5 6 7 8 9 1
    5 6 7 8 9 1 2 3 4
    8 9 1 2 3 4 5 6 7
    3 4 5 6 7 8 9 1 2
    6 7 8 9 1 2 3 4 5
    9 1 2 3 4 5 6 7 8
)

print_arr() {
    for i in ${!arr[@]}; do
		# IF WE FILLED LINE WITH $SIZE NUMBERS MAKE NEW LINE
        if [ $(expr $i % $size) == 0 ] && [ $i != 0 ]; then
            echo ""
        fi
        echo -n ${arr[$i]} " "
    done

    echo ""    
}

for (( round = 0; round < $(($RANDOM % $swaps + 5)); round++ )); do
	# ARRAY WITH SQUARE BEGINING POSITIONS
    first_in_square=(0 3 6)

    for (( cycle = 0; cycle < $(($RANDOM % $col_swaps + 1)); cycle++ )); do
        # CHOOSE SQUARE TO SWAP IN    
        square=${first_in_square[$(($RANDOM % 3))]}

        # COLUMNS POSISTIONS TO SWAP BETWEEN
        first_col=$(( $(($RANDOM % 3)) + $square ))
        second_col=$(( $(($RANDOM % 3)) + $square ))

        for ((i = 0; i < $size; i++)); do
            t=${arr[$first_col]}
            arr[$first_col]=${arr[$second_col]}
            arr[$second_col]=$t

            first_col=$(expr $first_col + $size)
            second_col=$(expr $second_col + $size)
        done
    done

    for (( cycle = 0; cycle < $(($RANDOM % $row_swaps + 1)); cycle++ )); do
        # CHOOSE SQUARE TO SWAP IN    
        square=${first_in_square[$(($RANDOM % 3))]}

        # ROWS POSITIONS TO SWAP BETWEEN
        first_row=$(( $(($RANDOM % 3)) * $size + $square * $size ))
        second_row=$(( $(($RANDOM % 3)) * $size + $square * $size ))

        for i in $(seq 0 $(($size - 1))); do
            t=${arr[$first_row + $i]}
            arr[$first_row + $i]=${arr[$second_row + $i]}
            arr[$second_row + $i]=$t
        done
    done

    for (( cycle = 0; cycle < $(($RANDOM % $square_swaps + 1)); cycle++ )); do
        first_square=${first_in_square[$(($RANDOM % 3))]}
        second_square=${first_in_square[$(($RANDOM % 3))]}

        for i in $(seq 0 2); do
            # ROWS POSITIONS TO SWAP BETWEEN
            first_row=$(( $i * $size + $first_square * $size ))
            second_row=$(( $i * $size + $second_square * $size ))

            for j in $(seq 0 $(($size - 1))); do
                t=${arr[$first_row + $j]}
                arr[$first_row + $j]=${arr[$second_row + $j]}
                arr[$second_row + $j]=$t
            done
        done

        for i in $(seq 0 2); do
            # COLUMNS POSISTIONS TO SWAP BETWEEN
            first_col=$(( $i + $first_square ))
            second_col=$(( $i + $second_square ))

            for ((i = 0; i < $size; i++)); do
                t=${arr[$first_col]}
                arr[$first_col]=${arr[$second_col]}
                arr[$second_col]=$t

                first_col=$(expr $first_col + $size)
                second_col=$(expr $second_col + $size)
            done
        done
    done
done

echo "Generated map:"
print_arr

# AMOUNT OF ERASED CELLS
difficult=$(expr ${#arr[@]} - $(($RANDOM % 40 + 10)))

for (( i = 0; i < $difficult; i++)); do
    arr[$(($RANDOM % ${#arr[@]}))]=0
done

echo "Can you solve it?"
print_arr
