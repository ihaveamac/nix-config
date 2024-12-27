import os

paths = os.environ['PATH'].split(':')

nixstores = list(filter(lambda x: x.startswith('/nix/store'), paths))
otherpaths = list(filter(lambda x: not x.startswith('/nix/store'), paths))

print(':'.join(nixstores + otherpaths))
