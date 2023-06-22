require("dotenv").config();
const expect = require("chai").expect;
const sinon = require("sinon");
const User = require("../models/user");
const mongoose = require("mongoose");
const FeedController = require("../controllers/feed");
const { after } = require("mocha");
const { uploadBytes } = require("firebase/storage");

describe("Feed Controller - posts", function () {
  // This hook runs before all tests
  before(function (done) {
    mongoose
      .connect(process.env.TEST_DATABASE_URL, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      })
      .then((result) => {
        const user = new User({
          name: "test",
          email: "test@test.com",
          password: "tester",
          profile: "",
          likedPosts: [],
          posts: [],
          _id: "5c0f66b979af55031b34728a",
        });
        return user.save();
      })
      .then(() => {
        done();
      });
  });

  //   it("should add a create post to the posts of the creator", function (done) {
  //     const req = {
  //       body: {
  //         title: "Test Post",
  //         content: "A Test Post",
  //         likes: 0,
  //       },
  //       files: {
  //         image:
  //           "https://cms.hugofox.com//resources/images/a0fea022-8ec7-4a37-b4e7-214846e7656f.jpg",
  //         audio:
  //           "https://cms.hugofox.com//resources/images/a0fea022-8ec7-4a37-b4e7-214846e7656f.jpg",
  //       },
  //       userId: "5c0f66b979af55031b34728a",
  //     };
  //     const res = {
  //       statusCode: 500,
  //       user: null,
  //       status: function () {
  //         return this;
  //       },
  //       json: function () {},
  //     };
  //     FeedController.createPost(req, res, () => {}).then((savedUser) => {
  //       expect(savedUser).to.have.property("posts");
  //       expect(savedUser.posts).to.have.length(1);
  //       done();
  //     });
  //   });

  // called after all tests
  after(function (done) {
    User.deleteMany({})
      .then(() => {
        return mongoose.disconnect();
      })
      .then(() => done());
  });
});
