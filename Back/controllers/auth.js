const { initializeApp } = require("firebase/app");
const {
  getStorage,
  ref,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} = require("firebase/storage");

const { validationResult } = require("express-validator/check");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const sendgridTransport = require("nodemailer-sendgrid-transport");

const User = require("../models/user");

const firebaseConfig = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGING_SENDER_ID,
  appId: process.env.APP_ID,
  measurementId: process.env.MEASURMENT_ID,
};

const firebase = initializeApp(firebaseConfig);
const defaultStorage = getStorage(firebase);

const transporter = nodemailer.createTransport(
  sendgridTransport({
    auth: {
      api_key: process.env.SENDGRID_KEY,
    },
  })
);

function createUser(req, res, next, imgUrl) {
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
        profile: imgUrl,
      });
      return user.save();
    })
    .then((result) => {
      const token = jwt.sign(
        {
          email: result.email,
          userId: result._id.toString(),
        },
        process.env.SECRET_KEY,
        { expiresIn: process.env.TOKEN_EXPIRE }
      );
      transporter
        .sendMail({
          to: email,
          from: process.env.SENDGRID_SENDER,
          subject: "Signup succeeded!",
          html: "<h1>You successfully signed up!</h1>",
        })
        .then(() => {
          res.status(201).json({
            username: result.name,
            userId: result._id.toString(),
            likedPosts: result.likedPosts,
            profile: result.profile,
            token: token,
            message: "success",
          });
        });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
}

exports.signup = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const error = new Error("Validation failed.");
    error.statusCode = 422;
    error.data = errors.array();
    throw error;
  }
  // -----------Upload profile photo to Firebase-----------
  if (req.files) {
    const image = req.files["image"][0];
    const time = new Date().toISOString();
    const storageImageRef = ref(
      defaultStorage,
      `profile/${time + "-" + image.originalname}`
    );
    const imagemetaData = { contentType: image.mimetype };
    uploadBytes(storageImageRef, image.buffer, imagemetaData)
      .then((snapshot) => getDownloadURL(snapshot.ref))
      .then((imgUrl) => {
        createUser(req, res, next, imgUrl);
      });
  } else {
    createUser(req, res, next, "");
  }
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
        process.env.SECRET_KEY,
        { expiresIn: process.env.TOKEN_EXPIRE }
      );
      res.status(200).json({
        username: loadedUser.name,
        userId: loadedUser._id.toString(),
        likedPosts: loadedUser.likedPosts,
        profile: loadedUser.profile,
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
          profile: user.profile,
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
exports.changeProfilePicture = (req, res, next) => {
  User.findById(req.userId)
    .then((user) => {
      if (!user) {
        const error = new Error("Unauthorized access.");
        error.statusCode = 401;
        throw error;
      } else {
        // delete old image from firebase if exists
        if (user.profile !== "") {
          clearFile(user.profile);
        }
        return user;
      }
    })
    .then((user) => {
      // upload the new image to firebase
      const image = req.files["image"][0];
      const time = new Date().toISOString();
      const storageImageRef = ref(
        defaultStorage,
        `profile/${time + "-" + image.originalname}`
      );
      const imagemetaData = { contentType: image.mimetype };

      uploadBytes(storageImageRef, image.buffer, imagemetaData)
        .then((snapshot) => getDownloadURL(snapshot.ref))
        .then((imgUrl) => {
          user.profile = imgUrl;
          user.save();
          res.status(200).json({
            username: user.name,
            userId: user._id.toString(),
            likedPosts: user.likedPosts,
            profile: user.profile,
            message: "success",
          });
        });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

function clearFile(refPath) {
  const storageRef = ref(defaultStorage, refPath);
  return deleteObject(storageRef);
}
