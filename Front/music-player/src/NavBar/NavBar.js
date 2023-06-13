import "./navbar.css";
import { useState } from "react";
import { useHistory } from "react-router-dom";
import {
  faCloudUploadAlt,
  faCog,
  faInfoCircle,
  faSignOutAlt,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

function NavBar() {
  const history = useHistory();
  const user = JSON.parse(localStorage.getItem("user"));
  const [UserData, setUserData] = useState(user);
  // setUserData(user);
  const [isOpen, setIsOpen] = useState(false);

  function handleLoginClick() {
    history.push("/login");
  }

  function handleSignUpClick() {
    history.push("/signup");
  }

  function handleHomeClick() {
    setUserData(user);
    history.push("");
  }

  function handleLogoutClick() {
    localStorage.removeItem("user");
    setUserData(null);
    history.push("/login");
  }

  function handleDropdownClick() {
    setIsOpen(!isOpen);
  }
  function handleUploadClick() {
    history.push("/upload_file");
  }

  return (
    <nav className="navbar">
      <div className="navbar__title" onClick={handleHomeClick}>
        iMusic
      </div>
      <div className="navbar__buttons">
        {UserData && UserData.token ? (
          <div className="navbar__dropdown">
            <button className="navbar__upload" onClick={handleUploadClick}>
              <div> Upload </div>
              <FontAwesomeIcon
                className="card__like-button"
                icon={faCloudUploadAlt}
              />
            </button>
            <div className="navbar__username" onClick={handleDropdownClick}>
              {user.username}
            </div>
            {isOpen && (
              <div className="navbar__dropdown-content">
                <div
                  className="navbar__dropdown-button"
                  onClick={handleLogoutClick}
                >
                  <FontAwesomeIcon
                    className="navbar__upload-icon"
                    icon={faSignOutAlt}
                  />
                  <div>Logout</div>
                </div>
                <div
                  className="navbar__dropdown-button"
                  onClick={() => console.log("Settings clicked")}
                >
                  <FontAwesomeIcon
                    className="navbar__upload-icon"
                    icon={faCog}
                  />
                  <div>Settings</div>
                </div>
                <div
                  className="navbar__dropdown-button"
                  onClick={() => console.log("Info clicked")}
                >
                  <FontAwesomeIcon
                    className="navbar__upload-icon"
                    icon={faInfoCircle}
                  />
                  <div>Info</div>
                </div>
              </div>
            )}
          </div>
        ) : (
          <>
            <button className="navbar__login" onClick={handleLoginClick}>
              Login
            </button>
            <button className="navbar__button" onClick={handleSignUpClick}>
              Sign Up
            </button>
          </>
        )}
      </div>
    </nav>
  );
}

export default NavBar;
