package main

import (
  "fmt"
)

func main() {
  var a, b int = 1, 1
  n := 2
  var (
    m int
    s string
  )
  s = "hello"
  m = 42
  fmt.Println(a, b, n, s, m)
  fmt.Println("hello, world")

  // for loop
  for i := 1; i < 10; i++ {  // there is no ++i
    fmt.Println(i)
  }

  // string
  japanese := "すごい"
  for _, v := range japanese {
    fmt.Printf("%c\n", v)
  }

  fmt.Println(len(japanese))

  // array
  // var x [5]int = [5]int{3,2,7,6,8}

  arr := [...]int{3, 2, 7, 6, 8}
  fmt.Println("len:", len(arr), "cap:", cap(arr))

  for _, v := range arr {
    fmt.Printf("%d\n", v)
  }
}
