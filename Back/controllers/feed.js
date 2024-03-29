const { initializeApp } = require("firebase/app");
const {
  getStorage,
  ref,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} = require("firebase/storage");

const { validationResult } = require("express-validator/check");

const Post = require("../models/post");
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

function getPosts(req, res, next, select = {}) {
  const currentPage = req.query.page || 1;
  const userId = req.userId;
  const perPage = 8;
  let totalItems;
  Post.find(select)
    .countDocuments()
    .then((count) => {
      totalItems = count;
      return Post.find(select)
        .skip((currentPage - 1) * perPage)
        .limit(perPage);
    })
    .then((posts) => {
      const updatedPosts = posts.map((post) => {
        const isLiked = post.likers.includes(userId); // Check if the post is liked by the user
        return {
          _id: post._id,
          title: post.title,
          content: post.content,
          imageUrl: post.imageUrl,
          musicUrl: post.musicUrl,
          creatorId: post.creator,
          likes: post.likes,
          isLiked: isLiked,
        }; // Add the isLiked boolean to the post object
      });
      res.status(200).json({
        message: "Fetched posts successfully.",
        posts: updatedPosts,
        totalItems: totalItems,
      });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
}

exports.getPosts = (req, res, next) => {
  getPosts(req, res, next, {});
};
exports.getLikePosts = (req, res, next) => {
  const userId = req.userId;
  User.findById(userId).then((user) => {
    const likedPostIds = user.likedPosts; // Get the array of liked post IDs from the user object
    getPosts(req, res, next, { _id: { $in: likedPostIds } });
  });
};

exports.createPost = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const error = new Error("Validation failed, entered data is incorrect.");
    error.statusCode = 422;
    throw error;
  }
  if (!req.files) {
    const error = new Error("No image provided.");
    error.statusCode = 422;
    throw error;
  }

  // -----------Upload to Firebase-----------
  const image = req.files["image"][0];
  const audio = req.files["audio"][0];
  const time = new Date().toISOString();
  const storageImageRef = ref(
    defaultStorage,
    `images/${time + "-" + image.originalname}`
  );
  const storageAudioRef = ref(
    defaultStorage,
    `music/${time + "-" + audio.originalname}`
  );
  const imagemetaData = { contentType: image.mimetype };
  const audiometaData = { contentType: audio.mimetype };
  // Upload image file
  let musicUrl, imgUrl;

  try {
    imgUrl = await uploadBytes(
      storageImageRef,
      image.buffer,
      imagemetaData
    ).then((snapshot) => {
      return getDownloadURL(snapshot.ref);
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
  }
  try {
    // Upload audio file
    musicUrl = await uploadBytes(
      storageAudioRef,
      audio.buffer,
      audiometaData
    ).then((snapshot) => {
      return getDownloadURL(snapshot.ref);
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
  }
  const title = req.body.title;
  const content = req.body.content;
  let creator;
  try {
    const post = new Post({
      title: title,
      content: content,
      imageUrl: imgUrl,
      musicUrl: musicUrl,
      likes: 0,
      creator: req.userId,
    });
    await post.save();
    const user = await User.findById(req.userId);
    user.posts.push(post);
    const savedUser = await user.save();
    res.status(201).json({
      message: "success",
      post: {
        _id: post._id,
        title: post.title,
        content: post.content,
        imageUrl: post.imageUrl,
        musicUrl: post.musicUrl,
        likes: post.likes,
        isLiked: false,
      },
      creator: { _id: user._id, name: user.name },
    });
    return savedUser;
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

exports.getPost = (req, res, next) => {
  const postId = req.params.postId;
  Post.findById(postId)
    .then((post) => {
      if (!post) {
        const error = new Error("Could not find post.");
        error.statusCode = 404;
        throw error;
      }
      let isLiked;
      if (post.likers.includes(req.body.userId)) {
        isLiked = true;
      }
      res.status(200).json({
        message: "Post fetched.",
        post: {
          _id: post._id,
          title: post.title,
          content: post.content,
          imageUrl: post.imageUrl,
          musicUrl: post.musicUrl,
          likes: post.likes,
          isLiked: isLiked,
        },
      });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

exports.updatePost = (req, res, next) => {
  const postId = req.params.postId;
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const error = new Error("Validation failed, entered data is incorrect.");
    error.statusCode = 422;
    throw error;
  }
  const title = req.body.title;
  const content = req.body.content;
  let imageUrl = req.body.image;
  if (req.file) {
    imageUrl = req.file.path;
  }
  if (!imageUrl) {
    const error = new Error("No file picked.");
    error.statusCode = 422;
    throw error;
  }
  Post.findById(postId)
    .then((post) => {
      if (!post) {
        const error = new Error("Could not find post.");
        error.statusCode = 404;
        throw error;
      }
      if (post.creator.toString() !== req.userId) {
        const error = new Error("Not authorized!");
        error.statusCode = 403;
        throw error;
      }
      if (imageUrl !== post.imageUrl) {
        clearImage(post.imageUrl);
      }
      post.title = title;
      post.imageUrl = imageUrl;
      post.content = content;
      return post.save();
    })
    .then((result) => {
      res.status(200).json({ message: "Post updated!", post: result });
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

exports.deletePost = (req, res, next) => {
  const postId = req.params.postId;
  let deletedPost;
  Post.findById(postId)
    .then((post) => {
      if (!post) {
        const error = new Error("Could not find post.");
        error.statusCode = 404;
        throw error;
      }
      if (post.creator.toString() !== req.userId) {
        const error = new Error("Not authorized!");
        error.statusCode = 403;
        throw error;
      }
      deletedPost = post;
      return clearFile(post.musicUrl);
    })
    .then((result) => clearFile(deletedPost.imageUrl))
    .then(() => Post.findByIdAndRemove(postId))
    .then((result) => {
      return User.findById(req.userId);
    })
    .then((user) => {
      user.posts.pull(postId);
      user.likedPosts.pull(postId);
      return user.save();
    })
    .then((result) => getPosts(req, res, next, {}))
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

exports.likePost = (req, res, next) => {
  const postId = req.params.postId;
  let userId = req.userId;
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const error = new Error("Validation failed, entered data is incorrect.");
    error.statusCode = 422;
    throw error;
  }
  Post.findById(postId)
    .then((post) => {
      if (!post) {
        const error = new Error("Could not find post.");
        error.statusCode = 404;
        throw error;
      }

      let isLiked = post.likers.includes(userId);
      if (!isLiked) {
        post.likers.push(userId);
      } else {
        post.likers.pull(userId);
      }
      post.likes = isLiked ? post.likes - 1 : post.likes + 1;
      post.isLiked = !isLiked;
      post.save();
      return User.findById(userId)
        .then((user) => {
          if (!user) {
            const error = new Error("Could not find user with id = " + userId);
            error.statusCode = 404;
            throw error;
          }
          if (!isLiked) {
            user.likedPosts.push(post._id);
          } else {
            user.likedPosts.pull(post._id);
          }
          user.save();
        })
        .then(() => getPosts(req, res, next, {}));
    })
    .catch((err) => {
      if (!err.statusCode) {
        err.statusCode = 500;
      }
      next(err);
    });
};

exports.createPlaylist = async (req, res, next) => {
  const userId = req.userId;
  const playlistName = req.body.name;
  const playlist = { name: playlistName, items: [] };
  try {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error("Could not find user with id = " + userId);
      error.statusCode = 404;
      throw error;
    }
    // If there is another playlist with the same name then return error
    const playlistWithSameName = user.playlists.find(
      (playlist) => playlist.name === playlistName
    );
    if (playlistWithSameName) {
      return res.status(403).json({
        message: "This name playlist name already exists",
      });
    }
    user.playlists.push(playlist);
    user.save();
    return res.status(201).json({
      message: "success",
      playlist: playlist,
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

exports.getPlaylists = async (req, res, next) => {
  const userId = req.userId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error("Could not find user with id = " + userId);
      error.statusCode = 404;
      throw error;
    }
    res.status(200).json({
      message: "success",
      playlists: user.playlists,
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

exports.getPlaylistById = async (req, res, next) => {
  const userId = req.userId;
  const playlistId = req.params.playlistId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error("Could not find user with id = " + userId);
      error.statusCode = 404;
      throw error;
    }
    // find the playlist that has id = playlistId
    const targetPlaylist = user.playlists.find(
      (playlist) => playlist.id === playlistId
    );
    if (!targetPlaylist) {
      const error = new Error(
        "Could not find playlist with id = " + playlistId
      );
      error.statusCode = 404;
      throw error;
    }
    // get the items of the playlist
    const items = targetPlaylist.items;
    const musicList = await Post.find({ _id: { $in: items } });
    res.status(200).json({
      message: "success",
      items: musicList,
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

exports.addItemToPlaylist = async (req, res, next) => {
  const userId = req.userId;
  const playlistName = req.body.name;
  const postId = req.body.postId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error("Could not find user with id = " + userId);
      error.statusCode = 404;
      throw error;
    }
    // find the playlist that has id = playlistId and add the postId to its items
    const targetPlaylist = user.playlists.find(
      (playlist) => playlist.name === playlistName
    );
    if (!targetPlaylist) {
      const error = new Error(
        "Could not find playlist with name = " + playlistName
      );
      error.statusCode = 404;
      throw error;
    }
    targetPlaylist.items.push(postId);
    user.save();
    res.status(200).json({
      message: "success",
      playlist: targetPlaylist,
    });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};
