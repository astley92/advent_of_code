package main

import (
	"io/ioutil"
	"log"
	"math"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	println(partOne(getInput()))
	println(partTwo(getInput()))
}

type wire struct {
	identifier string
	instruction string
	signal int
}

func partOne(input []string) int {
	wires := []wire{}
	for _, instructionString := range input {
		instructionPieces := strings.Split(instructionString, " -> ")
		identifier := instructionPieces[len(instructionPieces)-1]
		wires = append(wires, wire{identifier: identifier, signal: -1, instruction: instructionPieces[0]})
	}

	for !isFinished(wires) {
		for i, wire := range wires {
			// Dont check wires already done
			if wire.signal >= 0 {
				continue
			}

			// Attempt to determine the signal for the current wire
			wasFound, signal := determineSignal(wire, wires)
			if wasFound {
				wires[i].signal = signal
			}
		}
	}

	return 1
}

func determineSignal(wire wire, wires []wire) (bool, int) {
	// AND
	if strings.Contains(wire.instruction, "AND") {
		valOne, valTwo := findAndVals(wire.instruction, wires)
		if (valOne < 0) || (valTwo < 0) {
			return false, -1
		}
		return true, valOne & valTwo
	}

	// OR
	if strings.Contains(wire.instruction, "OR") {
		valOne, valTwo := findOrVals(wire.instruction, wires)
		if (valOne < 0) || (valTwo < 0) {
			return false, -1
		}
		return true, valOne | valTwo
	}

	// LSHIFT
	if strings.Contains(wire.instruction, "LSHIFT") {
		val, shiftAmount := findLshiftVals(wire.instruction, wires)
		if (val < 0) {
			return false, -1
		}
		return true, val << shiftAmount
	}

	// RSHIFT
	if strings.Contains(wire.instruction, "RSHIFT") {
		val, shiftAmount := findRshiftVals(wire.instruction, wires)
		if (val < 0) {
			return false, -1
		}
		return true, val >> shiftAmount
	}

	// NOT
	if strings.Contains(wire.instruction, "NOT") {
		val := findNotVal(wire.instruction, wires)
		if (val < 0) {
			return false, -1
		}
		return true, int(math.Abs(float64(^val))) - 1
	}

	// Straight value
	words := strings.Split(wire.instruction, " ")
	if len(words) == 1 {
		match, err := regexp.MatchString(`^[0-9]+$`, words[0])
		if err != nil {
			log.Fatal(err)
		}

		if match {
			num, err := strconv.Atoi(wire.instruction)
			if err != nil {
				log.Fatal(err)
			}
			return true, num
		} else {
			println("Hey")
			identifier := words[0]
			for _, wire := range wires {
				if wire.identifier == identifier {
					return true, wire.signal
				}
			}
		}
	}
	return false, -1
}

func findNotVal(instruction string, wires []wire) int {
	identifier := strings.Split(instruction, " ")[1]
	var val int
	for _, wire := range wires {
		if wire.identifier == identifier {
			val = wire.signal
		}
	}

	return val
}

func findLshiftVals(instruction string, wires []wire) (int, int) {
	wireVals := strings.Split(instruction, " LSHIFT ")
	identifier := wireVals[0]
	var val int
	shiftAmount, err := strconv.Atoi(wireVals[1])
	if err != nil {
		log.Fatal(err)
	}

	for _, wire := range wires {
		if wire.identifier == identifier {
			val = wire.signal
		}
	}

	return val, shiftAmount
}

func findRshiftVals(instruction string, wires []wire) (int, int) {
	wireVals := strings.Split(instruction, " RSHIFT ")
	identifier := wireVals[0]
	var val int
	shiftAmount, err := strconv.Atoi(wireVals[1])
	if err != nil {
		log.Fatal(err)
	}

	for _, wire := range wires {
		if wire.identifier == identifier {
			val = wire.signal
		}
	}

	return val, shiftAmount
}

func findAndVals(instruction string, wires []wire) (int, int) {
	wireVals := strings.Split(instruction, " AND ")
	valOne := -1
	valTwo := -1
	for _, wire := range wires {
		if wire.identifier == wireVals[0] {
			valOne = wire.signal
		} else if wire.identifier == wireVals[1] {
			valTwo = wire.signal
		}
	}
	return valOne, valTwo
}

func findOrVals(instruction string, wires []wire) (int, int) {
	wireVals := strings.Split(instruction, " OR ")
	valOne := -1
	valTwo := -1
	for _, wire := range wires {
		if wire.identifier == wireVals[0] {
			valOne = wire.signal
		} else if wire.identifier == wireVals[1] {
			valTwo = wire.signal
		}
	}
	return valOne, valTwo
}

func isFinished(wires []wire) bool {
	for _, wire := range wires {
		if wire.signal < 0 {
			return false
		}
	}

	return true
}

func partTwo(input []string) int {
	return 2
}

func getInput() []string {
	body, err := ioutil.ReadFile(
		"/Users/blakeastley/Projects/advent_of_code/go/2015/day_7/input.txt",
	)
	if err != nil {
		log.Fatal(err)
	}
	return strings.Split(strings.TrimRight(string(body), "\n"), "\n")
}
