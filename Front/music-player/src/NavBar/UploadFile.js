import React, { useState } from "react";
import "./dialog.css";

function UploadFile() {
  const [errorMessage, setErrorMessage] = useState("");
  const [audio, setAudio] = useState(null);
  const [image, setImage] = useState(null);
  const [title, setTitle] = useState("");
  const [Creator, setCreator] = useState("");

  function handleAudioSelect(event) {
    const file = event.target.files[0];
    if (file) {
      setAudio(file);
    }
  }
  function handleImageSelect(event) {
    const file = event.target.files[0];
    setImage(file);
  }

  function handleSubmit(event) {
    event.preventDefault();
    if (title === "") {
      setErrorMessage("Please enter a title");
      return;
    }
    if (Creator === "") {
      setErrorMessage("Please enter creator name");
      return;
    }
    if (!audio) {
      setErrorMessage("Please enter a valid audio file");
      return;
    }
    if (!image) {
      setErrorMessage("Please enter a valid image file");
      return;
    }
    const formData = new FormData();
    formData.append("image", image);
    formData.append("audio", audio);
    formData.append("title", title);
    formData.append("content", Creator);
    fetch("http://localhost:8080/feed/post", {
      method: "POST",
      body: formData,
      headers: {
        authorization: `Bearer ${
          JSON.parse(localStorage.getItem("user")).token
        }`,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        window.location.reload();
      })
      .catch((error) => console.error(error));
  }

  return (
    <div className="container">
      <h1>Upload Music</h1>
      <form className="modal__form" onSubmit={handleSubmit}>
        <label className="modal__label">
          Title
          <input
            className="modal__input"
            type="text"
            value={title}
            onChange={(event) => setTitle(event.target.value)}
          />
        </label>
        <label className="modal__label">
          Creator
          <input
            className="modal__input"
            type="text"
            value={Creator}
            onChange={(event) => setCreator(event.target.value)}
          />
        </label>
        <label className="modal__label">
          Image
          <input
            type="file"
            name="image"
            className="upload_buttons"
            onClick={handleImageSelect}
          />
          <p>{image ? image.path : ""}</p>
        </label>
        <label className="modal__label">
          Audio File
          <input
            type="file"
            name="audio"
            className="upload_buttons"
            onClick={handleAudioSelect}
          />
          <p>{audio ? audio.path : ""}</p>
        </label>
        <p className="err">{errorMessage}</p>
        <button className="modal__submit-button" type="submit">
          Submit
        </button>
      </form>
    </div>
  );
}

export default UploadFile;
