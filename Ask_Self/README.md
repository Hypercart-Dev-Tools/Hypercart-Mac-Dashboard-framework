# Ask_Self

This folder is a local ask-self integration for `hypercart-macos-dashboard`.

It uses the external `ask-self` checkout at:

- `/Users/noelsaw/Documents/GH Repos/ask-self`

and indexes this package with local Qwen embeddings into a SQLite vec database stored under:

- `Ask_Self/index/hypercart-macos-dashboard.sqlite`

For this project, the index intentionally lives inside `Ask_Self/index/` rather than under `temp/`. The goal is to keep the extraction workspace self-contained and make this style of package-local portable index easier to carry to other repos.

## Files

- `ask_self_harness.json`
  - repo-specific harness for this package
- `ask_self_system_instructions.json`
  - local answer behavior and response contract
- `ingest.sh`
  - builds or refreshes the local index
- `query.sh`
  - runs the external `ask-self query` path against this package harness
- `index/hypercart-macos-dashboard.sqlite`
  - sqlite-vec index for this package

## Notes

- Retrieval embeddings are configured to use `Qwen/Qwen3-Embedding-0.6B`.
- Full `ask-self query` synthesis still depends on Gemini credentials in the current upstream tool.
- The index in `index/` reflects the last ingest, not current unindexed edits.
- Local Qwen ingest is most reliable in safe mode for this project:
  - `TOKENIZERS_PARALLELISM=false`
  - `OMP_NUM_THREADS=1`
  - `MKL_NUM_THREADS=1`
  - ingest concurrency `1`
- The local `ingest.sh` wrapper applies those safe-mode defaults automatically unless you override them.

## Safe mode

Default ingest:

```sh
./Ask_Self/ingest.sh --mode all --json
```

Equivalent explicit safe-mode invocation:

```sh
env TOKENIZERS_PARALLELISM=false OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 ./Ask_Self/ingest.sh --mode all --concurrency 1 --json
```

If you want to experiment with a less conservative setup, you can override the wrapper defaults with:

```sh
ASK_SELF_CONCURRENCY=2 ./Ask_Self/ingest.sh --mode all
```

## Attribution

The underlying RAG engine is `ask-self`.
