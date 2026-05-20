#!/usr/bin/env node
'use strict';
const { spawnSync } = require('child_process');
const path = require('path');

const cmd = process.argv[2];
const args = process.argv.slice(3);

if (cmd === 'setup') {
  const script = path.join(__dirname, '..', 'install.sh');
  const result = spawnSync('bash', [script, ...args], { stdio: 'inherit' });
  process.exit(result.status || 0);
} else {
  console.log('Usage: oh-my-kiro-cli setup [--link] [--with-hooks]');
  process.exit(cmd ? 1 : 0);
}
