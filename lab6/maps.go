package main

import "fmt"

func main() {
  var m map[string]int  // nil; can't be used to store values
  m = make(map[string]int)
  m["homer"] = 20
  m["ned"] = 90

  fmt.Println(m["ned"])
  fmt.Println(m["lisa"])

  value := m["homer"]
  fmt.Println(value)
  delete(m, "homer")
  if value, ok := m["homer"]; ok {
    fmt.Println(value)
  } else {
    fmt.Println("no more homer")
  }
  fmt.Println(len(m))

  a, b := f()
  fmt.Println(a, b)
}

// function that returns 2 values
func f() (int, int) {
  return 1, 1
}
