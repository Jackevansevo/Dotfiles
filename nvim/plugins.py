from pathlib import Path
from collections import defaultdict
from subprocess import run

f = open('plugins.txt')
plugins = f.read().splitlines()

# Organise plugins by author
plugins_by_author = defaultdict(list)
for plugin in plugins:
    author_name, _ = plugin.split('/')
    plugins_by_author[author_name].append(plugin)


# Iterate over each plugin and install
for author, plugins in plugins_by_author.items():
    author_plugin_path = (Path("~/.config/nvim/pack") / author / 'start').expanduser()
    author_plugin_path.mkdir(parents=True, exist_ok=True)
    for plugin in plugins:
        print(plugin)
        _, plugin_name = plugin.split("/")
        if not (author_plugin_path / plugin_name).exists():
            run(['git', 'clone', f'https://github.com/{plugin}'], cwd=author_plugin_path)
        run(f'nvim -u NONE -c "helptags {plugin_name}/doc" -c q', cwd=author_plugin_path, shell=True)
