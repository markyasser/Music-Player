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

const UserOTPVerification = require("../models/userOTPverification");
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

const createUser = async (req, res, next, imgUrl) => {
  const email = req.body.email;
  const name = req.body.name;
  const password = req.body.password;
  try {
    const hashedPw = await bcrypt.hash(password, 12);
    const user = new User({
      email: email,
      password: hashedPw,
      name: name,
      profile: imgUrl,
    });
    const result = await user.save();
    sendOTPverification(result, res);
    // const token = jwt.sign(
    //   {
    //     email: result.email,
    //     userId: result._id.toString(),
    //   },
    //   process.env.SECRET_KEY,
    //   { expiresIn: process.env.TOKEN_EXPIRE }
    // );

    // res.status(201).json({
    //   username: result.name,
    //   userId: result._id.toString(),
    //   likedPosts: result.likedPosts,
    //   profile: result.profile,
    //   token: token,
    //   verified: false,
    //   message: "success",
    // });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

const sendOTPverification = async ({ _id, email }, res) => {
  try {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const mailOptions = {
      to: email,
      from: process.env.SENDGRID_SENDER,
      subject: "OTP Verification",
      html: `<p>Enter <b>${otp}</b> in the app to verify your identity.</p>
      <p>OTP will expire in <b>30 minutes</b> .</p>`,
    };

    const hashedOtp = await bcrypt.hash(otp, 12);
    await new UserOTPVerification({
      userId: _id,
      otp: hashedOtp,
      createdAt: Date.now(),
      expireAt: Date.now() + 30 * 60 * 1000,
    }).save();
    await transporter.sendMail(mailOptions);
    res.status(201).json({
      status: "pending",
      message: "OTP sent successfully to your email",
      data: {
        userId: _id,
        email: email,
      },
    });
  } catch (err) {
    res.status(422).json({
      status: "failed",
      message: err.message,
    });
  }
};
exports.signup = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const error = new Error("Validation failed.");
      error.statusCode = 422;
      error.data = errors.array();
      throw error;
    }
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    return next(err);
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

exports.resendOTPVerificationCode = async (req, res) => {
  try {
    let { userId, email } = req.body;
    if (!userId || !email) {
      throw new Error("Empty OTP details are not allowed");
    } else {
      await UserOTPVerification.deleteOne({ userId: userId });
      sendOTPverification({ _id: userId, email: email }, res);
    }
  } catch (err) {
    res.status(422).json({
      status: "failed",
      message: err.message,
    });
  }
};

exports.verifyOTP = async (req, res) => {
  try {
    let { userId, otp } = req.body;
    if (!userId || !otp) {
      throw new Error("Empty OTP details are not allowed");
    } else {
      const userOTPrecord = await UserOTPVerification.findOne({
        userId: userId,
      });
      if (!userOTPrecord) {
        throw new Error("userOTPrecord not found");
      } else {
        const { expireAt } = userOTPrecord;
        const hashedOtp = userOTPrecord.otp;
        if (expireAt < Date.now()) {
          await userOTPrecord.deleteOne({ userId: userId });
          throw new Error("OTP expired");
        } else {
          const validOTP = await bcrypt.compare(otp, hashedOtp);
          if (!validOTP) {
            throw new Error("Invalid OTP");
          } else {
            const user = await User.updateOne(
              { _id: userId },
              { $set: { verified: true } }
            );
            await userOTPrecord.deleteOne({ userId: userId });
            const updatedUser = await User.findById(userId);
            const token = jwt.sign(
              {
                email: updatedUser.email,
                userId: userId,
              },
              process.env.SECRET_KEY,
              { expiresIn: process.env.TOKEN_EXPIRE }
            );

            res.status(201).json({
              username: updatedUser.name,
              userId: userId,
              email: updatedUser.email,
              likedPosts: updatedUser.likedPosts,
              profile: updatedUser.profile,
              token: token,
              verified: true,
              message: "success",
            });
          }
        }
      }
    }
  } catch (err) {
    res.status(422).json({
      status: "failed",
      message: err.message,
    });
  }
};

exports.login = async (req, res, next) => {
  const username = req.body.name;
  const password = req.body.password;
  let loadedUser;
  try {
    const user = await User.findOne({
      name: { $regex: new RegExp(username, "i") },
    });

    if (!user) {
      const error = new Error("A user with this username could not be found.");
      error.statusCode = 401;
      throw error;
    }
    loadedUser = user;
    const isEqual = await bcrypt.compare(password, user.password);

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
      playlists: user.playlists,
      token: token,
      message: "success",
    });
    return;
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
    return err;
  }
};

exports.getUserData = async (req, res, next) => {
  const user = await User.findById(req.userId);
  try {
    if (!user) {
      const error = new Error("Unauthorized access.");
      error.statusCode = 401;
      throw error;
    } else {
      res.status(200).json({
        username: user.name,
        userId: user._id.toString(),
        likedPosts: user.likedPosts,
        playlists: user.playlists,
        profile: user.profile,
        message: "success",
      });
      return;
    }
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
    return err;
  }
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
