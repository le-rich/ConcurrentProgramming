package main

import (
  "fmt"
)

type Mutex struct {
  c chan bool
}

func NewMutex() *Mutex {
  m := new(Mutex)
  m.c = make(chan bool, 1)
  m.c <- true
  return m
}

func (m *Mutex) Lock() {
  <-m.c
}

func (m *Mutex) Unlock() {
  m.c <- true
}

func inc(count *int, m *Mutex, done chan bool) {
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
  go inc(&count, m, done)
  go inc(&count, m, done)
  _, _ = <-done, <-done
  fmt.Println(count)
}
