# Number Guessing Game

I created this small personal project in C to practise conditions, loops and keyboard input in the terminal.

The goal is to guess a number between 0 and 100 in five attempts. After each wrong answer, the program tells you whether the target number is higher or lower.

Some files still use the name “Pendu”, but the game in this repository is a C terminal program.

## Build and play

With GCC:

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror main.c mycode.c -o pendu
./pendu
```

On Windows, use `-o pendu.exe` and run `./pendu.exe`.

The project can also be built with CMake:

```sh
cmake -S . -B build
cmake --build build
```

The executable is created in the selected build directory.

## Tests

The program and its main files are written in C. The PowerShell script only automates GCC-based tests.

```powershell
pwsh -File tests/test.ps1
# If needed:
pwsh -File tests/test.ps1 -Compiler 'path/to/gcc.exe'
```

The tests cover winning, losing and the main input-error cases.
