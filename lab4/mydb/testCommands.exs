Mydb.WorkerSupervisor.start_db("test1")
Mydb.WorkerSupervisor.stop_db("test1")

Mydb.WorkerSupervisor.start_db("test1")
Mydb.WorkerSupervisor.start_db("test2")

Mydb.Worker.store("test1", "hello", "world")
Mydb.Worker.store("test2", "goodbye", "galaxy")
Mydb.Worker.store("test2", "Ayaya", "world")
Mydb.Worker.store("test2", "testing", "world") 

Mydb.Worker.find("test1", "hello")
Mydb.Worker.match("test1", "world")
Mydb.Worker.match("test2", "world")


