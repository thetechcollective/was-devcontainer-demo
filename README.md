## 0: Prep the repo
> [!WARNING]
> - Make sure friends have admin access to the repo (Asser)
> - Add all commits to a `demo` branch in successive order
> - Make sure the repo is configured as `template`
> - Make sure the _only_ file in the repo is a `README.md` with some fairly complex GitHub flavoured MarkDown (Mermaid)

## 1: Open a code space on an empty main branch

Default container is `universal:2`

Show a few commands: `ls`, `git`, `gh`, `az`

`az` doesn't work

## 2: Modify existing devcontainer

add the `az` CLI feature

add four extensions `cspell`, `markdownlint`, `markdown-preview-github-styles`, `phind` and `copilot` 

> [!NOTE]
> **COMMIT**

## 3: Get help!

Add the Live Share extension.

Invite a friend.

Make sure the friend has write access to repo and to terminals

## 4: Add a Jekyll site

Ask the friend to setup a Jekyll site:

In the terminal run:

```bash
jekyll new --skip-bundle --force ./docs
cd docs/
bundle update
bundle exec jekyll serve
```

> [!NOTE]
> **COMMIT**

> [!WARNING]
> The commit was impersonated by `me` even if it was my friend doing it!

## 5: Optimize the Jekyll site

- Use the `github` gem as per recommended in the `Gemfile`

```shell
bundle update
bundle exec jekyll serve
```

It fails! - add the missing gems:

```ruby
gem "webrick"
gem "faraday-retry"
```
Update and build

```shell
bundle update
bundle exec jekyll serve
```

In the `_config.yml` change

```yaml
baseurl: "devcontainer-demo" # same as repo name
...
remote_theme: jekyll/minima
```

> [!WARNING]
> With the `baseurl` set, the root of the website will show a `404`
> You must browse the `/devcontainer-demo/` folder to see the website.


> [!NOTE]
> **COMMIT**

### 6: Add a workspace shared `.gitconfig``

In the devcontainer add:

```json
"postCreateCommand": "git config --local --get include.path | grep -e ../.gitconfig || git config --local --add include.path ../.gitconfig"
```

Add a `.gitconfig` in the root

```ini
[push]
  default = current 

[alias]
  undo-commit = reset --soft HEAD^
  redo-commit = commit -C HEAD --amend 
  addremove = add -A
  co = checkout
  st = status
  root = rev-parse --show-toplevel
  tree = log --graph --full-history --all --color --date=short --pretty=format:\"%Cred%x09%h %Creset%ad%Cblue%d %Creset %s %C(bold)(%an)%Creset\"
  backward = checkout HEAD^1
  forward = !git checkout $(git log --all --ancestry-path ^HEAD --format=format:%H | tail -n 1)
```
> [!NOTE]
> **COMMIT**
> **PUSH**

## 7: Ask your friend to _do the right thing!_

Disconnect your friend from Live Share

Ask you friend to start a codespace instead

Let your friend hook up to the presentation 

Check
- Installed extensions (try to browse `README.md`)
- Shared git config (try `git config --list --show-origin`)

## 8: Serve the repo with GitHub pages

```shell
gh browse --settings
```

Go to pages, add a GitHub Action 

<details><summary><b>Use this workflow...</b> `jekyll-gh-pages.yml`</summary>

```yaml
# Inspired by sample workflow for building and deploying a Jekyll site to GitHub Pages
# https://github.com/actions/starter-workflows/blob/main/pages/jekyll.yml

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ruby:3.2.3-bullseye
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4
      - name: Build with Jekyll
        env:
          JEKYLL_ENV: production
        run: |
          cd docs
          bundle update
          bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./docs/_site

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
</details>

> [!NOTE]
> **COMMIT**

## 9: Start the code space in VS Code

From the repo on GitHub - right click the codespace and starte it in VS Code

It still works

```bash
cd docs/
bundle update
bundle exec jekyll serve
```

Note that the website is now running on your local PC!

## 10: Clone to local machine and open in VS Code

> [!WARNING]
> This part only works if you have Docker installed on your PC

```shell
gh repo clone "$GITHUB_USER/devcontainer-demo"
cd devcontainer-demo
code .
```
VS Code see's your `.devcontainer` file and offers you to "Reopen in Container". If you answer yes it will start the docker container locally on your PC.

> [!CAUTION]
> It will fail on a Mac with an M1 or M2 processor

## 11: Add a docker file you trust

Add a `dockerfile` in the root of the repo

Ask CoPilot to... 

```
Use ruby:3.2.3-bullseye. Set language to support BOM characters in Liquid. Add default workdir and expose the Jekyll related ports
```

...This can do it:

```dockerfile
FROM ruby:3.2.3-bullseye

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

EXPOSE 4000 35729
```

Get the current `devcontainer.json` file out of the way: Create a `Universal` folder under `/.devcontainer` and move it here.

From the command palette choose:
"Add Dev Container Configuration Files" >> "Add configuration to workspace" >> "From dockerfile"

In the new `devcontainer.json` file add the `features`, `customizations` and `postCreateCommand`sections from your _old_  (Universal) `devcontainer.json`.


> [!NOTE]
> **COMMIT**

From the command palette choose:
"Rebuild and reopen in container"

It works again:

```bash
cd docs/
bundle update
bundle exec jekyll serve
```

Note that the website is again running on your local PC!
...and check you Docker - it's a local container!

Where is the repo then? It's still on your PC's local disk

In VS Code try

```shell
echo clone is on PC's local disk > _temp
```

Browse the file on your local disk. - The repo is mounted into the devcontainer running in Docker.

  
> [!NOTE]
> **PUSH**

## 12: From GitHub - add a new codespace on the new container

From codespace menu choose the three dots next to the + - choose "New with options"

If you don't do this, you will get the `default` which is the one defined by `/.devcontainer/devcontainer.json``

And if that doesn't exist then it falls back to `Universal`...


## 13: On you PC - Clone in volume

Same thing as last time in VS Code:

```shell
code .
````

Only this time choose "Clone in volume" instead.

It still runs.

```bash
cd docs/
bundle update
bundle exec jekyll serve
```

So whats the difference?

Try to change the content of `_temp``

```shell
echo clone is inside the docker continer > _temp
git remote -vv
```

