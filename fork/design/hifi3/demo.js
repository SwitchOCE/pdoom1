function typeDate(withSound) {
  const line = document.getElementById("dlLine"), btn = document.getElementById("dlPlay"), note = document.getElementById("dlNote");
  const text = MONTHS[mi];
  if (typing) return;
  if (withSound && window.TypeSound && TypeSound.busy && TypeSound.busy()) return;  // the last play's tail is still sounding
  note.textContent = "";
  let times = null;
  if (reduced()) {
    line.textContent = text;
    if (!withSound) return;
    typing = true; btn.disabled = true;
    const free = () => { btn.disabled = false; typing = null; };
    times = playDateline(text, { onDone: free });
    if (!times) { note.textContent = "This browser cannot play the sound."; free(); }
    return;
  }
  btn.disabled = true;
  line.innerHTML = '<span id="dlTxt"></span><span class="cur"></span>';
  const txt = document.getElementById("dlTxt");
  const done = () => { line.textContent = text; btn.disabled = false; typing = null; };
  typing = true;
  if (withSound) times = playDateline(text, { onChar: (i) => { txt.textContent = text.slice(0, i + 1); }, onDone: done });
  if (!times) {
    if (withSound) note.textContent = "This browser cannot play the sound; showing the typing only.";
    [...text].forEach((ch, i) => setTimeout(() => { txt.textContent = text.slice(0, i + 1); }, 120 + i * 95));
    setTimeout(done, 120 + text.length * 95 + 600);
  }
}
document.getElementById("dlPlay").onclick = () => typeDate(true);
