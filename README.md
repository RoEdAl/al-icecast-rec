# icecast - broadcasting audio directly from sound card (Arch Linux package)

## Installation

* Build package.
* Install package. Optionally install `mailcap` package.
* Edit [`/etc/conf.d/icecast-rec`](env) configuration file.
  You can also modify [`/etc/icecast-rec.xml`](icecast.xml) for more advanced options.
* Adjust required capture mixer settings of selected sound device.
* Enable/start [`icecast-rec`](icecast-rec.service) and [`icecast-rec-source`](icecast-rec-source.service) services.

## See also

* [Icecast Documentation](http://icecast.org/docs/)
* [Issue with FFMPEG ALSA CPU usage](//trac.ffmpeg.org/ticket/6156)
* [Stereo Raspberry pi sound card](http://www.audioinjector.net/rpi-hat)
