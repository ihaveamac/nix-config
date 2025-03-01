# Auto-generated file
# Use update-extensions.py
{ pkgs, ... }:
{
  hax.services.mediawiki.extensions = {
    Variables = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/Variables-REL1_39-c1dea98.tar.gz";
      sha256 = "06pgzw2cvafih7sk6zzzrb30r0ihcvwjbj2i8k6mn4s1jnvwyac9";
    };
    TemplateStyles = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_39-12d1717.tar.gz";
      sha256 = "1zv0hp8sxjym4nal9w8n30wcj97lxp3yd5b5xwd8m75m3a0ccxqs";
    };
  };
}
