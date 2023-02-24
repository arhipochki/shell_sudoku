#!/bin/bash

size=9
swaps=100
# BASE GRID / MAIN RULE OF SUDOKU
arr=(
    1 2 3 4 5 6 7 8 9
    2 3 4 5 6 7 8 9 1
    3 4 5 6 7 8 9 1 2
    4 5 6 7 8 9 1 2 3
    5 6 7 8 9 1 2 3 4
    6 7 8 9 1 2 3 4 5
    7 8 9 1 2 3 4 5 6
    8 9 1 2 3 4 5 6 7
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
	# COLUMNS POSISTIONS TO SWAP BETWEEN
    first_col=$(($RANDOM % $size))
    second_col=$(($RANDOM % $size))

    for ((i = 0; i < $size; i++)); do
        t=${arr[$first_col]}
        arr[$first_col]=${arr[$second_col]}
        arr[$second_col]=$t

        first_col=$(expr $first_col + $size)
        second_col=$(expr $second_col + $size)
    done

	# ARRAY WITH ROWS BEGINING POSITIONS
    first_in_row=(0 9 18 27 36 45 54 63 72)

	# ROWS POSITIONS TO SWAP BETWEEN
    first_row=${first_in_row[$(($RANDOM % $size))]}
    second_row=${first_in_row[$(($RANDOM % $size))]}

    for i in $(seq 0 $(($size - 1))); do
        t=${arr[$first_row + $i]}
        arr[$first_row + $i]=${arr[$second_row + $i]}
        arr[$second_row + $i]=$t
    done
done

echo "Generated map:"
print_arr

# AMOUNT OF ERASED CELLS
difficult=$(expr ${#arr[@]} - $(($RANDOM % 35 + 20)))

for (( i = 0; i < $difficult; i++)); do
    arr[$(($RANDOM % ${#arr[@]}))]=0
done

echo "Can you solve it?"
print_arr
