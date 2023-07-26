const express = require("express");
const { body } = require("express-validator/check");

const feedController = require("../controllers/feed");
const isAuth = require("../middleware/is-auth");

const router = express.Router();
/**
 * @swagger
 * tags:
 *   name: Feed
 *   description: Feed endpoints
 */

// GET /feed/posts
/**
 * @swagger
 * /feed/posts:
 *   get:
 *     summary: Return all music records
 *     tags: [Feed]
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 posts:
 *                   type: array
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
 *                 totalItems:
 *                   type: number
 *                   description: number of music items in the lists
 *
 *
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.get("/posts", isAuth, feedController.getPosts);

// GET /feed/get_liked
/**
 * @swagger
 * /feed/get_liked:
 *   get:
 *     summary: Return all music records liked by the user
 *     tags: [Feed]
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 posts:
 *                   type: array
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
 *                 totalItems:
 *                   type: number
 *                   description: number of music items in the lists
 *
 *
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.get("/get_liked", isAuth, feedController.getLikePosts);

/**
 * @swagger
 * /feed/post/{postId}:
 *   get:
 *     summary: Return a single music record by id
 *     tags: [Feed]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         description: The ID of the post to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 post:
 *                   type: object
 *                   properties:
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
 *
 *
 *       404:
 *         description: Post not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.get("/post/:postId", isAuth, feedController.getPost);

// POST /feed/post
/**
 * @swagger
 * /feed/post:
 *   post:
 *     summary: Upload a single music record
 *     tags: [Feed]
 *     consumes:
 *       - multipart/form-data
 *     parameters:
 *       - in: formData
 *         name: title
 *         type: string
 *         required: true
 *         description: The title of the music
 *       - in: formData
 *         name: content
 *         type: string
 *         required: true
 *         description: The name of the band
 *       - in: formData
 *         name: image
 *         type: file
 *         required: true
 *         description: The image file for the post
 *       - in: formData
 *         name: music
 *         type: file
 *         required: true
 *         description: The music file for the post
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 post:
 *                    type: object
 *                    properties:
 *                     _id:
 *                       type: string
 *                       description: The auto-generated id of the post
 *                     title:
 *                       type: string
 *                       description: The title of the music
 *                     content:
 *                        type: string
 *                        description: The band of the music
 *                     imageUrl:
 *                        type: string
 *                        description: The image url of the music
 *                     musicUrl:
 *                        type: string
 *                        description: The music url of the music
 *                     creatorId:
 *                        type: string
 *                        description: The user that created the music
 *                     likes:
 *                        type: number
 *                        description: The number of likes of the music
 *                     isLiked:
 *                        type: boolean
 *                        description: The boolean value of whether the user liked the music
 *                 creator:
 *                   type: object
 *                   properties:
 *                      _id:
 *                        type: string
 *                        description: Id of the user uploaded the music
 *                      name:
 *                        type: string
 *                        description: name of the user uploaded the music
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
router.post(
  "/post",
  isAuth,
  [
    body("title").trim().isLength({ min: 5 }),
    body("content").trim().isLength({ min: 5 }),
  ],
  feedController.createPost
);

/**
 * @swagger
 * /feed/like/{postId}:
 *   post:
 *     summary: Like a music by its id
 *     tags: [Feed]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         description: The ID of the post to like
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 posts:
 *                   type: array
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
 *                 totalItems:
 *                   type: number
 *                   description: number of music items in the lists
 *       404:
 *         description: Post not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.post("/like/:postId", isAuth, feedController.likePost);

/**
 * @swagger
 * /feed/post/{postId}:
 *   put:
 *     summary: Update an existing song by its id
 *     tags: [Feed]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         description: The ID of the post to like
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 post:
 *                    type: object
 *                    properties:
 *                     _id:
 *                       type: string
 *                       description: The auto-generated id of the post
 *                     title:
 *                       type: string
 *                       description: The title of the music
 *                     content:
 *                        type: string
 *                        description: The band of the music
 *                     imageUrl:
 *                        type: string
 *                        description: The image url of the music
 *                     musicUrl:
 *                        type: string
 *                        description: The music url of the music
 *                     creatorId:
 *                        type: string
 *                        description: The user that created the music
 *                     likes:
 *                        type: number
 *                        description: The number of likes of the music
 *                     isLiked:
 *                        type: boolean
 *                        description: The boolean value of whether the user liked the music
 *       422:
 *         description: No file picked
 *       403:
 *         description: Not authorized
 *       404:
 *         description: Post not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.put(
  "/post/:postId",
  isAuth,
  [
    body("title").trim().isLength({ min: 5 }),
    body("content").trim().isLength({ min: 5 }),
  ],
  feedController.updatePost
);

/**
 * @swagger
 * /feed/post/{postId}:
 *   delete:
 *     summary: Update an existing song by its id
 *     tags: [Feed]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         description: The ID of the post to like
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 posts:
 *                   type: array
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
 *                 totalItems:
 *                   type: number
 *                   description: number of music items in the lists
 *       403:
 *         description: Not authorized
 *       404:
 *         description: Post not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.delete("/post/:postId", isAuth, feedController.deletePost);

/**
 * @swagger
 * /feed/playlist:
 *   post:
 *     summary: Create new playlist
 *     tags: [Feed]
 *     responses:
 *       201:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 playlist:
 *                   type: array
 *                   items:
 *                      type: array
 *                      items:
 *                        type: object
 *                        properties:
 *                          _id:
 *                            type: string
 *                            description: The music id
 *
 *       403:
 *         description: Not authorized
 *       404:
 *         description: User not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.post("/playlist", isAuth, feedController.createPlaylist);

/**
 * @swagger
 * /feed/addToplaylist:
 *   post:
 *     summary: Add music to playlist
 *     tags: [Feed]
 *     parameters:
 *      - in: body
 *        name: postId
 *        required: true
 *        description: The ID of the playlist
 *        schema:
 *          type: string
 *      - in: body
 *        name: postId
 *        required: true
 *        description: The ID of the music to add into the playlist
 *        schema:
 *          type: string
 *     responses:
 *       201:
 *         content:
 *           application/json:
 *             schema:
 *                properties:
 *                 message:
 *                   type: string
 *                   description: response status
 *                 playlist:
 *                   type: array
 *                   items:
 *                      type: array
 *                      items:
 *                        type: object
 *                        properties:
 *                          _id:
 *                            type: string
 *                            description: The music id
 *
 *       403:
 *         description: Not authorized
 *       404:
 *         description: User not found
 *       401:
 *         description: Not authenticated
 *       500:
 *         description: Internal server error
 *     security:
 *      - bearerAuth: []
 */
router.post("/addToplaylist", isAuth, feedController.addItemToPlaylist);
router.get("/playlists", isAuth, feedController.getPlaylists);
router.get("/playlist/:playlistId", isAuth, feedController.getPlaylistById);

module.exports = router;
