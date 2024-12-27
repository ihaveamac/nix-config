# Auto-generated file
# Use update-extensions.py
{ pkgs, ... }:
{
  hax.services.mediawiki.extensions = {
    CodeMirror = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_39-4579238.tar.gz";
      sha256 = "0vvlyvfv9l1fjw2nxpa09lr5mfrs1zfczzwba4223y9f2n48bixs";
    };
    Loops = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/Loops-REL1_39-733f372.tar.gz";
      sha256 = "15ymyjv9nkvmnvy2x6d6bmpsjxj4njpz98kq9rk46rdzxy5srjkf";
    };
    Variables = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/Variables-REL1_39-c1dea98.tar.gz";
      sha256 = "06pgzw2cvafih7sk6zzzrb30r0ihcvwjbj2i8k6mn4s1jnvwyac9";
    };
    MagicNoCache = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/MagicNoCache-REL1_39-ee12819.tar.gz";
      sha256 = "0hiv9i8hag7s73sapd9a48m1scpcgzqf4j274k9l16aqxbwj1ss8";
    };
    TemplateStyles = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_39-c86f78d.tar.gz";
      sha256 = "0rfa2ah0z7r6hy0bh69vn658ywwnrncbhskdv6l19m3hak11sfl9";
    };
    DynamicSidebar = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/DynamicSidebar-REL1_39-6492fef.tar.gz";
      sha256 = "0daskxv20ckdjm9spg4b0li8zfyg6cp73n4dn1w70fplw63xbqwr";
    };
    MobileFrontend = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_39-975c2b6.tar.gz";
      sha256 = "10wr7niskqy25bcrv3i9wf0cyb6s6kfk8bm0i3nsdi9ksnrk3rhb";
    };
    SecureLinkFixer = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/SecureLinkFixer-REL1_39-8f5bdcc.tar.gz";
      sha256 = "1l9nl8895xqas4ziv9ir0krfkipq4haiikzzds4hcqdayi6fnm14";
    };
  };
}
