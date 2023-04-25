const { spawn } = require('child_process');
const { env, cwd } = require('process');
const path = require('path');

async function startProcess(application, subdir=undefined) {
  if(env.PORT) return {pid:0};
  let isJava = application === 'java';
  let isNode = application === 'node';
  let rootdir = cwd();
  console.log('rootdir', rootdir)
  let appdir = subdir?path.join(rootdir, subdir):rootdir;
  console.log('appdir', appdir)
  let port = env.CDS_SERVICE_PORT || 0;

  let command;
  let args;
  let options = { cwd: appdir };

  if(isJava) {
    command = 'mvn';
    args = ['clean', 'spring-boot:run'];
  } else if(isNode) {
    command = 'npx';
    args = ['cds', env.CDS_COMMAND||'run'];
  } else {
    command = 'npx';
    args = ['cds', env.CDS_COMMAND||'run', application];
  }

  options.env = Object.assign( { PORT: port }, env );
  var cdsProcess = spawn(command, args, options);
  console.log('pid',cdsProcess.pid)
  cdsProcess.scriptOutput = '';

  if(cdsProcess.stdout) {
    cdsProcess.stdout.setEncoding('utf8');
    cdsProcess.stdout.on('data', function(data) {
      console.log(data)
      cdsProcess.scriptOutput+=data.toString();
    });
  }

  if(cdsProcess.stderr) {
    cdsProcess.stderr.setEncoding('utf8');
    cdsProcess.stderr.on('data', function(data) {
      console.log(data)
      cdsProcess.scriptOutput+=data.toString();
    });
  }

  cdsProcess.on('close', function(exitCode) {
    console.log('close',exitCode);
    cdsProcess.exitCode=exitCode;
  });

  cdsProcess.on('exit', function(exitCode) {
    console.log('exit',exitCode);
    cdsProcess.exitCode=exitCode;
  });

  let lookupString;
  if(isJava)
    lookupString = 'Tomcat started on port(s)';
  else
    lookupString = '[cds] - launched at ';
  let loops = 2000;
  for(var i=0; i<loops; i++) {
    if(cdsProcess.exitCode !== null) {
      throw Error(`Command '${command} ${args.join(" ")}' terminated with exit code ${cdsProcess.exitCode}!`);
    }
    process.stdout.write('.');
    await sleep(500);
    if(cdsProcess.scriptOutput.indexOf(lookupString) != -1) {
      process.stdout.write('\n');
      break;
    }
    await sleep(100);
  }

  if(isJava) {
    let re = /Tomcat started on port\(s\)\: (\d*) \(http\)/;
    let matched = cdsProcess.scriptOutput.match(re);
    cdsProcess.hostname = 'localhost';
    cdsProcess.port = matched[1];
    cdsProcess.signal = 'SIGTERM';
  } else {
    let re = /server listening on { url: \'http\:\/\/(.*):(.*)\'/;
    let matched = cdsProcess.scriptOutput.match(re);
    cdsProcess.hostname = matched[1];
    cdsProcess.port = matched[2];
    cdsProcess.signal = 'SIGUSR2';
  }

  console.log(`Application url: http://${cdsProcess.hostname}:${cdsProcess.port}`);

  return cdsProcess;
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

module.exports = startProcess;
