# https://github.com/b3nj5m1n/xdg-ninja/issues/289

def is_vanilla() -> bool:
    """ :return: whether running "vanilla" Python """
    import sys
    return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


def setup_history():
    """ read and write history from state file """
    import os
    import atexit
    import readline
    from pathlib import Path

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
    if state_home := os.environ.get('XDG_STATE_HOME'):
        state_home = Path(state_home)
    else:
        state_home = Path.home() / '.local' / 'state'

    history: Path = state_home / 'python_history'

    try:
        readline.read_history_file(str(history))
    except FileNotFoundError:
        pass
    atexit.register(readline.write_history_file, str(history))


if is_vanilla():
    setup_history()
