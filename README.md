# FFMPEG Downloader
Download static binary build of ffmpeg and ffprobe for use in docker , aws lambda layer, cloud.
This is a bash script that downloads and extracts the FFMPEG static binaries for a specified version and architecture built by John Van Sickle (http://johnvansickle.com/ffmpeg/).
Once the script downloads and extracts the tar file to donload directory it deletes downladed tar archive file.

## Requirements

The following programs are required to run this script:

- curl
- tar

## Usage
- Download the ffmpeg_downloader.sh script.
- Make the script executable by running:
  ```
  chmod u+x ./ffmpeg_downloader.sh
  ```

- Run the script with the following command:

```
./ffmpeg_downloader.sh [-v|--version <version>] [-a|--architecture <architecture>] [-d|--dir <download_directory>] [-c|--cleanup] [-h|--help]
```

Where:

- `-v | --version`: specify the FFMPEG version to download. You can use "release" to download the latest release or a specific version number (e.g. "5.1.1"). Defaults to `release`.
- `-a | --architecture`: specify the CPU architecture for the download. Supported values are amd64, arm64, i686, armhf, and armel. Defaults to `amd64`.
- `-d | --dir`: specify the directory where the binaries will be downloaded. Defaults to `ffmpeg-bin`.
- `-c | --cleanup`: specifies whether to delete downloaded archive after extracting binaries. Defaults to `false`. This argument is still under development and it is not used currently
- `-h | --help`: shows usage information.

Examples:

- Download the latest FFMPEG version for amd64 architecture to default directory: 

  ```
  ./ffmpeg_downloader.sh
  ```

- Download a specific FFMPEG version for amd64 architecture to a default directory: 

  ```
  ./ffmpeg_downloader.sh --version 5.1.1
  ```

- Download a specific FFMPEG version for amd64 architecture to a default directory: 

  ```
  ./ffmpeg_downloader.sh --version 5.1.1 --architecture arm64
  ```

- Download a specific FFMPEG version for arm64 architecture to a custom directory: 

  ```
  ./ffmpeg_downloader.sh --version 5.1.1 --architecture arm64 --dir /tmp/my-dir
  ```

## License

This script is licensed under the [GNU General Public License version 3.](https://www.gnu.org/licenses/gpl-3.0.en.html).