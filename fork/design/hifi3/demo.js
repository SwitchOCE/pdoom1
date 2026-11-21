function typeDate(withSound) {
  const line = document.getElementById("dlLine"), btn = document.getElementById("dlPlay"), note = document.getElementById("dlNote");
  const text = MONTHS[mi];
  if (typing) return;
  note.textContent = "";
  let times = null;
  if (reduced()) {
    line.textContent = text;
    times = withSound ? playDateline(text, {}) : null;
    if (withSound && !times) note.textContent = "This browser cannot play the sound.";
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
