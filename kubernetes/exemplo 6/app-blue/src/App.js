import './App.css';
import { useEffect, useState } from 'react';

function App() {
  const [podName, setPodName] = useState("");

  useEffect(() => {
    fetch("/podname")
      .then((res) => res.text())
      .then((data) => setPodName(data));
  }, []);

  return (
    <div className="container">
      <h1>Aula CEFET aprendendo Kubernetes</h1>

      <h2>Pod:</h2>
      <p>{podName}</p>
    </div>
  );
}

export default App;