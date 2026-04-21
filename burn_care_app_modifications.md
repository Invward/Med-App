# Burn Care App — Feature Modifications Spec

> **For the coding agent:** Implement all sections below in full. Each section describes the feature goal, the UX flow, the logic/rules, and the data/form structure. Follow the medical accuracy notes carefully — they are not optional. Burn detection / classification is already implemented — do not touch it.

---

## 0. Design & Aesthetic Direction

- **Palette:** Clean medical white (`#FAFAFA`) base, calm teal-blue primary (`#0E7C86`), urgent red (`#D94F3D`) for emergencies only. Avoid red on non-emergency screens.
- **Typography:** Humanist sans-serif (e.g., `Nunito` or `DM Sans`). Readable at small sizes. Heavier weight for headings.
- **Tone:** Clinical calm. Reassuring, never alarming unless medically necessary. Plain language — no jargon.
- **Accessibility:** WCAG 2.1 AA minimum. Touch targets ≥ 44×44px. Support dynamic text size on mobile.

---

## 1. Internationalisation — English / French Language Support

### Language Toggle Placement
- Place a **language toggle button** in the **top-right corner of every screen**, including the disclaimer screen.
- Render it as a compact pill/chip: **`EN | FR`** with the active language highlighted.
- On the disclaimer screen specifically, place it in the top-right corner above the disclaimer card so the user can switch language before reading and agreeing.

### Behavior
- Switching language updates **all UI text instantly** without reloading the screen or losing state.
- Persist the chosen language to local storage — remembered across sessions.
- Default language: detect device locale. If `fr` → French. Otherwise → English.

### Implementation
- Use a standard i18n library appropriate for the framework (e.g., `i18next` for React/Vue, `flutter_localizations` for Flutter).
- All user-facing strings must live in translation files — **no hardcoded UI text anywhere**.
- Provide two translation files: `en.json` and `fr.json`.
- Every string referenced in this spec must have both an English and a French entry. French strings are provided inline below where relevant; the agent must translate the rest consistently.

### Key Translated Strings (use these exactly)

| Key | English | French |
|---|---|---|
| `lang.toggle` | `EN \| FR` | `EN \| FR` |
| `disclaimer.title` | Medical Disclaimer | Avertissement Médical |
| `disclaimer.agree` | I Understand & Agree | Je Comprends & J'accepte |
| `disclaimer.emergency_line` | For emergencies, call your local emergency number immediately. | En cas d'urgence, appelez immédiatement votre numéro d'urgence local. |
| `nav.first_aid` | First Aid | Premiers Secours |
| `nav.nearby` | Nearby Help | Aide à Proximité |
| `nav.followup` | Follow-Up | Suivi |
| `nav.about` | About | À Propos |
| `emergency.heading` | Seek Emergency Care Immediately | Consultez les Urgences Immédiatement |
| `emergency.call` | Call Emergency Services | Appeler les Secours |
| `emergency.find_hospital` | Find Nearest Hospital | Trouver l'Hôpital le Plus Proche |
| `firstaid.immediate.title` | Immediate Steps | Gestes Immédiats |
| `firstaid.cool` | Cool the burn under lukewarm running water for 10 to 20 minutes. | Refroidir sous eau tiède courante pendant 10 à 20 minutes. |
| `firstaid.remove` | Carefully remove clothing and jewellery around the burn. | Retirer délicatement vêtements et bijoux autour de la brûlure. |
| `firstaid.cover` | Cover with a sterile non-stick dressing. | Protéger avec un pansement stérile non adhérent. |
| `firstaid.no_pierce` | Do not pierce blisters. | Ne pas percer les phlyctènes (cloques). |
| `firstaid.no_products` | Do not apply toothpaste, butter, oil, or any non-prescribed product. | Ne pas appliquer de dentifrice, beurre, huile ou tout produit non prescrit. |
| `firstaid.handwash` | Wash hands thoroughly before and after every dressing change. | Se laver les mains avant et après chaque changement de pansement. |
| `firstaid.hydration` | Stay well hydrated — drink plenty of water throughout healing. | Restez bien hydraté(e) — buvez suffisamment d'eau tout au long de la guérison. |
| `firstaid.worsen` | If the burn worsens or you notice abnormal signs, consult a doctor. | En cas d'aggravation ou de signes anormaux, consultez un médecin. |
| `firstaid.no_touch` | Do not manipulate the wound unnecessarily. | Ne pas manipuler la plaie inutilement. |
| `followup.infection` | Possible infection — please consult a doctor. | Infection probable — veuillez consulter un médecin. |
| `followup.no_infection` | No signs of infection detected. Continue your care routine. | Aucun signe d'infection détecté. Continuez votre routine de soins. |
| `alert.dressing` | Time to change your burn dressing. Wash hands first. | Il est temps de changer votre pansement. Lavez-vous les mains d'abord. |
| `alert.medication` | Time to apply your prescribed treatment. | Il est temps d'appliquer votre traitement prescrit. |
| `alert.checkin` | Don't forget your daily burn check-in. | N'oubliez pas votre suivi quotidien de brûlure. |

---

## 2. Disclaimer Screen (App Launch)

**Trigger:** Shown every time the app is opened cold, before any content is accessible.

### UI
- Full-screen modal / splash screen — **not dismissible by tapping outside**.
- Language toggle (`EN | FR`) fixed in top-right corner.
- App logo / name centred at top.
- Disclaimer text block — scrollable if it overflows the screen.
- Single CTA button: **"I Understand & Agree"** (`disclaimer.agree`) — disabled until the user scrolls to the bottom of the text.
- Small secondary line below button (`disclaimer.emergency_line`).

### Disclaimer Text

**English:**
> **Medical Disclaimer**
>
> This application is designed to provide general first-aid guidance and educational information about burn injuries only. It is **not** a substitute for professional medical advice, diagnosis, or treatment.
>
> Always seek the advice of a qualified healthcare provider for any medical condition. In case of severe burns, chemical burns, electrical burns, burns covering large body areas, or burns on the face, hands, feet, genitals, or major joints — **call emergency services immediately**.
>
> The developers of this application accept no liability for decisions made based on the information provided herein.

**French:**
> **Avertissement Médical**
>
> Cette application est conçue pour fournir des conseils de premiers secours généraux et des informations éducatives sur les brûlures uniquement. Elle **ne remplace pas** l'avis, le diagnostic ou le traitement d'un professionnel de santé.
>
> Consultez toujours un professionnel de santé qualifié pour tout problème médical. En cas de brûlures graves, chimiques, électriques, étendues, ou touchant le visage, les mains, les pieds, les organes génitaux ou les articulations principales — **appelez immédiatement les secours**.
>
> Les développeurs de cette application déclinent toute responsabilité pour les décisions prises sur la base des informations fournies.

### Behavior
- Tapping **"I Understand & Agree"** → dismiss disclaimer → show Main Interface.
- Store agreement flag in local storage — reshow on every cold open.

---

## 3. Main Interface

**Layout:** Bottom navigation bar (mobile) or sidebar (tablet/web).

| Tab | Icon | Label EN | Label FR |
|---|---|---|---|
| 🔥 Burn Detection | flame | *(already implemented — keep as-is)* | *(already implemented)* |
| 💡 First Aid | lightbulb | First Aid | Premiers Secours |
| 🏥 Nearby Help | map pin | Nearby Help | Aide à Proximité |
| 📅 Follow-Up | calendar | Follow-Up | Suivi |
| ℹ️ About | info circle | About | À Propos |

Language toggle (`EN | FR`) lives persistently in the **top-right corner of the app header/toolbar**, visible on all screens after the disclaimer.

### About Pop-up
- Triggered by tapping **ℹ️ About** → renders as a **modal / bottom-sheet**, not a new screen.
- Contents:
  - App name + version placeholder: `v1.0.0`
  - Placeholder description:
    - EN: *"BurnCare Assistant helps you treat and monitor burn injuries with guided first-aid advice and access to nearby medical facilities."*
    - FR: *"BurnCare Assistant vous aide à traiter et surveiller les brûlures grâce à des conseils de premiers secours guidés et un accès aux établissements médicaux à proximité."*
  - Developer placeholder: `Developed by [Your Team Name]`
  - **Close button** — X icon top-right + "Close / Fermer" button at bottom.
- Dismissible by close button **or** tapping the backdrop.

---

## 4. Emergency Escalation (Post-Detection)

> Burn detection itself is already implemented. This section covers only what happens **after** the detection result is returned.

### Trigger Emergency Alert if ANY of the following are true:
```
IF burn_degree IN [2nd_deep, 3rd, 4th]                          → EMERGENCY
IF burn_degree == 2nd_superficial AND burn_area > 10% TBSA      → EMERGENCY
IF burn_location IN [face, hands, feet, genitals, major_joints] → EMERGENCY
IF patient.age < 5 OR patient.age > 60
   AND burn_degree >= 2nd_superficial                            → EMERGENCY
IF patient.immunocompromised == true
   AND burn_degree >= 2nd_superficial                            → EMERGENCY
IF burn_cause IN [electrical, chemical, inhalation]             → EMERGENCY
```

> **Important:** For infant, elderly (>60), or immunocompromised patients — display the immediate first-aid steps first (Section 5a), **then** show the emergency alert. Do not skip first aid entirely; those gestures can limit damage while waiting for help.

### Emergency Alert Screen
- Full-screen red overlay.
- Heading (`emergency.heading`): **"Seek Emergency Care Immediately"** / **"Consultez les Urgences Immédiatement"**
- Clear reason text (e.g., *"3rd degree burn detected"* / *"Patient age requires immediate professional care"*).
- Large primary button (`emergency.call`): **📞 Call Emergency Services** → `tel:` link.
- Secondary button (`emergency.find_hospital`): **🗺️ Find Nearest Hospital** → opens Nearby Help filtered to emergency rooms.
- **Do NOT display self-care advice** on this screen beyond the immediate steps already shown.

### Non-Emergency Result Screen
- Burn degree badge + estimated healing time.
- Immediate first-aid steps (Section 5a) displayed inline.
- Button: **"Start Follow-Up Tracker" / "Démarrer le suivi"** → navigates to Follow-Up with burn data pre-filled.

---

## 5. First Aid Advice Screen

Two entry points: (a) standalone tab for general reference, (b) shown inline after a non-emergency detection result.

### 5a. Immediate Steps Card (shown first, always)

Displayed as a numbered action card titled **"Immediate Steps" / "Gestes Immédiats"**:

1. **Cool** (`firstaid.cool`) — Cool the burn under lukewarm (not ice cold) running water for **10 to 20 minutes**.
2. **Remove** (`firstaid.remove`) — Carefully remove clothing and jewellery around the burn area.
3. **Cover** (`firstaid.cover`) — Protect with a sterile non-stick dressing.
4. **Do not pierce blisters** (`firstaid.no_pierce`) — Never puncture blisters (phlyctènes).

> These four steps apply to all non-emergency burns. Display them prominently before any other advice.

### 5b. General Care Rules

Present as a clear do / don't list:

**✅ Do:**
- Wash hands thoroughly before **and** after every dressing change. (`firstaid.handwash`)
- Stay well hydrated throughout healing. (`firstaid.hydration`)
- Consult a doctor if the burn worsens or abnormal signs appear. (`firstaid.worsen`)

**🚫 Don't:**
- Do not apply toothpaste, butter, oil, or any non-prescribed product to the burn. (`firstaid.no_products`)
- Do not manipulate the wound unnecessarily. (`firstaid.no_touch`)
- Do not apply any cream or ointment unless prescribed by a doctor.

### 5c. Degree-Specific Advice Cards (accessible from the advice tab)

**1st Degree:**
- Follow immediate steps above.
- OTC pain relief (paracetamol or ibuprofen) if needed — *only as directed by a pharmacist or doctor*.
- Keep out of sun until healed.
- Seek care if: pain worsens after 48h, redness spreads, or fever develops.

**2nd Degree – Superficial:**
- Follow immediate steps above.
- Do NOT burst blisters.
- Cover with a non-adherent sterile dressing (e.g., silicone mesh).
- Change dressing every 2–3 days or as directed by a doctor.
- Monitor daily for infection (see Follow-Up section).
- Seek care if: blisters larger than a coin, face/hands/feet involved, no improvement in 2 weeks.

**2nd Degree – Deep / 3rd Degree:**
- Apply immediate steps as temporary measures while waiting for emergency services.
- Display message:
  - EN: *"This burn requires professional medical treatment. Do not attempt to manage this at home."*
  - FR: *"Cette brûlure nécessite une prise en charge médicale. Ne tentez pas de la traiter seul(e)."*
- Show Emergency button prominently.

**Chemical Burns:**
- Brush off any dry chemical particles before applying water.
- Flush with large volumes of running water for ≥ 20 minutes.
- Remove contaminated clothing carefully (protect yourself too).
- Do not attempt to neutralise the chemical.
- Always seek medical care regardless of apparent severity.

**Electrical Burns:**
- Do NOT touch the patient if still in contact with the current source.
- Call emergency services — internal injuries may not be visible on the surface.
- All electrical burns require hospital evaluation.

### 5d. General Wellness Advice Tab

- **Hydration:** Increased fluid intake supports burn healing.
- **Nutrition:** A protein-rich diet accelerates tissue repair.
- **Sun protection:** Keep healing skin out of direct sunlight. Use SPF 50+ once fully healed.
- **Scar care:** Silicone gel or sheets can help after complete healing — consult a doctor first.
- **Psychological support:**
  - EN: *"It is normal to feel anxious after a burn. Please speak to someone you trust or a healthcare professional if you are struggling."*
  - FR: *"Il est normal de se sentir anxieux(se) après une brûlure. Parlez à quelqu'un de confiance ou à un professionnel de santé si vous en ressentez le besoin."*

---

## 6. Nearby Help Screen

### Data Source
Device GPS + maps API (Google Maps, OpenStreetMap, or equivalent) to find:
- Hospitals / burn units (prioritised for 2nd+ degree burns)
- General practitioners / specialist centres
- Pharmacies (for dressing supplies)

### UI
- Map view with pinned results.
- List view toggle (one card per facility).
- Filter chips: **Emergency Room | Clinic | GP / Specialist | Pharmacy** (translated in FR).
- Each card: name, distance, open/closed status (if available), phone number, **"Get Directions / Itinéraire"** button.
- Burn Unit badge on facilities that have one — sorted to top for serious burns.
- Fallback if GPS unavailable: manual city / postcode entry field.

---

## 7. Follow-Up Tracker Screen

### Purpose
Daily monitoring of the burn wound for signs of infection, with automated result scoring and care reminders.

### 7a. Care Plan Setup (shown on first Follow-Up entry)

Collect:
- Burn date (auto-calculates current day number).
- Dressing change interval: every **1 / 2 / 3 days** (user selects).
- Medications (optional, repeatable): medication name + times per day (add/remove fields).
- Follow-up appointment date (optional).

### 7b. Daily Check-In Form

Displayed once per day — locked after submission until the next calendar day.

| # | Question (EN) | Question (FR) | Input |
|---|---|---|---|
| 1 | Day N of healing *(auto)* | Jour N de guérison *(auto)* | Read-only |
| 2 | Pain level (0–10) | Niveau de douleur (0–10) | Slider |
| 3 | Is the wound oozing? | La plaie suinte-t-elle ? | Yes / No |
| 4 | If yes — colour of discharge | Si oui — couleur de l'écoulement | Clear / Yellow / Green / Brown |
| 5 | Unusual smell from the wound? | Odeur anormale de la plaie ? | Yes / No |
| 6 | Redness spreading around the wound? | Rougeur qui s'étend autour de la plaie ? | Yes / No |
| 7 | Skin around wound warm or hot to touch? | Peau autour de la plaie chaude au toucher ? | Yes / No |
| 8 | Swelling increasing? | Gonflement qui augmente ? | Yes / No |
| 9 | Fever today? | Fièvre aujourd'hui ? | Yes / No |
| 10 | If yes — temperature | Si oui — température | Number (°C / °F) |
| 11 | General wellbeing | État général | 😊 😐 😟 😰 |
| 12 | Notes (optional) | Notes (facultatif) | Free text |

### 7c. Infection Risk Scoring (runs automatically after submission)

```
score = 0

IF oozing == yes AND discharge_color IN [yellow, green]  → score += 2
IF unusual_smell == yes                                  → score += 2
IF redness_spreading == yes                              → score += 2
IF warm_to_touch == yes                                  → score += 1
IF swelling_increasing == yes                            → score += 1
IF fever == yes AND temperature >= 38.0°C               → score += 3
IF pain_level >= 7 AND day_number > 2                   → score += 1
```

**Result displayed immediately after submission:**

| Score | Status | EN Message | FR Message |
|---|---|---|---|
| 0–2 | 🟢 Healing normally | *"No signs of infection detected. Continue your care routine."* | *"Aucun signe d'infection détecté. Continuez votre routine de soins."* |
| 3–4 | 🟡 Monitor closely | *"Some signs may indicate early infection. Watch closely and consult a doctor if symptoms worsen in 24–48 hours."* | *"Certains signes peuvent indiquer une infection débutante. Surveillez et consultez si les symptômes s'aggravent sous 24–48h."* |
| 5+ | 🔴 Possible infection | *"Possible infection — please consult a doctor today. Do not wait."* | *"Infection probable — veuillez consulter un médecin aujourd'hui. N'attendez pas."* |

- For 🔴 result: also display a **"Find Nearby Help / Trouver de l'aide"** button linking to Section 6.

### 7d. Alerts & Reminders (local push notifications)

Request notification permission on first Follow-Up setup.

| Alert | Trigger | EN Message | FR Message |
|---|---|---|---|
| Dressing change | Per user-set interval | *"Time to change your burn dressing. Wash your hands first."* | *"Il est temps de changer votre pansement. Lavez-vous les mains d'abord."* |
| Apply prescribed treatment | Per medication schedule | *"Time to apply your prescribed treatment."* | *"Il est temps d'appliquer votre traitement prescrit."* |
| Daily check-in | Once daily at user-set time | *"Don't forget your daily burn check-in."* | *"N'oubliez pas votre suivi quotidien de brûlure."* |
| Follow-up appointment | Day before + morning of | *"Reminder: follow-up appointment tomorrow / today."* | *"Rappel : rendez-vous de suivi demain / aujourd'hui."* |

> Notifications must be delivered in the user's currently selected language.

### 7e. History View

- Timeline / calendar showing all past daily submissions.
- Each day: date + status badge (🟢 / 🟡 / 🔴).
- Tap to expand full submission detail.
- Useful for the patient to share with their doctor at a follow-up visit.

---

## 8. Data & Privacy

- All personal data stored **locally on device only** — no cloud sync without explicit user opt-in.
- Do not transmit patient data to any server.
- Provide **"Delete All My Data / Supprimer toutes mes données"** in Settings.

---

## 9. Edge Cases

- No internet / GPS → degrade gracefully; show manual entry for Nearby Help; all offline features remain functional.
- User indicates electrical or chemical burn → always trigger emergency flow regardless of other inputs.
- Patient profile not yet filled → prompt gently before first detection run; do not block access to advice or follow-up tabs.
- All copy mentioning medication must include:
  - EN: *"Only take or apply medications as directed by your healthcare provider."*
  - FR: *"N'utilisez les médicaments que selon les instructions de votre professionnel de santé."*
- Language switch mid-session → update all visible text immediately; preserve all form data and navigation state.

---

*End of spec. Burn detection is already implemented — do not modify it. Implement everything else as described. Priorities: (1) i18n system, (2) emergency escalation logic, (3) follow-up infection scoring. None of these may silently fail.*
