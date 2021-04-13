package main

import (
  "fmt"
)

type Mutex chan bool

func NewMutex() Mutex {
  m := make(chan bool, 1)
  m <- true
  return m
}

func (m Mutex) Lock() {
  <-m
}

func (m Mutex) Unlock() {
  m <- true
}

func inc(count *int, m Mutex, start, done chan bool) {
  <-start  // block until main closes start
  for i := 0; i < 1000000; i++ {
    m.Lock()
    (*count)++
    m.Unlock()
  }
  done <- true
}

func main() {
  var count int = 0
  m := NewMutex()
  done := make(chan bool, 2)
  start := make(chan bool)  // for coordinating start of goroutines
  go inc(&count, m, start, done)
  go inc(&count, m, start, done)
  close(start)   // signal goroutines to start
  _, _ = <-done, <-done
  fmt.Println(count)
}
