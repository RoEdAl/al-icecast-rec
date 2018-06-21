# icecast - broadcasting audio directly from sound card [Arch Linux package]

## Features

* Two sources - audio is encoded twice:
  * `/live` - Opus codec (adjustable bitrate),
  * `/live-hd` - FLAC codec (ogg stream).
* Simple, flat configuration files.
* No log files - logging to journal only.

## Installation

* Build and install package.
* Optionally install `mailcap` package.
* Edit [`/etc/conf.d/icecast-rec`](env) and [`/etc/conf.d/icecast-rec-source`](env-source) configuration files.
  You can set `AUDIO_PATTERN` environment variable to `white-noise` or `busy-tone` for test purposes (no audio capturing).
* Adjust required capture mixer settings of selected sound device.
* Enable/start [`icecast-rec`](icecast-rec.service) and [`icecast-rec-source`](icecast-rec-source.service) services.

## See also

* [Icecast Documentation](http://icecast.org/docs/)
* [Issue with FFMPEG ALSA CPU usage](//trac.ffmpeg.org/ticket/6156)
* [Stereo Raspberry Pi Sound Card](http://www.audioinjector.net/rpi-hat)
