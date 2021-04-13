// student store
package studentsvr

import (
  "fmt"
  "sync"
)

// only exported names are encoded
type Name struct {
  First  string  `json:"first"`  // tag
  Last   string  `json:"last"`
}

type Student struct {
  Id     string  `json:"id"`
  Name   Name    `json:"name"`
  Score  int     `json:"score"`
}

type StudentStore struct {
  mut       sync.Mutex
  students  []Student
}

func (ss *StudentStore) Retrieve(n int) (Student, error) {
  ss.mut.Lock()
  defer ss.mut.Unlock()
  if n < 0 || n >= len(ss.students) {
    return Student{}, fmt.Errorf("record not found")
  }
  return ss.students[n], nil
}

func (ss *StudentStore) Append(s Student) (int, error) {
  ss.mut.Lock()
  defer ss.mut.Unlock()
  ss.students = append(ss.students, s)
  return len(ss.students) - 1, nil
}

func newStudentStore() *StudentStore {
  // return &StudentStore{}
  return new(StudentStore)
}
