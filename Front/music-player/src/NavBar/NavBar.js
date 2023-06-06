import "./navbar.css";
import { useState } from 'react';
import { useHistory } from 'react-router-dom';

function NavBar() {
  const history = useHistory();
  const user = JSON.parse(localStorage.getItem('user'));
  const [isOpen, setIsOpen] = useState(false);

  function handleLoginClick() {
    history.push('/login');
  }

  function handleSignUpClick() {
    history.push('/signup');
  }

  function handleHomeClick() {
    history.push('');
  }

  function handleLogoutClick() {
    localStorage.removeItem('user');
    history.push('/login');
  }

  function handleDropdownClick() {
    setIsOpen(!isOpen);
  }

  return (
    <nav className="navbar">
      <div className="navbar__title" onClick={handleHomeClick}>iMusic</div>
      <div className="navbar__buttons">
        {user && user.token ? (
          <div className="navbar__dropdown">
            <div className="navbar__username" onClick={handleDropdownClick}>{user.username}</div>
            {isOpen && (
              <div className="navbar__dropdown-content">
                <button className="navbar__logout" onClick={handleLogoutClick}>Logout</button>
              </div>
            )}
          </div>
        ) : (
          <>
            <button className="navbar__login" onClick={handleLoginClick}>Login</button>
            <button className="navbar__button" onClick={handleSignUpClick}>Sign Up</button>
          </>
        )}
      </div>
    </nav>
  );
}

export default NavBar;