// Ephemeral answer workspace: never stored or included in progress exports.
export function setupResponse(document, window) {
  const $ = id => document.getElementById(id);
  const pad = $("answer-pad"), text = $("answer-text"), button = $("speak-answer");
  const status = message => { $("voice-status").textContent = message; };
  let pointer = null, stroke = null, points = [], recognition = null;
  const Speech = window.SpeechRecognition || window.webkitSpeechRecognition;
  const idle = Speech ? "Tap Speak answer and allow microphone access, or use keyboard dictation." :
    "Voice recognition is unavailable in this browser. Use your tablet keyboard’s microphone in the text field.";
  button.disabled = !Speech;
  status(idle);

  function endStroke() {
    if (pointer !== null && pad.hasPointerCapture?.(pointer)) pad.releasePointerCapture(pointer);
    pointer = null; stroke = null; points = [];
  }
  function point(event) {
    const rect = pad.getBoundingClientRect();
    if (!rect.width || !rect.height) return;
    const x = Math.max(0, Math.min(1000, (event.clientX - rect.left) * 1000 / rect.width));
    const y = Math.max(0, Math.min(500, (event.clientY - rect.top) * 500 / rect.height));
    points.push(`${x},${y}`);
    // A repeated initial point makes pen taps visible as round dots.
    stroke.setAttribute("points", points.length === 1 ? `${points[0]} ${x + .01},${y}` : points.join(" "));
  }
  pad.addEventListener("pointerdown", event => {
    if (pointer !== null || event.button !== 0 || (event.pointerType === "touch" && $("pen-only").checked)) return;
    event.preventDefault();
    pointer = event.pointerId;
    stroke = document.createElementNS("http://www.w3.org/2000/svg", "polyline");
    pad.append(stroke);
    pad.setPointerCapture?.(pointer);
    point(event);
  });
  pad.addEventListener("pointermove", event => {
    if (event.pointerId !== pointer) return;
    event.preventDefault();
    const samples = event.getCoalescedEvents?.() || [];
    for (const sample of samples.length ? samples : [event]) point(sample);
  });
  for (const type of ["pointerup", "pointercancel", "lostpointercapture"]) {
    pad.addEventListener(type, event => { if (event.pointerId === pointer) endStroke(); });
  }
  $("undo-ink").addEventListener("click", () => { endStroke(); pad.lastElementChild?.remove(); });
  $("clear-ink").addEventListener("click", () => { endStroke(); pad.replaceChildren(); });

  function stop() {
    const active = recognition;
    recognition = null; // Ignore late events after navigation, edits or microphone stop.
    if (active) { try { active.abort(); } catch {} }
    button.textContent = "Speak answer";
    button.setAttribute("aria-pressed", "false");
    text.readOnly = false;
    if (active) status("Microphone stopped. You can edit your answer or speak again.");
  }
  button.addEventListener("click", () => {
    if (recognition) { stop(); return; }
    if (!Speech) return;
    try {
      const session = new Speech();
      recognition = session;
      const base = text.value.trim();
      session.lang = "en-US";
      session.continuous = true;
      session.interimResults = true;
      session.onresult = event => {
        if (recognition !== session) return;
        const words = Array.from(event.results, result => result[0].transcript.trim()).join(" ");
        text.value = [base, words].filter(Boolean).join(" ");
      };
      session.onerror = event => {
        if (recognition !== session) return;
        stop();
        status(event.error === "not-allowed" || event.error === "service-not-allowed"
          ? "Microphone access was denied. Allow it in browser settings, or use keyboard dictation."
          : "Voice recognition stopped. Try again, or use keyboard dictation.");
      };
      session.onend = () => { if (recognition === session) stop(); };
      button.textContent = "Stop microphone";
      button.setAttribute("aria-pressed", "true");
      text.readOnly = true;
      status("Listening… Say your answer, then tap Stop microphone.");
      session.start();
    } catch {
      stop();
      status("Could not start voice recognition. Try keyboard dictation in the text field.");
    }
  });
  $("clear-text").addEventListener("click", () => { stop(); text.value = ""; });
  document.addEventListener("visibilitychange", () => { if (document.hidden) stop(); });
  window.addEventListener("pagehide", stop);
  return {
    stop,
    async snapshot() {
      stop(); endStroke();
      const answer = text.value.trim();
      if (!pad.children.length) return {text: answer, image: null};
      const copy = pad.cloneNode(true);
      copy.setAttribute("xmlns", "http://www.w3.org/2000/svg");
      copy.setAttribute("width", "1000"); copy.setAttribute("height", "500");
      for (const line of copy.children) {
        line.setAttribute("fill", "none"); line.setAttribute("stroke", "#111");
        line.setAttribute("stroke-width", "3"); line.setAttribute("stroke-linecap", "round");
        line.setAttribute("stroke-linejoin", "round");
      }
      const source = new window.XMLSerializer().serializeToString(copy);
      const url = window.URL.createObjectURL(new window.Blob([source], {type:"image/svg+xml"}));
      try {
        const image = new window.Image();
        await new Promise((resolve, reject) => { image.onload = resolve; image.onerror = reject; image.src = url; });
        const canvas = document.createElement("canvas"); canvas.width = 1000; canvas.height = 500;
        const context = canvas.getContext("2d");
        context.fillStyle = "#fff"; context.fillRect(0, 0, 1000, 500); context.drawImage(image, 0, 0);
        return {text: answer, image: canvas.toDataURL("image/png")};
      } finally { window.URL.revokeObjectURL(url); }
    },
    reset() { stop(); endStroke(); pad.replaceChildren(); text.value = ""; status(idle); }
  };
}
