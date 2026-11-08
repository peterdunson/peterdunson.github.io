---
layout: page
title: VAPOR
description: an R package for Bayesian VAR models with factor-structured precision matrices
importance: 0
category: research
related_publications: false
---

VAPOR (Vector Autoregressive Precision factOR) estimates vector autoregressive dynamics jointly with a low-rank-plus-diagonal innovation precision matrix, and reads the partial correlations among series directly from the fitted precision rather than imposing a zero pattern. It is designed for panels where the number of series is comparable to the number of time points. The Gibbs sampler is written in C++ through RcppArmadillo.

## Model

$$
y_t = B y_{t-1} + \varepsilon_t, \quad \varepsilon_t \sim N(0, \Omega^{-1}), \quad \Omega = \Lambda\Lambda^\top + \Delta, \quad B = UV^\top
$$

Here $$\Lambda$$ is a $$p \times k$$ loading matrix with a Dirichlet-Laplace prior, $$\Delta$$ is diagonal with a Dirichlet process prior on the idiosyncratic precisions, and the coefficient matrix $$B$$ has rank $$r$$. The partial correlation between series $$i$$ and $$j$$ is $$\rho_{ij} = -\Omega_{ij} / \sqrt{\Omega_{ii}\Omega_{jj}}$$, and a pair is reported as an edge when the central 95% posterior credible interval of $$\rho_{ij}$$ excludes zero.

## Application

Applied to 100 quarterly FRED-QD series, VAPOR finds that each Treasury rate is directly related only to the rates at adjacent maturities, places all 26 selected dependencies within a single FRED-QD group, and attains the lowest held-out prediction error among the estimators compared. Paper: "Bayesian precision factor models for high-dimensional macroeconomic time series" (preprint forthcoming).

## Usage

```r
library(VAPOR)

# Y: T x p matrix of stationary series (rows = time points)
set.seed(1)
Y <- matrix(rnorm(200 * 5), 200, 5)

fit <- vapor(Y, lags = 1, k = 2, nrun = 5000, burn = 2500, thin = 5)

fit                        # summary
fit$Omega                  # posterior mean precision matrix
partial_correlations(fit)  # posterior mean partial correlations
```

## Install

```r
devtools::install_github("peterdunson/vapor")
```

[Source on GitHub](https://github.com/peterdunson/vapor). MIT licensed.
