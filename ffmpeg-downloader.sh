#!/usr/bin/env bash
set -e

# Set default values
FFMPEG_VERSION="release"
FFMPEG_ARCHITECTURE="amd64"
DOWNLOAD_DIR="ffmpeg-bin"
DOWNLOADED_ARCHIVE=ffmpeg.tar.xz
CLEANUP_FILES=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -v | --version)
    FFMPEG_VERSION=$2
    shift 2
    ;;
  -a | --architecture)
    FFMPEG_ARCHITECTURE=$2
    shift 2
    ;;
  -d | --dir)
    DOWNLOAD_DIR=$2
    shift 2
    ;;
  -c | --cleanup)
    CLEANUP_FILES=true
    shift
    ;;
  -h | --help)
    echo "Usage: $0 [-v|--version <version>] [-a|--architecture <architecture>] [-d|--dir <download_directory>] [-c|--cleanup] [-h|--help]"
    exit 0
    ;;
  *)
    echo "Error: invalid argument: $1"
    exit 1
    ;;
  esac
done

#fetches latest release version from website
function get_version_from_latest_release() {
  lv=$(curl -s https://johnvansickle.com/ffmpeg/ | grep -Eo 'release: [0-9]{1,3}+(\.[0-9]{1,3}+)*')
  echo "${lv}" | sed 's/release: //g'
}

function check_installed() {
  local program="${1}"
  if which $program >/dev/null; then
    echo "$program is installed on this system."
  else
    echo "$program is not installed on this system."
  fi
}

function download() {
  local url="${1}"
  echo $url
  check_installed curl
  curl -L $url --output $DOWNLOADED_ARCHIVE
}

function extract() {
  local archive="${1}"
  check_installed tar
  [ -d $DOWNLOAD_DIR ] || mkdir $DOWNLOAD_DIR
  tar -xJf "${archive}" --strip-components 1 -C $DOWNLOAD_DIR && rm -f "${archive}" && echo "programs are ready in: $DOWNLOAD_DIR"
}

#deletes not needed files
#delete all except binaries only on linux
#currently not in use
function delete_files() {
  if [ "$(uname)" == "Linux" ]; then
    echo "This system is running Linux."
    find ./$DOWNLOAD_DIR -maxdepth 3 ! -name "ffmpeg" ! -name "ffprobe" -type f -exec rm -rf {} +
  fi
}

case "$FFMPEG_ARCHITECTURE" in
amd64)
  ARCH="amd64"
  ;;
arm64)
  ARCH="arm64"
  ;;
i686)
  ARCH="i686"
  ;;
armhf)
  ARCH="armhf"
  ;;
armel)
  ARCH="armel"
  ;;
*)
  echo "unsupported architecture: $FFMPEG_ARCHITECTURE" >&2
  exit 1
  ;;
esac

case "$FFMPEG_VERSION" in
release)
  echo "Downloading latest FFMPEG version: $FFMPEG_VERSION for architecture: $FFMPEG_ARCHITECTURE to directory: $DOWNLOAD_DIR"
  DOWNLOAD_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-${FFMPEG_VERSION}-${FFMPEG_ARCHITECTURE}-static.tar.xz"
  ;;
[0-9.]*)
  echo "Downloading specific FFMPEG version: $FFMPEG_VERSION for architecture: $FFMPEG_ARCHITECTURE to directory: $DOWNLOAD_DIR"
  LATEST_RELEASE_VERSION=$(get_version_from_latest_release)
  DOWNLOAD_URL="https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-${FFMPEG_VERSION}-${FFMPEG_ARCHITECTURE}-static.tar.xz"
  #compares version from argument and latest release version from website
  if [ "${FFMPEG_VERSION}" == "${LATEST_RELEASE_VERSION}" ]; then
    echo "downloading latest release version"
    DOWNLOAD_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-${FFMPEG_VERSION}-${FFMPEG_ARCHITECTURE}-static.tar.xz"
  fi
  ;;
help)
  echo "download latest version for amd64: $0" >&2
  echo "download specific version: $0 5.1.1" >&2
  echo "download specific version and architecture: $0 5.1.1 arm64 or $0 5.1.1 amd64" >&2
  exit 1
  ;;
*)
  echo '$FFMPEG_VERSION must be release or version number eg. 5.1.1' >&2
  exit 1
  ;;
esac

download $DOWNLOAD_URL && extract $DOWNLOADED_ARCHIVE
