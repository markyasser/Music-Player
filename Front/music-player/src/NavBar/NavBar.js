import "./navbar.css";
import { useHistory } from 'react-router-dom';

function NavBar() {
  const history = useHistory();
  function handleLoginClick() {
    history.push('/login');
  }
  function handleSignUpClick() {
    history.push('/signup');
  }
  function handleHomeClick() {
    history.push('');
  }
  return (
      <nav className="navbar">
        <div className="navbar__title" onClick={handleHomeClick}>iMusic</div>
        <div className="navbar__buttons">
          <button className="navbar__login" onClick={handleLoginClick}>Login</button>
          <button className="navbar__button" onClick={handleSignUpClick}>Sign Up</button>
        </div>
      </nav>
  );
}

export default NavBar;