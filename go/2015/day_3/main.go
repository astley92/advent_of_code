package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
)

func main() {
	println(partOne(getInput()))
	println(partTwo(getInput()))
}

func partOne(input string) int {
	currentPosition := []int{0,0}
	positions := map[string]int{"0,0": 1}
	dirVecs := map[string][]int{
		">": []int{1, 0},
		"<": []int{-1,0},
		"^": []int{0,-1},
		"v": []int{0, 1},
	}
	for _, char := range strings.Split(input, "") {
		dirVec := dirVecs[char]
		nextPos := []int{currentPosition[0] + dirVec[0], currentPosition[1] + dirVec[1]}
		lookupKey := fmt.Sprintf("%v,%v", nextPos[0], nextPos[1])
		currentPosition = nextPos
		val, ok := positions[lookupKey]
		if ok {
			positions[lookupKey] = val + 1
			} else {
			positions[lookupKey] = 1
		}
	}
	return len(positions)
}

func partTwo(input string) int {
	santaCurrentPosition := []int{0,0}
	roboSantaCurrentPosition := []int{0,0}
	positions := map[string]int{"0,0": 2}
	dirVecs := map[string][]int{
		">": []int{1, 0},
		"<": []int{-1,0},
		"^": []int{0,-1},
		"v": []int{0, 1},
	}
	current := "santa"

	for _, char := range strings.Split(input, "") {
		dirVec := dirVecs[char]
		var currentPosition []int
		var nextPos []int

		if current == "santa" {
			currentPosition = santaCurrentPosition
			current = "robo"
			nextPos = []int{currentPosition[0] + dirVec[0], currentPosition[1] + dirVec[1]}
			santaCurrentPosition = nextPos
		} else {
			currentPosition = roboSantaCurrentPosition
			current = "santa"
			nextPos = []int{currentPosition[0] + dirVec[0], currentPosition[1] + dirVec[1]}
			roboSantaCurrentPosition = nextPos
		}

		lookupKey := fmt.Sprintf("%v,%v", nextPos[0], nextPos[1])
		val, ok := positions[lookupKey]
		if ok {
			positions[lookupKey] = val + 1
			} else {
			positions[lookupKey] = 1
		}
	}
	return len(positions)
}

func getInput() string {
	body, err := ioutil.ReadFile(
		"/Users/blakeastley/Projects/advent_of_code/go/2015/day_3/input.txt",
	)
	if err != nil {
		log.Fatal(err)
	}
	return strings.TrimRight(string(body), "\n")
}
