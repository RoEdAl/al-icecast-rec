# icecast - broadcasting audio directly from sound card (Arch Linux package)

## Installation

* Build package.
* Install package
* Edit [`/etc/conf.d/icecast-rec`](env) configuration file. You can also modify [`/etc/icecast-rec.xml`](icecast.xml) for more advanced options.
* Enable/start [`icecast-rec`](icecast-rec.service), [`icecast-rec-source`](icecast-rec-source.service) services.

## See also

* [Issue with FFMPEG ALSA CPU usage](//trac.ffmpeg.org/ticket/6156)
* [Stereo Raspberry pi sound card](http://www.audioinjector.net/rpi-hat)
