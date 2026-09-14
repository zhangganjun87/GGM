# GGM: Parametric Pencil Hatching Generation

<p align="center">
  <b>MATLAB implementation for</b><br>
  <i>Parametric Pencil Hatching Generation with Generic Gaussian Model Based on LIC</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-Research%20Code-orange" alt="MATLAB">
  <img src="https://img.shields.io/badge/NPR-Pencil%20Hatching-blue" alt="NPR">
  <img src="https://img.shields.io/badge/Method-GGM%20%2B%20LIC-lightgrey" alt="GGM + LIC">
</p>

---

## Overview

This repository contains the MATLAB implementation of our **Generic Gaussian Model (GGM)** for parametric pencil hatching generation with **Line Integral Convolution (LIC)**.

Our study shows that LIC-based hatching results generated from different non-structured stochastic noise models approximate a Gaussian distribution under the **Lyapunov Central Limit Theorem**. Based on this observation, we use a generic Gaussian representation to replace conventional noise-degraded LIC inputs.

The resulting hatching style can be controlled mainly through the **mean** and **variance** of the GGM.

### Main contributions

- Systematic analysis of stochastic noise models used in LIC-based pencil hatching.
- Investigation of the statistical factors that determine LIC hatching appearance.
- A unified **Generic Gaussian Model (GGM)** for controllable pencil hatching generation.
- Parametric generation of different hatching styles, including pencil grades from **9H to 9B**.

---

## Method

```text
Input Image
    ↓
Tone / Region Processing
    ↓
GGM Parameterization
    ↓
Vector Field
    ↓
Line Integral Convolution (LIC)
    ↓
Pencil Hatching
```

---

## Code

The repository includes code for:

- GGM-based pencil hatching
- LIC and vector-field processing
- Noise-model comparison
- K-means-based tonal segmentation
- Pencil-grade rendering
- KL / Jensen–Shannon divergence evaluation

Main files include:

```text
pencilsketch_1.m
v_pencilsketch.m
tone_seg_f_compare.m
tone_seg_f_pencil_grading.m
tone_kmeans_f_mine*.m
perform_lic.m
tone_lic.m
script_pencli_grades_pic.m
computeKLDiv.m
computeJSDiv.m
```

---

## Requirements

- MATLAB
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox

---

## Quick Start

Clone the repository:

```bash
git clone https://github.com/zhangganjun87/GGM.git
cd GGM
```

Add the project to the MATLAB path:

```matlab
addpath(genpath(pwd));
```

For pencil-grade experiments, run:

```matlab
script_pencli_grades_pic
```

Please check the input/output paths in the corresponding MATLAB scripts before running.

---

## Paper

**Parametric Pencil Hatching Generation with Generic Gaussian Model Based on LIC**

**Ganjun Zhang¹, Siyi Liu², Yun Sheng³, Xiaoyang Mao⁴**

1. Shanghai Bingzuo Jingyi Technology Co., Ltd., China  
2. School of Information, Changde College, Changde 415000, China  
3. Faculty of Science and Engineering, Queen Mary University of London, U.K.  
4. Department of Computer Science, University of Yamanashi, Yamanashi 400-8510, Japan  

**Corresponding author:** Yun Sheng — y.sheng@qmul.ac.uk

---

## Citation

If you use this code in your research, please cite:

```bibtex
@misc{zhang2026ggm,
  title  = {Parametric Pencil Hatching Generation with Generic Gaussian Model Based on LIC},
  author = {Zhang, Ganjun and Liu, Siyi and Sheng, Yun and Mao, Xiaoyang},
  year   = {2026}
}
```

Publication information will be updated after the paper is published.

---

<p align="center">
  If you find this repository useful, please consider giving it a ⭐.
</p>
