# ☀️ SolarScrap — Renewable Energy Hardware Lifecycle, Photovoltaic Recycling & Metal Yield Valuation Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Next.js](https://img.shields.io/badge/Next.js-14_App_Router-black?style=for-the-badge&logo=next.js&logoColor=white)](https://nextjs.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

---

## 🌟 Executive Overview & Industrial Problem Solved

**SolarScrap** is an enterprise circular-economy platform engineered to solve the industrial decommissioning, residual valuation, and material recycling challenges of end-of-life photovoltaic (PV) solar panels and renewable energy infrastructure.

As solar installations decommission across global grids, asset managers and scrap recyclers require precise metallurgical yield calculations, logistics collection routing, and transparent commodity pricing to responsibly recover high-value materials (silicon, silver, copper, and aluminum).

---

## 🏛️ Monorepo Architecture

The platform is designed as an integrated industrial monorepo:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          UNIFIED CLIENT APPLICATIONS                        │
│                                                                             │
│   ┌───────────────────────────────┐       ┌─────────────────────────────┐   │
│   │    SolarScrap Mobile App      │       │     Enterprise Web Portal   │   │
│   │       (solar_scrap_app/)      │       │        (website_main/)      │   │
│   │  • On-Site Barcode Scanning   │       │  • Bulk Decommission Desk   │   │
│   │  • Photo Condition Grading    │       │  • Industrial Yield Reports │   │
│   │  • Instant Yield Calculator   │       │  • Corporate ESG Compliance │   │
│   └───────────────┬───────────────┘       └──────────────┬──────────────┘   │
└───────────────────┼──────────────────────────────────────┼──────────────────┘
                    ▼                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    HIGH-PERFORMANCE FASTAPI BACKEND                         │
│                                (backend/)                                   │
│   • Metallurgical Yield Estimation Models (Purity, Mass, Degradation)       │
│   • Live Commodity Market Index Feeds (LME Copper, Silver spot pricing)     │
│   • Logistics Scheduling & Hazardous Material Transport Chain of Custody    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1. On-Site Mobile App (`solar_scrap_app/`)
- **Field Inspector Workflows:** Guided panel condition grading, serial barcode scanning, and photographic damage recording.
- **Dynamic Yield Estimator:** Input panel wattage, manufacturer, and cell architecture (Monocrystalline, Polycrystalline, Thin-Film) to compute recoverable scrap value.

### 2. Corporate Enterprise Web Portal (`website_main/`)
- **Bulk Farm Decommissioning:** Large-scale commercial solar farm decommission requests and shipping manifest tracking.
- **ESG & Regulatory Certification:** Generate verifiable recycling audit certificates complying with environmental e-waste mandates.

### 3. FastAPI Python Backend (`backend/`)
- High-efficiency asynchronous Python 3.11 endpoints powering metallurgical calculations, real-time commodity pricing pipelines, and logistics state machines.

---

## 🛠️ Complete Technology Stack

| Domain | Technology | Implementation Detail |
|---|---|---|
| **Mobile Application** | Flutter 3.x / Dart 3.x | Field inspection toolchain, offline photo caching, clean UI |
| **Enterprise Web** | Next.js 14, React 18, Tailwind | Commercial booking portal and corporate ESG reporting dashboards |
| **Backend API** | FastAPI / Python 3.11+ | Asynchronous REST microservice with Pydantic v2 schemas |
| **Database & Auth** | Firebase & Relational DB | User identity, quote records, and verified salvage chains |

---

## 🏛️ Engineering Provenance

Architected, engineered, and maintained by **Muhammad Ali** as Principal Mobile Architect.
