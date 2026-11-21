# Round 3 (icons and the empty office): agreed result

Sources: r3x-{opus,sol,neon}.md and r3x-consensus-{opus,sol,neon}.md. All
three members proposed the same ranking and the same blocking lists.

- **Ranking: 1 E. Rooms and Stations, 2 A. The Desk, 3 C. The Paperwork
  Desk, 4 G. The Existing UI, Modernised.** (E and A tie on scores; two of
  three members put E first, and Sol joined E first in consensus.)
- Review scores (/10): opus A 8.5, C 8, E 8.5, G 7.5; sol A 8.5, C 8, E 8.5,
  G 7.5; neon A 9, C 8.5, E 9, G 8.
- The operator silhouette is gone from every view of A, C and E (G never had
  one); the space was left empty; all three members say the empty office
  reads as eerie, as Alex wanted.

## Question for Alex (non-blocking until he answers)

Do these count as "the person"?
- People in event pictures: the portrait on C's WATCH memo; the two figures
  in E's WATCH memo art.
- Pip's small control icons: Staff (`ui_staff_management`, three silhouettes
  at a table) and Hire (`button_hire_normal`, head and shoulders).
If yes, the fix is cheap: drop the memo images and draw figure-free Staff and
Hire icons. Until then, none of these changes.

## Blocking fixes

### A. The Desk
1. Plan plate (home, home-m1, plan, watch; and the Plan screen title if it
   carries the icon): replace `action_policy_audit_requirement` (a near-twin of
   Safety Audit) with Pip's calendar `ui_config_date`.
2. Read the Literature (door view, Scouting folder): replace the research flask
   `research.png` (it already means the Research balance) with
   `resource_papers_small`.
3. In-tray plate (home, home-m1, plan): replace the open safe
   `ui_save_archive` with a new inbox-tray icon in the same style, listed as
   "new, needs art".

### C. The Paperwork Desk
1. Form A-20 (plan view, item column): each row carries its own play's icon,
   the same as in the door view (Go to Meetups, Read the Literature, Post
   Online ...), not the Scouting radar.
2. Financing (`take_loan.png`) and Work Your Connections (`network.png`) in
   actions, door and plan: seat them on the same dark square tile as the other
   icons, or swap to the framed `action_funding_loan` and
   `action_publicity_network`.

### E. Rooms and Stations
1. Travel & Conferences (actions and door views): replace the globe-handshake
   `action_policy_international_cooperation` with a suitcase in the same style
   ("new, needs art").
2. Plan (plan view and `?view=plan&open=x8`): give the fixed column-heading row
   the same right gutter as the scrolling rows (22px) so Hours, Cost and Order
   line up with their headings.

### G. The Existing UI, Modernised
1. Left rail (every view): Staff -- replace the smiley `resource_morale` with
   `ui_staff_management`; Ledger -- replace the gavel
   `ui_governance_oversight` with `ui_budget_finance`, and move the Financing
   action (actions view) to `action_funding_loan` so the two stay distinct.
2. Publish Safety Paper (actions view): replace `open_source_release` (the game
   uses it for Open Source Tools) with `paper.png`.
3. Plan (plan view and `?view=plan&expand=read`): when the list scrolls, give
   the header and Total rows the same scrollbar gutter so the columns line up,
   and widen the play column so "x6" never runs into "6 plan".

## Non-blocking (agreed)

- The "new, needs art" icons are flatter than Pip's painted ones (most in G).
- Pip's calendar icon shows a fixed "17".
- Fundraising and Financing money bags look alike; a distinct Fundraising
  icon in a later art pass.
- Pip's round medallion icons mixed with his square tiles in a few action
  cards (A, E).
