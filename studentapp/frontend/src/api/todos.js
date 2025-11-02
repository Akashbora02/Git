const BASE = import.meta.env.VITE_API_BASE || 'http://localhost:3001';


export async function getTodos() {
const res = await fetch(`${BASE}/api/todos`);
return res.json();
}
export async function createTodo(title) {
const res = await fetch(`${BASE}/api/todos`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ title }) });
return res.json();
}
export async function toggleTodo(id) {
const res = await fetch(`${BASE}/api/todos/${id}/toggle`, { method: 'PUT' });
return res.json();
}
export async function deleteTodo(id) {
await fetch(`${BASE}/api/todos/${id}`, { method: 'DELETE' });
}