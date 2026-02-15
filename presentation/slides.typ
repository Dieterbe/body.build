#let bg = gradient.linear(
  angle: 120deg,
  (0%, rgb(6, 18, 31)),
  (100%, rgb(13, 33, 54))
)

#let accent = rgb(117, 198, 255)

#set page(
  width: 1920pt / 3.2,
  height: 1080pt / 3.2,
  margin: 1cm,
  fill: bg
)

#set text(font: "Source Sans Pro", fill: rgb(229, 241, 252))
#set heading(numbering: none)
#set list(marker: [#text(fill: accent, size: 18pt)[•]])

#let slide(title, body) = [
  #align(center)[
    #column(
      spacing: 1em,
      align(center),
      [
        #text(size: 46pt, weight: "bold", fill: accent)[title]
        #rect(width: 45%, height: 3pt, fill: accent)
        #box(width: 80%)[
          #set par(align: left, leading: 1.2em)
          body
        ]
      ]
    )
  ]
]

// Notes: Hook the audience by comparing Wikipedia's impact with what fitness still lacks.
#slide(
  "What brings personal fitness?",
  [
    - Wikipedia unlocked information; fitness still needs trustworthy data *and* actionable apps.
    - Mission: build the "Wikipedia for strength" that is personalized, evidence-based, and free.
    - Fully open-source (AGPL) so lifters and coaches own their data and tools.
  ]
)

#pagebreak()

// Notes: Mention graduating magna cum laude and why the Menno course matters.
#slide(
  "Proof we know our stuff",
  [
    - Completed the Menno Henselmans PT Course, graduating *magna cum laude*.
    - Deep dive into biomechanics, nutrition, and program design science.
    - Built body.build so advanced lifters don't have to piece together scattered info.
    #align(center)[
      #image("dieter-menno.jpg", width: 55%)
    ]
  ]
)

#pagebreak()

// Notes: Emphasize the structured database and links to trusted media/studies.
#slide(
  "It starts with the database",
  [
    - Detailed exercise records: setup cues, biomechanics notes, long/short length targeting.
    - Links to vetted videos, expert breakdowns, and research references.
    - Open data model so anyone can extend it or audit the source.
  ]
)

#pagebreak()

// Notes: Walk through each app briefly—programmer demo, kcal calculator, logging.
#slide(
  "Applications on top",
  [
    - **Program creator:** fractional volume accounting + muscle coverage checks.
    - **Kcal calculator:** personalized energy targets tied to training phases.
    - **Gym tracker (in progress):** mobile logging + on-the-fly adjustments.
    - **Weight logging:** moving-average insights to detect real trends.
  ]
)

#pagebreak()

// Notes: Close with invite to try it, remind it's free/open, ask for contributors.
#slide(
  "Own your training future",
  [
    - Try it today: https://body.build
    - Explore the source: https://github.com/Dieterbe/body.build
    - Contribute data, features, or testing—help make advanced coaching tools free for all.
  ]
)
