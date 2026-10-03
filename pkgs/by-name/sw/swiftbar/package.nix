{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  unzip,
}:
let
  build = "597";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "swiftbar";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/swiftbar/SwiftBar/releases/download/v${finalAttrs.version}/SwiftBar.v${finalAttrs.version}.b${build}.zip";
    hash = "sha256-/N7EkHgtZYcEYwQESVHGPeSaxCL8Y4kqb6st17xwwM0=";
  };

  unpackCmd = "unzip -qq $curSrc -x '*/._*'";
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r ./SwiftBar.app $out/Applications

    # Symlinking doesnt work; The auto-updater will fail to start which renders the app useless
    makeWrapper $out/Applications/SwiftBar.app/Contents/MacOS/SwiftBar $out/bin/SwiftBar

    runHook postInstall
  '';

  meta = {
    description = "Powerful macOS menu bar customization tool";
    homepage = "https://swiftbar.app";
    changelog = "https://github.com/swiftbar/SwiftBar/releases/tag/v${finalAttrs.version}";
    mainProgram = "SwiftBar";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ matteopacini ];
  };
})
