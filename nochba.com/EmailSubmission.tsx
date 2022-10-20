// import react dependancies
import React, { useEffect, useState } from 'react';

const { GoogleSpreadsheet } = require('google-spreadsheet');

function SubmitEmail(props) {
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("submitting");
    console.log(email, name, message);
    // call google spreadsheet app via rest
    // post data with email, name and message

    const baseUrl = 'https://hooks.zapier.com/hooks/catch/9246099/bi7yiqe/';





  };

  return (
    <div className="email-submission">
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="text"
          placeholder="name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <textarea
          placeholder="message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
        />
        <button type="submit">Submit</button>
      </form>
    </div>
  );
}
