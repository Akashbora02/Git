const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

// --- Create pool (without specifying database yet) ---
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 3306,
  waitForConnections: true,
  connectionLimit: 10,
});

// --- Initialize DB & Table ---
(async () => {
  try {
    // Create database if not exists
    await pool.query(`CREATE DATABASE IF NOT EXISTS ${process.env.DB_NAME}`);
    console.log(`Database '${process.env.DB_NAME}' ensured.`);

    // Use the database
    await pool.query(`USE ${process.env.DB_NAME}`);

    // Create table if not exists
    await pool.query(`
      CREATE TABLE IF NOT EXISTS todos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        completed TINYINT(1) DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    console.log("Table 'todos' ensured.");
  } catch (err) {
    console.error('Error initializing database:', err);
  }
})();

// --- Routes ---

// Get all todos
app.get('/api/todos', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM todos ORDER BY id DESC');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Create todo
app.post('/api/todos', async (req, res) => {
  try {
    const { title } = req.body;
    if (!title) return res.status(400).json({ error: 'Title required' });

    const [result] = await pool.query('INSERT INTO todos (title) VALUES (?)', [title]);
    const [row] = await pool.query('SELECT * FROM todos WHERE id = ?', [result.insertId]);
    res.status(201).json(row[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Toggle complete
app.put('/api/todos/:id/toggle', async (req, res) => {
  try {
    const id = req.params.id;
    await pool.query('UPDATE todos SET completed = NOT completed WHERE id = ?', [id]);
    const [row] = await pool.query('SELECT * FROM todos WHERE id = ?', [id]);
    res.json(row[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Delete
app.delete('/api/todos/:id', async (req, res) => {
  try {
    const id = req.params.id;
    await pool.query('DELETE FROM todos WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`Backend listening on port ${PORT}`));



/* const express = require('express');
const cors = require('cors');
const pool = require('./db');
const dotenv = require('dotenv');


dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());


// Get all todos
app.get('/api/todos', async (req, res) => {
try {
const [rows] = await pool.query('SELECT * FROM todos ORDER BY id DESC');
res.json(rows);
} catch (err) {
console.error(err);
res.status(500).json({ error: 'Database error' });
}
});


// Create todo
app.post('/api/todos', async (req, res) => {
try {
const { title } = req.body;
if (!title) return res.status(400).json({ error: 'Title required' });
const [result] = await pool.query('INSERT INTO todos (title) VALUES (?)', [title]);
const [row] = await pool.query('SELECT * FROM todos WHERE id = ?', [result.insertId]);
res.status(201).json(row[0]);
} catch (err) {
console.error(err);
res.status(500).json({ error: 'Database error' });
}
});


// Toggle complete
app.put('/api/todos/:id/toggle', async (req, res) => {
try {
const id = req.params.id;
await pool.query('UPDATE todos SET completed = NOT completed WHERE id = ?', [id]);
const [row] = await pool.query('SELECT * FROM todos WHERE id = ?', [id]);
res.json(row[0]);
} catch (err) {
console.error(err);
res.status(500).json({ error: 'Database error' });
}
});


// Delete
app.delete('/api/todos/:id', async (req, res) => {
try {
const id = req.params.id;
await pool.query('DELETE FROM todos WHERE id = ?', [id]);
res.json({ success: true });
} catch (err) {
console.error(err);
res.status(500).json({ error: 'Database error' });
}
});


const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`Backend listening on port ${PORT}`)); */