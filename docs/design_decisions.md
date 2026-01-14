## Key Design Decisions

- RAW layer preserves source fidelity
- STAGING performs all type casting and cleanup
- ANALYTICS layer contains only business-ready tables
- Facts separated by grain (orders vs items)
- Incremental loading via watermark pattern
