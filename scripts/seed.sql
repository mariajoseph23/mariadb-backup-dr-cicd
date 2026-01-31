USE appdb;

INSERT INTO users (email, full_name) VALUES
  ('maria.one@example.com', 'Maria One'),
  ('maria.two@example.com', 'Maria Two'),
  ('maria.three@example.com', 'Maria Three');

INSERT INTO orders (user_id, amount_cents, status) VALUES
  (1, 1299, 'PAID'),
  (1, 2500, 'PAID'),
  (2, 4999, 'PENDING'),
  (3, 1999, 'PAID');

