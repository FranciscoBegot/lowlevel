# lowlevel
# 🧠 Low Level Journey — Assembly & Systems Programming

Welcome to my personal **low-level programming repository**.  
Here I document and explain everything I’ve been learning about **Assembly**, **computer architecture**, and **systems programming** — from basic instructions to full program analysis.

This repo is both a **study log** and a **reference** for anyone interested in understanding what really happens behind the code.

---

## 📚 What You’ll Find Here

- 🧩 **Assembly programs (x86-64 / NASM)**  
  Each program comes with comments and explanations line by line.

- 🧠 **Learning notes**  
  Short summaries explaining how specific instructions, syscalls, registers, and memory operations work.

- ⚙️ **Experiments**  
  Simple reverse engineering snippets, hex manipulation, and other low-level tricks.

---

## 🧰 Tools & Environment

- **Assembler:** NASM  
- **Linker/Loader:** `ld` (GNU)  
- **Architecture:** x86-64  
- **Platform:** Linux  

Example build and run:
```bash
nasm -f elf64 program.asm -o program.o
ld program.o -o program
./program

