VERDICT: CHANGES NEEDED

The operator silhouette is gone from every view in A, C and E, and G never had one. The empty space has been left empty, and the office now reads as eerie, the way Alex wanted: an empty chair at a lit CRT (A, C), and an empty mezzanine floor (E). Icons are Pip's own in almost every place.

Two icons still do not match their buttons, and Alex has already rejected icons like that once:
- E's Travel & Conferences icon.
- A's Plan icon.

Everything else is non-blocking.

I checked every render at full size and made contact sheets of each concept's icon files (`assets/icons/`) to judge what each icon shows.

| Concept | Icons match | Person-free | Score |
|---|---|---|---|
| E. Rooms and Stations | n (1 mismatch) | y | 8.5 |
| A. The Desk | n (1 mismatch) | y | 8.5 |
| C. The Paperwork Desk | y | y | 8 |
| G. The Existing UI, Modernised | y | y | 7.5 |

## Ranking
1. **E**: the eeriest home (an empty floor under hanging lamps). Icons are one size per place on matching dark tiles, and the stations read more clearly with icons.
2. **A**: the empty chair and desk at the CRT is a strong image. Icons sit consistently top-right on cards and left on plates.
3. **C**: icons are clean on every desk object, card and form row. The desk band is now uncluttered.
4. **G**: icons are tidy and consistent, and the new art is labelled clearly. It is still the least diegetic of the four.

## Blocking fixes

### E
1. **Travel & Conferences has the wrong icon.** In E/actions.png and E/door.png (right column, row 1) it uses `action_policy_international_cooperation`, a globe with a handshake. That shows a policy, not travel. The council already ruled this exact icon a mismatch on G's Travel row in Round 2 (r2s-agreed.md, G item 1). Fix: use the suitcase ("new, needs art"), as A, C and G do.

### A
1. **The Plan icon shows an audit.** On the home, plan and watch rack, the PLAN plate uses `action_policy_audit_requirement`, a clipboard with a stamp and a magnifier. Safety Audit's card uses `employee_role_auditor`, a magnifier on a checklist. The two look almost the same, and neither says "the month's plan". Fix: use Pip's `ui_config_date` calendar, which C and E use for their plan objects. Use it on the plate and on the Plan CRT title.

### C, G
None.

## Non-blocking
1. **Small figures that Alex may count as people:**
   - `ui_staff_management` (three silhouettes around a table) on A Staff, C Staff File and E Lab Floor.
   - `button_hire_normal` (a head-and-shoulders pictogram) on Hire Staff in all four.
   - Event pictures: C's memo portrait and E's memo image of two men at a window.

   These are Pip's own art, not the operator outline Alex rejected. Ask Alex once whether these count; G already avoided `ui_staff_management`.
2. **Mixed icon shapes.** Pip's root icons (`paper.png`, `compute.png`, `money.png` and so on) are round medallions, while the `_64` icons are square tiles. In A's action cards (Publish Safety Paper, Purchase Compute) and E's (Publish Safety Paper), a round medallion sits beside square tiles. It is a small style mismatch, so a square tile version would be better.
3. **Flat new icons.** The "new, needs art" icons are flatter than Pip's painted ones; G's flat orange glyphs stand out most. The designers have already marked them for an art pass.

## Disk report
I wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r3x-opus.md` and four icon contact sheets (`icons_A.png`, `icons_C.png`, `icons_E.png`, `icons_G.png`, about 1 MB) in my scratchpad. The whole scratchpad (about 19 MB, `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can be deleted.
