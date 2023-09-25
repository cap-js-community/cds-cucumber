const fs = require('node:fs');
const tar = require('tar-stream');
const zlib = require('zlib');

const extract = tar.extract();

let files = {};
let count = 0;

const dirs = [ 'test-resources', 'resources' ];

extract.on('entry', function(header, stream, next) {
  let filename = header.name;
  if(count>0 && count%1000==0)
    console.log(count,filename);
  if(filename.indexOf('/resources/')==-1 && filename.indexOf('/test-resources/')==-1
      && !filename.startsWith('resources/') && !filename.startsWith('test-resources/')) {
    filename="";
  } else {
    let parts = filename.split('/');
    while(parts.length>0) {
      if(dirs.includes(parts[0])) break;
      parts=parts.slice(1);
    }
    if(parts.length==0) filename=undefined;
    else filename=parts.join('/');
  }
  if(filename && !files[filename]) {
    files[filename]=[];
    count++;
  }
  stream.on('data', function(chunk) {
    if(filename) files[filename].push(chunk);
  });

  stream.on('end', function() {
    next();
  });

  stream.resume();
});

if(require.main == module) {
  let { argv } = process;
  loadTGZ(argv[2]);
} else {
  module.exports = loadTGZ;
}

function loadTGZ(filename) {
  return new Promise((resolve, reject) => {
    fs.createReadStream(filename)
      .pipe(zlib.createGunzip())
      .pipe(extract);
    extract.on('finish', function() {
      files.done=true;
      resolve(files);
    });
    
  })
}

module.exports = loadTGZ;
