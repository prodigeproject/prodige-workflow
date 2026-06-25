#!/usr/bin/env node
/**
 * .ai/scripts/prodige-mcp.js
 * Prodige Model Context Protocol (MCP) Server.
 * Menyediakan toolsets standar untuk Hermes, OpenClaw, Cline, RooCode, dan Claude Desktop.
 * 
 * Desain tanpa dependensi eksternal (menggunakan modul bawaan Node.js stdio).
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const ROOT_DIR = path.resolve(__dirname, '../..');
const AI_DIR = path.resolve(ROOT_DIR, '.ai');
const STATE_FILE = path.resolve(AI_DIR, 'runtime/state.json');
const LOCKS_DIR = path.resolve(AI_DIR, 'runtime/locks');
const MEM_DIR = path.resolve(AI_DIR, 'memory');

// Helper untuk membaca stdio JSON-RPC
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

function logError(msg) {
  const logDir = path.resolve(AI_DIR, 'runtime');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }
  fs.appendFileSync(path.join(logDir, 'mcp-error.log'), `[${new Date().toISOString()}] ${msg}\n`);
}

function getActiveContext() {
  if (fs.existsSync(STATE_FILE)) {
    try {
      return JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
    } catch (e) {
      logError("Gagal membaca state.json: " + e.message);
    }
  }
  
  // Fallback: Membaca berkas activeContext.md tradisional jika state.json belum ada
  const activeContextPath = path.join(MEM_DIR, 'activeContext.md');
  let focus = "Tidak ada tugas aktif.";
  if (fs.existsSync(activeContextPath)) {
    const content = fs.readFileSync(activeContextPath, 'utf8');
    const match = content.match(/#\s+Active\s+Context[^\n]*\n+([\s\S]*?)(?=\n#|$)/i);
    if (match && match[1]) {
      focus = match[1].trim().split('\n')[0];
    }
  }

  return {
    focus,
    allowed_files: [],
    tasks: []
  };
}

function handleAcquireLock(resource, agentId) {
  if (!fs.existsSync(LOCKS_DIR)) {
    fs.mkdirSync(LOCKS_DIR, { recursive: true });
  }

  const safeName = resource.replace(/[^a-zA-Z0-9]/g, '_') + '.lock';
  const lockPath = path.join(LOCKS_DIR, safeName);

  if (fs.existsSync(lockPath)) {
    return { success: false, message: `Resource '${resource}' sudah dikunci oleh agen lain.` };
  }

  const lockData = {
    resource,
    agent_id: agentId || 'unknown-mcp-agent',
    pid: process.pid,
    timestamp: new Date().toISOString()
  };

  fs.writeFileSync(lockPath, JSON.stringify(lockData, null, 2));
  return { success: true, message: `Lock berhasil didapatkan untuk '${resource}'.` };
}

// JSON-RPC Handler Loop
rl.on('line', (line) => {
  try {
    if (!line.trim()) return;
    const request = JSON.parse(line);
    
    if (request.method === 'initialize') {
      const response = {
        jsonrpc: '2.0',
        id: request.id,
        result: {
          protocolVersion: '2024-11-05',
          capabilities: {
            tools: {}
          },
          serverInfo: {
            name: 'prodige-mcp-server',
            version: '1.0.0'
          }
        }
      };
      console.log(JSON.stringify(response));
      return;
    }

    if (request.method === 'tools/list') {
      const response = {
        jsonrpc: '2.0',
        id: request.id,
        result: {
          tools: [
            {
              name: 'get_active_context',
              description: 'Mendapatkan status tugas, fokus, dan daftar file staged aktif.',
              inputSchema: { type: 'object', properties: {} }
            },
            {
              name: 'acquire_lock',
              description: 'Mengunci berkas sumber agar tidak dimodifikasi oleh agen paralel lain.',
              inputSchema: {
                type: 'object',
                properties: {
                  resource: { type: 'string', description: 'Path berkas relatif dari root.' },
                  agentId: { type: 'string', description: 'Identifier unik agen.' }
                },
                required: ['resource']
              }
            }
          ]
        }
      };
      console.log(JSON.stringify(response));
      return;
    }

    if (request.method === 'tools/call') {
      const { name, arguments: args } = request.params;
      let result = null;

      if (name === 'get_active_context') {
        result = { content: [{ type: 'text', text: JSON.stringify(getActiveContext(), null, 2) }] };
      } else if (name === 'acquire_lock') {
        const res = handleAcquireLock(args.resource, args.agentId);
        result = { content: [{ type: 'text', text: JSON.stringify(res, null, 2) }] };
      }

      const response = {
        jsonrpc: '2.0',
        id: request.id,
        result
      };
      console.log(JSON.stringify(response));
      return;
    }

    // Default response untuk method tidak dikenal
    if (request.id) {
      console.log(JSON.stringify({
        jsonrpc: '2.0',
        id: request.id,
        error: { code: -32601, message: `Method '${request.method}' tidak ditemukan.` }
      }));
    }
  } catch (err) {
    logError("Error memproses RPC: " + err.message + " | Line: " + line);
  }
});
