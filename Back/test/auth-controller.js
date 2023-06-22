require("dotenv").config();
const expect = require("chai").expect;
const sinon = require("sinon");
const User = require("../models/user");
const mongoose = require("mongoose");
const AuthController = require("../controllers/auth");

describe("Auth Controller - Login", function () {
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

  // beforeEach(function () {}); // called before each test
  // afterEach(function () {});  // called after each test

  it("should throw error with code 500 if accessing DB fails", function (done) {
    sinon.stub(User, "findOne");
    User.findOne.throws();

    const req = {
      body: {
        name: "test",
        password: "tester",
      },
    };

    AuthController.login(req, {}, () => {}).then((result) => {
      expect(result).to.be.an("error");
      expect(result).to.have.property("statusCode", 500);
      done();
    });

    User.findOne.restore();
  });

  it("should return status code 200 if user id exist", function (done) {
    const req = {
      userId: "5c0f66b979af55031b34728a",
    };
    const res = {
      statusCode: 500,
      user: null,
      status: function (code) {
        this.statusCode = code;
        return this;
      },
      json: function (data) {
        this.user = data;
      },
    };
    AuthController.getUserData(req, res, () => {}).then((result) => {
      expect(res.statusCode).to.be.equal(200);
      expect(res.user).to.have.property("username", "test");
      done();
    });
  });

  // called after all tests
  after(function (done) {
    User.deleteMany({})
      .then(() => {
        return mongoose.disconnect();
      })
      .then(() => done());
  });
});
