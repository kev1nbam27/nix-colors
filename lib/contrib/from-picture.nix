{ pkgs }:
{
  path,
  variant ? kind,
  kind ? "light" # Older alias
}:
import (pkgs.stdenv.mkDerivation {
  name = "generated-colorscheme";
  buildInputs = with pkgs; [ wpgtk toybox ];
  unpackPhase = "true";
  buildPhase = ''
    template=$(cat <<-END
    {{
      slug = "$(basename ${path} | cut -d '.' -f1)-${variant}";
      name = "Generated";
      author = "nix-colors";
      palette = {{
        base00 = "{color0}";
        base01 = "{color1}";
        base02 = "{color2}";
        base03 = "{color3}";
        base04 = "{color4}";
        base05 = "{color5}";
        base06 = "{color6}";
        base07 = "{color7}";
        base08 = "{color8}";
        base09 = "{color9}";
        base0A = "{color10}";
        base0B = "{color11}";
        base0C = "{color12}";
        base0D = "{color13}";
        base0E = "{color14}";
        base0F = "{color15}";
      }};
    }}
    END
    )

    HOME=/build
    echo $HOME "$(pwd)" >&2
    # exit 1
    light=""
    [[ "${variant}" = "light" ]] && light="--light"
    wpg $light -a "${path}" >&2
    wpg $light -A "$(wpg -l)" >&2
    echo "$template" > scheme.nix
    wpg -t -a scheme.nix >&2
    # chmod --quiet 400 /dev/pts/*
    wpg -n --noreload -s "$(wpg -l)" >&2 || true
    # chmod --quiet 620 /dev/pts/*

    #echo "$template" >&2
    cat scheme.nix >&2
    cat scheme.nix > default.nix
  '';
  installPhase = "mkdir -p $out && cp default.nix $out";
})
