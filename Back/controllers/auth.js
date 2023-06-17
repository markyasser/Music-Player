const { validationResult } = require("express-validator/check");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");

exports.signup = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const error = new Error("Validation failed.");
    error.statusCode = 422;
    error.data = errors.array();
    throw error;
  }
  const email = req.body.email;
  const name = req.body.name;
  const password = req.body.password;
  bcrypt
    .hash(password, 12)
    .then((hashedPw) => {
      const user = new User({
        email: email,
        password: hashedPw,
        name: name,
      });
      return user.save();
    })
    .then((result) => {
      const token = jwt.sign(
        {
          email: result.email,
          userId: result._id.toString(),
        },
        "somesupersecretsecret",
        { expiresIn: "30d" }
      );
      res.status(201).json({
        username: result.name,
        userId: loadedUser._id.toString(),
        likedPosts: loadedUser.likedPosts,
        token: token,
        message: "success",
      });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

exports.login = (req, res, next) => {
  const username = req.body.name;
  const password = req.body.password;
  let loadedUser;
  User.findOne({ name: { $regex: new RegExp(username, "i") } })
    .then((user) => {
      if (!user) {
        const error = new Error("A user with this email could not be found.");
        error.statusCode = 401;
        throw error;
      }
      loadedUser = user;
      return bcrypt.compare(password, user.password);
    })
    .then((isEqual) => {
      if (!isEqual) {
        const error = new Error("Wrong password!");
        error.statusCode = 401;
        throw error;
      }
      const token = jwt.sign(
        {
          email: loadedUser.email,
          userId: loadedUser._id.toString(),
        },
        "somesupersecretsecret",
        { expiresIn: "30d" }
      );
      res.status(200).json({
        username: loadedUser.name,
        userId: loadedUser._id.toString(),
        likedPosts: loadedUser.likedPosts,
        token: token,
        message: "success",
      });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

exports.getUserData = (req, res, next) => {
  User.findById(req.userId)
    .then((user) => {
      if (!user) {
        const error = new Error("Unauthorized access.");
        error.statusCode = 401;
        throw error;
      } else {
        res.status(200).json({
          username: user.name,
          userId: user._id.toString(),
          likedPosts: user.likedPosts,
          message: "success",
        });
      }
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};
