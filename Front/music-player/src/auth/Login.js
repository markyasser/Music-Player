import "./login.css";
import { useState } from "react";
import { useHistory } from "react-router-dom";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const history = useHistory();

  function handleSubmit(event) {
    event.preventDefault();

    fetch("http://localhost:8080/auth/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, password }),
    })
      .then((response) => response.json())
      .then((data) => {
        // redirect to home page
        if (data.token) {
          localStorage.setItem("user", JSON.stringify(data));
          console.log(data);
          history.push("/");
        }
      })
      .catch((error) => console.error(error));
  }
  return (
    <div className="login-page">
      <h1>Login</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="username">email</label>
        <input
          type="text"
          id="email"
          name="email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
        />

        <label htmlFor="password">Password</label>
        <input
          type="password"
          id="password"
          name="password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
        />

        <button type="submit">Login</button>
      </form>
    </div>
  );
}

export default Login;
