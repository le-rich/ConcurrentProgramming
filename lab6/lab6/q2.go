package main

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
)

func sieve(size int) []bool {
	s := make([]bool, size)
	for i := 2; i < size; i++ {
		s[i] = true
	}

	for i := 2; i * i < size; i++ {
		if s[i] {
			for j := i * i; j < size; j += i {
				s[j] = false
			}
		}
	}

	return s
}

func getPermKey(val int) string {
	str := strconv.Itoa(val)
	var result []string
	for _, char := range str {
		result = append(result, string(char))
	}
	sort.Strings(result)
	return strings.Join(result, "");
}

func createPrimePermMap(primes []bool) map[string][]int {
	m := make(map[string][]int)
	for idx, val := range primes {
		if (val && idx > 1000000){
			key := getPermKey(idx)
			m[key] = append(m[key], idx)
		}
	}
	
	return m
}

func main() {
	s := sieve(9999999)
	m := createPrimePermMap(s)

	max := 0
	for _, element := range m {
		if len(element) > max {
			max = len(element)
		}
	}	
	fmt.Println("Largest set of 7 digit primes: " + strconv.Itoa(max))
}
