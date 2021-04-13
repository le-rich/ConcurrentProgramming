package main

import (
  "fmt"
  "math"
)

type Shape interface {
  Area() float64
}

type Circle struct {
  x, y, r float64
}

func (c Circle) Area() float64 {  // c is a Circle; both Circle & *Circle are
                                  // Shapes
  return math.Pi * c.r * c.r
}

type Rectangle struct {
  x1, y1, x2, y2 float64
}

func (r *Rectangle) Area() float64 {  // r is a pointer to Rectangle; only
                                      // *Rectangle is a Shape
  return math.Abs((r.x1 - r.x2) * (r.y1 - r.y2))
}

func Area(shapes ...Shape) float64 {
  total := 0.0
  for _, s := range shapes {
    total += s.Area()
  }
  return total
}

func main() {
  c := Circle{1, 1, 2}

  var s Shape = c
  fmt.Println(s.Area())
  // var p *Shape = &c  // invalid because *Shape is not an interface

  var s2 Shape = &c
  fmt.Println(s2.Area())

  r := Rectangle{x1: 0, y1: 0, x2: 2, y2: 3}
  // var s3 Shape = r  // invalid
  var s3 Shape = &r
  fmt.Println(s3.Area())

  shapes := []Shape{&c, &r}
  fmt.Println(Area(shapes...))
}
