package main

import (
	"fmt"
	"sync"
	"strconv"
)

type State struct {
	m *sync.Mutex
	numPQ, numR int
	pqLess *sync.Cond
}

var wg sync.WaitGroup

func NewState() *State {
	s := new(State)
  s.m = new(sync.Mutex)
	s.numPQ = 0
	s.numR = 0
	s.pqLess = sync.NewCond(s.m)
	return s
}

func produceP(s *State){
		s.m.Lock()
		fmt.Print("P")
		s.numPQ++
		if s.numPQ > s.numR {
			s.pqLess.Signal()
		}
		s.m.Unlock()
}

func produceQ(s *State){
		s.m.Lock()
		fmt.Print("Q")
		s.numPQ++ 
		if s.numPQ > s.numR {
			s.pqLess.Signal()
		}
		s.m.Unlock()
}

func produceR(s *State){
		s.m.Lock()
		for s.numR >= s.numPQ {
			s.pqLess.Wait()
		}		
		fmt.Print("R")
		s.numR++
		if (s.numR > s.numPQ){
			fmt.Println("")
			fmt.Println("")
			fmt.Println("ERROR!!!!!!!!!!!")
		}
		s.m.Unlock()
}

func putP(s *State){
	for { 
		produceP(s)
	}
}

func putQ(s *State){
	for { 
		produceQ(s)
	}
}

func putR(s *State){
	for { 
		produceR(s)
	}
}

func main(){
	wg.Add(1)
	s := NewState()
	go putP(s)
	go putQ(s)
	go putR(s)	
	wg.Wait()
	fmt.Println("")
	fmt.Println("PQ: " + strconv.Itoa(s.numPQ))
	fmt.Println("R: " + strconv.Itoa(s.numR))
}
