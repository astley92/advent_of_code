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
	niceCount := 0
	for _, line := range strings.Split(input, "\n") {
		if isNiceString(line) { niceCount += 1 }
	}
	return niceCount
}

func isNiceString(s string) bool {
	vowels := "aeiou"
	var invalids = []string{"ab", "cd", "pq", "xy"}

	// Quick invalid check
	for _, subs := range invalids {
		if strings.Contains(s, subs) {
			return false
		}
	}

	// Check for 3 vowels and a duplicate
	vowelCount := 0
	containsDup := false

	for _, char := range strings.Split(s, "") {
		if strings.Contains(vowels, char) {
			vowelCount += 1
		}

		dupString := fmt.Sprintf("%v%v", char, char)
		if strings.Contains(s, dupString) {
			containsDup = true
		}
	}
	if vowelCount < 3 || !containsDup {
		return false
	}

	return true
}

func partTwo(input string) int {
	niceCount := 0
	for _, line := range strings.Split(input, "\n") {
		if isReallyNiceString(line) { niceCount += 1 }
	}
	return niceCount
}

func isReallyNiceString(s string) bool {
	// Check for a pair of letters that appears twice
	recurringPair := false
	for i := 0; i < len(s) - 3; i++ {
		char := s[i]
		nextChar := s[i+1]
		pair := fmt.Sprintf("%c%c", char, nextChar)
		subString := s[i+2:]
		if strings.Contains(subString, pair) {
			recurringPair = true
			break
		}
	}

	// Check for recurring char with random char in between
	recurringChar := false
	for i := 0; i < len(s) - 2; i++ {
		char := s[i]
		if s[i+2] == char {
			recurringChar = true
			break
		}
	}

	return recurringChar && recurringPair
}

func getInput() string {
	body, err := ioutil.ReadFile(
		"/Users/blakeastley/Projects/advent_of_code/go/2015/day_5/input.txt",
	)
	if err != nil {
		log.Fatal(err)
	}
	return strings.TrimRight(string(body), "\n")
}
