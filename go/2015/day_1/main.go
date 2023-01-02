package main

import (
	"io/ioutil"
)

func main() {
	println(partOne(getInput()))
	println(partTwo(getInput()))
}

func partOne(input string) int {
	var answer = 0
	for _, char := range input {
		if string(char) == "(" {
			answer += 1
			} else if string(char) == ")" {
			answer -= 1
		}
	}
	return answer
}

func partTwo(input string) int {
	var answer = 0
	for i, char := range input {
		if string(char) == "(" {
			answer += 1
			} else if string(char) == ")" {
			answer -= 1
		}

		if answer < 0 {
			return i + 1
		}
	}
	panic("Uh Oh")
}


func getInput() string {
	body, err := ioutil.ReadFile("/Users/blakeastley/Projects/advent_of_code/go/2015/day_1/input.txt")
	if err != nil {
		panic(err)
	}
	return string(body)
}
