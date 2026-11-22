// Build a self-contained Sites Worker; source assets stay reviewable in the math repo.
import fs from "node:fs";
import path from "node:path";
const checkout = process.argv[2];
if (!checkout) throw new Error("Usage: node flashcards/server/build-site.mjs <Sites checkout>");
const root = path.resolve(import.meta.dirname, "..");
const web = path.join(root,"web");
const decks = ["ordered-fields", "calculus", "geometry"];
const cards = [];
const assets = {};
const mime = file => file.endsWith(".css") ? "text/css" : file.endsWith(".json") ? "application/json" : file.endsWith(".html") ? "text/html" : "text/javascript";
for (const file of fs.readdirSync(web).filter(file => /\.(html|css|mjs|js)$/.test(file))) {
  assets["/" + file] = {body:fs.readFileSync(path.join(web,file),"utf8"),type:mime(file)};
}
assets["/"] = assets["/index.html"];
assets["/decks/curriculum.json"] = {body:fs.readFileSync(path.join(root,"content/curriculum.json"),"utf8"),type:"application/json"};
for (const deck of decks) {
  const data = path.join(root,"content",deck);
  for (const file of fs.readdirSync(data).filter(file => file.endsWith(".json"))) {
    assets["/decks/" + deck + "/" + file] = {body:fs.readFileSync(path.join(data,file),"utf8"),type:"application/json"};
  }
  const manifest = JSON.parse(fs.readFileSync(path.join(data,"manifest.json"),"utf8"));
  cards.push(...manifest.stages.flatMap(stage => JSON.parse(fs.readFileSync(path.join(data,stage.file),"utf8"))));
}
for (const file of ["assets/css/site.css","assets/js/site.js"]) {
  const saved = path.join(checkout,"assets",file);
  if (!fs.existsSync(saved)) {
    fs.mkdirSync(path.dirname(saved),{recursive:true});
    fs.copyFileSync(path.join(checkout,"dist",file),saved);
  }
  assets["/" + file] = {body:fs.readFileSync(saved,"utf8"),type:mime(file)};
}
const server = fs.readFileSync(path.join(root,"server/grader.mjs"),"utf8");
const worker = `${server}\nconst assets=${JSON.stringify(assets)};\nconst cards=${JSON.stringify(cards)};\nexport default {async fetch(request,env) {
  const url=new URL(request.url);
  if(url.pathname === '/api/grade') return gradeRequest(request,env,cards);
  const asset=assets[url.pathname];
  if(!asset || !['GET','HEAD'].includes(request.method)) return new Response('Not found',{status:404});
  return new Response(request.method === 'HEAD' ? null : asset.body,{headers:{'content-type':asset.type+'; charset=utf-8','cache-control':'private, no-store'}});
}};`;
fs.mkdirSync(path.join(checkout,"dist/server"),{recursive:true});
fs.writeFileSync(path.join(checkout,"dist/server/index.js"),worker);
const hostingPath = path.join(checkout,".openai/hosting.json");
const hosting = JSON.parse(fs.readFileSync(hostingPath,"utf8"));
delete hosting.static;
fs.writeFileSync(hostingPath,JSON.stringify(hosting,null,2)+"\n");
fs.mkdirSync(path.join(checkout,"dist/.openai"),{recursive:true});
fs.writeFileSync(path.join(checkout,"dist/.openai/hosting.json"),JSON.stringify(hosting,null,2)+"\n");
console.log("Built private flashcard grading Worker.");
