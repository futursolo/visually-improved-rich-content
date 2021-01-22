# VIsually iMproved Rich Content
My Simple Vim Configuration

### Credits
This project is based on [janus](https://github.com/carlhuda/janus). I
used to use janus and loved it. However, around sometime in 2018, it
stopped updating. Since then I have to disable a lot of plugins just to
update to a new version. Hence, I have decided to to derive my own vimrc
from janus.

### Note
I have configured this `vimrc` to suit my need. It may have some useful
stuff for you to use in your own `vimrc`. Feel free to add / remove and
make your own `vimrc`.

### Prerequisites
- Vim 8 compiled with Python 3 Support
- [code-minimap](https://github.com/wfxr/code-minimap)

### Prerequisites (Optional)
- [MacVim](https://macvim-dev.github.io/macvim/)
- [dark-mode](https://github.com/sindresorhus/dark-mode)
- Rust (cargo, rls, std-src, rustfmt)
- Python (mypy, flake8, isort, black, autoimport)
- Terraform (terraform fmt, tflint)

### Install
```shell
git clone https://github.com/futursolo/visually-improved-rich-content ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
```

### Features
- Supported Languages: Python, Rust, Markdown, Terraform, VimScript
- Dark / Light Theme follows system preference(macOS Only)
- Async Linting / Auto Completion / Auto Formatting via [ALE](https://github.com/dense-analysis/ale)
- NerdTree + Git Support

### Licence
Copyright 2021 Kaede Hoshikawa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
