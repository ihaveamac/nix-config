#!/usr/bin/env python3

import json
from collections import defaultdict
from os.path import isdir
from subprocess import run, PIPE
from tempfile import TemporaryDirectory
from sys import argv

import requests

extensions = {
    "REL1_39": [
        "Variables",
        "TemplateStyles",
    ]
}

skins = {
    'REL1_39': [
    ],
}

commits_file = 'ext-commits.json'

commits = defaultdict((lambda: defaultdict(dict)))
try:
    with open(commits_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
except FileNotFoundError:
    pass
else:
    # due to the way defaultdict works, we have to copy the items over
    for branch, exts in data.items():
        for ext, sha in exts.items():
            commits[branch][ext] = sha

api_url_template = 'https://gerrit.wikimedia.org/r/projects/mediawiki%2F{etype}%2F{ename}/branches/{ebranch}'
targz_name_template = '{ename}-{ebranch}-{esha}.tar.gz'
targz_url_template = 'https://extdist.wmflabs.org/dist/{etype}/{targz}'

tmpdir = TemporaryDirectory(suffix="-mediawiki-ext-update")
outdir = tmpdir.name

print(commits)

def getter(exttype: str, extname: str, branch: str, s: requests.Session):
    api_url = api_url_template.format(etype=exttype, ename=extname, ebranch=branch)
    print('Getting:', branch, extname, exttype)
    with s.get(api_url) as r:
        # why?!?!?!?
        real_json = r.text[5:]
        sha = {'revhash': json.loads(real_json)['revision'][:7]}

    try:
        if ('force' not in argv) and (commits[branch][extname]['revhash'] == sha['revhash']):
            print('No need to update')
            return
    except KeyError:
        # can't find "revhash"
        pass

    targz_name = targz_name_template.format(ename=extname, ebranch=branch, esha=sha['revhash'])
    targz_url = targz_url_template.format(etype=exttype, targz=targz_name)
    outf = outdir + '' + targz_name

    sha['url'] = targz_url

    with s.get(targz_url, stream=True) as r:
        r.raise_for_status()
        print(f'Saving {outf}...', end='\r')
        with open(outf, 'wb') as o:
            o.write(r.raw.read())
    print(f'Saving {outf}...done')

    nix_hash = run(['nix-prefetch-url', '--unpack', 'file://' + outf], stdout=PIPE, encoding='utf-8').stdout.strip()
    sha['nixhash'] = nix_hash
    commits[branch][extname] = sha
    print(f'Importing {outf}...', end='\r')
    run(['nix-store', '--add-fixed', 'sha256', outf], stdout=PIPE)
    print(f'Importing {outf}...done')

with requests.Session() as se:
    for branch, extlist in extensions.items():
        for ext in extlist:
            try:
                getter('extensions', ext, branch, se)
            except requests.exceptions.HTTPError as e:
                print('Failed to get due to an HTTP error.')
                print(type(e), e)

    for branch, skinlist in skins.items():
        for skin in skinlist:
            try:
                getter('skins', skin, branch, se)
            except requests.exceptions.HTTPError as e:
                print('Failed to get due to an HTTP error.')
                print(type(e), e)

    #for repo, rinfo in github.items():
    #    branch, name = rinfo
    #    if isdir(outdir + name):
    #        print(f'Pulling {name}...')
    #        vun(['git', '-C', outdir + name, 'pull'])
    #        print(f'Checking out branch {branch} on {name}...')
    #        run(['git', '-C', outdir + name, 'checkout', branch])
    #    else:
    #        print(f'Cloning {name}...')
    #        run(['git', 'clone', '-b', branch, f'https://github.com/{repo}', outdir + name])

with open(commits_file, 'w', encoding='utf-8') as f:
    json.dump(commits, f)

tmpdir.cleanup()

with open('cfg-mediawiki-extensions.nix', 'w') as extnix:
    extnix.write('# Auto-generated file\n'
                 '# Use update-extensions.py\n'
                 '{ pkgs, ... }:\n'
                 '{\n'
                 '  hax.services.mediawiki.extensions = {\n')
    for branch, exts in commits.items():
        for extname, ext in exts.items():
            extnix.write(f'    {extname} = pkgs.fetchzip {{\n'
                         f'      url = "{ext["url"]}";\n'
                         f'      sha256 = "{ext["nixhash"]}";\n'
                         f'    }};\n')
    extnix.write('  };\n'
                 '}\n')
