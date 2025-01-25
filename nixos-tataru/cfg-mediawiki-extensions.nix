# Auto-generated file
# Use update-extensions.py
{ pkgs, ... }:
{
  hax.services.mediawiki.extensions = {
    CodeMirror = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_39-a4fae18.tar.gz";
      sha256 = "13fckkd4i8dqhm2hp4dii7ndp93sarjxfxnhgv5w3lnx7624ylgj";
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
      url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_39-b7b9067.tar.gz";
      sha256 = "12jfdqqj6f78g6mll69wm6pizabli6pxxrzw08mykg7w2hd0sl8a";
    };
    DynamicSidebar = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/DynamicSidebar-REL1_39-cb47238.tar.gz";
      sha256 = "0zjhx15askmg5il5y0qddyf2frz6dikwg9905vhmfi8rz3pljfl3";
    };
    MobileFrontend = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_39-d6969a0.tar.gz";
      sha256 = "15vkzi55823rmh747r1ynhwwy3w32x31z3xd50ixh8q7fip4nkff";
    };
    SecureLinkFixer = pkgs.fetchzip {
      url = "https://extdist.wmflabs.org/dist/extensions/SecureLinkFixer-REL1_39-b67e07c.tar.gz";
      sha256 = "1aymnc0vih3ggsa38bilaazcz0xjmnr30g5ly9z4daa5dy8azmaa";
    };
  };
}
