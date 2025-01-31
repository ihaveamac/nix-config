# Auto-generated file
# Use update-extensions.py
{ pkgs, ... }:
{
  hax.services.mediawiki.extensions = {
    CodeMirror = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_39-06dab41.tar.gz";
      sha256 = "109v1wp0hm3c6ga5gcn688iwbv69vx060idrr8ghn4nirypbaz8p";
    };
    Loops = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/Loops-REL1_39-83cd81d.tar.gz";
      sha256 = "1fdv3516ayd877kfmkaylamniq67y4pkglwdym7f4di8idshwp7a";
    };
    Variables = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/Variables-REL1_39-c1dea98.tar.gz";
      sha256 = "06pgzw2cvafih7sk6zzzrb30r0ihcvwjbj2i8k6mn4s1jnvwyac9";
    };
    MagicNoCache = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/MagicNoCache-REL1_39-6cd009e.tar.gz";
      sha256 = "05j6waina8w57z6im0n5vf3dvs7klhp8ijyiymdx9iwd5zm4gnw4";
    };
    TemplateStyles = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_39-12d1717.tar.gz";
      sha256 = "1zv0hp8sxjym4nal9w8n30wcj97lxp3yd5b5xwd8m75m3a0ccxqs";
    };
    DynamicSidebar = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/DynamicSidebar-REL1_39-cb47238.tar.gz";
      sha256 = "0zjhx15askmg5il5y0qddyf2frz6dikwg9905vhmfi8rz3pljfl3";
    };
    MobileFrontend = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_39-8667a44.tar.gz";
      sha256 = "00485fyyc7dgjcrac9cd18w35dlpsf9bz22ia2lk1b0y96s6aw3v";
    };
    SecureLinkFixer = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/SecureLinkFixer-REL1_39-b67e07c.tar.gz";
      sha256 = "1aymnc0vih3ggsa38bilaazcz0xjmnr30g5ly9z4daa5dy8azmaa";
    };
  };
}
