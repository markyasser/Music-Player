const expect = require("chai").expect;
const authMiddleware = require("../middleware/is-auth");
const jwt = require("jsonwebtoken");
const sinon = require("sinon");

describe("Auth middleware", function () {
  it("should throw error if no authorization header is present", function () {
    const req = {
      get: function (headerName) {
        return null;
      },
    };

    expect(authMiddleware.bind(this, req, {}, () => {})).to.throw(
      "Not authenticated."
    );
  });

  it("should yeild a userId after decoding the token", function () {
    const req = {
      get: function (headerName) {
        return "Bearer asdfghjkl";
      },
    };
    sinon.stub(jwt, "verify"); // this will replace the original function with a stub (mock) function
    jwt.verify.returns({ userId: "abc" }); // returns is a sinon method that will return the value we want but it will not execute the original function

    authMiddleware(req, {}, () => {});
    expect(req).to.have.property("userId");
    // expect(req).to.have.property("userId",'abc');
    jwt.verify.restore(); // this will restore the original function
  });
});
