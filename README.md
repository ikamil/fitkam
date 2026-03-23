# fitkam — a unique management system for distributed fitness club networks

Download trial version: https://github.com/ikamil/fitkam/blob/main/README.md#установка-серверной-части-oracle-xe

Full information at https://fit.kambox.ru

A desktop application for managing a distributed fitness club network with specific business processes, complex billing, multiple legal entities, and marketing promotions.

For all inquiries: https://t.me/fitkam

---

## Key Features

- **The most flexible pricing configuration in the industry** — inspired by the tariff structures used by internet service providers.
- **Multi-legal-entity support with automatic payment routing** across different cash register terminals — the cashier simply selects a service, and the receipt is automatically sent to one of several connected POS devices.
- **Convenient platform for managing fitness instructor compensation** with a cumulative rating scale.
- **The most flexible, configurable, and pre-built reporting system in the industry**, organized as a multi-level catalog.
- **Intelligent locker room filling algorithm** that evenly distributes locker assignments, with support for paid reservations of preferred lockers.
- **Unique gift certificate batch management** with automatic redemption upon visits.
- **Role-based access model** with the ability to configure privileges at the level of restrictions, interface display, and available functionality.
- **Selective data synchronization system** between servers in a distributed club network. The following can be synchronized independently:
  - Client data (memberships, payments, and service orders operate locally)
  - Price plan and service catalog (prices are configured locally)
  - Staff members with their assigned fitness zones
- **Strict business process typing** — payments are separated from services, visits from training sessions, payment dates from service validity dates, etc.
- **Toolkit for bulk printing of club membership cards.**

---

## Server Installation (Oracle XE)

1. Prepare a Linux server with Docker and Docker Compose
2. Grant the user access to Docker, e.g. `usermod kam -gdocker`
3. In the target folder, run `git clone https://github.com/ikamil/fitkam.git`
4. Run `chmod 777 fitkam/data && cd fitkam/docker`
5. Start the installation and wait for it to complete: `docker-compose up -d`

## Client Installation

1. Download Oracle Instant Client version 19
2. Extract the Oracle Instant Client into the **desktop/instantclient** folder
3. Edit the file **desktop/instantclient/tnsnames.ora** and enter the server's IP address
4. Launch `mms2.exe` with the parameter `-m1`

---

## Documentation
https://fit.kambox.ru

## Telegram Channel
https://t.me/fitkam
