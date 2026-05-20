#!/usr/bin/env node
'use strict';
const { spawnSync } = require('child_process');
const path = require('path');
const os = require('os');

const cmd = process.argv[2];
const args = process.argv.slice(3);

if (cmd === 'setup') {
  // R3: --link is only for git-clone installs, not npm installs
  const isNpmInstall = __dirname.includes(`${path.sep}node_modules${path.sep}`);
  if (isNpmInstall && args.includes('--link')) {
    console.error('--link is only supported for git-clone installs, not npm installs.');
    process.exit(2);
  }

  const script = path.join(__dirname, '..', 'install.sh');
  const result = spawnSync('bash', [script, ...args], { stdio: 'inherit' });

  // R2: handle signal termination correctly
  if (result.error) {
    console.error(result.error.message);
    process.exit(1);
  }
  if (result.signal) {
    console.error(`\nsetup interrupted by ${result.signal}`);
    const signum = os.constants.signals[result.signal] || 1;
    process.exit(128 + signum);
  }
  process.exit(result.status ?? 1);
} else {
  console.log('Usage: oh-my-kiro-cli setup [--link] [--with-hooks]');
  process.exit(cmd ? 1 : 0);
}
