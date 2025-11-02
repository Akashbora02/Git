import React, { useEffect, useState } from 'react'
import { getTodos, createTodo, toggleTodo, deleteTodo } from './api/todos'


export default function App(){
const [todos, setTodos] = useState([])
const [text, setText] = useState('')


useEffect(()=>{ refresh() }, [])
async function refresh(){
const data = await getTodos()
setTodos(data)
}


async function add(e){
e.preventDefault()
if(!text.trim()) return
await createTodo(text.trim())
setText('')
refresh()
}


async function onToggle(id){
await toggleTodo(id)
refresh()
}
async function onDelete(id){
await deleteTodo(id)
refresh()
}


return (
<div style={{ maxWidth: 600, margin: '40px auto', fontFamily: 'Arial, sans-serif' }}>
<h1>Todo App</h1>
<form onSubmit={add} style={{ marginBottom: 20 }}>
<input value={text} onChange={e=>setText(e.target.value)} placeholder="Add todo" style={{ padding: 8, width: '70%' }} />
<button style={{ padding: 8 }}>Add</button>
</form>


<ul style={{ listStyle: 'none', padding: 0 }}>
{todos.map(t => (
<li key={t.id} style={{ display:'flex', justifyContent:'space-between', padding: '8px 0', borderBottom: '1px solid #eee' }}>
<div>
<input type="checkbox" checked={!!t.completed} onChange={()=>onToggle(t.id)} />
<span style={{ marginLeft: 8, textDecoration: t.completed ? 'line-through' : 'none' }}>{t.title}</span>
</div>
<div>
<button onClick={()=>onDelete(t.id)}>Delete</button>
</div>
</li>
))}
</ul>
</div>
)
}