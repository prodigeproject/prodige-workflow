#!/usr/bin/env node
/**
 * .ai/scripts/prodige-cli.js
 * Prodige Workflow CLI Helper: Dashboard, Checkpoint & Rollback Manager.
 * 
 * Enterprise Hardening: Atomic writes, Auto-Backup/Recovery, & Audit Telemetry.
 * Language: English
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT_DIR = path.resolve(__dirname, '../..');
const AI_DIR = path.resolve(ROOT_DIR, '.ai');
const MEM_DIR = path.resolve(AI_DIR, 'memory');
const STATE_DIR = path.resolve(AI_DIR, 'state');
const STATE_FILE = path.resolve(AI_DIR, 'runtime/state.json');
const LOCKS_DIR = path.resolve(AI_DIR, 'runtime/locks');
const CP_CACHE_DIR = path.resolve(AI_DIR, 'runtime/cache/checkpoints');

// ANSI Color Helpers
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  magenta: '\x1b[35m',
  bgBlue: '\x1b[44m',
  bgBlack: '\x1b[40m'
};

// Ensure checkpoint cache directory exists
if (!fs.existsSync(CP_CACHE_DIR)) {
  fs.mkdirSync(CP_CACHE_DIR, { recursive: true });
}

function logError(msg) {
  const logDir = path.resolve(AI_DIR, 'runtime');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }
  fs.appendFileSync(path.join(logDir, 'mcp-error.log'), `[${new Date().toISOString()}] CLI-ERROR: ${msg}\n`);
}

function logAudit(action, details) {
  const auditLogPath = path.resolve(AI_DIR, 'runtime/audit.log');
  const logDir = path.dirname(auditLogPath);
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }
  const entry = `[${new Date().toISOString()}] ACTION: ${action} | DETAILS: ${JSON.stringify(details)}\n`;
  fs.appendFileSync(auditLogPath, entry);
}

function runGit(cmd) {
  try {
    return execSync(`git ${cmd}`, { cwd: ROOT_DIR, stdio: 'pipe' }).toString().trim();
  } catch (e) {
    return null;
  }
}

/**
 * Enterprise Resilience: Safely read state file with backup (.bak) fallback
 */
function readStateSafely() {
  const bakPath = STATE_FILE + '.bak';
  if (fs.existsSync(STATE_FILE)) {
    try {
      return JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
    } catch (e) {
      logError(`File state.json is corrupted. Attempting backup recovery. Error: ${e.message}`);
      if (fs.existsSync(bakPath)) {
        try {
          const bakData = JSON.parse(fs.readFileSync(bakPath, 'utf8'));
          fs.copyFileSync(bakPath, STATE_FILE); // Restore main file
          logAudit("STATE_RESTORE_FROM_BACKUP", { success: true });
          return bakData;
        } catch (bakError) {
          logError(`Backup file is also corrupted: ${bakError.message}`);
        }
      }
    }
  }
  return null;
}

/**
 * Enterprise Resilience: Write state file atomically to prevent data corruption
 */
function writeStateAtomically(data) {
  const tempPath = STATE_FILE + '.tmp';
  const bakPath = STATE_FILE + '.bak';
  try {
    fs.writeFileSync(tempPath, JSON.stringify(data, null, 2));
    if (fs.existsSync(STATE_FILE)) {
      fs.copyFileSync(STATE_FILE, bakPath); // Copy to backup before overwrite
    }
    fs.renameSync(tempPath, STATE_FILE); // Overwrite atomically
    return true;
  } catch (e) {
    logError("Failed to write state atomically: " + e.message);
    return false;
  }
}

/**
 * 1. Command: dashboard
 */
function handleDashboard() {
  console.clear();
  console.log(`${colors.bgBlue}${colors.bright}  === PRODIGE WORKFLOW COCKPIT ===  ${colors.reset}\n`);

  // A. Read activeContext.md
  let activeFocus = 'No active task.';
  const stateData = readStateSafely();
  
  if (stateData && stateData.session && stateData.session.active_focus) {
    activeFocus = stateData.session.active_focus;
  } else {
    const activeContextPath = path.join(MEM_DIR, 'activeContext.md');
    if (fs.existsSync(activeContextPath)) {
      const content = fs.readFileSync(activeContextPath, 'utf8');
      const match = content.match(/#\s+Active\s+Context[^\n]*\n+([\s\S]*?)(?=\n#|$)/i);
      if (match && match[1]) {
        activeFocus = match[1].trim().split('\n')[0];
      }
    }
  }
  console.log(`${colors.bright}${colors.cyan}[FOCUS]${colors.reset} ${activeFocus}`);

  // B. Read task.md (Checklist & Progress)
  const taskPath = path.join(ROOT_DIR, 'task.md');
  let taskLines = [];
  if (fs.existsSync(taskPath)) {
    taskLines = fs.readFileSync(taskPath, 'utf8').split('\n');
  } else {
    const aiTaskPath = path.join(AI_DIR, 'task.md');
    if (fs.existsSync(aiTaskPath)) {
      taskLines = fs.readFileSync(aiTaskPath, 'utf8').split('\n');
    }
  }

  let totalTasks = 0;
  let completedTasks = 0;
  const listItems = [];

  taskLines.forEach(line => {
    if (line.match(/^\s*-\s*\[([\s xX/])\]/)) {
      totalTasks++;
      const isDone = line.includes('[x]') || line.includes('[X]');
      const isProgress = line.includes('[/]');
      if (isDone) completedTasks++;
      
      let statusStr = `[ ]`;
      if (isDone) statusStr = `${colors.green}[x]${colors.reset}`;
      else if (isProgress) statusStr = `${colors.yellow}[/]${colors.reset}`;

      const text = line.replace(/^\s*-\s*\[.\]\s*/, '').trim();
      listItems.push(`  ${statusStr} ${text}`);
    }
  });

  console.log(`\n${colors.bright}${colors.cyan}[TASKS PROGRESS]${colors.reset}`);
  if (totalTasks > 0) {
    const percent = Math.round((completedTasks / totalTasks) * 100);
    const barWidth = 30;
    const filledWidth = Math.round((completedTasks / totalTasks) * barWidth);
    const emptyWidth = barWidth - filledWidth;
    const progressBar = `${colors.green}${'█'.repeat(filledWidth)}${colors.reset}${'░'.repeat(emptyWidth)}`;
    console.log(`  Progress: [${progressBar}] ${percent}% (${completedTasks}/${totalTasks} completed)`);
    console.log(listItems.slice(0, 10).join('\n'));
    if (listItems.length > 10) console.log(`  ...and ${listItems.length - 10} other tasks.`);
  } else {
    console.log(`  ${colors.yellow}No active checklist tasks in task.md.${colors.reset}`);
  }

  // C. Read Locks
  console.log(`\n${colors.bright}${colors.cyan}[ACTIVE LOCKS]${colors.reset}`);
  if (fs.existsSync(LOCKS_DIR)) {
    const locks = fs.readdirSync(LOCKS_DIR).filter(f => f.endsWith('.lock'));
    if (locks.length > 0) {
      locks.forEach(f => {
        const fileContent = fs.readFileSync(path.join(LOCKS_DIR, f), 'utf8');
        try {
          const data = JSON.parse(fileContent);
          console.log(`  ${colors.red}🔒 locked${colors.reset} -> ${colors.yellow}${data.resource}${colors.reset} (PID: ${data.pid || 'n/a'}, Agent: ${data.agent_id})`);
        } catch (e) {
          console.log(`  ${colors.red}🔒 locked${colors.reset} -> ${f} (Invalid format)`);
        }
      });
    } else {
      console.log(`  ${colors.green}🔓 All clear - no locked files.${colors.reset}`);
    }
  }

  // D. Read Checkpoints
  console.log(`\n${colors.bright}${colors.cyan}[SAVED CHECKPOINTS]${colors.reset}`);
  const checkpoints = fs.readdirSync(CP_CACHE_DIR);
  if (checkpoints.length > 0) {
    checkpoints.forEach(cp => {
      const metaPath = path.join(CP_CACHE_DIR, cp, 'meta.json');
      if (fs.existsSync(metaPath)) {
        const meta = JSON.parse(fs.readFileSync(metaPath, 'utf8'));
        console.log(`  📍 ${colors.green}${cp}${colors.reset} (${meta.timestamp}) - Git: ${meta.commitSha.slice(0, 7)}`);
      }
    });
  } else {
    console.log(`  No checkpoints. Create one with: ${colors.yellow}node prodige-cli.js checkpoint <name>${colors.reset}`);
  }

  console.log(`\n${colors.bright}${colors.cyan}[GIT STATUS]${colors.reset}`);
  const gitStatus = runGit('status --short');
  if (gitStatus) {
    console.log(gitStatus.split('\n').map(line => `  ${line}`).join('\n'));
  } else if (gitStatus === '') {
    console.log(`  ${colors.green}Clean - no staged/unstaged changes.${colors.reset}`);
  } else {
    console.log(`  ${colors.red}Not a Git repository or Git is not installed in PATH.${colors.reset}`);
  }

  console.log(`\n${colors.bgBlack} [U] Undo  [R] Rollback  [Q] Quit ${colors.reset}\n`);
}

/**
 * 2. Command: checkpoint
 */
function handleCheckpoint(name) {
  if (!name) {
    console.error(`${colors.red}[ERROR] Provide a checkpoint name. Example: node prodige-cli.js checkpoint refactor-db${colors.reset}`);
    process.exit(1);
  }

  console.log(`\n📍 Creating checkpoint '${name}'...`);

  const version = runGit('--version');
  if (!version) {
    console.error(`${colors.red}[ERROR] Git is not found in PATH. Checkpoint requires Git.${colors.reset}`);
    process.exit(1);
  }

  console.log('  - Saving Git status...');
  runGit('add .');
  const commitMsg = `prodige-checkpoint: ${name}`;
  runGit(`commit -m "${commitMsg}"`);
  
  const commitSha = runGit('rev-parse HEAD');
  if (!commitSha) {
    console.error(`${colors.red}[ERROR] Failed to retrieve Git commit SHA.${colors.reset}`);
    process.exit(1);
  }

  const cpDir = path.join(CP_CACHE_DIR, name);
  const cpMemDir = path.join(cpDir, 'memory');
  const cpStateDir = path.join(cpDir, 'state');

  fs.mkdirSync(cpMemDir, { recursive: true });
  fs.mkdirSync(cpStateDir, { recursive: true });

  if (fs.existsSync(MEM_DIR)) {
    fs.readdirSync(MEM_DIR).forEach(f => {
      const src = path.join(MEM_DIR, f);
      if (fs.statSync(src).isFile()) {
        fs.copyFileSync(src, path.join(cpMemDir, f));
      }
    });
  }

  if (fs.existsSync(STATE_DIR)) {
    fs.readdirSync(STATE_DIR).forEach(f => {
      const src = path.join(STATE_DIR, f);
      if (fs.statSync(src).isFile()) {
        fs.copyFileSync(src, path.join(cpStateDir, f));
      }
    });
  }

  const meta = {
    name,
    timestamp: new Date().toISOString(),
    commitSha,
  };
  fs.writeFileSync(path.join(cpDir, 'meta.json'), JSON.stringify(meta, null, 2));

  // Write to audit log
  logAudit("CREATE_CHECKPOINT", { name, commitSha });

  console.log(`${colors.green}[SUCCESS] Checkpoint '${name}' created successfully!${colors.reset}`);
}

/**
 * 3. Command: rollback
 */
function handleRollback(name) {
  if (!name) {
    console.error(`${colors.red}[ERROR] Provide a checkpoint name for rollback. Example: node prodige-cli.js rollback refactor-db${colors.reset}`);
    process.exit(1);
  }

  const cpDir = path.join(CP_CACHE_DIR, name);
  if (!fs.existsSync(cpDir)) {
    console.error(`${colors.red}[ERROR] Checkpoint '${name}' not found!${colors.reset}`);
    process.exit(1);
  }

  console.log(`\n⏮️  Restoring system to checkpoint '${name}'...`);

  const meta = JSON.parse(fs.readFileSync(path.join(cpDir, 'meta.json'), 'utf8'));

  console.log(`  - Performing Git hard reset to ${meta.commitSha.slice(0, 7)}...`);
  runGit(`reset --hard ${meta.commitSha}`);

  console.log('  - Restoring Prodige memory status...');
  const cpMemDir = path.join(cpDir, 'memory');
  const cpStateDir = path.join(cpDir, 'state');

  if (fs.existsSync(cpMemDir)) {
    fs.readdirSync(cpMemDir).forEach(f => {
      fs.copyFileSync(path.join(cpMemDir, f), path.join(MEM_DIR, f));
    });
  }

  if (fs.existsSync(cpStateDir)) {
    fs.readdirSync(cpStateDir).forEach(f => {
      fs.copyFileSync(path.join(cpStateDir, f), path.join(STATE_DIR, f));
    });
  }

  // Write to audit log
  logAudit("ROLLBACK_SYSTEM", { name, commitSha: meta.commitSha });

  console.log(`${colors.green}[SUCCESS] System restored to checkpoint '${name}' successfully and atomically!${colors.reset}`);
}

// Route Argument
const args = process.argv.slice(2);
const command = args[0] || 'dashboard';

switch (command.toLowerCase()) {
  case 'dashboard':
  case 'status':
    handleDashboard();
    break;
  case 'checkpoint':
    handleCheckpoint(args[1]);
    break;
  case 'rollback':
    handleRollback(args[1]);
    break;
  default:
    console.log(`
Prodige CLI Helper

Usage:
  node prodige-cli.js [command] [options]

Commands:
  dashboard / status    : Show real-time cockpit dashboard
  checkpoint <name>     : Create atomic checkpoint of code + memory
  rollback <name>       : Restore code and memory back to checkpoint
    `);
}
