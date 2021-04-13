// HTTP server containing a student store
package studentsvr

import (
  "net/http"
  "encoding/json"
  "github.com/gorilla/mux"
)

type studentServer struct {
  ss  *StudentStore
}

func newStudentServer() *studentServer {
  return &studentServer{ss: newStudentStore()}
}

func NewHTTPServer(addr string) *http.Server {
  s := newStudentServer()
  r := mux.NewRouter()
  r.HandleFunc("/", s.handleRetrieve).Methods("GET")
  r.HandleFunc("/", s.handleAppend).Methods("POST")
  return &http.Server{
    Addr: addr,
    Handler: r,
  }
}

// for conversion to JSON 
type RetrieveRequest struct {
  StudentNum  int  `json:"studentnum"`
}

type RetrieveResponse struct {
  Student Student  `json:"student"`
}

func (s *studentServer) handleRetrieve(w http.ResponseWriter, r *http.Request) {
  // decode JSON request (into struct)
  var req RetrieveRequest
  err := json.NewDecoder(r.Body).Decode(&req)
  if err != nil {
    http.Error(w, err.Error(), http.StatusBadRequest)
    return
  }

  // handle request by invoking method on student store
  student, err := s.ss.Retrieve(req.StudentNum)
  if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
  }

  // convert response to JSON & send it back
  resp := RetrieveResponse{Student: student}
  err = json.NewEncoder(w).Encode(resp)
  if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
  }
}

type AppendRequest struct {
  Student Student  `json:"student"`
}

type AppendResponse struct {
  StudentNum  int  `json:"studentnum"`
}

func (s *studentServer) handleAppend(w http.ResponseWriter, r *http.Request) {
  var req AppendRequest
  err := json.NewDecoder(r.Body).Decode(&req)
  if err != nil {
    http.Error(w, err.Error(), http.StatusBadRequest)
    return
  }
  n, err := s.ss.Append(req.Student)
  if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
  }
  resp := AppendResponse{StudentNum: n}
  err = json.NewEncoder(w).Encode(resp)
  if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
  }
}

