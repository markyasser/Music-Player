import NavBar from "./NavBar/NavBar.js";
import Home from "./Home/Home.js";
import Login from "./auth/Login.js";
import SignUp from "./auth/Signup.js";
import LikedTracks from "./Home/LikedTracks.js";
import UploadFile from "./NavBar/UploadFile.js";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
function App() {
  const token = localStorage.getItem("user");
  // let homePath = token ? "/" : "/login";
  // let loginPath = token ? "/" : "/login";
  return (
    <Router>
      <div className="App">
        <NavBar />
        <Switch>
          <Route path="/login">
            <Login />
          </Route>
          <Route path="/signup">
            <SignUp />
          </Route>
          <Route path="/liked">
            <LikedTracks />
          </Route>
          <Route path="/upload_file">
            {token ? <UploadFile /> : <Login />}
          </Route>
          <Route path="/">{token ? <Home /> : <Login />}</Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
