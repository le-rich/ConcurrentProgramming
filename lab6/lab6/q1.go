package main

import (
	"fmt"
	"bufio"
	"log"
	"os"
	"strings"
	"strconv"
	"sort"
)

type Record struct {
	firstName, lastName string
	score int
}

func newRecord(firstname string, lastname string, score int) *Record {
	r := new(Record)
	r.firstName = firstname
	r.lastName = lastname
	r.score = score
	return r
}

func createStudentFromLine(line string) *Record {
	data := strings.Split(line, "#")
	split := strings.Split(data[0], " ")
	score, _ := strconv.Atoi(split[2])
	r := newRecord(split[0], split[1], score)
	return r
}


func main(){
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter The file path: ")
	text, _ := reader.ReadString('\n')
	text = strings.Replace(text, "\n", "", -1)
	file, err := os.Open(text)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var recs []*Record
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		recs = append(recs, createStudentFromLine(scanner.Text()))
		fmt.Println(scanner.Text())
	}

	sort.SliceStable(recs, func(i, j int) bool {
		if (recs[i].score == recs[j].score && recs[i].lastName == recs[j].lastName){	
			return recs[i].firstName < recs[j].firstName
		} else if (recs[i].score == recs[j].score){
			return recs[i].lastName < recs[j].lastName
		}

		return recs[i].score > recs[j].score
	})

	for _, rec := range recs {
		fmt.Println(*rec)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
