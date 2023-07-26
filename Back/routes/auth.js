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
 *                   description: username
 *                 userId:
 *                   type: string
 *                   description: userId
 *                 likedPosts:
 *                   type: array
 *                   description: likedPosts
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
 *     parameters:
 *       - in: formData
 *         name: email
 *         type: string
 *         required: true
 *         description: email
 *       - in: formData
 *         name: name
 *         type: string
 *         required: true
 *         description: username
 *       - in: formData
 *         name: password
 *         type: string
 *         required: true
 *         description: password
 *       - in: formData
 *         name: profile
 *         type: file
 *         required: true
 *         description: profile picture image file
 *     responses:
 *       201:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 status:
 *                   type: string
 *                   description: response status
 *                 message:
 *                   type: string
 *                   description: OTP sent successfully
 *                 data:
 *                  type: object
 *                  properties:
 *                    userId:
 *                     type: string
 *                     description: The id of the new user
 *                    email:
 *                     type: string
 *                     description: The email of the new user
 *
 *
 *       422:
 *         description: Validation failed
 *       500:
 *         description: Internal server error
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

/**
 * @swagger
 * /auth/verifyOTP:
 *   post:
 *       summary: Verify the OTP sent to the user's email
 *       tags: [Auth]
 *       parameters:
 *         - in: body
 *           type: object
 *           required: true
 *           description: email and OTP
 *           schema:
 *              type: object
 *              properties:
 *                  email:
 *                    type: string
 *                    description: user email
 *                  otp:
 *                    type: string
 *                    description: OTP sent to the user's email
 *       responses:
 *          201:
 *            content:
 *              application/json:
 *                schema:
 *                   properties:
 *                    username:
 *                      type: string
 *                      description: username
 *                    userId:
 *                      type: string
 *                      description: userId
 *                    email:
 *                      type: string
 *                      description: user email
 *                    likedPosts:
 *                      type: array
 *                      description: likedPosts (empty array initially)
 *                    profile:
 *                      type: string
 *                      description: profile picture url
 *                    token:
 *                      type: string
 *                      description: user access token
 *                    verifed:
 *                      type: boolean
 *                      description: should be true
 *                    message:
 *                      type: string
 *                      description: response status
 *
 *
 *          422:
 *            description: Validation failed
 *          500:
 *            description: Internal server error
 */
router.post("/verifyOTP", authController.verifyOTP);
router.post("/resendOTPVerification", authController.resendOTPVerificationCode);

/**
 * @swagger
 * /auth/login:
 *   post:
 *       summary: User login
 *       tags: [Auth]
 *       parameters:
 *         - in: body
 *           type: object
 *           required: true
 *           description: email and OTP
 *           properties:
 *            username:
 *              type: string
 *              description: username
 *            password:
 *              type: string
 *              description: password
 *       responses:
 *          200:
 *              content:
 *                application/json:
 *                  schema:
 *                     properties:
 *                      username:
 *                        type: string
 *                        description: username
 *                      userId:
 *                        type: string
 *                        description: userId
 *                      email:
 *                        type: string
 *                        description: user email
 *                      likedPosts:
 *                        type: array
 *                        description: likedPosts
 *                      profile:
 *                        type: string
 *                        description: profile picture url
 *                      token:
 *                        type: string
 *                        description: user access token
 *                      verifed:
 *                        type: boolean
 *                        description: should be true
 *                      message:
 *                        type: string
 *                        description: response status
 *          401:
 *            description: Wrong username or password
 *          500:
 *            description: Internal server error
 */
router.post("/login", authController.login);

/**
 * @swagger
 * /feed/post:
 *   post:
 *     summary: upload a single music record
 *     tags: [Feed]
 *     consumes:
 *       - multipart/form-data
 *     parameters:
 *       - in: formData
 *         name: image
 *         type: file
 *         required: true
 *         description: The image file for the post
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *
 *
 *       422:
 *         description: Validation failed or Missing data
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.patch("/profile_picture", isAuth, authController.changeProfilePicture);

module.exports = router;
