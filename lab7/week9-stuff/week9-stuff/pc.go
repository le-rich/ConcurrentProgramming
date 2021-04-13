package main

import (
  "fmt"
  "sync"
)

type Buffer struct {
  size, capacity int64
  m *sync.Mutex
  notEmpty, notFull *sync.Cond
}

func NewBuffer(capacity int64) *Buffer {
  b := new(Buffer)
  b.size = 0
  b.capacity = capacity
  b.m = new(sync.Mutex)
  b.notEmpty = sync.NewCond(b.m)  // a condition variable must be used with
                                  // with a mutex
  b.notFull = sync.NewCond(b.m)
  return b
}

func (b *Buffer) put() {
  b.m.Lock()
  for b.size == b.capacity {
    b.notFull.Wait()
  }
  b.size++
  fmt.Println("+")
  b.notEmpty.Signal()
  b.m.Unlock()
}

func (b *Buffer) get() {
  b.m.Lock()
  for b.size == 0 {    // must be a loop
    b.notEmpty.Wait()  // automatically unlocks associated mutex
  }
  b.size--
  fmt.Println("-")
  b.notFull.Signal()
  b.m.Unlock()
}

func produce(b *Buffer) {
  for {
    b.put()
  }
}

func consume(b *Buffer) {
  for {
    b.get()
  }
}

func main() {
  var wg sync.WaitGroup
  wg.Add(1)
  b := NewBuffer(1000)
  go produce(b)
  go produce(b)
  go consume(b)
  wg.Wait()
}
