package main

import "fmt"

func main() {
  a := [5]int{0,1,2,3,4}

  fmt.Println(sum(a[:]))

  s := a[1:5]  // len = 5 - 1
  fmt.Println("len:", len(s), "cap:", cap(s))
  s[0] = 10  // changes a[1]

  s2 := append(s, s...)
  fmt.Println(s)
  fmt.Println(s2)
  fmt.Println(a)

  s3 := []int{3,2,7,6,8}
  for i := 0; i < len(s3); i++ {
    fmt.Println(s3[i])
  }

  s4 := make([]int, 10)
  for _, v := range s4 {
    fmt.Println(v)
  }
}

func sum(a []int) int {
  total := 0
  for i := 0; i < len(a); i++ {
    total += a[i]
  }
  return total
}
