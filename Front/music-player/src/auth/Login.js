import "./login.css";
import { useState } from 'react';

function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  function handleSubmit(event) {
    event.preventDefault();

    fetch('http://localhost:8080/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ username, password })
    })
      .then(response => response.json())
      .then(data => console.log(data))
      .catch(error => console.error(error));
  }
  return (
    <div className="login-page">
    <h1>Login</h1>
    <form onSubmit={handleSubmit}>
      <label htmlFor="username">Username:</label>
      <input type="text" id="username" name="username" value={username} onChange={event => setUsername(event.target.value)} />

      <label htmlFor="password">Password:</label>
      <input type="password" id="password" name="password" value={password} onChange={event => setPassword(event.target.value)} />

      <button type="submit">Login</button>
    </form>
  </div>
  );
}

export default Login;