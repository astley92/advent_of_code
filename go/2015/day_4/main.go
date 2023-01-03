package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strings"
)

func main() {
	println(partOne("ckczppom"))
	println(partTwo("ckczppom"))
}

func partOne(input string) int {
	for i := 0; i < 2_000_000; i++ {
		newString := fmt.Sprintf("%v%v", input, i)
		hash := md5.Sum([]byte(newString))
		hashString := hex.EncodeToString(hash[:])
		if strings.HasPrefix(hashString, "00000") {
			println(newString)
			return i
		}
	}
	return -1
}

func partTwo(input string) int {
	for i := 0; i < 200_000_000; i++ {
		newString := fmt.Sprintf("%v%v", input, i)
		hash := md5.Sum([]byte(newString))
		hashString := hex.EncodeToString(hash[:])
		if strings.HasPrefix(hashString, "000000") {
			println(newString)
			return i
		}
	}
	return -1
}
