This repository contains a collection of MATLAB scripts and helpers to convert
photos into pencil-sketch-like images using LIC, L0 smoothing, k-means based
tone-mapping and other image-processing building blocks. The guidance below is
focused, actionable, and specific to the discoverable patterns in this codebase.

Essentials (big picture)
- Primary entry scripts: `v_pencilsketch.m`, `pencilsketch_1.m`, and
  `script_pencli_grades_pic.m` (batch/experiment drivers). Treat these as the
  orchestration layer that load images, call preprocessing (L0 smoothing,
  filtering), compute vector fields and run LIC/tone modules, then write results
  into `results/`.
- Core processing helpers: `perform_lic.m`, `perform_blurring.m`,
  `perform_vf_integration.m`, `perform_vf_normalization.m`, `de_filter.m`,
  `L0Smoothing.m`, and `tone_kmeans_f_mine*.m`. These implement the LIC flow,
  convolution/blur helpers and tone mapping pipelines.
- Data artifacts: `results/LIC0.jpg`, `direction.mat`, and `myhistdata.mat` are
  referenced by multiple scripts. Assume `results/` must exist and some scripts
  expect prepared MAT/JPG files (histogram templates, direction fields).

How to run / developer workflows
- Run single-file experiments interactively in MATLAB by opening an entry script
  (e.g. `pencilsketch_1.m`) and executing. Scripts use relative paths and
  write outputs to `results/` or `result/` (note inconsistent pluralization).
- Batch runs: `pencilsketch_1.m` iterates input directories and writes per-image
  outputs; check and update the hard-coded `imgPath`/`directory` variables before
  running locally.
- Reproducible runs: ensure `results/` contains `LIC0.jpg` and optionally
  `myhistdata.mat` and `direction.mat` if scripts call `load(...)` — otherwise
  runs may error or produce different outputs.

Project-specific patterns & conventions
- Mixed naming and duplication: several functions have similar variants
  (e.g. `tone_kmeans_f_mine.m`, `tone_kmeans_f_mine_two.m`,
  `tone_kmeans_f_mine_three.m`). When modifying tone mapping, update only the
  variants that the active entry scripts call (check `pencilsketch_1.m` lines
  ~220-232).
- Options pattern: use `getoptions(options, 'name', default)` throughout
  (see `getoptions.m`). When adding new behavior toggleable by options, add a
  call to `getoptions` with a safe default to maintain backwards compatibility.
- Image I/O: code commonly expects NTSC-luminance conversions
  (`rgb2ntsc`/`ntsc2rgb`) and uses `im2double` / `im2uint8` conversions; keep
  those when adding new processing stages.

Integration points & boundaries
- LIC (line integral convolution) pipeline: `perform_lic.m` composes with
  `perform_vf_integration.m` and relies on a noise source `options.M0` or the
  internal random noise generator plus `perform_blurring`. Changes to the LIC
  noise model should be made by updating `options` keys and `perform_blurring`.
- Vector fields: `de_filter.m` and `direction.mat` are used to obtain flow
  information. If adding new VF estimation code, keep the same output shape
  (n x n x 2) and unit normalization expected by `perform_lic`.

Quick examples for an agent
- To find the entry point that runs batch processing, open
  `pencilsketch_1.m` and search for `tone_kmeans_f_mine_two` — that shows the
  tone-mapping variant currently used in the script.
- To modify blur behavior for LIC noise, edit `perform_blurring.m` or change
  the `options.spot_size` passed into `perform_lic` (see calls in drivers).

Safety notes for edits
- Preserve `getoptions` usage for new optional parameters.
- Avoid renaming files without updating all callers — many scripts use
  hard-coded string paths (e.g. `'.\results\LIC0.jpg'`).
- When adding dependencies, note this repo targets MATLAB (no external
  package manager). Document required MATLAB toolboxes in a README if you add
  toolbox-specific code (Image Processing Toolbox functions like `rgb2ntsc`,
  `imsegkmeans` appear in the codebase).

If anything in these notes is unclear or you want more granular examples
(call graph, key variable shapes, or suggested refactors), tell me which area
to expand and I will iterate.
