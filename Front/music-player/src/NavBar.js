import "./navbar.css";

function NavBar() {

  return (
      <nav className="navbar">
        <div className="navbar__title">iMusic</div>
        <div className="navbar__buttons">
          <button className="navbar__login" >Login</button>
          <button className="navbar__button">Sign Up</button>
        </div>
      </nav>
  );
}

export default NavBar;