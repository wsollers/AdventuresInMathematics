import {schedule, selectCards, stats, levelCardIds, mayUnlock} from "./scheduler.mjs";

const $ = id => document.getElementById(id);
const DATA = new URL("./decks/ordered-fields/", import.meta.url);
const KEY = "aim-foundations-review-v1";
const FORMAT = "aim-foundations-progress";
const RATINGS = ["again", "hard", "good", "easy"];
const state = {
  cards: [], ids: new Set(), levels: [], coverage: new Map(), manifest: null,
  reviews: {}, unlocked: new Set(), seen: new Set(),
  current: null, flipped: false, completed: 0, loaded: false
};

async function json(path) {
  const response = await fetch(new URL(path, DATA), {cache: "no-cache"});
  if (!response.ok) throw new Error("Could not load " + path + " (HTTP " + response.status + ")");
  return response.json();
}

function announce(message) { $("study-status").textContent = message; }

function math(target, text) {
  target.textContent = String(text ?? "");
  if (typeof window.renderMathInElement === "function") {
    try {
      window.renderMathInElement(target, {
        delimiters: [
          {left: "$$", right: "$$", display: true},
          {left: "\\[", right: "\\]", display: true},
          {left: "$", right: "$", display: false},
          {left: "\\(", right: "\\)", display: false}
        ],
        throwOnError: false,
        trust: false,
        strict: "ignore"
      });
    } catch (error) { console.warn("Math rendering failed for a card", error); }
  }
}

function normalizedReview(value) {
  if (!value || typeof value !== "object") return null;
  const reviewCount = Number(value.reviewCount);
  const reviewed = Date.parse(value.reviewedAt);
  const due = Date.parse(value.dueAt);
  if (!Number.isSafeInteger(reviewCount) || reviewCount < 1 || reviewCount > 100000 ||
      !Number.isFinite(reviewed) || !Number.isFinite(due) || due < reviewed) return null;
  const intervalMinutes = Math.min(10_000_000, Math.max(1, Number(value.intervalMinutes) || 1));
  return {
    reviewCount,
    repetitions: Math.max(0, Math.min(100000, Math.floor(Number(value.repetitions) || 0))),
    lapses: Math.max(0, Math.min(100000, Math.floor(Number(value.lapses) || 0))),
    ease: Math.max(1.3, Math.min(3.2, Number(value.ease) || 2.5)),
    intervalMinutes,
    lastRating: RATINGS.includes(value.lastRating) ? value.lastRating : "good",
    reviewedAt: new Date(reviewed).toISOString(),
    dueAt: new Date(due).toISOString()
  };
}

function acceptProgress(input, merge = true) {
  if (!input || input.format !== FORMAT || input.version !== 1 ||
      !input.reviews || typeof input.reviews !== "object" || Array.isArray(input.reviews) ||
      !Array.isArray(input.unlocked)) throw new Error("Not a compatible Foundations progress backup.");
  const next = merge ? {...state.reviews} : {};
  let accepted = 0;
  for (const [id, value] of Object.entries(input.reviews)) {
    if (!state.ids.has(id)) continue;
    const record = normalizedReview(value);
    if (!record) continue;
    if (!next[id] || Date.parse(record.reviewedAt) > Date.parse(next[id].reviewedAt)) {
      next[id] = record;
      accepted += 1;
    }
  }
  const known = new Set(state.levels.map(level => level.id));
  const unlocked = merge ? new Set(state.unlocked) : new Set();
  for (const id of input.unlocked) if (known.has(id)) unlocked.add(id);
  state.reviews = next;
  state.unlocked = unlocked;
  return accepted;
}

function save() {
  const payload = {format: FORMAT, version: 1, unlocked: [...state.unlocked], reviews: state.reviews};
  try { localStorage.setItem(KEY, JSON.stringify(payload)); }
  catch { announce("Browser storage is unavailable. Export a backup before closing this tab."); }
}

function loadProgress() {
  state.unlocked = new Set(state.levels.length ? [] : []);
  const defaults = state.levelDefaults || [];
  for (const id of defaults) state.unlocked.add(id);
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) acceptProgress(JSON.parse(raw), true);
  } catch {
    announce("Stored progress was unreadable; a fresh local study session is available.");
  }
}

function filters() {
  return {
    mode: $("mode").value,
    stage: $("stage").value,
    type: $("type").value,
    available: levelCardIds(state.levels, state.unlocked),
    seen: state.seen,
    now: Date.now()
  };
}

function updateStats() {
  const s = stats(state.cards, state.reviews, levelCardIds(state.levels, state.unlocked));
  for (const field of ["total", "unlocked", "new", "due", "studied"]) {
    $("stat-" + field).textContent = String(s[field]);
  }
  $("level-count").textContent = state.unlocked.size + " / " + state.levels.length;
}

function levelList() {
  const parent = $("level-list");
  parent.replaceChildren();
  for (const level of state.levels) {
    const row = document.createElement("div");
    row.className = "level-row";
    const heading = document.createElement("h3");
    heading.textContent = level.title;
    const desc = document.createElement("p");
    desc.textContent = level.card_ids.length + " cards";
    const unlocked = state.unlocked.has(level.id);
    const ready = mayUnlock(level, state.unlocked);
    row.append(heading, desc);
    if (unlocked) {
      const label = document.createElement("span");
      label.className = "unlocked";
      label.textContent = "Unlocked";
      row.append(label);
    } else {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.disabled = !ready;
      btn.textContent = ready ? "Unlock level" : "Unlock prerequisites first";
      btn.setAttribute("aria-label", "Unlock " + level.title);
      btn.addEventListener("click", () => {
        state.unlocked.add(level.id);
        state.seen.clear();
        state.completed = 0;
        save();
        levelList();
        render();
        announce("Unlocked " + level.title + ".");
      });
      row.append(btn);
    }
    parent.append(row);
  }
}

function sourceInfo(card) {
  const wrap = $("source-content");
  wrap.replaceChildren();
  const src = card.source || {};
  const links = [
    {label: "Reference (TeX)", path: src.tex},
    {label: "Formalization (Lean)", path: src.lean}
  ];
  for (const entry of links) {
    if (typeof entry.path !== "string" || !entry.path) continue;
    const p = document.createElement("p");
    const link = document.createElement("a");
    link.href = "https://github.com/wsollers/AdventuresInMathematics/blob/main/" + entry.path;
    link.target = "_blank"; link.rel = "noopener noreferrer";
    link.textContent = entry.label;
    p.append(link); wrap.append(p);
  }
  if (src.declaration) {
    const p = document.createElement("p");
    p.textContent = "Declaration: " + src.declaration;
    wrap.append(p);
    const record = state.coverage.get(src.declaration);
    if (record) {
      const status = document.createElement("p");
      status.textContent = record.proof_status === "contains_sorry"
        ? "Lean proof: contains sorry; NOT formally verified."
        : "Lean declaration: no sorry detected here; this is not a compiler verification result.";
      wrap.append(status);
    }
  }
}

function currentQueue() { return selectCards(state.cards, state.reviews, filters()); }

function showAnswer() {
  if (!state.current || state.flipped) return;
  state.flipped = true;
  $("answer-section").hidden = false;
  math($("card-back"), state.current.back);
  const explanation = state.current.explanation || state.current.reference;
  $("explanation-wrap").hidden = !explanation;
  $("explanation-wrap").open = false;
  if (explanation) math($("card-explanation"), explanation);
  $("source-details").hidden = false;
  sourceInfo(state.current);
  $("reveal").hidden = true;
  if ($("mode").value === "browse") {
    $("browse-actions").hidden = false;
  } else {
    $("grade-panel").hidden = false;
  }
  announce($("mode").value === "browse" ? "Answer shown. Choose next card." : "Answer shown. Rate your recall.");
}

function nextCard() {
  state.current = null;
  state.flipped = false;
  render();
}

function finishCurrent(rating) {
  if (!state.current) return;
  const mode = $("mode").value;
  if (rating && (!state.flipped || mode === "browse")) return;
  if (rating) {
    state.reviews[state.current.id] = schedule(state.reviews[state.current.id], rating);
    state.completed += 1;
    save();
  }
  state.seen.add(state.current.id);
  nextCard();
}

function render() {
  if (!state.loaded) return;
  updateStats();
  const queue = currentQueue();
  state.current = queue[0] || null;
  state.flipped = false;
  $("answer-section").hidden = true;
  $("grade-panel").hidden = true;
  $("browse-actions").hidden = true;
  $("reveal").hidden = false;
  $("source-details").hidden = true;
  $("study-actions").hidden = !state.current;
  const title = state.current ? state.current.front : "No cards in this selection.";
  math($("card-front"), title);
  if (!state.current) {
    $("card-position").textContent = "Session finished";
    $("card-category").textContent = "";
    const mode = $("mode").value;
    const advice = mode === "due" ? "No reviews are due now." :
      mode === "new" ? "Nothing new is available. Check unlocked levels and prerequisites." :
      "Choose another stage or restart the session.";
    announce(advice + (state.completed ? " Reviewed this session: " + state.completed + "." : ""));
    const button = document.createElement("button");
    button.type = "button"; button.textContent = "Restart session";
    button.className = "restart";
    button.addEventListener("click", resetSession);
    $("card-front").append(document.createElement("p"), button);
    return;
  }
  const remaining = queue.length;
  $("card-position").textContent = remaining + " remaining in selection";
  $("card-category").textContent = "Stage " + state.current.stage + " · " + state.current.type;
  $("study-status").textContent = state.completed ? state.completed + " reviewed this session" : "";
}

function resetSession() {
  state.seen.clear(); state.completed = 0; state.current = null;
  render();
}

function handleKeyboard(event) {
  if (event.altKey || event.ctrlKey || event.metaKey ||
      ["INPUT","SELECT","TEXTAREA","BUTTON","SUMMARY"].includes(event.target?.tagName)) return;
  if (event.code === "Space") {
    if (state.current && !state.flipped) {event.preventDefault();showAnswer();}
  } else if (event.key.toLowerCase() === "n") {
    if (state.current) {event.preventDefault(); finishCurrent(null);}
  } else if (["1","2","3","4"].includes(event.key)) {
    const rating = RATINGS[Number(event.key)-1];
    if (state.current && state.flipped && $("mode").value !== "browse") {
      event.preventDefault();finishCurrent(rating);
    }
  }
}

async function exportProgress() {
  const blob = new Blob([JSON.stringify({
    format: FORMAT, version: 1,
    exportedAt: new Date().toISOString(),
    unlocked: [...state.unlocked], reviews: state.reviews
  }, null, 2)], {type: "application/json"});
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url; anchor.download = "aim-foundations-progress.json";
  anchor.click();
  setTimeout(() => URL.revokeObjectURL(url), 2000);
  announce("Downloaded a copy of your local review progress.");
}

async function importProgress(event) {
  const file = event.target.files?.[0];
  event.target.value = "";
  if (!file) return;
  if (file.size > 2_000_000) {announce("Backup file is too large."); return;}
  try {
    const payload = JSON.parse(await file.text());
    const count = acceptProgress(payload, true);
    save();
    levelList();
    resetSession();
    announce("Imported progress. Merged " + count + " newer card records.");
  } catch (error) {
    announce("Import failed: " + error.message);
  }
}

async function init() {
  try {
    const [manifest, unlocks, coverage] = await Promise.all([
      json("manifest.json"), json("unlock-levels.json"), json("coverage.json")
    ]);
    const arrays = await Promise.all(manifest.stages.map(stage => json(stage.file)));
    const cards = arrays.flat();
    const ids = new Set(cards.map(c => c.id));
    if (ids.size !== cards.length) throw new Error("The deck contains duplicate card IDs.");
    if (cards.length !== manifest.cards.length) throw new Error("The deck manifest disagrees with the card files.");
    for (let i=0;i<arrays.length;i++) {
      if (arrays[i].some((c,j) => c.id !== manifest.stages[i].card_ids[j])) {
        throw new Error("Stage " + i + " does not match the manifest order.");
      }
    }
    const assigned = new Set(unlocks.levels.flatMap(x => x.card_ids));
    if (assigned.size !== cards.length || cards.some(c => !assigned.has(c.id)))
      throw new Error("The curriculum unlock map is incomplete.");
    state.cards = cards; state.ids = ids; state.levels = unlocks.levels;
    state.levelDefaults = unlocks.default_unlocked || [];
    state.coverage = new Map((coverage.lean_declarations || []).map(x => [x.declaration, x]));
    state.manifest = manifest;
    for (const stage of manifest.stages) {
      const option = document.createElement("option");
      option.value = String(stage.stage);
      option.textContent = "Stage " + stage.stage + " — " + stage.title;
      $("stage").append(option);
    }
    for (const type of [...new Set(cards.map(c => c.type))].sort()) {
      const option = document.createElement("option");
      option.value = type;
      option.textContent = type[0].toUpperCase() + type.slice(1);
      $("type").append(option);
    }
    loadProgress();
    state.loaded = true;
    levelList();
    render();
    if ("serviceWorker" in navigator && location.protocol === "https:") {
      navigator.serviceWorker.register("./sw.js").catch(() => {});
    }
  } catch (error) {
    $("load-error").hidden = false;
    $("load-error").textContent = "Could not load the deck: " + error.message + ". Try reloading the page.";
    $("card-front").textContent = "The study deck is temporarily unavailable.";
    console.error(error);
  }
}

$("reveal").addEventListener("click", showAnswer);
$("skip").addEventListener("click", () => finishCurrent(null));
$("browse-next").addEventListener("click", () => finishCurrent(null));
for (const button of document.querySelectorAll("[data-grade]")) {
  button.addEventListener("click", () => finishCurrent(button.dataset.grade));
}
for (const id of ["mode","stage","type"]) {
  $(id).addEventListener("change", resetSession);
}
$("export-progress").addEventListener("click", exportProgress);
$("import-progress").addEventListener("change", importProgress);
$("reset-progress").addEventListener("click", () => {
  if (!window.confirm("Delete all progress stored in this browser for this deck? Export a backup first if you need it.")) return;
  state.reviews = {};
  state.unlocked = new Set(state.levelDefaults);
  save(); levelList(); resetSession();
  announce("Local progress reset.");
});
document.addEventListener("keydown", handleKeyboard);
init();
