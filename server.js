var express = require('express');
var app = express();
var fs = require("fs");

app.get('/students', function (req, res) {
   fs.readFile( __dirname + "/" + "student.json", 'utf8', function (err, data) {
      console.log( data );
      res.end( data );
   });
})

var server = app.listen(8083, function () {
   var host = server.address().address
   var port = server.address().port
   console.log("Example app listening at http://127.0.0.1:8083", host, port)
})


app.post('/students', function (req, res) {
    debugger
    // First read existing users.
    fs.readFile( __dirname + "/" + "student.json", 'utf8', function (err, data) {
       data = JSON.parse( data );
    //   data["user4"] = user["user4"];
       console.log( data );
       res.end( JSON.stringify(data));
    });
 })





