'use strict';

const express = require('express');
const path = require('path');
const fs = require('fs');
const jwt = require('jwt-simple');

const publicPath = path.resolve(__dirname, 'public');
const app = express();
const port = 8500;

app.listen(port, function() {
  console.log(`app listening on port ${port}`);
});

app.get('/', function(req, res) {
  res.sendFile(`${publicPath}/index.html`);
});