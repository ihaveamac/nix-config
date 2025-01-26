{
  lib,
  stdenvNoCC,
  rsync,
  nixosSystem,
}:

let
  isobase = nixosSystem.config.system.build.isoImage;
in
stdenvNoCC.mkDerivation {
  name = (isobase.name + "-static-name");

  dontUnpack = true;
  dontPatch = true;
  dontUpdateAutotoolsGnuConfigScripts = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir $out
    isoname=${isobase}/iso/${isobase.name}
    ln -s $isoname $out/nixos.iso
    cat >$out/copy-to-thancred.sh <<EOF
    ${rsync}/bin/rsync -avzLI --progress $isoname thancred:nixos.iso
    EOF

    cat >$out/copy-to-macbook.sh <<EOF
    ${rsync}/bin/rsync -avzLI --progress $isoname alphinaud:nixos.iso
    EOF

    cat >$out/copy-to-libvirt-images.sh <<EOF
    sudo cp -v $isoname /var/lib/libvirt/images
    EOF

    chmod +x $out/*.sh
  '';
}
