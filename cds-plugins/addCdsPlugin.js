#!/usr/bin/env node

const { spawn } = require('node:child_process');
const { argv, env, cwd } = require('node:process');
const fs = require('node:fs');
const path = require('node:path');
const npm = path.sep == '/' ? 'npm':'npm.cmd';

function _execCommand(command, args, options) {
  return new Promise((resolve,reject) => {
    var proc = spawn(command, args, options);
    proc.scriptOutput='';

    if(proc.stdout) {
      proc.stdout.setEncoding('utf8');
      proc.stdout.on('data', function(data) {
        console.log(data)
        proc.scriptOutput+=data.toString();
      });
    }
  
    if(proc.stderr) {
      proc.stderr.setEncoding('utf8');
      proc.stderr.on('data', function(data) {
        console.log(data)
        proc.scriptOutput+=data.toString();
      });
    }
  
    proc.on('exit', function(exitCode) {
      proc.exitCode=exitCode;
      if(exitCode===0)
        resolve(proc);
      else
        reject(proc);
    });
  
  })
}

async function execCommand(command, args=[], options={}) {
  console.log('exec:', command, args);
  let res = await _execCommand(command, args ,options);
  return res;
}

async function addPlugin(pluginName, targetAppWorkspace) {
  let targetPluginName = pluginName+'-plugin';
  let srcPluginDir = path.join(path.dirname(__filename), pluginName);
  if(!fs.existsSync(srcPluginDir))
    throw Error(`Plugin source directory missing: ${srcPluginDir}`);

  const initWS = await execCommand(npm,['init','-w',targetPluginName,'-y']);
  let re1 = /Wrote to (.*?):\n/;
  let re1res = initWS.scriptOutput.match(re1);
  if(!re1res) throw Error('Could not extract newly created workspace directory!');
  let pluginDir = path.dirname(re1res[1]);
  console.log('pluginDir:',pluginDir)

  fs.writeFileSync(path.join(pluginDir,'index.js'),'');
  fs.copyFileSync(path.join(srcPluginDir,'cds-plugin.js'), path.join(pluginDir,'cds-plugin.js'))

  if(targetAppWorkspace)
    await execCommand(npm,['add','-w',targetAppWorkspace,targetPluginName]);
  else
    await execCommand(npm,['add',targetPluginName]);

  copyFiles(path.join(srcPluginDir,'files'), pluginDir);

  const initSh = path.join(srcPluginDir,'init.sh');
  if(fs.existsSync(initSh)) {
    let args = [initSh].concat(argv.slice(2));
    let options = { cwd: pluginDir }
    let rootdir = cwd();
    options.env = Object.assign( { 
      CDS_SERVICE_ROOT_DIR: path.join(rootdir,targetAppWorkspace?targetAppWorkspace:'.'),
      CDS_CUCUMBER_PLUGIN_DIR: srcPluginDir,
    }, env );
    await execCommand('bash', args, options)
  }

}

function copyFiles(fromDir, toDir) {
  console.log('copyFiles',fromDir,toDir)
  if(!fs.existsSync(fromDir)) return false;
  if(!fs.existsSync(toDir)) fs.mkdirSync(toDir);
  if(!fs.existsSync(toDir)) return false;
  let files = fs.readdirSync(fromDir);
  files.forEach(file => {
    let f1=path.join(fromDir,file);
    let f2=path.join(toDir,file);
    if(fs.existsSync(f2) && env.CDS_CUCUMBER_PLUGIN_OVERWRITE!=="1") return;
    console.log('copy',f1)
    console.log('  ->to',f2)
    if(fs.lstatSync(f1).isDirectory()) {
      copyFiles(f1,f2);
    } else {
      fs.copyFileSync(f1, f2);
    }
  })
}

if (require.main === module) {

  (async function () {
    let plugin;
    let workspace;
    let param;
    argv.slice(2).forEach(arg => {
      if(arg[0]=='-') param=arg;
      else {
        if(param=='-p') plugin=arg;
        if(param=='-w') workspace=arg;
      }
    })
    if(!plugin) throw Error('No plugin name provided as parameter!');
    console.log('Add cds-plugin:',plugin);
    if(workspace)
      console.log('  workspace:',workspace);
    await addPlugin(plugin,workspace);
  })();

} else {

  module.exports = execCommand

}
