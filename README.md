# Custom Android Builds

GitHub Actions workflows for building custom Android ROMs and Halium kernels for:

| Device | Codename | SoC | Build |
|--------|----------|-----|-------|
| Samsung Galaxy J7 Neo | `j7velte` | Exynos 7870 | CyanogenMod 14.1 / Halium 9.0 |
| Xiaomi Redmi 10 2022 | `selene` | MediaTek Helio G88 (MT6768) | Halium 9.0 (R vendor) |

## Status

### Samsung J7 Neo (`j7velte`)

| Workflow | Branch | Status |
|----------|--------|--------|
| CyanogenMod 14.1 | `main` | [![CM 14.1](https://github.com/jzadl/testing-adrod/actions/workflows/build.yml/badge.svg)](https://github.com/jzadl/testing-adrod/actions/workflows/build.yml) |
| Halium Kernel | `halium-j7velte` | [![Kernel](https://github.com/jzadl/testing-adrod/actions/workflows/build-kernel.yml/badge.svg?branch=halium-j7velte)](https://github.com/jzadl/testing-adrod/actions/workflows/build-kernel.yml) |
| Halium Full Build | `halium-j7velte` | [![Halium](https://github.com/jzadl/testing-adrod/actions/workflows/build-halium.yml/badge.svg?branch=halium-j7velte)](https://github.com/jzadl/testing-adrod/actions/workflows/build-halium.yml) |

### Xiaomi Redmi 10 2022 (`selene`)

| Workflow | Branch | Status |
|----------|--------|--------|
| Halium Kernel | `halium-selene` | [![Kernel](https://github.com/jzadl/testing-adrod/actions/workflows/build-kernel-selene.yml/badge.svg?branch=halium-selene)](https://github.com/jzadl/testing-adrod/actions/workflows/build-kernel-selene.yml) |
| Halium Full Build | `halium-selene` | [![Halium](https://github.com/jzadl/testing-adrod/actions/workflows/build-halium.yml/badge.svg?branch=halium-selene)](https://github.com/jzadl/testing-adrod/actions/workflows/build-halium.yml) |

## Branches

| Branch | Description |
|--------|-------------|
| `main` | CyanogenMod 14.1 build for j7velte |
| `halium-j7velte` | Halium 9.0 kernel + full build for j7velte |
| `halium-selene` | Halium 9.0 kernel + full build for selene (R vendor) |

## Releases

Successful kernel builds automatically create a GitHub release with the kernel image attached.
