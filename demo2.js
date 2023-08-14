var express = require("express");
var app = express();
const port = process.env.PORT || 5001;

app.get("/", (req, res) => {
  res.send("ok");
});

app.get("/services/service-1", (req, res) => {
  res.send("this is just a service");
});

app.get("/services/service-1/status", (req, res) => {
  res.send("this is just a service 2515");
});

app.listen(port, () => {
  console.log(`example of this is a use http://localhost:${port}`);
});
