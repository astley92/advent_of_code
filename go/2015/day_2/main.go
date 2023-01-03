package main

import (
	"io/ioutil"
	"log"
	"sort"
	"strconv"
	"strings"
)

func main() {
	println(partOne(getInput()))
	println(partTwo(getInput()))
}

func partOne(input string) int {
	dimensions := parseInput(input)
	total := 0
	for _, dimension := range dimensions {
		sort.Ints(dimension)
		sum := 0

		sum += dimension[0] * dimension[1] * 2
		sum += dimension[1] * dimension[2] * 2
		sum += dimension[2] * dimension[0] * 2
		sum += dimension[0] * dimension[1]

		total += sum
	}
	return total
}

func partTwo(input string) int {
	dimensions := parseInput(input)
	total := 0
	for _, dimension := range dimensions {
		sort.Ints(dimension)
		sum := 0

		sum += (dimension[0] * 2) + (dimension[1] * 2)
		sum += dimension[0] * dimension[1] * dimension[2]

		total += sum
	}
	return total
}

func parseInput(input string) [][]int {
	dimensions := [][]int{}
	input = strings.TrimRight(input, "\n")
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		dimStrings := strings.Split(line, "x")
		dims := []int{}
		for _, dimString := range dimStrings {
			num, err := strconv.Atoi(dimString)
			if err != nil {
				log.Fatal(err)
			}

			dims = append(dims, num)
		}
		dimensions = append(dimensions, dims)
	}
	return dimensions
}

func getInput() string {
	body, err := ioutil.ReadFile("/Users/blakeastley/Projects/advent_of_code/go/2015/day_2/input.txt")
	if err != nil {
		log.Fatal(err)
	}
	return string(body)
}
