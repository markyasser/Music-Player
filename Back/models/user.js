const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema({
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  profile: {
    type: String,
    default: "",
  },
  verified: {
    type: Boolean,
    default: false,
  },
  posts: [
    {
      type: Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  likedPosts: [
    {
      type: Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  playlists: [
    {
      name: String,
      items: [
        {
          type: Schema.Types.ObjectId,
          ref: "Post",
        },
      ],
    },
  ],
});

module.exports = mongoose.model("User", userSchema);
