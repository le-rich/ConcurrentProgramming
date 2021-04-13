package main

import (
	"fmt"
	"golang.org/x/sync/semaphore"
	"sync"
	"context"
)

type State struct {
	numP, numQ, numR int
	lock, rMore, qMore *semaphore.Weighted
}

var wg sync.WaitGroup

func NewState(ctx context.Context) *State {
	s := new(State)
	s.numP = 0
	s.numQ = 0
	s.numR = 0
	s.lock = semaphore.NewWeighted(1)
	s.rMore = semaphore.NewWeighted(1)
	s.qMore = semaphore.NewWeighted(1)
	return s
}

func (s *State) produceP(ctx context.Context){
	if s.numP < s.numR && s.numP < s.numQ {
		s.rMore.Acquire(ctx, 1)
		s.qMore.Acquire(ctx, 1)
		s.lock.Acquire(ctx, 1)
		fmt.Print("P")
		s.numP++
		s.lock.Release(1)
		s.rMore.Release(1)
		s.qMore.Release(1)
	}
}

func (s *State) produceQ(ctx context.Context){
		if s.numQ < s.numR {
			s.qMore.Acquire(ctx, 1)	
			s.lock.Acquire(ctx, 1)
			fmt.Print("Q")
			s.numQ++
			s.lock.Release(1)
			if s.numQ > s.numP && s.numQ <= s.numR {
				s.qMore.Release(1)
			} 
		}
}

func (s *State) produceR(ctx context.Context){
			s.rMore.Acquire(ctx, 1)
			s.lock.Acquire(ctx, 1)
			fmt.Print("R")
			s.numR++
			s.lock.Release(1)
			if (s.numR > s.numQ && s.numR > s.numP) {
				s.rMore.Release(1)
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
	go putR(ctx, s)
	go putQ(ctx, s)
	go putP(ctx, s)	
	wg.Wait()
}
