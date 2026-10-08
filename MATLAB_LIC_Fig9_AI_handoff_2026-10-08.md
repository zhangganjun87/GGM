# MATLAB / LIC / Fig. 9 实验交接（给下一位 AI）

更新时间：2026-10-08。本文记录已核对的代码事实、独立实验及后续边界。用户要求：**不要改正式 MATLAB 代码、原始输入图或论文 Fig. 9；先在隔离环境验证，修改前备份，改论文须另行征得用户同意。** 论文内容由当前助手另行负责；下一位 AI 主要接手 MATLAB 实验。

## 1. 路径和入口

| 作用 | 路径 |
|---|---|
| 正式 MATLAB 代码（只读对待） | `C:\Users\zhang\Desktop\m_code` |
| 独立实验目录（可在此续做） | `D:\MyProj\my_python_script\matlab_clt_experiment_20261004` |
| 正式代码完整副本 | 上述实验目录下的 `source_copy` |
| 附录 13 张输入图 | `D:\MatlabTest\test_one_A\input_Figure_9\appendix pics` |
| 附录批量曲线与索引 | 实验目录下的 `appendix_pics_multi_20261004` |
| 论文主稿 | `C:\Users\zhang\Desktop\newBarn_v2_250310\EG2027_submission\EGauthorGuidelines-EG2027-sub-GGM.tex`（使用前确认当前路径与版本） |
| MATLAB 可执行文件 | `D:\Program Files\Polyspace\R2021a\bin\matlab.exe` |

2026-10-04 曾用 SHA-256 核对正式目录与 `source_copy` 的全部 123 个文件（含隐藏文件），当时 `mismatched=0`。这是当时的快照，**不能假定正式代码此后没有被用户修改**；下一位 AI 开始前请重新比较所需文件，不要从副本反向覆盖正式目录。

实际入口为 `pencilsketch_1.m`，其当前有效调用在约第 227 行：`tone_seg_f_noSeg(tone, work_strok, imgDir(i).name, directory)`。后者完成输入亮度图镜像填充、噪声生成、模糊、LIC 及红蓝分布图。真正的积分在 `perform_lic.m`；若需追踪流场，继续读这两个文件以及 `perform_vf_integration.m`、`perform_blurring.m`。**不要把 `m0_replace` 误当作实际 LIC 输入**：当前乘性噪声分支里它另行采样，但实际经过模糊进入 `options.M0` 的是 `m0`。

## 2. 红蓝线的数据流与问题

当前正式 `tone_seg_f_noSeg.m` 的有效噪声分支是 `mode='multi'`，`mean1=-0.0`，`sig1=1.0`。令输入亮度为 `f`（归一化到约 `[0,1]`），原始随机像素在此分支为 `m0 = f + (1-f) Z`，`Z` 是独立标准高斯；均值图约为 `f`，方差图为 `(1-f).^2`。随后执行 `M0 = perform_blurring(m0,3.8,options)`，并由 `perform_lic(v2,w,options)` 采样、插值、平均；当前 `w=40`、`dt=0.5`。

`perform_lic.m` 对模糊后的 `M0` 用 `interp2` 沿轨迹取值，累加实际输出 `M`，再除以各像素有效采样权重 `W`。同时，它从未模糊的 `options.src` 沿轨迹另行计算 `Means` 和 `Sig_sq_sum`。这两个理论量**没有经过与实际像素相同的模糊/插值线性算子**；`Sig_sq_sum` 也没有像 `M` 那样按 flow-correction 掩码逐项乘权。因此，单把 `Sig_sq_sum` 放到实际 LIC 输出的标准化分母里会失配。

正式代码画蓝线所用的是：

```matlab
Norm_result_v2 = (tone - M_out.Mean) ./ ...
                 (sqrt(M_out.Sig_sq_sum) ./ (2*w+1));
```

另一变量 `Norm_result=(M_sum-Means_sum)./Sn` 并非当前绘图所用。当前几何下名义轨迹点数是 `2*w+1=81`，但 `perform_lic` 真正用于平均的 `W` 是逐像素计算的，可能因采样/修正而不同；更主要的问题仍是模糊和插值诱导的相关性以及均值/方差算子不一致。不能只把 `81` 改成 `W` 就宣称完成修复。

红线的分箱目前已在正式代码中改为和蓝线一致：`edges=-800.5:1:800.5`、`x=255*z`，红线是 `numel(x)*(normcdf(edge_right/255)-normcdf(edge_left/255))`。这使红线与蓝线使用相同的区间和频数尺度，但**未解决蓝线标准差偏小的根因**。用户曾在 MATLAB 断点测试，正常预模糊时 `std(z)≈0.7387`；把 `options.M0` 临时设为未模糊的 `m0` 后约为 `1.2006`。这说明旧分母与实际处理链不匹配。断点修改仅在当次 MATLAB 运行中生效，不应视为正式代码变更。

## 3. 独立实验如何修复归一化

实验目录的 `run_kernel_model.m`、`run_full_bird.m` 与 `lic_standardize_operator.m` 不修改正式输出；只为诊断/绘制统计分布。当前 `v2` 是空间恒定的对角直线方向，因此整个“预模糊 → 双线性插值 → LIC 平均”在图像内区可视作同一个线性算子。`run_kernel_model.m` 用中心单像素脉冲求出其内区 `91×91` 核，并存为 `interior_kernel_256.mat`。

对独立原始噪声像素，正确的输出均值应将**原始均值图**通过同一模糊和 LIC 算子计算；输出方差在平移不变的内区为**原始方差图与 `kernel.^2` 的卷积**。`run_full_bird.m` 的均值由正式 `perform_lic` 直接作用在模糊后的 `raw_mean` 得到，方差由脉冲核的平方卷积给出，再用实际输出减均值、除标准差。它不是按观测直方图的标准差对蓝线事后缩放。靠近图像边缘时，内区核只是近似，边界偏差仍需处理。

关键测试：在 256×256 测试块上做 12 次独立重复，旧标准化的合并标准差约 `0.76277`，算子方法约 `1.00966`；可复用函数 `lic_standardize_operator.m` 与独立逐像素推导结果的最大差异约 `6.7e-15`。全尺寸新运行（固定 `rng(20261004,'twister')`，并非恢复旧 Fig. 9 随机种子）如下：

| 图像/噪声 | 旧法全图 SD | 算子法全图 SD | 算子法内区 SD |
|---|---:|---:|---:|
| bird / multiplicative | 0.7357 | 1.0211 | 0.9958 |
| cat / multiplicative | 0.7583 | 1.0407 | 1.0216 |
| ying / multiplicative | 0.7690 | 1.0392 | 1.0169 |
| cat / RBWN | 0.7322 | 1.0131 | 0.9947 |
| boat / hybrid | 0.8971 | 1.0313 | 0.9948 |
| angel / Poisson | 0.8678 | 1.0261 | 0.9997 |
| rim / multiplicative | 0.7544 | 1.0453 | 1.0193 |

Poisson 试验中的 `scale_2` 沿用代码按一次随机样本确定；以固定 `scale_2` 计算解析方差是**条件近似**，不能当作完全无条件推导。混合噪声、RBWN 等分支的参数应以具体实验脚本为准，不能推断旧 Fig. 9 当年使用了完全相同的配置。

## 4. Fig. 9 式“随机起伏”如何画出

最初实验图用标准化坐标箱宽 `0.025`，视觉上过于平滑。现在的 `run_full_bird.m` 用 `255*z` 为横轴，箱边界 `-800.5:1:800.5`，等于标准化坐标箱宽 `1/255`；蓝线为**未经平滑的实际频数**，红线为标准正态在同一箱中的预期频数。较细分箱使蓝线出现自然的有限样本起伏；**没有给图额外加噪声，也没有人为拉伸蓝线**。四种噪声的示例是实验目录中的 `full_cat_RBWN_fig9_style.png`、`full_boat_hybrid_fig9_style.png`、`full_angel_Poisson_fig9_style.png`、`full_rim_multi_fig9_style.png`。

用户随后要求对 `appendix pics` 下全部图像生成同式红蓝线。`run_appendix_batch.m` 用相同的**乘性噪声**配置批量处理 13 张，结果在 `appendix_pics_multi_20261004`；其中 `README.md` 给出逐图链接，已核对 13 输入对应 13 张 `_fig9_style.png`，无漏图。`daisy1024.jpg` 和 `hako.jpg` 有零方差/近零方差区域，不能除以零，实验脚本将这些像素标为无效并从直方图排除；方图计算域中分别排除 1,113 与 35,989 像素。其余统计图也保存在同一目录。

## 5. 复现与继续工作

MATLAB R2021a 中切换至实验目录，先确保 `interior_kernel_256.mat` 存在。它可以由 `run_kernel_model` 重新生成。常用命令：

```matlab
run_kernel_model
run_full_bird('D:/MatlabTest/test_one_A/input_Figure_9/animal/cat1024.jpg', 'cat', 'RBWN')
run_full_bird('D:/MatlabTest/test_one_A/input_Figure_9/landscapes/boat.jpg', 'boat', 'hybrid')
run_appendix_batch
```

Windows 命令行批量运行示例：

```powershell
& 'D:\Program Files\Polyspace\R2021a\bin\matlab.exe' -batch "cd('D:/MyProj/my_python_script/matlab_clt_experiment_20261004'); run_appendix_batch"
```

`run_appendix_batch.m` 会重写**实验输出目录**中同名图片，请在再次批跑前确认是否需要保留用户已经挑选的版本。正式目录与原图目录无需写权限，也不应被批处理写入。核对输出时检查 `batch_log.txt` 是否有 `FAILED`，并比较输入图片数与 `_fig9_style.png` 数量。注意 Windows 下文件名通配符不区分大小写，`*.jpg` 已包含 `bird.JPG`；不要再额外拼接 `*.JPG`，否则会重复运行。

若想从正式主流程接入**实验副本**，在生成 `tone` 后，理论上可调用：

```matlab
[z_operator, detail] = lic_standardize_operator( ...
    tone, mu_clt, sigma_clt.^2, v2, w, options, 3.8);
```

但必须先核对 `mu_clt`/`sigma_clt` 确实对应进入 `perform_blurring` 的那次实际随机 `m0` 的模型参数、`v2` 仍为空间恒定流场、`options`/边界设置一致。这个调用**尚未写入正式代码**。如要提交论文图，应另存新文件供用户审阅，不要直接覆盖旧 Fig. 9。

## 6. 未解决的问题与科学表述边界

1. **内区核不等于全图精确核。** 全图算子法 SD 比 1 常高约 1–5%，尤其接近边缘及输入图包含大片白色区域时。可选择明确报告内区统计，或实现逐像素边界权重；不能把全图完全吻合说成已验证。
2. **各噪声模型需要分开审阅。** 上述附录 13 图只跑了 multiplicative，不代表已经对同一批图跑过 RBWN、hybrid、Poisson。若用户要四模型全覆盖，先确认参数和文件命名方案。
3. **经验曲线与 Lyapunov 证明不是同一命题。** 此修正检验实际“模糊 + 插值 + LIC”输出标准化后的分布；它并不直接证明论文把 LIC 输入样本当作独立变量时的 Lyapunov 条件。multiplicative 分支的原始输入本来就是高斯；固定线性算子的输出理论上仍是高斯，不能把该分支的吻合单独当成 CLT 的非平凡证据。正式改论文叙述前要请用户确认。
4. **不可从图形外观恢复旧实验配置。** 旧 Fig. 9 的完整参数与随机种子没有找回；上述图片是新的、可复现的结果。不要声称逐像素复现旧图，也不要为了让红蓝线“好看”而对蓝线加噪声或用实测 SD 反调参数。

## 7. 给下一位 AI 的首轮检查清单

- 先读本文件和实验目录 `README.md`，再读实际 `run_full_bird.m`、`lic_standardize_operator.m`、`run_appendix_batch.m`；不要只靠本文假定代码未变。
- 核对用户最新想跑的是**哪张输入图、哪一种噪声模型**，以及输出目标是诊断图、论文候选图，还是正式替换。
- 确认正式 `m_code` 与 `source_copy` 是否仍一致；若不同，记录差异但不要擅自同步或覆盖。
- 对每次新实验记录输入路径、噪声模型与参数、随机种子、有效像素数量、全图与内区均值/SD、生成的文件名。
- 保持所有新结果在隔离实验目录；正式 MATLAB 代码和论文图只有在用户明确批准后才改。
