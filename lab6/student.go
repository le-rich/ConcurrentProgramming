package main

import "fmt"

type Student struct {
  id, name string
  gpa float32
}

func (s Student) Print() {
  fmt.Println(s.id, s.name, s.gpa)
}

func NewStudent(id, name string, gpa float32) *Student {
  s := new(Student)
  s.id = id
  s.name = name
  s.gpa = gpa
  return s
}

func main() {
  s := Student{id: "a11111111", name: "homer", gpa: 45}
  s2 := NewStudent("a66666666", "monty", 99.9)
  s.Print()
  s2.Print()   // automatically dereferences s2
}
