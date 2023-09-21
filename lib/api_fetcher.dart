// Endpoint
const String api = 'https://todoapp-api.apps.k8s.gu.se';
// API Key
const String apiKey = '8a68cedb-e3f7-42c7-a0b0-a9547d962017';

// GET /todos?key=$api_key // list todos, returns an array of todos

// POST /todos?key=$api_key  // takes a todo as payload(body)
// set the Content-Type header to application/json
// will return the entire list of todos, including the added todo

// PUT /todos/:id?key=$api_key // update todo with :id
// takes a todo as payload(body) and updates title and done for the already existing todo with id in URL

// DELETE /todos/:id?key=$api_key
// deletes a todo with id in URL

