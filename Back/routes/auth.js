const express = require("express");
const { body } = require("express-validator/check");

const User = require("../models/user");
const authController = require("../controllers/auth");
const isAuth = require("../middleware/is-auth");
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Auth endpoints
 */

/**
 * @swagger
 * /auth/user:
 *   get:
 *     summary: Returns the user data of the authenticated user (sending token in header)
 *     tags: [Auth]
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 username:
 *                   type: string
 *                   description: response status
 *                 userId:
 *                   type: string
 *                   description: response status
 *                 likedPosts:
 *                   type: array
 *                   description: response status
 *                   items:
 *                      type: object
 *                      properties:
 *                         _id:
 *                           type: string
 *                           description: The auto-generated id of the post
 *                         title:
 *                           type: string
 *                           description: The title of the music
 *                         content:
 *                            type: string
 *                            description: The band of the music
 *                         imageUrl:
 *                            type: string
 *                            description: The image url of the music
 *                         musicUrl:
 *                            type: string
 *                            description: The music url of the music
 *                         creatorId:
 *                            type: string
 *                            description: The user that created the music
 *                         likes:
 *                            type: number
 *                            description: The number of likes of the music
 *                         isLiked:
 *                            type: boolean
 *                            description: The boolean value of whether the user liked the music
 *                 profile:
 *                   type: string
 *                   description: response status
 *                 message:
 *                   type: string
 *                   description: response status
 *
 *
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.get("/user", isAuth, authController.getUserData);

/**
 * @swagger
 * /auth/signup:
 *   put:
 *     summary: Creates a new user
 *     tags: [Auth]
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 username:
 *                   type: string
 *                   description: response status
 *                 userId:
 *                   type: string
 *                   description: response status
 *                 likedPosts:
 *                   type: array
 *                   description: response status
 *                   items:
 *                     type: object
 *                     properties:
 *                 profile:
 *                   type: string
 *                   description: response status
 *                 message:
 *                   type: string
 *                   description: response status
 *
 *
 *       422:
 *         description: Validation failed
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.put(
  "/signup",
  [
    body("email")
      .isEmail()
      .withMessage("Please enter a valid email.")
      .custom((value, { req }) => {
        return User.findOne({ email: value }).then((userDoc) => {
          if (userDoc) {
            return Promise.reject("E-Mail address already exists!");
          }
        });
      })
      .normalizeEmail(),
    body("password").trim().isLength({ min: 5 }),
    body("name").trim().not().isEmpty(),
  ],
  authController.signup
);

router.post("/verifyOTP", authController.verifyOTP);
router.post("/resendOTPVerification", authController.resendOTPVerificationCode);
router.post("/login", authController.login);

router.patch("/profile_picture", isAuth, authController.changeProfilePicture);

module.exports = router;
