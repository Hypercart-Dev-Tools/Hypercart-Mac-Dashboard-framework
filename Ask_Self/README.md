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

- Retrieval embeddings are configured to use `Qwen/Qwen3-Embedding-0.6B` (1024 dims).
- Synthesis is configured to use a local Ollama model (`qwen3:8b`) via `http://localhost:11434`. Start the daemon with `ollama serve` and pull the model with `ollama pull qwen3:8b` if you don't have it.
- The index in `index/` reflects the last ingest, not current unindexed edits.
- `ARCHITECTURE.md` is the primary repo-local architecture note indexed for onboarding and repo-grounded answers.
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

## Querying

Three query paths are available against this index:

```sh
# Fully local: Qwen retrieval + Ollama synthesis (no remote API).
./Ask_Self/query.sh --local-only "What public layers does this package expose?"

# Retrieval only: returns the matching chunks without an answer pass.
./Ask_Self/query.sh --retrieval-only --json "..."

# Default (matches the harness): Qwen retrieval + Ollama synthesis.
./Ask_Self/query.sh "..."
```

`--local-only` is a sanity gate: it refuses to run if either retrieval or synthesis would touch a remote API given the current harness config. To switch back to Gemini synthesis, edit `synthesis.provider` in `ask_self_harness.json`.

## Attribution

The underlying RAG engine is `ask-self`.
