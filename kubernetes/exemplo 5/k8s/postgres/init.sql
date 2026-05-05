CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT
);

INSERT INTO users (name)
SELECT 'User ' || generate_series(1,1000);