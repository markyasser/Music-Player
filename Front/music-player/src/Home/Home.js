import React, { useState, useEffect } from "react";
import "./card.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-solid-svg-icons";
import { faPause } from "@fortawesome/free-solid-svg-icons";
import ProgressBar from "react-progressbar";
// import Slider from "react-slider";
// function SongBar({ title, artist, progress, image }) {
//   const [currentProgress, setCurrentProgress] = useState(progress);
//   const handleProgressBarClick = (event) => {
//     const progressBar = event.currentTarget;
//     const clickPosition =
//       event.pageX - progressBar.getBoundingClientRect().left;
//     const progressBarWidth = progressBar.offsetWidth;
//     const newProgress = (clickPosition / progressBarWidth) * 100;
//     setCurrentProgress(newProgress);
//   };
//   return (
//     <div className="song-bar">
//       <div className="song-bar__title">
//         <img src={image} alt="Song cover" className="song-bar__image" />
//         <p> {title}</p>
//       </div>

//       <div className="song-bar__progress">
//         <ProgressBar
//           completed={currentProgress}
//           color="#fff"
//           completedColor="#ff5722"
//           borderRadius="10px"
//           onClick={handleProgressBarClick}
//         />
//       </div>
//       <p className="song-bar__artist">{artist}</p>
//     </div>
//   );
// }

function Card({ postId, title, likes, image, audio }) {
  const [isLiked, setIsLiked] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const audioRef = React.createRef();
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
        setIsLiked(data.isLiked);
      });
  }
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
      audio.play();
    }

    setIsPlaying(!isPlaying);
  }

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100vh" }}>
      <div style={{ flexGrow: 1 }}>
        <div className="card" onClick={handleAudioClick}>
          <img src={image} alt=" img" className="card__image" />
          <div className="card__content">
            <h2 className="card__title">{title}</h2>
            <p className="card__likes">{likes} Likes</p>
            <button className="card__like-button" onClick={handleLikeClick}>
              <FontAwesomeIcon
                icon={faHeart}
                color={isLiked ? "red" : "black"}
              />
            </button>
          </div>
        </div>
      </div>
      <audio ref={audioRef} src={audio} onTimeUpdate={handleTimeUpdate} />
      {isPlaying && (
        // <SongBar
        //   title={title}
        //   artist={"Mark"}
        //   progress={progress}
        //   image={image}
        // />
        <div className="song-bar">
          <div className="song-bar__title">
            <img src={image} alt="Song cover" className="song-bar__image" />
            <p> {title}</p>
          </div>
          <div className="song-bar__container">
            <button
              className="song-bar__pause-button"
              onClick={handleAudioClick}
            >
              <FontAwesomeIcon icon={faPause} />
            </button>
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

function Home() {
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    fetch("http://localhost:8080/feed/posts")
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        setPosts(data.posts);
      })
      .catch((error) => console.error(error));
  }, []);

  return (
    <div>
      {posts.map((post) => (
        <Card
          postId={post._id}
          title={post.title}
          likes={post.likes}
          image={post.imageUrl}
          audio={post.musicUrl}
        />
      ))}
    </div>
  );
}

export default Home;
