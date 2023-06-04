import "./login.css";
import { useState } from 'react';
import { useHistory } from 'react-router-dom';

function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const history = useHistory();


  function handleSubmit(event) {
    event.preventDefault();

    fetch('http://localhost:8080/auth/signup', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email,name, password })
    })
      .then(response => response.json())
      .then(data => {
        // redirect to home page
        if (data.token) {
          localStorage.setItem('token', data.token);
          history.push('/');
        }
      })
      .catch(error => console.error(error));
  }
  return (
    <div className="login-page">
    <h1>Login</h1>
    <form onSubmit={handleSubmit}>
      <label htmlFor="name">username</label>
      <input type="text" id="name" name="name" value={name} onChange={event => setName(event.target.value)} />
      
      <label htmlFor="email">email</label>
      <input type="text" id="email" name="email" value={email} onChange={event => setEmail(event.target.value)} />

      <label htmlFor="password">Password</label>
      <input type="password" id="password" name="password" value={password} onChange={event => setPassword(event.target.value)} />

      <button type="submit">Login</button>
    </form>
  </div>
  );
}

export default SignUp;