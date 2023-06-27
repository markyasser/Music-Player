const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userOTPverificationSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
  },
  otp: String,
  createdAt: Date,
  expiredAt: Date,
});

module.exports = mongoose.model(
  "UserOTPVerification",
  userOTPverificationSchema
);
