import test from "node:test";
import assert from "node:assert/strict";
import {gradeRequest} from "../../server/grader.mjs";
const cards = [{id:"one",front:"State commutativity",back:"a + b = b + a"}];
const submission = (body = {cardId:"one",text:"a plus b equals b plus a",image:null}, origin="https://example.test") => new Request("https://example.test/api/grade", {method:"POST",headers:{origin,"content-type":"application/json"},body:JSON.stringify(body)});
test("grader checks server card, accepts image, disables storage and normalizes suggested rating", async () => {
  let payload;
  const result = await gradeRequest(submission({cardId:"one",text:"",image:"data:image/png;base64,AAAA"}),{OPENAI_API_KEY:"test-secret"},cards,async (url,options) => {
    payload = JSON.parse(options.body);
    return Response.json({status:"completed",output:[{content:[{type:"output_text",text:JSON.stringify({verdict:"partial",rating:"easy",reading:"a + b",feedback:"Missing equality",missing:"Include b + a"})}]}]});
  });
  assert.equal(result.status,200);
  assert.equal((await result.json()).rating,"hard");
  assert.equal(payload.store,false);
  assert.equal(payload.input[0].content[1].type,"input_image");
  assert.match(payload.input[0].content[0].text,/a \+ b = b \+ a/);
  assert.equal(result.headers.get("cache-control"),"no-store");
});
test("grader rejects cross-origin, empty and unknown-card requests without calling provider", async () => {
  const noCall = () => { throw new Error("Provider must not be called"); };
  const env={OPENAI_API_KEY:"test"};
  assert.equal((await gradeRequest(submission(undefined,"https://other.test"),env,cards,noCall)).status,403);
  assert.equal((await gradeRequest(submission({cardId:"one",text:"",image:null}),env,cards,noCall)).status,400);
  assert.equal((await gradeRequest(submission({cardId:"invented",text:"answer",image:null}),env,cards,noCall)).status,400);
  assert.equal((await gradeRequest(submission(),{},cards,noCall)).status,503);
});
test("provider failures and incomplete assessments never become grades", async () => {
  for (const response of [new Response("private provider details",{status:401}),Response.json({status:"incomplete"}),Response.json({status:"completed",output:[]})]) {
    const result=await gradeRequest(submission(),{OPENAI_API_KEY:"test"},cards,async()=>response);
    assert.equal(result.status,502);
    assert.equal((await result.json()).verdict,undefined);
  }
});
