"""Compile src/modules/search_engine into distributable .pyc files."""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path
import py_compile


def compile_package(output: Path, optimize: int) -> Path:
    repo_root = Path(__file__).resolve().parents[1]
    source_dir = repo_root / "src" / "modules" / "search_engine"
    if not source_dir.exists():
        raise SystemExit(f"Source directory not found: {source_dir}")

    output_dir = output if output.is_absolute() else repo_root / output
    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    py_files = [p for p in source_dir.rglob("*.py") if "__pycache__" not in p.parts]
    if not py_files:
        raise SystemExit("No Python files found to compile.")

    compiled_files: list[Path] = []
    for py_path in py_files:
        rel_path = py_path.relative_to(source_dir)
        target_dir = output_dir / rel_path.parent
        target_dir.mkdir(parents=True, exist_ok=True)
        cfile = target_dir / f"{py_path.stem}.pyc"
        py_compile.compile(
            str(py_path), cfile=str(cfile), dfile=str(rel_path), optimize=optimize
        )
        compiled_files.append(cfile.relative_to(output_dir))

    manifest = output_dir / "MANIFEST.txt"
    manifest_lines = [
        "search_engine package compiled to bytecode",
        f"Optimize level: {optimize}",
        "",
        "Files:",
    ]
    manifest_lines.extend(f"  - {path.as_posix()}" for path in sorted(compiled_files))
    manifest.write_text("\n".join(manifest_lines))

    return output_dir


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        default="dist/protected/search_engine",
        help="Destination directory for the compiled package (default: %(default)s)",
    )
    parser.add_argument(
        "--optimize",
        type=int,
        choices=(0, 1, 2),
        default=2,
        help="Optimization level passed to the compiler (0, 1, or 2)",
    )
    return parser


def main(argv: list[str] | None = None) -> None:
    args = build_argument_parser().parse_args(argv)
    output_dir = compile_package(Path(args.output), args.optimize)
    print(f"Protected package written to {output_dir}")


if __name__ == "__main__":
    main()
