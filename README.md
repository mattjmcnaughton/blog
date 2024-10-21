# Blog

The code and blog entires behind my [blog](https://mattjmcnaughton.com).

## Writing

- To add a new post, run `hugo new content post/SLUG-FOR-POST.md`.
- To add a new "top-level" page (i.e. `about`, etc...) run `hugo new content SLUG-FOR-PAGE.md`.
    - Ensure that we add `menu = "main"` to the `config` at the top of the
      markdown file. See [about.md](./content/about.md) as an example.

## Development

We manage the development environment via Nix. Run `nix develop` to enter the
dev environment.

See [flake.nix](./flake.nix) for what is included.

## Deploy

Deployed via fly.io.

### Initial provisioning

Run `just launch` for the initial provisioning of the application. We only need
to do this once to generate the `fly.toml`.

See https://fly.io/docs/languages-and-frameworks/static/. Ensure we update the
port from 8080 to 80.

### Deploy

For each new deploy, run `just deploy`. This step will run both `hugo build` and
`fly deploy`.

### Custom domain

The `mattjmcnaughton.com` DNS lives in
[nuage](https://github.com/mattjmcnaughton/nuage).

We made the configuration updates in this [nuage
PR](https://github.com/mattjmcnaughton/nuage/pull/3).

We currently route the following hostnames to `fly.io`:
- `mattjmcnaughton.com`
- `www.mattjmcnaughton.com`
- `blog.mattjmcnaughton.com`

See https://fly.io/docs/networking/custom-domain/ for the documentation we
followed.

We need to use an A/AAAA record for `mattjmcnaughton.com` (as we cannot set a
CNAME for `mattjmcnaughton.com`, as its the zone apex, and we can't set a CNAME
for the zone apex).

We use a CNAME for the non-zone apex domains.

### SSL Certs

We can configure SSL certs via running the following from the project root. **We
only need to run this operation once for each of the hostnames listed above for
which we want to set-up certs.**

`fly certs add $HOSTNAME`

We can check the status of the certs with `fly certs show $HOSTNAME`.

See https://fly.io/docs/networking/custom-domain/#get-certified for the
documentation we followed.

### Provisioning

Currently we deploy 2 machines, each w/ 1 CPU and 256mb RAM. According to
https://fly.io/docs/about/pricing/, this will cost us ~$4 per month.

If we wanted to deploy only a single machine, we could run `fly deploy
--ha=false`.
