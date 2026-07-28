{
  lib,
  stdenvNoCC
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "harkprompt";
  version = "0.1.0";

  src = ./.;

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions
    cp prompt_hark_setup $out/share/zsh/site-functions/
  '';

  meta = {
    description = "An aesthetic component-based prompt for Zsh";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mrbjarksen ];
  };
})
