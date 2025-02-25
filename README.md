# Presage test site

[![Netlify Status](https://api.netlify.com/api/v1/badges/d9ec25ff-3c82-4803-a84b-2eafcb85cb7c/deploy-status)](https://app.netlify.com/sites/peppy-tulumba-8f6533/deploys)

To build the site:

1. Install juliaup (run `curl -fsSL https://install.julialang.org | sh` or `brew install juliaup`in a terminal on macOS or Linux, or `winget install julia -s msstore` on Windows)
2. Use juliaup to install julia
3. Clone this repository
4. Navigate to the repository directory in a terminal
5. Start julia and activate this environment with `] activate .`, where `]` is the command to enter the julia REPL Package mode.
6. Instantiate this environment with `instantiate` while still in package mode.
7. At the normal julia prompt (use backspace to exit package mode), run `using Franklin` to load `Franklin.jl`.
8. `serve()` will start a local server at http://localhost:8000
9. `publish()` will publish the site to Netlify
