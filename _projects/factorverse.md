---
layout: page
title: factorverse
description: an R package for Bayesian factor models
img: assets/img/factorverse_preview.jpg
importance: 1
category: work
related_publications: false
---

`factorverse` fits a variety of linear Gaussian Bayesian factor models under
different shrinkage and sparsity priors on the loading matrix. The samplers are
Gibbs samplers written in C++ via `RcppArmadillo`, and every method shares one
interface, so switching priors is a one-word change.

The model is the linear factor model,

$$
\mathbf{x}_i = \boldsymbol{\Lambda}\mathbf{b}_i + \boldsymbol{\epsilon}_i,
\qquad
\boldsymbol{\epsilon}_i \sim N(\mathbf{0}, \boldsymbol{\Sigma}),
$$

with loadings $$\boldsymbol{\Lambda}$$ ($$P \times K$$), factor scores
$$\mathbf{b}_i$$, and diagonal residual variances $$\boldsymbol{\Sigma}$$. The
quantity identified without rotation or sign ambiguity is the induced covariance
$$\boldsymbol{\Omega} = \boldsymbol{\Lambda}\boldsymbol{\Lambda}^{\top} + \boldsymbol{\Sigma}$$.

## Usage

```r
library(factorverse)

# Simulate from a block-sparse loading structure
Lambda <- sim_lambda(P = 12, K = 3, val = 1.2)
Sigma  <- diag(rep(0.3, 12))
Omega  <- tcrossprod(Lambda) + Sigma
dat    <- sim_data(list(Lambda = Lambda, Sigma = Sigma, Omega = Omega),
                   N = 300, seed = 42)

# Fit a model
fit <- fit_bfm(method = "dl", dat = dat, k0 = 3,
               chains = 1, nrun = 10000, burn = 5000,
               save_rds = FALSE, verbose = FALSE)
```

Available priors are `"mgps"`, `"ssl"`, `"dl"`, `"hs"`, `"bass"`, and `"mnl"`.
The fitted object holds the posterior draws in `$posterior` and the
posterior-mean loadings in `$Lambda_hat`.

## Simulation and diagnostics

`sim_run()` drives a full replicated study: it builds the parameter sets,
generates datasets, fits every method to each one, and records per-replicate
metrics, including wall-clock time and effective sample size. `sim_summarize()`
collapses the output into summary tables. At high dimension the fitter switches
to a memory-light streaming path so large-$$P$$ runs stay feasible.

For real data, `analyze_factor_fits()` and `score_correlation()` summarize
residual and factor correlation structure, `bfm_convergence()` reports $$\hat{R}$$
and bulk/tail effective sample sizes, and `residuals_by_sample()` gives per-draw
residual diagnostics.

## Install

```r
devtools::install_github("peterdunson/factorverse")
```

[Source on GitHub](https://github.com/peterdunson/factorverse). Developed in the
Crainiceanu Lab at Johns Hopkins Biostatistics. MIT licensed.