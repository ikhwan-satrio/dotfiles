{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt,
  libevdev,
  pkg-config,
  spdlog
}:

let
  tomlplusplus = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "v3.4.0";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };
in
stdenv.mkDerivation rec {
  pname = "smooth-scroll-linux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Wayne6530";
    repo = "smooth-scroll-linux";
    rev = "v${version}";
    hash = "sha256-8Pcp3+FNojSJuMaNHXejZAL+KYVsm2gkH9oWx2cVq2U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    fmt
    libevdev
    spdlog
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'install(FILES debian/smooth-scroll.service DESTINATION /etc/systemd/system)' \
        "" \
      --replace-fail \
        'DESTINATION /etc/smooth-scroll' \
        'DESTINATION ''${CMAKE_INSTALL_PREFIX}/etc/smooth-scroll'
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DFETCHCONTENT_SOURCE_DIR_TOMLPLUSPLUS=${tomlplusplus}"
  ];

  meta = with lib; {
    description = "Smooth mouse wheel scrolling with inertia for Linux desktots";
    homepage = "https://github.com/Wayne6530/smooth-scroll-linux";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "smooth-scroll";
  };
}
