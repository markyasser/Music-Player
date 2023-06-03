import "./navbar.css";
import "./card.css";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faHeart } from '@fortawesome/free-solid-svg-icons';
function Card() {
  return (
    <div className="card">
      <img src="https://via.placeholder.com/150x150" alt=" img" className="card__image"/>
      <div className="card__content">
        <h2 className="card__title">Card Title</h2>
        <p className="card__likes">100 Likes</p>
        <button className="card__like-button"><FontAwesomeIcon icon={faHeart} /></button>
      </div>
    </div>
  );
}

function App() {
  return (
    <div className="App">
      <nav className="navbar">
        <div className="navbar__title">iMusic</div>
        <div className="navbar__buttons">
          <button className="navbar__login">Login</button>
          <button className="navbar__button">Sign Up</button>
        </div>
      </nav>

      <Card />
      <Card />
      <Card />
    </div>
  );
}

export default App;