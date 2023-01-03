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
	lights := buildLightArray()

	for _, instrLine := range strings.Split(input, "\n"){
		xRange, yRange := buildRanges(instrLine)

		if strings.HasPrefix(instrLine, "toggle") {
			lights = toggleLights(lights, xRange[:], yRange[:])
		} else if strings.HasPrefix(instrLine, "turn on") {
			lights = turnOnLights(lights, xRange[:], yRange[:])
		} else if strings.HasPrefix(instrLine, "turn off") {
			lights = turnOffLights(lights, xRange[:], yRange[:])
		} else {
			log.Fatal("Unkown command: ", instrLine)
		}
	}

	return countOnLights(lights)
}

func partTwo(input string) int {
	lights := buildLightArray()

	for _, instrLine := range strings.Split(input, "\n"){
		xRange, yRange := buildRanges(instrLine)

		if strings.HasPrefix(instrLine, "toggle") {
			lights = adjustLights(lights, 2, xRange[:], yRange[:])
			} else if strings.HasPrefix(instrLine, "turn on") {
			lights = adjustLights(lights, 1, xRange[:], yRange[:])
			} else if strings.HasPrefix(instrLine, "turn off") {
			lights = adjustLights(lights, -1, xRange[:], yRange[:])
		} else {
			log.Fatal("Unkown command: ", instrLine)
		}
	}

	return sumLightBrightness(lights)
}

func getInput() string {
	body, err := ioutil.ReadFile(
		"/Users/blakeastley/Projects/advent_of_code/go/2015/day_6/input.txt",
	)
	if err != nil {
		log.Fatal(err)
	}
	return strings.TrimRight(string(body), "\n")
}


func buildLightArray() [][]int {
	size := 1000
	lights := make([][]int, size)
	for i := 0; i < size; i++ {

		lightRow := make([]int, size)
		for j := 0; j < size; j++{
			lightRow[j] = 0
		}
		lights[i] = lightRow
	}
	return lights
}

func convertStringToInt(s string) int {
	num, err := strconv.Atoi(s)
	if err != nil {
		log.Fatal(err)
	}
	return num
}

func countOnLights(lights [][]int) int {
	onCount := 0
	for _, row := range lights {
		for _, val := range row {
			if val == 1 {
				onCount += 1
			}
		}
	}
	return onCount
}

func sumLightBrightness(lights [][]int) int {
	sum := 0
	for _, row := range lights {
		for _, val := range row {
			sum += val
		}
	}
	return sum
}

func toggleLights(lights [][]int, xRange []int, yRange []int) [][]int {
	for y, row := range lights {
		for x, val := range row {
			if (y > yRange[1]) || (y < yRange[0]) || (x < xRange[0]) || (x > xRange[1]) {
				continue
			}

			if val == 0 {
				lights[y][x] = 1
				} else {
				lights[y][x] = 0
			}
		}
	}
	return lights
}

func turnOnLights(lights [][]int, xRange []int, yRange []int) [][]int {
	for y, row := range lights {
		for x := range row {
			if (y > yRange[1]) || (y < yRange[0]) || (x < xRange[0]) || (x > xRange[1]) {
				continue
			}

			lights[y][x] = 1
		}
	}
	return lights
}

func adjustLights(lights [][]int, val int, xRange []int, yRange []int) [][]int {
	for y, row := range lights {
		for x := range row {
			if (y > yRange[1]) || (y < yRange[0]) || (x < xRange[0]) || (x > xRange[1]) {
				continue
			}

			lights[y][x] += val

			if lights[y][x] < 0 {
				lights[y][x] = 0
			}
		}
	}
	return lights
}

func turnOffLights(lights [][]int, xRange []int, yRange []int) [][]int {
	for y, row := range lights {
		for x := range row {
			if (y > yRange[1]) || (y < yRange[0]) || (x < xRange[0]) || (x > xRange[1]) {
				continue
			}

			lights[y][x] = 0
		}
	}
	return lights
}

func buildRanges(instrLine string) ([2]int, [2]int) {
	words := strings.Split(instrLine, " ")
	fromStrings := words[len(words) - 3]
	toStrings := words[len(words) - 1]

	fromCoords := strings.Split(fromStrings, ",")
	toCoords := strings.Split(toStrings, ",")

	xRange := [2]int{
		convertStringToInt(fromCoords[0]),
		convertStringToInt(toCoords[0]),
	}
	yRange := [2]int{
		convertStringToInt(fromCoords[1]),
		convertStringToInt(toCoords[1]),
	}

	sort.Ints(xRange[:])
	sort.Ints(yRange[:])

	return xRange, yRange
}
