# NES on ESP32 — Project Roadmap

> **Vision:** Run authentic NES games at full speed on an ESP32 microcontroller,
> displayed on an SPI TFT screen and controlled via physical buttons, using only
> open-source tooling.

---

## Table of Contents

1. [Hardware Bill of Materials](#hardware-bill-of-materials)
2. [Development Phases](#development-phases)
   - [Phase 0 — Infrastructure ✅ Complete](#phase-0--infrastructure--complete)
   - [Phase 1 — Core Emulation 🔄 In Progress](#phase-1--core-emulation--in-progress)
   - [Phase 2 — Hardware Integration 🔲 Not Started](#phase-2--hardware-integration--not-started)
   - [Phase 3 — Polish & Advanced Features 🔲 Not Started](#phase-3--polish--advanced-features--not-started)
3. [Milestone Summary](#milestone-summary)
4. [Dependency Graph](#dependency-graph)
5. [Game Compatibility Targets](#game-compatibility-targets)
6. [Performance Targets](#performance-targets)
7. [Contribution Focus Areas](#contribution-focus-areas)

---

## Hardware Bill of Materials

| Component | Recommended Part | Notes |
|-----------|-----------------|-------|
| Microcontroller | ESP32-WROVER-B (4 MB Flash + 8 MB PSRAM) | PSRAM required for frame buffer; WROOM-32 does **not** include PSRAM |
| Display | ILI9341 2.8" 320×240 SPI TFT | SPI bus, 8-bit color or RGB565 |
| Storage | Micro-SD card module (SPI) | FAT32 formatted, stores `.nes` ROMs |
| Controller | 2× NES controller connectors | Shift-register protocol (4021 IC) |
| Audio | MAX98357 I²S amplifier + speaker | Or PWM buzzer for simpler setup |
| Power | 3.3 V LDO regulator + USB-C input | ESP32 is 3.3 V; max ~500 mA |
| Buttons | 8× tactile buttons (optional) | Alternative to original controllers |
| PCB / Wiring | Breadboard or custom PCB | See `docs/wiring_diagram.md` (planned) |

---

## Development Phases

### Phase 0 — Infrastructure ✅ Complete

Everything needed to write, test, and deploy code is in place.

| Item | Status |
|------|--------|
| CMake build system (host/PC) | ✅ |
| PlatformIO build system (ESP32) | ✅ |
| Google Test unit-test framework (37+ tests) | ✅ |
| GitHub Actions CI (Windows, Linux, macOS) | ✅ |
| VS Code / VS 2022 integration | ✅ |
| Core project structure (`src/`, `include/`, `test/`, `docs/`) | ✅ |
| PSRAM frame-buffer allocation | ✅ |
| Macro-collision fix (`OP_` prefix for all opcodes) | ✅ |

---

### Phase 1 — Core Emulation 🔄 In Progress

**Goal:** Run a Mapper-0 ROM to the point of displaying a correct first frame on the
host PC (no hardware required yet).

#### 1-A  CPU 6502 — Priority: 🔴 Critical

The CPU is the heart of the emulator. Everything else depends on it.

| Task | Details | Status |
|------|---------|--------|
| Addressing modes | All 12 modes are stubbed; need proper cycle counting | 🔄 Partial |
| 56 legal opcodes | Every opcode body is currently `return 0` | 🔲 Todo |
| Load/Store | `LDA`, `LDX`, `LDY`, `STA`, `STX`, `STY` | 🔲 |
| Transfer | `TAX`, `TAY`, `TXA`, `TYA`, `TSX`, `TXS` | 🔲 |
| Stack | `PHA`, `PHP`, `PLA`, `PLP` | 🔲 |
| Arithmetic | `ADC`, `SBC`, `INC/DEC`, `INX/DEX`, `INY/DEY` | 🔲 |
| Logical | `AND`, `ORA`, `EOR` | 🔲 |
| Shift / Rotate | `ASL`, `LSR`, `ROL`, `ROR` | 🔲 |
| Compare | `CMP`, `CPX`, `CPY`, `BIT` | 🔲 |
| Branch | `BCC`, `BCS`, `BEQ`, `BNE`, `BMI`, `BPL`, `BVC`, `BVS` | 🔲 |
| Jump / Call | `JMP`, `JSR`, `RTS`, `RTI` | 🔲 |
| Flags | `CLC`, `CLD`, `CLI`, `CLV`, `SEC`, `SED`, `SEI` | 🔲 |
| System | `BRK`, `NOP` | 🔲 |
| Interrupt handling | NMI, IRQ, RESET vectors | 🔲 |
| Cycle-accurate timing | Extra cycles for page-cross / branch-taken | 🔲 |
| Bus connection | Connect `read()`/`write()` to the NES bus | 🔲 |
| CPU test coverage | Expand from 12 → 60+ tests, target ≥ 90 % | 🔲 |

> **Reference:** [NESdev CPU wiki](https://www.nesdev.org/wiki/CPU)

#### 1-B  ROM Loader — Priority: 🔴 Critical

Without a ROM we have nothing to run.

| Task | Details | Status |
|------|---------|--------|
| iNES 1.0 header parser | 16-byte header, validate magic `NES\x1A` | 🔲 |
| PRG-ROM loading | 16 KB chunks into emulator memory | 🔲 |
| CHR-ROM loading | 8 KB chunks into PPU memory | 🔲 |
| Mapper detection | Read mapper number from header bytes 6 & 7 | 🔲 |
| Mapper 0 (NROM) | Simplest mapper; covers ~11 % of library | 🔲 |
| Mapper interface | Abstract base class for future mappers | 🔲 |

#### 1-C  PPU (Picture Processing Unit) — Priority: 🔴 Critical

| Task | Details | Status |
|------|---------|--------|
| Background rendering | Nametable + attribute table + pattern table fetch | 🔲 |
| Palette application | NES 64-colour palette → RGB565 for TFT | 🔲 |
| Scrolling | Loopy register fine/coarse scroll | 🔲 |
| Sprite evaluation | OAM scan, 8-sprite-per-line limit | 🔲 |
| Sprite rendering | Pattern fetch, priority, transparency | 🔲 |
| Sprite-0 hit | Collision detection flag | 🔲 |
| VBlank / NMI | Set flag, trigger CPU NMI at correct scanline | 🔲 |
| PPU test coverage | Expand from 12 → 40+ tests | 🔲 |

> **Reference:** [NESdev PPU wiki](https://www.nesdev.org/wiki/PPU)

#### 1-D  NES Bus / Integration — Priority: 🟠 High

| Task | Details | Status |
|------|---------|--------|
| CPU bus read/write | Wire CPU ↔ RAM ↔ PPU registers ↔ Cartridge | 🔲 |
| PPU bus read/write | Wire PPU ↔ CHR-ROM ↔ VRAM ↔ Palette | 🔲 |
| Clock-ratio enforcement | 3 PPU ticks per 1 CPU tick | 🔄 Partial |
| Integration tests | Boot a ROM, verify CPU+PPU interact correctly | 🔲 |

**Phase 1 exit criterion:** Super Mario Bros (or Donkey Kong) boots and renders a
recognisable title screen in a host-side debug window (no ESP32 needed).

---

### Phase 2 — Hardware Integration 🔲 Not Started

**Goal:** The emulator runs on physical ESP32 hardware at 60 FPS with display and
controller input working.

#### 2-A  Display Output — Priority: 🔴 Critical

| Task | Details | Status |
|------|---------|--------|
| PPU → frame buffer write | Fill `ppu.frameBuffer` correctly each frame | 🔲 |
| Frame buffer → TFT push | `tft.pushImage()` / DMA transfer | 🔲 |
| Scaling | 256×240 NES → 320×240 TFT (stretch or centre) | 🔲 |
| Double buffering | Prevent tearing; swap buffers atomically | 🔲 |
| 60 FPS target | Profile and optimise render path | 🔲 |

#### 2-B  Controller Input — Priority: 🔴 Critical

| Task | Details | Status |
|------|---------|--------|
| NES controller protocol | Serial read via shift register (4021) | 🔲 |
| GPIO button mapping | A, B, Select, Start, D-Pad | 🔲 |
| Button debouncing | Software debounce (~5 ms) | 🔲 |
| Two-player support | Second controller on separate GPIO pins | 🔲 |
| Input latency test | Target < 1 frame (< 17 ms) | 🔲 |

#### 2-C  SD Card / ROM Loading — Priority: 🟠 High

| Task | Details | Status |
|------|---------|--------|
| SPI SD card init | `SdFat` library initialisation | 🔲 |
| File system scan | List `.nes` files on card | 🔲 |
| ROM browser UI | Simple on-screen menu using TFT | 🔲 |
| ROM streaming | Load PRG/CHR into emulator at runtime | 🔲 |

#### 2-D  Dual-Core Utilisation — Priority: 🟡 Medium

| Task | Details | Status |
|------|---------|--------|
| Core 0: emulation loop | CPU + PPU ticking | 🔲 |
| Core 1: display + input | Frame push + controller poll | 🔲 |
| FreeRTOS task design | Queues / semaphores between cores | 🔲 |

#### 2-E  Audio (APU) — Priority: 🟡 Medium

| Task | Details | Status |
|------|---------|--------|
| APU structure | 5 channels: 2× pulse, triangle, noise, DMC | 🔲 |
| Pulse channel 1 & 2 | Square wave with envelope & sweep | 🔲 |
| Triangle channel | 32-step linear counter | 🔲 |
| Noise channel | LFSR-based noise | 🔲 |
| DMC channel | Delta-modulation sample playback | 🔲 |
| I²S output | `i2s_write()` to MAX98357 DAC | 🔲 |
| PWM fallback | `ledcWrite()` if no DAC available | 🔲 |
| Frame timing sync | APU frame counter tied to PPU VBlank | 🔲 |

> **Reference:** [NESdev APU wiki](https://www.nesdev.org/wiki/APU)

**Phase 2 exit criterion:** Super Mario Bros is fully playable on physical hardware
at ≥ 55 FPS with audio.

---

### Phase 3 — Polish & Advanced Features 🔲 Not Started

**Goal:** Broaden game compatibility and improve the user experience.

#### 3-A  Additional Mappers — Priority: 🟠 High

| Mapper | Name | Share of library | Popular games |
|--------|------|-----------------|---------------|
| 0 (Phase 1) | NROM | ~11 % | Donkey Kong, Pac-Man |
| 1 | MMC1 | ~28 % | Zelda, Mega Man 2 |
| 2 | UxROM | ~11 % | Mega Man, Castlevania |
| 3 | CNROM | ~8 % | Paperboy, Q*Bert |
| 4 | MMC3 | ~24 % | SMB3, Mega Man 3–6 |

#### 3-B  Save States — Priority: 🟡 Medium

| Task | Status |
|------|--------|
| State serialisation (all registers + RAM + VRAM) | 🔲 |
| Save to SD card | 🔲 |
| Load from SD card | 🔲 |
| Quick-save / quick-load button shortcut | 🔲 |

#### 3-C  Menu & Settings — Priority: 🟡 Medium

| Task | Status |
|------|--------|
| Boot-up ROM browser | 🔲 |
| In-game pause menu | 🔲 |
| Button remapping | 🔲 |
| Display brightness / scaling options | 🔲 |
| Volume control | 🔲 |

#### 3-D  Debugging Tools — Priority: 🟢 Low

| Task | Status |
|------|--------|
| CPU instruction trace (serial output) | 🔲 |
| Register/memory viewer | 🔲 |
| PPU nametable / pattern-table viewer | 🔲 |
| Performance profiler (FPS, CPU %) | 🔲 |

**Phase 3 exit criterion:** ≥ 80 % of common Mapper 0–4 games boot and are playable.

---

## Milestone Summary

| # | Name | Key Deliverable | Depends On |
|---|------|----------------|------------|
| M0 | Infrastructure | Build + test pipeline | — |
| M1 | CPU Complete | All 56 opcodes pass test suite | M0 |
| M2 | ROM Boot | iNES ROM boots on PC emulator | M1 |
| M3 | First Frame | Correct first frame rendered (PC) | M2 |
| M4 | Hardware Display | Frame renders on TFT at 30+ FPS | M3 |
| M5 | Playable | 60 FPS + controller input on hardware | M4 |
| M6 | Audio | APU output via I²S/PWM | M5 |
| M7 | Mapper 1–4 | Broader game compatibility (~+73 % of library) | M5 |
| M8 | Save States | Persist and restore game state | M7 |
| M9 | Full UI | ROM browser, settings, pause menu | M7 |

---

## Dependency Graph

```
M0 (Infrastructure) ──► M1 (CPU) ──► M2 (ROM Boot) ──► M3 (First Frame)
                                                               │
                                          ┌────────────────────┘
                                          ▼
                                   M4 (HW Display)
                                          │
                                          ▼
                                   M5 (Playable HW)
                                     │         │
                                     ▼         ▼
                                M6 (APU)   M7 (Mappers)
                                               │
                                    ┌──────────┴──────────┐
                                    ▼                     ▼
                              M8 (Save States)      M9 (Full UI)
```

---

## Game Compatibility Targets

### After Phase 1 (PC emulator)
- [ ] Donkey Kong (Mapper 0)
- [ ] Pac-Man (Mapper 0)
- [ ] Balloon Fight (Mapper 0)

### After Phase 2 (ESP32 hardware)
- [ ] Super Mario Bros (Mapper 0)
- [ ] Ice Climber (Mapper 0)
- [ ] Excitebike (Mapper 0)

### After Phase 3 (advanced mappers)
- [ ] The Legend of Zelda (Mapper 1)
- [ ] Mega Man 2 (Mapper 1)
- [ ] Castlevania (Mapper 1)
- [ ] Super Mario Bros 3 (Mapper 4)
- [ ] Kirby's Adventure (Mapper 4)

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Frame rate | ≥ 60 FPS sustained |
| Input latency | < 1 frame (< 17 ms) |
| Boot time | < 3 seconds from power-on to ROM start |
| RAM usage | < 50 % of DRAM (frame buffer in PSRAM) |
| Flash usage | < 50 % (leave room for OTA) |
| Audio latency | < 50 ms |

---

## Contribution Focus Areas

The following areas are most in need of contributors:

1. **CPU opcode implementations** — `src/cpu_6502.cpp` (all stubs, best first task)
2. **PPU background rendering** — `src/ppu.cpp` (core rendering pipeline)
3. **iNES ROM parser** — new file `src/cartridge.cpp` / `include/cartridge.h`
4. **Mapper 0** — simplest mapper, unblocks all testing
5. **APU architecture** — new file `src/apu.cpp` / `include/apu.h`
6. **Hardware wiring diagrams** — `docs/wiring_diagram.md`
7. **Performance profiling** — help hit 60 FPS on ESP32

See [CONTRIBUTING.md](CONTRIBUTING.md) for code style, PR process, and testing
requirements.

---

*Last updated: 2025 — see [PROJECT_STATUS.md](PROJECT_STATUS.md) for current progress metrics.*
