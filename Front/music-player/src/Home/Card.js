import React, { useState, useEffect } from "react";
import "./card.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-solid-svg-icons";
import { faPause } from "@fortawesome/free-solid-svg-icons";
import ProgressBar from "react-progressbar";

function Card({ postId, title, likes, isLikedbefore, image, audio }) {
  const [isLiked, setIsLiked] = useState(isLikedbefore);
  const [likesNumber, setLikes] = useState(likes);
  const [isPlaying, setIsPlaying] = useState(false);
  const audioRef = React.createRef();
  const [likesData, setLikesData] = useState({
    likes: likes,
    isLiked: isLiked,
  });
  function handleLikeClick() {
    const token = JSON.parse(localStorage.getItem("user")).token;
    console.log("token : " + token);
    fetch(`http://localhost:8080/feed/like/${postId}`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data) {
          setLikesData({
            likes: data.result.likes,
            isLiked: data.result.isLiked,
          });
          const user = JSON.parse(localStorage.getItem("user"));
          user.likedPosts = data.result.likedPosts;
          localStorage.setItem("user", JSON.stringify(user));
        }
      });
  }
  useEffect(() => {
    setLikes(likesData.likes);
    setIsLiked(likesData.isLiked);
  }, [likesData]);
  const [progress, setProgress] = useState(0);

  const handleTimeUpdate = () => {
    const currentTime = audioRef.current.currentTime;
    const duration = audioRef.current.duration;
    const progressPercent = (currentTime / duration) * 100;
    setProgress(progressPercent);
  };
  const handleProgressBarClick = (event) => {
    const progressBar = event.currentTarget;
    const clickPosition =
      event.pageX - progressBar.getBoundingClientRect().left;
    const progressBarWidth = progressBar.offsetWidth;
    const newProgress = (clickPosition / progressBarWidth) * 100;
    audioRef.current.currentTime = newProgress;
  };

  function handleAudioClick() {
    const audio = audioRef.current;

    if (isPlaying) {
      audio.pause();
    } else {
      const audioElements = document.getElementsByTagName("audio");
      for (let i = 0; i < audioElements.length; i++) {
        if (audio !== audioElements[i]) {
          audioElements[i].pause();
          audioElements[i].currentTime = 0;
        }
      }
      audio.play();
    }

    setIsPlaying(!isPlaying);
  }

  return (
    <div>
      <div>
        <div className="card">
          <img
            src={image}
            alt=" img"
            className="card__image"
            onClick={handleAudioClick}
          />
          <div className="card__content">
            <h2 className="card__title">{title}</h2>
            <p className="card__likes">{likesNumber} Likes</p>
            <FontAwesomeIcon
              className="card__like-button"
              icon={faHeart}
              color={isLiked ? "red" : "black"}
              onClick={handleLikeClick}
            />
          </div>
        </div>
      </div>
      <audio ref={audioRef} src={audio} onTimeUpdate={handleTimeUpdate} />
      {isPlaying && (
        <div className="song-bar">
          <div className="song-bar__title">
            <img src={image} alt="Song cover" className="song-bar__image" />
            <p> {title}</p>
          </div>
          <div className="song-bar__container">
            <FontAwesomeIcon
              className="song-bar__pause-button"
              icon={faPause}
              onClick={handleAudioClick}
            />
            <div className="song-bar__progress">
              <ProgressBar
                completed={progress}
                color="#fff"
                completedColor="#ff5722"
                borderRadius="10px"
                onClick={handleProgressBarClick}
              />
            </div>
          </div>
          <p className="song-bar__artist">Mark</p>
        </div>
      )}
    </div>
  );
}

export default Card;
