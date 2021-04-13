package main

import (
	"fmt"
	"golang.org/x/sync/semaphore"
	"sync"
	"time"
	"strconv"
	"context"
)

type State struct {
	numPQ, numR int
	lock, pqMore *semaphore.Weighted
}

var wg sync.WaitGroup

func NewState(ctx context.Context) *State {
	s := new(State)
	s.numPQ = 0
	s.numR = 0
	s.lock = semaphore.NewWeighted(1)
	s.pqMore = semaphore.NewWeighted(1)
	return s
}

func (s *State) produceP(ctx context.Context){
		s.pqMore.Acquire(ctx, 1)
		s.lock.Acquire(ctx, 1)
		fmt.Print("P")
		s.numPQ++
		s.lock.Release(1)
		if s.numPQ >= s.numR {
			s.pqMore.Release(1)
		}
}

func (s *State) produceQ(ctx context.Context){
		s.pqMore.Acquire(ctx, 1)
		s.lock.Acquire(ctx, 1)
		fmt.Print("Q")
		s.numPQ++
		s.lock.Release(1)
		if s.numPQ >= s.numR {
			s.pqMore.Release(1)
		} 
}

func (s *State) produceR(ctx context.Context){
		if s.pqMore.Acquire(ctx, 1) == nil && s.numPQ > s.numR{
			s.lock.Acquire(ctx, 1)
			fmt.Print("R")
			s.numR++
			s.lock.Release(1)
			s.pqMore.Release(1)
		} 
}

func putP(ctx context.Context, s *State){
	for { 
		s.produceP(ctx)
	}
}

func putQ(ctx context.Context, s *State){
	for { 
		s.produceQ(ctx)
	}
}

func putR(ctx context.Context, s *State){
	for { 
		s.produceR(ctx)
	}
}

func main(){
	wg.Add(1)
	ctx := context.TODO()
	s := NewState(ctx)
	go putP(ctx, s)
	go putQ(ctx, s)
	time.Sleep(1 * time.Second)
	go putR(ctx, s)	
	wg.Wait()
	fmt.Println("")
	fmt.Println("PQ: " + strconv.Itoa(s.numPQ))
	fmt.Println("R: " + strconv.Itoa(s.numR))
}
