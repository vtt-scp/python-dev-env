# Python development environment <!-- omit in toc -->
Python development environment setup and guidelines.

## Contents
- [Software requirements](#software-requirements)
- [Python](#python)
  - [`pyproject.toml`](#pyprojecttoml)
    - [Production dependencies](#production-dependencies)
    - [Development dependencies](#development-dependencies)
      - [Black](#black)
      - [Pylint](#pylint)
      - [Mypy](#mypy)
      - [Pytest](#pytest)
  - [Virtual environment](#virtual-environment)
  - [pip-tools](#pip-tools)
    - [pip-compile](#pip-compile)
    - [pip-sync](#pip-sync)
- [Visual Studio Code](#visual-studio-code)
  - [Extensions](#extensions)
  - [Settings](#settings)
  - [Remote development](#remote-development)
  - [Debugger](#debugger)
- [Other](#other)
  - [`.gitignore`](#gitignore)
  - [`.env`](#env)
  - [`README.md`](#readmemd)
  - [`Makefile` (Only works readily on Linux)](#makefile-only-works-readily-on-linux)
- [Containers](#containers)
  - [Dockerfile](#dockerfile)
  - [docker-compose.yml](#docker-composeyml)


# Software requirements
- [Python](https://www.python.org/downloads/)
- Container engine
  - [Docker for Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- Optional
  - [Visual Studio Code](https://code.visualstudio.com/download)


# Python

## `pyproject.toml`
Human editable project metadata file. Used by various tools to generate requirements and packages. An example can be found in [PEP 621](https://peps.python.org/pep-0621/).

- Project metadata
- Python requirements
- Python development requiremnets
- Build system for package creation

### Production dependencies
Production dependencies are minimally required to run the Python service. These are listed in `pyproject.toml` under `[project]` > `dependencies`:
```toml
[project]
dependencies = ["numpy", "pandas"]
```

### Development dependencies
Development dependencies are required for developing or testing the Python service. These are listed in `pyproject.toml` under `[project.optional-dependencies]`:
```toml
[project.optional-dependencies]
dev = ["black", "pylint", "mypy", "pytest"]
```
#### Black
Formats .py files to an highly opinionated format. Great for consistent codestyle and clarity across multiple developers. Can be integrated to a code editor or run separately for current project with:
```
black .
```
#### Pylint
Python linting. Highlights code for issues in style and execution. Can be integrated to a code editor or run separately for modules with:
```
pylint .\example\
```
#### Mypy
Python typehints and hint issue highlighting. Highly recommended for code clarity and discovering potential issues in code logic. Can be integrated to a code editor or run separately for current project with:
```
mypy .
```
#### Pytest
Python test library. Pytest is only one among many other options, use whatever works best. Search for tests and run them with:
```
pytest
```

## Virtual environment
Virtual environments are used to keep Python and project package depdendencies contained. Generally, each Python project is run from its own virtual environment.  
Create a new Python virtual environment at desired location, for example:
```
python3.11 -m venv .venv
```
To activate the environment run the activation script on:  
Ubuntu:
```
source .venv/bin/activate
```
Windows:
```
.\.venv\Scripts\activate
```
The virtualenv is activated if your command line is preceded with something like `(.venv)`  
Now you can update pip from within the virtual environment simply with:
```
python -m pip install --upgrade pip
```

## pip-tools
[Pip-tools](https://github.com/jazzband/pip-tools) is a simple option for generating consistent requirements files of Python dependencies in `pyproject.toml`. The requirements files are used to easily install Python dependencies when setting up production or development environments.  
Install pip-tools within your virtual environment:
```
pip install pip-tools
```

### pip-compile
Compiling new requirements files is required when dependencies are updated in `pyproject.toml`.  
Compile a production requirements file, e.g. to `requirements/prod.txt`:
```
pip-compile --generate-hashes --resolver backtracking --output-file requirements/prod.txt
```
Compile a development requirements file, e.g. to `requirements/dev.txt`:
```
pip-compile --generate-hashes --resolver backtracking --extra dev --output-file requirements/dev.txt
```

### pip-sync
Pip-sync is used to synchronise the production and/or development dependencies to your virtual environment based on the input requirements files.  
To synchronise dependencies in a production environment, run:
```
pip-sync dev-requirements.txt requirements.txt
```
Installing only production dependencies in a production environment is done with pip:
```
pip install -r requirements.txt
```


# Visual Studio Code
VSCode is basically a simple text editor which can be easily improved with official and community created extensions. It has good support, via extensions, for developing most programming languages. It also provides a graphical interface for simple git operations (`Source Control` tab).

## Extensions
Extensions can be installed from the `Extensions` tab. Recommended extensions for a particular project can be added to `.vscode/extensions.json`. For this project the recommendations are:

- Python (`ms-python.python`)
- isort (`ms-python.isort`)
- Better TOML (`bungcip.better-toml`)
- Markdown All in One (`yzhang.markdown-all-in-one`)
  
Once the Python extension is installed, VSCode should automatically detect and use the Python virtualenv if it is created to project root within `.venv` named folder. You can check that the virtual env is detected from the bottom right corner when a Python file is open in the editor, e.g. `3.11.1 ('.venv':venv)`.

## Settings
Use `.vscode/settings.json` or `File` > `Preferences` > `Settings` > `Workspace` to ensure correct Python styleguides and linters are used in the project. The development tools from `pyproject.toml` are activated in [.vscode/settings.json](.vscode/settings.json).

## Remote development
With the remote development extensions (`Remote - SSH` or `Dev Containers`) VSCode can connect to another computer over SSH or to a running container. The development environment is then fully contained on the remote machine or container. More info [here](https://code.visualstudio.com/docs/remote/remote-overview).

## Debugger
Debugging configuration can be found in `.vscode/launch.json`. Run the specified debugging configuration by pressing `F5`. As configured, VS Code automatically loads environment variables from `.env` file when running via the debugger. More info [here](https://code.visualstudio.com/docs/editor/debugging).


# Other

## `.gitignore`
Add file and folder names to `.gitignore` file that should not be included in git version management. The contents of the [.gitignore](.gitignore) found in this project is copied from [here](https://github.com/github/gitignore/blob/main/Python.gitignore). The `.gitignore` should be appended as necessary.

## `.env`
Add secrets and other platform configuration information here such as usernames, passwords, addresses to other services, etc. The `.env` file is automatically found and read by some debuggers and services. The defined variables can also be used in the `docker-compose.yml` file.  
The `.env` is generally left out from source management such as git by including it to `.gitignore`. However, it is included in this example project.

## `README.md`

## `Makefile` (Only works readily on Linux)
Makefile is a convenient place to store commands and scripts to manage, build, or run the project and its applications. An example for some useful commands can be seen in `Makefile`.
```
make <target_name>
```

# Containers
Tools such as Docker are used to run applications in containers that include everything required, from OS to code dependencies, to execute the application.

## Dockerfile
Dockerfile is a set of instructions for creating a image of the project including all necessary dependencies. Build a dockerfile of this project:
```
docker build .
```

## docker-compose.yml
Docker compose file includes instructions on running multiple services in containers with simple `up`, `down` and `build` commands. Build and run the defined services with:
```
docker compose up --build
```
Stop containers with:
```
docker compose down
```