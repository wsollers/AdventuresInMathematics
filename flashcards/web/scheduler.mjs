/* Deterministic, browser-independent review scheduling. No network or storage here. */
export const MINUTE = 60_000;
export const DAY = 1_440 * MINUTE;
export const RATINGS = Object.freeze(["again", "hard", "good", "easy"]);

function finitePositive(value, fallback) {
  const n = Number(value);
  return Number.isFinite(n) && n > 0 ? n : fallback;
}

export function schedule(previous, rating, now = Date.now()) {
  if (!RATINGS.includes(rating)) throw new RangeError("Unknown rating");
  if (!Number.isFinite(now)) throw new RangeError("Invalid review time");
  const before = previous && typeof previous === "object" ? previous : {};
  const count = Math.max(0, Math.floor(Number(before.reviewCount) || 0));
  const priorInterval = finitePositive(before.intervalMinutes, 0);
  let ease = Math.min(3.2, Math.max(1.3, finitePositive(before.ease, 2.5)));
  let repetitions = Math.max(0, Math.floor(Number(before.repetitions) || 0));
  let lapses = Math.max(0, Math.floor(Number(before.lapses) || 0));
  let intervalMinutes = 1;

  if (rating === "again") {
    repetitions = 0;
    lapses += 1;
    ease = Math.max(1.3, ease - 0.2);
    intervalMinutes = 1;
  } else if (rating === "hard") {
    repetitions += 1;
    ease = Math.max(1.3, ease - 0.15);
    intervalMinutes = count === 0 ? 10 : Math.max(10, Math.ceil(priorInterval * 1.2));
  } else if (rating === "good") {
    repetitions += 1;
    intervalMinutes = count === 0 ? 1_440 : Math.max(1_440, Math.ceil(priorInterval * ease));
  } else {
    repetitions += 1;
    ease = Math.min(3.2, ease + 0.15);
    intervalMinutes = count === 0 ? 5_760 : Math.max(5_760, Math.ceil(priorInterval * (ease + 0.5)));
  }
  // Dates remain ISO strings so local backup files are portable.
  return {
    reviewCount: count + 1,
    repetitions, lapses, ease, intervalMinutes,
    lastRating: rating,
    reviewedAt: new Date(now).toISOString(),
    dueAt: new Date(now + intervalMinutes * MINUTE).toISOString()
  };
}

export function isDue(record, now = Date.now()) {
  if (!record || !record.reviewCount) return false;
  const due = Date.parse(record.dueAt);
  return Number.isFinite(due) && due <= now;
}

export function prerequisitesMet(card, reviews) {
  return (card.prerequisites || []).every(id => Number(reviews[id]?.reviewCount) > 0);
}

export function mayUnlock(level, unlocked) {
  return (level.requires || []).every(id => unlocked.has(id));
}

export function levelCardIds(levels, unlocked) {
  const set = new Set();
  for (const level of levels) if (unlocked.has(level.id)) {
    for (const id of level.card_ids) set.add(id);
  }
  return set;
}

export function selectCards(cards, reviews, options = {}) {
  const { mode = "new", stage = "all", type = "all", available = new Set(), seen = new Set(), now = Date.now() } = options;
  return cards.filter(card => {
    if (stage !== "all" && card.stage !== Number(stage)) return false;
    if (type !== "all" && card.type !== type) return false;
    if (seen.has(card.id)) return false;
    if (mode === "browse") return true;
    if (!available.has(card.id)) return false;
    if (mode === "new") return !reviews[card.id]?.reviewCount && prerequisitesMet(card, reviews);
    if (mode === "due") return isDue(reviews[card.id], now);
    if (mode === "practice") return prerequisitesMet(card, reviews);
    return false;
  });
}

export function stats(cards, reviews, available, now = Date.now()) {
  const unlocked = cards.filter(c => available.has(c.id));
  return {
    total: cards.length,
    unlocked: unlocked.length,
    studied: unlocked.filter(c => Number(reviews[c.id]?.reviewCount) > 0).length,
    due: unlocked.filter(c => isDue(reviews[c.id], now)).length,
    new: unlocked.filter(c => !reviews[c.id]?.reviewCount && prerequisitesMet(c, reviews)).length
  };
}
