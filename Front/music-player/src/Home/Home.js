import { useState, useEffect } from 'react';
import "./card.css";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faHeart } from '@fortawesome/free-solid-svg-icons';

function Card({ title, image}) {
  console.log(image);
  return (
    <div className="card">
      <img src={image} alt=" img" className="card__image"/>
      <div className="card__content">
        <h2 className="card__title">{title}</h2>
        <p className="card__likes">{0} Likes</p>
        <button className="card__like-button"><FontAwesomeIcon icon={faHeart} /></button>
      </div>
    </div>
  );
}

function Home() {
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    const token = localStorage.getItem('token');

    fetch('http://localhost:8080/feed/posts', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })
      .then(response => response.json())
      .then(data => {
        console.log(data);
        setPosts(data.posts);
      })
      .catch(error => console.error(error));
  }, []);

  return (
      <div>
        {posts.map(post => <Card key={post._id} title={post.title} image={`http://localhost:8080/${post.imageUrl}`} />)}
      </div>
  );
}

export default Home;