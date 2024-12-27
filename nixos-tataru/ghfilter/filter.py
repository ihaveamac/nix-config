from asyncio import get_event_loop
from json import load, loads, dumps
from sys import argv
from typing import Mapping

from aiohttp import web, ClientSession
from aiohttp.web_request import Request

# Webhook URL to POST to, should the filter not deny it.
with open(argv[1], 'r') as f:
    webhook_url = f.read().strip()

# Port to listen to.
port = int(argv[2])
# URL to listen to.
url = argv[3]


async def post_webhook(headers: Mapping, body: bytes) -> 'web.Response':
    headers = {'X-GitHub-Delivery': headers['X-GitHub-Delivery'],
               'X-GitHub-Event': headers['X-GitHub-Event'],
               'X-GitHub-Hook-ID': headers['X-GitHub-Hook-ID'],
               'X-GitHub-Hook-Installation-Target-ID': headers['X-GitHub-Hook-Installation-Target-ID'],
               'X-GitHub-Hook-Installation-Target-Type': headers['X-GitHub-Hook-Installation-Target-Type'],
               'User-Agent': headers['User-Agent'],
               'Content-Type': headers['Content-Type']}

    async with ClientSession() as s:
        print('Sending...')
        async with s.post(webhook_url, data=body, headers=headers) as r:
            print(r.request_info.headers)
            print()
            print(r.headers)
            print(r.status)
            print('Returning...')
            return web.Response(headers={x: y for x, y in r.headers.items() if x.lower().startswith(('x-ratelimit',))},
                                body=await r.read())


async def handle(request: 'Request'):
    body = await request.read()
    print('Got a request:', request.headers['X-GitHub-Event'])
    if request.headers['X-GitHub-Event'] in {'pull_request', 'push', 'create', 'delete'}:
        bodyjson = loads(await request.text())

        if request.headers['X-GitHub-Event'] in {'pull_request'}:
            if bodyjson['pull_request']['head']['ref'] in {'l10n', 'l10n_master'}:
                return web.Response(text=dumps({'filter': 'Request not sent'}))
            else:
                return await post_webhook(request.headers, body)
        else:
            # gotta make this into a config option...
            if bodyjson['ref'] in {'l10n', 'refs/heads/l10n', 'l10n_master', 'refs/heads/l10n_master', 'gh-pages', 'refs/heads/gh-pages'}:
                return web.Response(text=dumps({'filter': 'Request not sent'}))
            else:
                return await post_webhook(request.headers, body)
    else:
        print('Passing through')
        return await post_webhook(request.headers, body)


# mostly for testing
async def handle_get(request: 'Request'):
    return web.Response(text='Hello!')


app = web.Application()
app.router.add_post(url, handle)
app.router.add_get(url, handle_get)

web.run_app(app, port=port)
