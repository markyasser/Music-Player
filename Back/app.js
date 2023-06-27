require("dotenv").config();

const fs = require("fs");
const path = require("path");
const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const multer = require("multer");
const helmet = require("helmet");
const morgan = require("morgan");

const feedRoutes = require("./routes/feed");
const authRoutes = require("./routes/auth");

const app = express();

app.use(bodyParser.json()); // application/json

app.use(
  multer({ storage: multer.memoryStorage() }).fields([
    { name: "image", maxCount: 1 },
    { name: "audio", maxCount: 1 },
  ])
);

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "OPTIONS, GET, POST, PUT, PATCH, DELETE"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});

const accessLogStream = fs.createWriteStream(
  path.join(__dirname, "access.log"),
  { flags: "a" }
);

app.use(helmet());
app.use(morgan("combined", { stream: accessLogStream }));

//---this is for temporary use---
let submissions = [];
app.post("/submit", (req, res, next) => {
  const name = req.body.name;
  if (submissions.includes(name)) {
    return res.status(201).json({ message: "already exist" });
  }
  submissions.push(name);
  console.log(submissions);
  res.status(201).json({ message: "success" });
});
app.delete("/remove", (req, res, next) => {
  const index = req.body.index;
  if (index < submissions.length) {
    submissions.splice(index, 1);
    console.log(submissions);
    return res.status(201).json({ message: "success" });
  }
  res.status(201).json({ message: "Error : index out of range" });
});
app.post("/clear", (req, res, next) => {
  submissions = [];
  console.log(submissions);
  return res.status(201).json({ message: "success" });
});
//------------------------------
app.use("/feed", feedRoutes);
app.use("/auth", authRoutes);

app.use((error, req, res, next) => {
  console.log(error);
  const status = error.statusCode || 500;
  const message = error.message;
  const data = error.data;
  res.status(status).json({ message: message, data: data });
});

mongoose
  .connect(process.env.DATABASE_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then((result) => {
    app.listen(process.env.PORT || 8080);
  })
  .catch((err) => console.log(err));
