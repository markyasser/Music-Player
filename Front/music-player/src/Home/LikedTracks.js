import React, { useState, useEffect } from "react";
import "./card.css";
import Card from "./Card.js";

function LikedTracks() {
  const [posts, setPosts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const token = JSON.parse(localStorage.getItem("user")).token;

  function getPosts() {
    fetch("http://localhost:8080/feed/get_liked", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        setPosts(data.posts);
        setIsLoading(false);
      })
      .catch((error) => console.error(error));
  }
  useEffect(() => {
    console.log(posts);
    getPosts();
    // eslint-disable-next-line
  }, []);

  return (
    <div>
      <h1>Liked Tracks</h1>
      {isLoading ? (
        <p>Loading...</p>
      ) : (
        posts.map((post) => (
          <Card
            postId={post._id}
            title={post.title}
            likes={post.likes}
            isLikedbefore={post.isLiked}
            image={post.imageUrl}
            audio={post.musicUrl}
          />
        ))
      )}
    </div>
  );
}

export default LikedTracks;
